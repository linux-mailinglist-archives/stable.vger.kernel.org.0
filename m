Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5631063DF82
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbiK3Srx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:47:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbiK3Sru (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:47:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9D714D08
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:47:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45DFE61D70
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F44C433D7;
        Wed, 30 Nov 2022 18:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834066;
        bh=tJdmi+VAmUh1K1AL9Xxugcz4t2un5dZEBZ/utV+HkzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xYhFrStFdUb6Xlz7Mo6z0w49+hCyRxolUaMuqs0dJUVp8/A4wD8ww4Hrn9h8FBYSG
         O0oPP1D8865eOGhoVxyTmpJnAL06kH8qbqLikchETharq0B+KNfC40EIOBLdYFsjAk
         7RwQhdgCX/w86KiapgkTof/CVcXRE4qs8DrCRkuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Roi Dayan <roid@nvidia.com>,
        Chris Mi <cmi@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 109/289] net/mlx5: E-Switch, Set correctly vport destination
Date:   Wed, 30 Nov 2022 19:21:34 +0100
Message-Id: <20221130180546.611470563@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

[ Upstream commit 6d942e40448931be9371f1ba8cb592778807ce18 ]

The cited commit moved from using reformat_id integer to packet_reformat
pointer which introduced the possibility to null pointer dereference.
When setting packet reformat flag and pkt_reformat pointer must
exists so checking MLX5_ESW_DEST_ENCAP is not enough, we need
to make sure the pkt_reformat is valid and check for MLX5_ESW_DEST_ENCAP_VALID.
If the dest encap valid flag does not exists then pkt_reformat can be
either invalid address or null.
Also, to make sure we don't try to access invalid pkt_reformat set it to
null when invalidated and invalidate it before calling add flow code as
its logically more correct and to be safe.

Fixes: 2b688ea5efde ("net/mlx5: Add flow steering actions to fs_cmd shim layer")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Chris Mi <cmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  | 10 ++++++----
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 5aff97914367..5b6a79d2034e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -224,15 +224,16 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 	list_for_each_entry(flow, flow_list, tmp_list) {
 		if (!mlx5e_is_offloaded_flow(flow) || flow_flag_test(flow, SLOW))
 			continue;
-		spec = &flow->attr->parse_attr->spec;
-
-		/* update from encap rule to slow path rule */
-		rule = mlx5e_tc_offload_to_slow_path(esw, flow, spec);
 
 		attr = mlx5e_tc_get_encap_attr(flow);
 		esw_attr = attr->esw_attr;
 		/* mark the flow's encap dest as non-valid */
 		esw_attr->dests[flow->tmp_entry_index].flags &= ~MLX5_ESW_DEST_ENCAP_VALID;
+		esw_attr->dests[flow->tmp_entry_index].pkt_reformat = NULL;
+
+		/* update from encap rule to slow path rule */
+		spec = &flow->attr->parse_attr->spec;
+		rule = mlx5e_tc_offload_to_slow_path(esw, flow, spec);
 
 		if (IS_ERR(rule)) {
 			err = PTR_ERR(rule);
@@ -251,6 +252,7 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 	/* we know that the encap is valid */
 	e->flags &= ~MLX5_ENCAP_ENTRY_VALID;
 	mlx5_packet_reformat_dealloc(priv->mdev, e->pkt_reformat);
+	e->pkt_reformat = NULL;
 }
 
 static void mlx5e_take_tmp_flow(struct mlx5e_tc_flow *flow,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 3c68cac4a9c2..061ac8799354 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -431,7 +431,7 @@ esw_setup_vport_dest(struct mlx5_flow_destination *dest, struct mlx5_flow_act *f
 		    mlx5_lag_mpesw_is_activated(esw->dev))
 			dest[dest_idx].type = MLX5_FLOW_DESTINATION_TYPE_UPLINK;
 	}
-	if (esw_attr->dests[attr_idx].flags & MLX5_ESW_DEST_ENCAP) {
+	if (esw_attr->dests[attr_idx].flags & MLX5_ESW_DEST_ENCAP_VALID) {
 		if (pkt_reformat) {
 			flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
 			flow_act->pkt_reformat = esw_attr->dests[attr_idx].pkt_reformat;
-- 
2.35.1



