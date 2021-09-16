Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1348A40E6C2
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344041AbhIPRZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:25:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236705AbhIPRWi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:22:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DAD061356;
        Thu, 16 Sep 2021 16:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810592;
        bh=sQlpCIQOIZc/1gWnMmczeaTUI9JHZ8cwU8Uv5hxetBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mHd5qTGeBYBkkns/Va562UnUjR6u5gTECXP6PmbW3T2YiiMcjmSp3M8bgzv7I1FgI
         rOdkzLUoWvwUEVoC1W3B984UcZhJICJZg/N7rTJyv5tL564ml+vurtFZpL7in0+99I
         md7a9kj2uayQB+u1ktQ61juJl6xWEW5R191gZHgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 165/432] dma-buf: fix dma_resv_test_signaled test_all handling v2
Date:   Thu, 16 Sep 2021 17:58:34 +0200
Message-Id: <20210916155816.339127096@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 9d38814d1e346ea37a51cbf31f4424c9d059459e ]

As the name implies if testing all fences is requested we
should indeed test all fences and not skip the exclusive
one because we see shared ones.

v2: fix logic once more

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210702111642.17259-3-christian.koenig@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/dma-resv.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/dma-buf/dma-resv.c b/drivers/dma-buf/dma-resv.c
index f26c71747d43..e744fd87c63c 100644
--- a/drivers/dma-buf/dma-resv.c
+++ b/drivers/dma-buf/dma-resv.c
@@ -615,25 +615,21 @@ static inline int dma_resv_test_signaled_single(struct dma_fence *passed_fence)
  */
 bool dma_resv_test_signaled(struct dma_resv *obj, bool test_all)
 {
-	unsigned int seq, shared_count;
+	struct dma_fence *fence;
+	unsigned int seq;
 	int ret;
 
 	rcu_read_lock();
 retry:
 	ret = true;
-	shared_count = 0;
 	seq = read_seqcount_begin(&obj->seq);
 
 	if (test_all) {
 		struct dma_resv_list *fobj = dma_resv_shared_list(obj);
-		unsigned int i;
-
-		if (fobj)
-			shared_count = fobj->shared_count;
+		unsigned int i, shared_count;
 
+		shared_count = fobj ? fobj->shared_count : 0;
 		for (i = 0; i < shared_count; ++i) {
-			struct dma_fence *fence;
-
 			fence = rcu_dereference(fobj->shared[i]);
 			ret = dma_resv_test_signaled_single(fence);
 			if (ret < 0)
@@ -641,24 +637,19 @@ bool dma_resv_test_signaled(struct dma_resv *obj, bool test_all)
 			else if (!ret)
 				break;
 		}
-
-		if (read_seqcount_retry(&obj->seq, seq))
-			goto retry;
 	}
 
-	if (!shared_count) {
-		struct dma_fence *fence_excl = dma_resv_excl_fence(obj);
-
-		if (fence_excl) {
-			ret = dma_resv_test_signaled_single(fence_excl);
-			if (ret < 0)
-				goto retry;
+	fence = dma_resv_excl_fence(obj);
+	if (ret && fence) {
+		ret = dma_resv_test_signaled_single(fence);
+		if (ret < 0)
+			goto retry;
 
-			if (read_seqcount_retry(&obj->seq, seq))
-				goto retry;
-		}
 	}
 
+	if (read_seqcount_retry(&obj->seq, seq))
+		goto retry;
+
 	rcu_read_unlock();
 	return ret;
 }
-- 
2.30.2



