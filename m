Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F078F111E8B
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbfLCWyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:54:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:48244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730270AbfLCWyX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:54:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3DFE2053B;
        Tue,  3 Dec 2019 22:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413663;
        bh=8r2JsTAyGjsvZ0Gg6ZeGqXJwOS6tHIwxhleHmJXJ/Q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=skYij4SJ8F6CnFj+vXGi92Q3Aru/KMQCoDH78WHpHc/YLrHn8yCDfSOMNfd6QSBu6
         ARGOYHOJYohXdpGSVNtmxqm/rTZsDU2NKigCwrDZ5P3SxPQIdrGLnDNVISlM9XWuaq
         cZ64prz2QqanEjy0zSohZIoEEPswdtW8aujGLu+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 175/321] IB/rxe: Make counters thread safe
Date:   Tue,  3 Dec 2019 23:34:01 +0100
Message-Id: <20191203223436.234359386@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a0ec28d2b71a4..6a75f96b90962 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -409,16 +409,16 @@ struct rxe_dev {
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



