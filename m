Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847C13DD9E5
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235402AbhHBOFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:05:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235452AbhHBODI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:03:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E57D861208;
        Mon,  2 Aug 2021 13:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912629;
        bh=+gSNiW5h03Ed1RDtqAHCy6UznWIMDeYH1bhgBXKIZbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zfWDPfodGQDlGctGERBvkthbisCLaM4C9dwJBWpA/Lbvty0RrOJmafzpsB/u+T79r
         3iQiaD2Zz9RDbqwVRyaFA/74RVsL1VXz1eiD6Tjj3pZ6kxLidCLTpDWlENxYT+ZXz8
         kaBNLG+aWTbdIgJXap+Dp8mox9s1pXonj1EUBQ3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 079/104] net/mlx5e: RX, Avoid possible data corruption when relaxed ordering and LRO combined
Date:   Mon,  2 Aug 2021 15:45:16 +0200
Message-Id: <20210802134346.612168034@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

[ Upstream commit e2351e517068718724f1d3b4010e2a41ec91fa76 ]

When HW aggregates packets for an LRO session, it writes the payload
of two consecutive packets of a flow contiguously, so that they usually
share a cacheline.

The first byte of a packet's payload is written immediately after
the last byte of the preceding packet.
In this flow, there are two consecutive write requests to the shared
cacheline:
1. Regular write for the earlier packet.
2. Read-modify-write for the following packet.

In case of relaxed-ordering on, these two writes might be re-ordered.
Using the end padding optimization (to avoid partial write for the last
cacheline of a packet) becomes problematic if the two writes occur
out-of-order, as the padding would overwrite payload that belongs to
the following packet, causing data corruption.

Avoid this by disabling the end padding optimization when both
LRO and relaxed-ordering are enabled.

Fixes: 17347d5430c4 ("net/mlx5e: Add support for PCI relaxed ordering")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index f410c1268422..133eb13facfd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -471,6 +471,15 @@ static void mlx5e_build_rx_cq_param(struct mlx5_core_dev *mdev,
 	param->cq_period_mode = params->rx_cq_moderation.cq_period_mode;
 }
 
+static u8 rq_end_pad_mode(struct mlx5_core_dev *mdev, struct mlx5e_params *params)
+{
+	bool ro = pcie_relaxed_ordering_enabled(mdev->pdev) &&
+		MLX5_CAP_GEN(mdev, relaxed_ordering_write);
+
+	return ro && params->lro_en ?
+		MLX5_WQ_END_PAD_MODE_NONE : MLX5_WQ_END_PAD_MODE_ALIGN;
+}
+
 int mlx5e_build_rq_param(struct mlx5_core_dev *mdev,
 			 struct mlx5e_params *params,
 			 struct mlx5e_xsk_param *xsk,
@@ -508,7 +517,7 @@ int mlx5e_build_rq_param(struct mlx5_core_dev *mdev,
 	}
 
 	MLX5_SET(wq, wq, wq_type,          params->rq_wq_type);
-	MLX5_SET(wq, wq, end_padding_mode, MLX5_WQ_END_PAD_MODE_ALIGN);
+	MLX5_SET(wq, wq, end_padding_mode, rq_end_pad_mode(mdev, params));
 	MLX5_SET(wq, wq, log_wq_stride,
 		 mlx5e_get_rqwq_log_stride(params->rq_wq_type, ndsegs));
 	MLX5_SET(wq, wq, pd,               mdev->mlx5e_res.hw_objs.pdn);
-- 
2.30.2



