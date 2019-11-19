Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD031013FA
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728394AbfKSF3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:29:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:47616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728914AbfKSF3G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:29:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D10EF222DF;
        Tue, 19 Nov 2019 05:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141345;
        bh=rJZmS8a2liOWHcDaTjgFTXazWE8WcQ8YmMRJxhUxWQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ess/GGr48fVCgBg1V5MupqRWw6efyVbat5aEhXhLWzCXrukiHUqKUC9RGKR+KxwNa
         uIUfHUBT/bb0BMmRf4ehUzSrcTHcXuR0IaL3vjE8+JhcRuHNk1LdtXFInzO+plpHTE
         PZ5CrG4cgt11o9C4ZO4aDEbnmq19/HpAJsjYTI7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Daniel Jurgens <danielj@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 128/422] IB/mlx5: Dont hold spin lock while checking device state
Date:   Tue, 19 Nov 2019 06:15:25 +0100
Message-Id: <20191119051407.229145815@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2e7230392a498..ef0f710587ad8 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4407,6 +4407,12 @@ static int _mlx5_ib_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
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
 
@@ -4416,13 +4422,6 @@ static int _mlx5_ib_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 
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
@@ -4737,18 +4736,17 @@ static int _mlx5_ib_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
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



