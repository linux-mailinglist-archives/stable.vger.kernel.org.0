Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDFD529B241
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761150AbgJ0OiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:38:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761140AbgJ0OiI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:38:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 444B6206B2;
        Tue, 27 Oct 2020 14:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809487;
        bh=pgU48Lf+PiMP7v6usSDcWLCT0cPhAWdBgvnWQMGxPRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1wT5iVizgcbMV94Y5plw3SzGkMJivyICVn00hMiVja5zCJn56P9meRuvqHzFEtywM
         nyahEPAY7DROvrWWkJ455Whq+C8SYBatzkwJVoZ1QWFiLzoXRe9m/7I2BAz6RO3aWw
         SduZzR4LxcGSe6LVQqqjDaPOB1+QuZ1rhxHp95zk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        coverity-bot <keescook+coverity-bot@chromium.org>,
        Kees Cook <keescook@chromium.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 212/408] ida: Free allocated bitmap in error path
Date:   Tue, 27 Oct 2020 14:52:30 +0100
Message-Id: <20201027135504.933326356@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
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



