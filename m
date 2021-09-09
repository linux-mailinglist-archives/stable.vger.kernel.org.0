Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70866404985
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236169AbhIILme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:42:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236303AbhIILm3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:42:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 920C361186;
        Thu,  9 Sep 2021 11:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187680;
        bh=sQlpCIQOIZc/1gWnMmczeaTUI9JHZ8cwU8Uv5hxetBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YCS3GE+/i3ZMLCH/8H6Pu8OXrp/U6Bk86aMJ+Mw+q0xj6UeUurpsAxT9GCTaWqywN
         JOH25THMcnqHISenY8eJmt/7aKj48sxzusMbnHUjA31oVK8gVyoZbskXlyDNN6WKjU
         O5OqCZHVVWVCLhsgXhkYcDiGOYxjB1lBKqByaU+YoguIJoUMywQniOSyr+JBkryMrH
         jeAJBVGivRelE93h+fH7e2G5lVNNBAZeZCK8mbJF+Kq5Pyj+aCvRQoFS6tWN+yDL/i
         TYhpIRGkLjQdxzaLe4jz08N28t+ZNLzbHG40wCcXLZcehxmMICKmw35u7eHvYwasHr
         Gna7XmHxTzHHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH AUTOSEL 5.14 010/252] dma-buf: fix dma_resv_test_signaled test_all handling v2
Date:   Thu,  9 Sep 2021 07:37:04 -0400
Message-Id: <20210909114106.141462-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

