Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74603106340
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbfKVGJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:09:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:35292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729366AbfKVF5I (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:57:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B46C120659;
        Fri, 22 Nov 2019 05:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402228;
        bh=VvRfFCC/KgixHFcsaFYlG0r52DlU90PC4AO4Z5QVs/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z0iACGkfDu4PzmKpKb6vasJHlraKGiFqbsCPUT42z/Q8tA8j8b42C0GNKWHntFgDu
         i+uE1YDyPW9unWObavtQoVg6b/s3vr04BrKj6CUiDvQ6z+UHeMlnChzFgskkWivk+R
         S3rbDlHEy1Jgx+R73Q7lqOY/jvBUaTwgvohIEc/8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Parav Pandit <parav@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 074/127] IB/rxe: Make counters thread safe
Date:   Fri, 22 Nov 2019 00:54:52 -0500
Message-Id: <20191122055544.3299-73-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
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
index b2b76a316ebae..d1cc89f6f2e33 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -410,16 +410,16 @@ struct rxe_dev {
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

