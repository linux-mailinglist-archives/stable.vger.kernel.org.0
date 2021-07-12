Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4CC3C4DF0
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243548AbhGLHPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:15:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241897AbhGLHOm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:14:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4773A613D6;
        Mon, 12 Jul 2021 07:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073893;
        bh=4+7dtKjnZGuQ5I0aGaI5q+Rxqi9G/g7QWNd0uDr75do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Za425rP+JdsKmNpQGk+hc47j2mBgOaQEPjgB9q5B+0MPXXw03N2cuUGzb2yImfqR8
         wY7qClhU2Mstp1UDE6lfv2W4LU4hX6JHtCqst7nONcFIeqm4wGagbDLH0RU0OfowIi
         fneep8YROKP1kRKlrGMryeGgOWWNEsYRgUE0zyhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 393/700] RDMA/core: Sanitize WQ state received from the userspace
Date:   Mon, 12 Jul 2021 08:07:56 +0200
Message-Id: <20210712061018.209802241@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index ab55f8b3190e..92ae454d500a 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3033,12 +3033,29 @@ static int ib_uverbs_ex_modify_wq(struct uverbs_attr_bundle *attrs)
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
index 651785bd57f2..18a47248e444 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -4254,13 +4254,8 @@ int mlx4_ib_modify_wq(struct ib_wq *ibwq, struct ib_wq_attr *wq_attr,
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
index 843f9e7fe96f..bcaaf238b364 100644
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



