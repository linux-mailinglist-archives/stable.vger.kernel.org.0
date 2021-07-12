Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB8B3C539A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348203AbhGLHzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350528AbhGLHvG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 341A761166;
        Mon, 12 Jul 2021 07:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075959;
        bh=zkl4VXu8HUQpwp2SMaTNSypLqsMJ8VGkkXWeojMrZZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KyB4fwdh6JV0+wpQadkrVY3q596MTKHR4G6se2cGscnbq57db0SWNQe4WCfH6xaZT
         MnBLC23gy/10OOhRUf5JzFTsLes9VKLS8Oie5AH8nzsxVBJOCX34XbH0qJAJCPBDeM
         UDMd5GCBgITSDOoYHFchnM1FogI+Xcy65XqTJNBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 439/800] RDMA/core: Sanitize WQ state received from the userspace
Date:   Mon, 12 Jul 2021 08:07:42 +0200
Message-Id: <20210712061013.771645591@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit f97442887275d11c88c2899e720fe945c1f61488 ]

The mlx4 and mlx5 implemented differently the WQ input checks.  Instead of
duplicating mlx4 logic in the mlx5, let's prepare the input in the central
place.

The mlx5 implementation didn't check for validity of state input.  It is
not real bug because our FW checked that, but still worth to fix.

Fixes: f213c0527210 ("IB/uverbs: Add WQ support")
Link: https://lore.kernel.org/r/ac41ad6a81b095b1a8ad453dcf62cf8d3c5da779.1621413310.git.leonro@nvidia.com
Reported-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 21 +++++++++++++++++++--
 drivers/infiniband/hw/mlx4/qp.c      |  9 ++-------
 drivers/infiniband/hw/mlx5/qp.c      |  6 ++----
 3 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 64e4be1cbec7..a1d1deca7c06 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3034,12 +3034,29 @@ static int ib_uverbs_ex_modify_wq(struct uverbs_attr_bundle *attrs)
 	if (!wq)
 		return -EINVAL;
 
-	wq_attr.curr_wq_state = cmd.curr_wq_state;
-	wq_attr.wq_state = cmd.wq_state;
 	if (cmd.attr_mask & IB_WQ_FLAGS) {
 		wq_attr.flags = cmd.flags;
 		wq_attr.flags_mask = cmd.flags_mask;
 	}
+
+	if (cmd.attr_mask & IB_WQ_CUR_STATE) {
+		if (cmd.curr_wq_state > IB_WQS_ERR)
+			return -EINVAL;
+
+		wq_attr.curr_wq_state = cmd.curr_wq_state;
+	} else {
+		wq_attr.curr_wq_state = wq->state;
+	}
+
+	if (cmd.attr_mask & IB_WQ_STATE) {
+		if (cmd.wq_state > IB_WQS_ERR)
+			return -EINVAL;
+
+		wq_attr.wq_state = cmd.wq_state;
+	} else {
+		wq_attr.wq_state = wq_attr.curr_wq_state;
+	}
+
 	ret = wq->device->ops.modify_wq(wq, &wq_attr, cmd.attr_mask,
 					&attrs->driver_udata);
 	rdma_lookup_put_uobject(&wq->uobject->uevent.uobject,
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 92ddbcc00eb2..2ae22bf50016 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -4251,13 +4251,8 @@ int mlx4_ib_modify_wq(struct ib_wq *ibwq, struct ib_wq_attr *wq_attr,
 	if (wq_attr_mask & IB_WQ_FLAGS)
 		return -EOPNOTSUPP;
 
-	cur_state = wq_attr_mask & IB_WQ_CUR_STATE ? wq_attr->curr_wq_state :
-						     ibwq->state;
-	new_state = wq_attr_mask & IB_WQ_STATE ? wq_attr->wq_state : cur_state;
-
-	if (cur_state  < IB_WQS_RESET || cur_state  > IB_WQS_ERR ||
-	    new_state < IB_WQS_RESET || new_state > IB_WQS_ERR)
-		return -EINVAL;
+	cur_state = wq_attr->curr_wq_state;
+	new_state = wq_attr->wq_state;
 
 	if ((new_state == IB_WQS_RDY) && (cur_state == IB_WQS_ERR))
 		return -EINVAL;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 9282eb10bfae..5851486c0d93 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5309,10 +5309,8 @@ int mlx5_ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
 
 	rqc = MLX5_ADDR_OF(modify_rq_in, in, ctx);
 
-	curr_wq_state = (wq_attr_mask & IB_WQ_CUR_STATE) ?
-		wq_attr->curr_wq_state : wq->state;
-	wq_state = (wq_attr_mask & IB_WQ_STATE) ?
-		wq_attr->wq_state : curr_wq_state;
+	curr_wq_state = wq_attr->curr_wq_state;
+	wq_state = wq_attr->wq_state;
 	if (curr_wq_state == IB_WQS_ERR)
 		curr_wq_state = MLX5_RQC_STATE_ERR;
 	if (wq_state == IB_WQS_ERR)
-- 
2.30.2



