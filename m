Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3096B395E60
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbhEaN57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:57:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232474AbhEaNzw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:55:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD80A61925;
        Mon, 31 May 2021 13:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468062;
        bh=aDdELBJolIwaHwa7WqyX+ylH/b6zpzeXArGxknQS0QA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NqZEyd2V0RmdFCWU7zvvC149QOu/OIq3OKWTUuSNt8iltC45/sb1iojVJWHfIC+IV
         qvisGIDMSHWBiMlT4aa8x+AfLRe+/MeCNHK414+fIW20Pi4IJFOACBYMgf3AH9CRRO
         fLOuy4JXwzW8LfH9krZxsDlZLTDcLxGS/MfWIsqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianbo Liu <jianbol@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.10 102/252] net/mlx5: Set reformat action when needed for termination rules
Date:   Mon, 31 May 2021 15:12:47 +0200
Message-Id: <20210531130701.467370257@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianbo Liu <jianbol@nvidia.com>

commit 442b3d7b671bcb779ebdad46edd08051eb8b28d9 upstream.

For remote mirroring, after the tunnel packets are received, they are
decapsulated and sent to representor, then re-encapsulated and sent
out over another tunnel. So reformat action is set only when the
destination is required to do encapsulation.

Fixes: 249ccc3c95bd ("net/mlx5e: Add support for offloading traffic from uplink to uplink")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c |   31 +++-------
 1 file changed, 10 insertions(+), 21 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -171,19 +171,6 @@ mlx5_eswitch_termtbl_put(struct mlx5_esw
 	}
 }
 
-static bool mlx5_eswitch_termtbl_is_encap_reformat(struct mlx5_pkt_reformat *rt)
-{
-	switch (rt->reformat_type) {
-	case MLX5_REFORMAT_TYPE_L2_TO_VXLAN:
-	case MLX5_REFORMAT_TYPE_L2_TO_NVGRE:
-	case MLX5_REFORMAT_TYPE_L2_TO_L2_TUNNEL:
-	case MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL:
-		return true;
-	default:
-		return false;
-	}
-}
-
 static void
 mlx5_eswitch_termtbl_actions_move(struct mlx5_flow_act *src,
 				  struct mlx5_flow_act *dst)
@@ -201,14 +188,6 @@ mlx5_eswitch_termtbl_actions_move(struct
 			memset(&src->vlan[1], 0, sizeof(src->vlan[1]));
 		}
 	}
-
-	if (src->action & MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT &&
-	    mlx5_eswitch_termtbl_is_encap_reformat(src->pkt_reformat)) {
-		src->action &= ~MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
-		dst->action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
-		dst->pkt_reformat = src->pkt_reformat;
-		src->pkt_reformat = NULL;
-	}
 }
 
 static bool mlx5_eswitch_offload_is_uplink_port(const struct mlx5_eswitch *esw,
@@ -278,6 +257,14 @@ mlx5_eswitch_add_termtbl_rule(struct mlx
 		if (dest[i].type != MLX5_FLOW_DESTINATION_TYPE_VPORT)
 			continue;
 
+		if (attr->dests[num_vport_dests].flags & MLX5_ESW_DEST_ENCAP) {
+			term_tbl_act.action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+			term_tbl_act.pkt_reformat = attr->dests[num_vport_dests].pkt_reformat;
+		} else {
+			term_tbl_act.action &= ~MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+			term_tbl_act.pkt_reformat = NULL;
+		}
+
 		/* get the terminating table for the action list */
 		tt = mlx5_eswitch_termtbl_get_create(esw, &term_tbl_act,
 						     &dest[i], attr);
@@ -299,6 +286,8 @@ mlx5_eswitch_add_termtbl_rule(struct mlx
 		goto revert_changes;
 
 	/* create the FTE */
+	flow_act->action &= ~MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+	flow_act->pkt_reformat = NULL;
 	rule = mlx5_add_flow_rules(fdb, spec, flow_act, dest, num_dest);
 	if (IS_ERR(rule))
 		goto revert_changes;


