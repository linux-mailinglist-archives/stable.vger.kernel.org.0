Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB5FF147B97
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733081AbgAXJoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:44:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729719AbgAXJoy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:44:54 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C62B20718;
        Fri, 24 Jan 2020 09:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859093;
        bh=SdlvnvSTKjq9F67Dssl3iH+ACt71AD9/66iLmeoZHrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=io15iipxzO7AGaok0H3tVVWO/IqBpZd5wT2uXxOdqBO/GQZlc9qFJhSjo548cQCBH
         qGriGdg3nPvyoGrLtXFAO5UyULjxv+9neJwkDVVPV3reYV7uJEh7JigfnrExVYclSc
         U13ZZYV8wg23/X/bEub5htdZ9ARVSH66Q6NDVtwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuval Shaia <yuval.shaia@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Zhu Yanjun <yanjun.zhu@oracle.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 028/343] IB/rxe: Fix incorrect cache cleanup in error flow
Date:   Fri, 24 Jan 2020 10:27:26 +0100
Message-Id: <20200124092923.440793278@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b4a8acc7bb7d6..0e2425f282335 100644
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



