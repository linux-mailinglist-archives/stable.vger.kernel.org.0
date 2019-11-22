Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4319106558
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbfKVFvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:51:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:56826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726865AbfKVFvh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:51:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 862962071F;
        Fri, 22 Nov 2019 05:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401897;
        bh=D8uedxp58DJdJ5NOweYsrKV1g/NMpFA8GPf5Tgpbrtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OrrS6k9evWzNsTxr9oOuld9p8bcXnknpIGzHGQhFi/q2phcLTDE9ic/K4LCK8Wyz6
         oO8vpn2BZq7jcfSmUjTi6Ru30kUW+I/yu23F2dzRBHD9HKHuTKawHvCUBzIZ0xbeXL
         SFZgz54zV4iPGukBCv0elpozB8G3DYVf6gsA2Bi4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Parav Pandit <parav@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 129/219] IB/rxe: Make counters thread safe
Date:   Fri, 22 Nov 2019 00:47:41 -0500
Message-Id: <20191122054911.1750-122-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

[ Upstream commit d5108e69fe013ff47ab815b849caba9cc33ca1e5 ]

Current rxe device counters are not thread safe.
When multiple QPs are used, they can be racy.
Make them thread safe by making it atomic64.

Fixes: 0b1e5b99a48b ("IB/rxe: Add port protocol stats")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_hw_counters.c | 2 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h       | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_hw_counters.c b/drivers/infiniband/sw/rxe/rxe_hw_counters.c
index 6aeb7a165e469..ea4542a9d69e6 100644
--- a/drivers/infiniband/sw/rxe/rxe_hw_counters.c
+++ b/drivers/infiniband/sw/rxe/rxe_hw_counters.c
@@ -59,7 +59,7 @@ int rxe_ib_get_hw_stats(struct ib_device *ibdev,
 		return -EINVAL;
 
 	for (cnt = 0; cnt  < ARRAY_SIZE(rxe_counter_name); cnt++)
-		stats->value[cnt] = dev->stats_counters[cnt];
+		stats->value[cnt] = atomic64_read(&dev->stats_counters[cnt]);
 
 	return ARRAY_SIZE(rxe_counter_name);
 }
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index 3b731c7682e5b..a61782df4e805 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -408,16 +408,16 @@ struct rxe_dev {
 	spinlock_t		mmap_offset_lock; /* guard mmap_offset */
 	int			mmap_offset;
 
-	u64			stats_counters[RXE_NUM_OF_COUNTERS];
+	atomic64_t		stats_counters[RXE_NUM_OF_COUNTERS];
 
 	struct rxe_port		port;
 	struct list_head	list;
 	struct crypto_shash	*tfm;
 };
 
-static inline void rxe_counter_inc(struct rxe_dev *rxe, enum rxe_counters cnt)
+static inline void rxe_counter_inc(struct rxe_dev *rxe, enum rxe_counters index)
 {
-	rxe->stats_counters[cnt]++;
+	atomic64_inc(&rxe->stats_counters[index]);
 }
 
 static inline struct rxe_dev *to_rdev(struct ib_device *dev)
-- 
2.20.1

