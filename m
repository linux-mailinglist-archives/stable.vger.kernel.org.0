Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FF53DDA19
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236493AbhHBOGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:06:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236353AbhHBOCK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:02:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9189D61206;
        Mon,  2 Aug 2021 13:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912625;
        bh=BX+yWh97LQhZaktYnVrL82g/nJzEZjkgIoevaOt8Kno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bPLhYvEhAellKJZGsaETSSiPDJKqbqwZCN6Xlw57BUcPfQBz7v2gyaxepkA5L2NTe
         dph4kIXZJcaEBerHoxO76i15/ok9XBvrAQ3iNtcWO4AlOM7xG8TsjBF84w2aCI3ykc
         qw2VPsLQ5ZsjY6RwhQsHw1LY4fGbnobJou+2MGuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 077/104] net/mlx5: E-Switch, Set destination vport vhca id only when merged eswitch is supported
Date:   Mon,  2 Aug 2021 15:45:14 +0200
Message-Id: <20210802134346.549045440@linuxfoundation.org>
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

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit c671972534c6f7fce789ac8156a2bc3bd146f806 ]

Destination vport vhca id is valid flag is set only merged eswitch isn't supported.
Change destination vport vhca id value to be set also only when merged eswitch
is supported.

Fixes: e4ad91f23f10 ("net/mlx5e: Split offloaded eswitch TC rules for port mirroring")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index d18a28a6e9a6..91571156a89d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -382,10 +382,11 @@ esw_setup_vport_dest(struct mlx5_flow_destination *dest, struct mlx5_flow_act *f
 {
 	dest[dest_idx].type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
 	dest[dest_idx].vport.num = esw_attr->dests[attr_idx].rep->vport;
-	dest[dest_idx].vport.vhca_id =
-		MLX5_CAP_GEN(esw_attr->dests[attr_idx].mdev, vhca_id);
-	if (MLX5_CAP_ESW(esw->dev, merged_eswitch))
+	if (MLX5_CAP_ESW(esw->dev, merged_eswitch)) {
+		dest[dest_idx].vport.vhca_id =
+			MLX5_CAP_GEN(esw_attr->dests[attr_idx].mdev, vhca_id);
 		dest[dest_idx].vport.flags |= MLX5_FLOW_DEST_VPORT_VHCA_ID;
+	}
 	if (esw_attr->dests[attr_idx].flags & MLX5_ESW_DEST_ENCAP) {
 		if (pkt_reformat) {
 			flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
-- 
2.30.2



