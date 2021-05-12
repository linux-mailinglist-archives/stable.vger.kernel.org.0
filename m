Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC3337CD96
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbhELQ4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:56:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243986AbhELQmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFCEA61CEF;
        Wed, 12 May 2021 16:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835754;
        bh=AipH79RHv+U+mV+CdpC3mkHxxed/WoVC3DwWSz0LlA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xUzoUPk82J2cBmewNJAXoNA53MN/B9hBbck+p0DVfXGqvKXwSf4s6w51FsY36o/mL
         7SeKdhSwdLlfYMOW4wgs+Ptc5R6z9Qw10rqlkYkVflXp3l8vnmxjUECJLzdE0byE1+
         ZBXwlOQskzPbykw/9PvdnO2a3ynMapibBmuPJ+cA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Bloch <markb@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 471/677] RDMA/mlx5: Fix drop packet rule in egress table
Date:   Wed, 12 May 2021 16:48:37 +0200
Message-Id: <20210512144853.006508055@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit c73700806d4e430d182c2be069d230076818a99a ]

Initial drop action support missed that drop action can be added to egress
flow tables as well. Add the missing support.

This requires making sure that dest_type isn't set to PORT which in turn
exposes a possibility of passing dst while indicating number of dsts as
zero. Explicitly check for number of dsts and pass the appropriate
pointer.

Fixes: f29de9eee782 ("RDMA/mlx5: Add support for drop action in DV steering")
Link: https://lore.kernel.org/r/20210318135123.680759-1-leon@kernel.org
Reviewed-by: Mark Bloch <markb@nvidia.com>
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/fs.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index 25da0b05b4e2..f0af3f1ae039 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -1528,8 +1528,8 @@ static struct mlx5_ib_flow_handler *raw_fs_rule_add(
 		dst_num++;
 	}
 
-	handler = _create_raw_flow_rule(dev, ft_prio, dst, fs_matcher,
-					flow_context, flow_act,
+	handler = _create_raw_flow_rule(dev, ft_prio, dst_num ? dst : NULL,
+					fs_matcher, flow_context, flow_act,
 					cmd_in, inlen, dst_num);
 
 	if (IS_ERR(handler)) {
@@ -1885,8 +1885,9 @@ static int get_dests(struct uverbs_attr_bundle *attrs,
 		else
 			*dest_id = mqp->raw_packet_qp.rq.tirn;
 		*dest_type = MLX5_FLOW_DESTINATION_TYPE_TIR;
-	} else if (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_EGRESS ||
-		   fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_RDMA_TX) {
+	} else if ((fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_EGRESS ||
+		    fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_RDMA_TX) &&
+		   !(*flags & MLX5_IB_ATTR_CREATE_FLOW_FLAGS_DROP)) {
 		*dest_type = MLX5_FLOW_DESTINATION_TYPE_PORT;
 	}
 
-- 
2.30.2



