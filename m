Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3CD1F4A64
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389367AbfKHMIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:08:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:53244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388555AbfKHLkT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:40:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAC8620869;
        Fri,  8 Nov 2019 11:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213217;
        bh=dmAVpWaZYqY6ZFO1w9id17o0pJ3Rwbi6SyqvsEp3byw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FN9YmFj7n/g4H7mJu/TIWoG+qcYZlBscTgh5BAQNnODiU+Kf4l+668m9njKKkyKxv
         4xyIt/Z3vgjQSVY33Qe+PVxz3Om3XwCmR83wXfbQbpG+6NPv3eygM9NFxFLF9FaC3V
         Dy3gQ+A5VwjzJau4kYqiROQFZYzdoRkfwVzGLKGY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Parav Pandit <parav@mellanox.com>,
        Daniel Jurgens <danielj@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 096/205] IB/mlx5: Don't hold spin lock while checking device state
Date:   Fri,  8 Nov 2019 06:36:03 -0500
Message-Id: <20191108113752.12502-96-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

[ Upstream commit 6c75520f7e5a6a353f3b332509d205e213d05855 ]

mdev->state device state is not protected by the QP for which WRs are
being processed. Therefore, there is no need to hold spin lock while
checking mdev state.

Given that device fatal error is unlikely situation, wrap the condition
check with unlikely().

Additionally, kernel QP1 is also a kernel ULP for which soft CQEs needs
to be generated. Therefore, check for device fatal error before
processing QP1 work requests.

Fixes: 89ea94a7b6c4 ("IB/mlx5: Reset flow support for IB kernel ULPs")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Daniel Jurgens <danielj@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 69669c3b13d85..3f96f0e4db796 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4405,6 +4405,12 @@ static int _mlx5_ib_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 	u8 next_fence = 0;
 	u8 fence;
 
+	if (unlikely(mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR &&
+		     !drain)) {
+		*bad_wr = wr;
+		return -EIO;
+	}
+
 	if (unlikely(ibqp->qp_type == IB_QPT_GSI))
 		return mlx5_ib_gsi_post_send(ibqp, wr, bad_wr);
 
@@ -4414,13 +4420,6 @@ static int _mlx5_ib_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 
 	spin_lock_irqsave(&qp->sq.lock, flags);
 
-	if (mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR && !drain) {
-		err = -EIO;
-		*bad_wr = wr;
-		nreq = 0;
-		goto out;
-	}
-
 	for (nreq = 0; wr; nreq++, wr = wr->next) {
 		if (unlikely(wr->opcode >= ARRAY_SIZE(mlx5_ib_opcode))) {
 			mlx5_ib_warn(dev, "\n");
@@ -4735,18 +4734,17 @@ static int _mlx5_ib_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
 	int ind;
 	int i;
 
+	if (unlikely(mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR &&
+		     !drain)) {
+		*bad_wr = wr;
+		return -EIO;
+	}
+
 	if (unlikely(ibqp->qp_type == IB_QPT_GSI))
 		return mlx5_ib_gsi_post_recv(ibqp, wr, bad_wr);
 
 	spin_lock_irqsave(&qp->rq.lock, flags);
 
-	if (mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR && !drain) {
-		err = -EIO;
-		*bad_wr = wr;
-		nreq = 0;
-		goto out;
-	}
-
 	ind = qp->rq.head & (qp->rq.wqe_cnt - 1);
 
 	for (nreq = 0; wr; nreq++, wr = wr->next) {
-- 
2.20.1

