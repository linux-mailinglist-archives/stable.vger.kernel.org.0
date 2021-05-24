Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0231338EF80
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbhEXP6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234276AbhEXP4w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:56:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F66461947;
        Mon, 24 May 2021 15:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870994;
        bh=p4tMViJ21b/FvMRpi4ZmBriUtVwJhoQr/WeyN0qWI5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qOSLIk6Gymt+iS3RojaEQW/izy1p+l4k9IRt5gf4Y2q1I0YEOncvD+hx1H3GxF41p
         O2j9Z99HRL5TdXYhzOL5fIH/6Gu2nidVa2YdTFMPhZWPD95bOTHTuROR2QULHOEiB3
         lOjP+63WZk5kLfy1YZh2LI4Eh/NyfpqimprpwWIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yishai Hadas <yishaih@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 024/127] RDMA/mlx5: Fix query DCT via DEVX
Date:   Mon, 24 May 2021 17:25:41 +0200
Message-Id: <20210524152335.669861048@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit cfa3b797118eda7d68f9ede9b1a0279192aca653 ]

When executing DEVX command to query QP object, we need to take the QP
type from the mlx5_ib_qp struct which hold the driver specific QP types as
well, such as DC.

Fixes: 34613eb1d2ad ("IB/mlx5: Enable modify and query verbs objects via DEVX")
Link: https://lore.kernel.org/r/6eee15d63f09bb70787488e0cf96216e2957f5aa.1621413654.git.leonro@nvidia.com
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/devx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 07b8350929cd..81276b4247f8 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -630,9 +630,8 @@ static bool devx_is_valid_obj_id(struct uverbs_attr_bundle *attrs,
 	case UVERBS_OBJECT_QP:
 	{
 		struct mlx5_ib_qp *qp = to_mqp(uobj->object);
-		enum ib_qp_type	qp_type = qp->ibqp.qp_type;
 
-		if (qp_type == IB_QPT_RAW_PACKET ||
+		if (qp->type == IB_QPT_RAW_PACKET ||
 		    (qp->flags & IB_QP_CREATE_SOURCE_QPN)) {
 			struct mlx5_ib_raw_packet_qp *raw_packet_qp =
 							 &qp->raw_packet_qp;
@@ -649,10 +648,9 @@ static bool devx_is_valid_obj_id(struct uverbs_attr_bundle *attrs,
 					       sq->tisn) == obj_id);
 		}
 
-		if (qp_type == MLX5_IB_QPT_DCT)
+		if (qp->type == MLX5_IB_QPT_DCT)
 			return get_enc_obj_id(MLX5_CMD_OP_CREATE_DCT,
 					      qp->dct.mdct.mqp.qpn) == obj_id;
-
 		return get_enc_obj_id(MLX5_CMD_OP_CREATE_QP,
 				      qp->ibqp.qp_num) == obj_id;
 	}
-- 
2.30.2



