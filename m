Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3B113E27E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733238AbgAPQ42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:56:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:42760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732442AbgAPQ41 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:56:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8CF921582;
        Thu, 16 Jan 2020 16:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193786;
        bh=pVwNJTS267s0DwV6idTs9NtxVWaFw9mF8KkJysJqDvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3I23oJqFonzSqTR4u02vV9BYK+W8zgb9ZrVXg3IoPeuGcK5Q7+8sMYqKQ1i5ag4X
         0UfImHgNus9qt3ATlKMuyGZbw4deQ9ffU4zsNY/r4xs2hVREiCONX7FIudUkn7QzIp
         Vik8fBeVeanLYBX5dNavym+r0tfLjj/Ogt1GlPUo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yuval Shaia <yuval.shaia@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Zhu Yanjun <yanjun.zhu@oracle.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 062/671] IB/rxe: Fix incorrect cache cleanup in error flow
Date:   Thu, 16 Jan 2020 11:44:53 -0500
Message-Id: <20200116165502.8838-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuval Shaia <yuval.shaia@oracle.com>

[ Upstream commit 6db21d8986e14e2e86573a3b055b05296188bd2c ]

Array iterator stays at the same slot, fix it.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Yuval Shaia <yuval.shaia@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Zhu Yanjun <yanjun.zhu@oracle.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_pool.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_pool.c b/drivers/infiniband/sw/rxe/rxe_pool.c
index b4a8acc7bb7d..0e2425f28233 100644
--- a/drivers/infiniband/sw/rxe/rxe_pool.c
+++ b/drivers/infiniband/sw/rxe/rxe_pool.c
@@ -112,6 +112,18 @@ static inline struct kmem_cache *pool_cache(struct rxe_pool *pool)
 	return rxe_type_info[pool->type].cache;
 }
 
+static void rxe_cache_clean(size_t cnt)
+{
+	int i;
+	struct rxe_type_info *type;
+
+	for (i = 0; i < cnt; i++) {
+		type = &rxe_type_info[i];
+		kmem_cache_destroy(type->cache);
+		type->cache = NULL;
+	}
+}
+
 int rxe_cache_init(void)
 {
 	int err;
@@ -136,24 +148,14 @@ int rxe_cache_init(void)
 	return 0;
 
 err1:
-	while (--i >= 0) {
-		kmem_cache_destroy(type->cache);
-		type->cache = NULL;
-	}
+	rxe_cache_clean(i);
 
 	return err;
 }
 
 void rxe_cache_exit(void)
 {
-	int i;
-	struct rxe_type_info *type;
-
-	for (i = 0; i < RXE_NUM_TYPES; i++) {
-		type = &rxe_type_info[i];
-		kmem_cache_destroy(type->cache);
-		type->cache = NULL;
-	}
+	rxe_cache_clean(RXE_NUM_TYPES);
 }
 
 static int rxe_pool_init_index(struct rxe_pool *pool, u32 max, u32 min)
-- 
2.20.1

