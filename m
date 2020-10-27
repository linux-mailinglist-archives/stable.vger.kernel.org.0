Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00AF29BC40
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764444AbgJ0Poo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:44:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801044AbgJ0Phd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:37:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9C00204EF;
        Tue, 27 Oct 2020 15:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813052;
        bh=pgU48Lf+PiMP7v6usSDcWLCT0cPhAWdBgvnWQMGxPRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xsSp5BiSEhBlT4KXtoMKeqafNtYEWA55DuJDyVQhtUKlV4lJzVx7cFluSnTo05XWG
         nXLcxy7QynvRKzNEM6IwkGnbvViLM+5sszQyn4QHJZipJ5yA5Cr/tbvia4vcU79Tdb
         2O3GTmhWJSq8NlwAE1G1OGxkcFNfLHgrbofhYVJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        coverity-bot <keescook+coverity-bot@chromium.org>,
        Kees Cook <keescook@chromium.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 422/757] ida: Free allocated bitmap in error path
Date:   Tue, 27 Oct 2020 14:51:12 +0100
Message-Id: <20201027135510.359998751@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit a219b856a2b993da234108307be772448f22b0ce ]

If a bitmap needs to be allocated, and then by the time the thread
is scheduled to be run again all the indices which would satisfy the
allocation have been allocated then we would leak the allocation.  Almost
impossible to hit in practice, but a trivial fix.  Found by Coverity.

Fixes: f32f004cddf8 ("ida: Convert to XArray")
Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/idr.c                           |  1 +
 tools/testing/radix-tree/idr-test.c | 29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/lib/idr.c b/lib/idr.c
index c2cf2c52bbde5..4d2eef0259d2c 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -470,6 +470,7 @@ int ida_alloc_range(struct ida *ida, unsigned int min, unsigned int max,
 	goto retry;
 nospc:
 	xas_unlock_irqrestore(&xas, flags);
+	kfree(alloc);
 	return -ENOSPC;
 }
 EXPORT_SYMBOL(ida_alloc_range);
diff --git a/tools/testing/radix-tree/idr-test.c b/tools/testing/radix-tree/idr-test.c
index 8995092d541ec..3b796dd5e5772 100644
--- a/tools/testing/radix-tree/idr-test.c
+++ b/tools/testing/radix-tree/idr-test.c
@@ -523,8 +523,27 @@ static void *ida_random_fn(void *arg)
 	return NULL;
 }
 
+static void *ida_leak_fn(void *arg)
+{
+	struct ida *ida = arg;
+	time_t s = time(NULL);
+	int i, ret;
+
+	rcu_register_thread();
+
+	do for (i = 0; i < 1000; i++) {
+		ret = ida_alloc_range(ida, 128, 128, GFP_KERNEL);
+		if (ret >= 0)
+			ida_free(ida, 128);
+	} while (time(NULL) < s + 2);
+
+	rcu_unregister_thread();
+	return NULL;
+}
+
 void ida_thread_tests(void)
 {
+	DEFINE_IDA(ida);
 	pthread_t threads[20];
 	int i;
 
@@ -536,6 +555,16 @@ void ida_thread_tests(void)
 
 	while (i--)
 		pthread_join(threads[i], NULL);
+
+	for (i = 0; i < ARRAY_SIZE(threads); i++)
+		if (pthread_create(&threads[i], NULL, ida_leak_fn, &ida)) {
+			perror("creating ida thread");
+			exit(1);
+		}
+
+	while (i--)
+		pthread_join(threads[i], NULL);
+	assert(ida_is_empty(&ida));
 }
 
 void ida_tests(void)
-- 
2.25.1



