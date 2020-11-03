Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25792A55D4
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733070AbgKCVWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:22:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:43732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733172AbgKCVFR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:05:17 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5842B20658;
        Tue,  3 Nov 2020 21:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437516;
        bh=XWKBGVT0fLlUqbteaHTUAI/g2Q91q7n4qRD6yK2GNdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tp7j302UnQj3vjnjAWxdv/Xy8xOckMJ46WwwGHLUNtwftNuyH+otCZFu7KgGR8GuY
         1O+3RigkxsrQftWIObVEFiw9MbQEXcEmeuH4OlL7HXJ5sI+JXpjCjyU8mDWMAY8J2b
         daQOdwmGHavm2iApKt8SE6KCrthztVVymTrtWxjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 110/191] sgl_alloc_order: fix memory leak
Date:   Tue,  3 Nov 2020 21:36:42 +0100
Message-Id: <20201103203243.802362900@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Gilbert <dgilbert@interlog.com>

[ Upstream commit b2a182a40278bc5849730e66bca01a762188ed86 ]

sgl_alloc_order() can fail when 'length' is large on a memory
constrained system. When order > 0 it will potentially be
making several multi-page allocations with the later ones more
likely to fail than the earlier one. So it is important that
sgl_alloc_order() frees up any pages it has obtained before
returning NULL. In the case when order > 0 it calls the wrong
free page function and leaks. In testing the leak was
sufficient to bring down my 8 GiB laptop with OOM.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/scatterlist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 60e7eca2f4bed..3b859201f84c6 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -506,7 +506,7 @@ struct scatterlist *sgl_alloc_order(unsigned long long length,
 		elem_len = min_t(u64, length, PAGE_SIZE << order);
 		page = alloc_pages(gfp, order);
 		if (!page) {
-			sgl_free(sgl);
+			sgl_free_order(sgl, order);
 			return NULL;
 		}
 
-- 
2.27.0



