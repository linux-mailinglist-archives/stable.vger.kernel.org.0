Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7D41631B4
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgBRUCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:02:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:42402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728882AbgBRUCN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:02:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDEA62464E;
        Tue, 18 Feb 2020 20:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056133;
        bh=mxKnM7pMPMd/YYHFnDhjWINAWLECBBrs3PzAEoLYjGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yGObA4RMv4+WdEnHtPynBfBeLdgz4NfVnwOE0kBVmZS/IV8IEZQJ91jG7fTgrnvNC
         0rCou1ysA3jPwa8WC3EQ/tllcZ/F2wuhLHAUHoYVqfRBH3nIDUbva2F1acpeRgR54K
         VV/o/hSBZD3258AUy4bS2p8kwXToFDqJoVdMaUOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Zhang <markz@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.5 48/80] IB/mlx5: Return failure when rts2rts_qp_counters_set_id is not supported
Date:   Tue, 18 Feb 2020 20:55:09 +0100
Message-Id: <20200218190436.869817382@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

commit 10189e8e6fe8dcde13435f9354800429c4474fb1 upstream.

When binding a QP with a counter and the QP state is not RESET, return
failure if the rts2rts_qp_counters_set_id is not supported by the
device.

This is to prevent cases like manual bind for Connect-IB devices from
returning success when the feature is not supported.

Fixes: d14133dd4161 ("IB/mlx5: Support set qp counter")
Link: https://lore.kernel.org/r/20200126171708.5167-1-leon@kernel.org
Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/qp.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3394,9 +3394,6 @@ static int __mlx5_ib_qp_set_counter(stru
 	struct mlx5_ib_qp_base *base;
 	u32 set_id;
 
-	if (!MLX5_CAP_GEN(dev->mdev, rts2rts_qp_counters_set_id))
-		return 0;
-
 	if (counter)
 		set_id = counter->id;
 	else
@@ -6529,6 +6526,7 @@ void mlx5_ib_drain_rq(struct ib_qp *qp)
  */
 int mlx5_ib_qp_set_counter(struct ib_qp *qp, struct rdma_counter *counter)
 {
+	struct mlx5_ib_dev *dev = to_mdev(qp->device);
 	struct mlx5_ib_qp *mqp = to_mqp(qp);
 	int err = 0;
 
@@ -6538,6 +6536,11 @@ int mlx5_ib_qp_set_counter(struct ib_qp
 		goto out;
 	}
 
+	if (!MLX5_CAP_GEN(dev->mdev, rts2rts_qp_counters_set_id)) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
 	if (mqp->state == IB_QPS_RTS) {
 		err = __mlx5_ib_qp_set_counter(qp, counter);
 		if (!err)


