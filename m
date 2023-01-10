Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC458664AF5
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239436AbjAJSiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239623AbjAJShX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:37:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21325B4A2
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:32:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D626B818FF
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:32:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3836C433EF;
        Tue, 10 Jan 2023 18:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375552;
        bh=o/wS/E74r0r4tJoNLvolTgFX0knmZcqXzoXWHqCB3IA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fxhgMpUaY5qXDAqdQF8+DzXVMkGtB4uTD2F11Qr/mLaWkkePTiwyt2iLSE89HiF+A
         sntXuhUPDg+hR4faYjdL+4Q1OihpZVCIos0DDFONY5l19ObILIYnWR9d37WavIRvY2
         VJ5PUDTT5CO7NSTUUf04zMnndYGemslQ03oSXlqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 226/290] net/mlx5e: TC, Refactor mlx5e_tc_add_flow_mod_hdr() to get flow attr
Date:   Tue, 10 Jan 2023 19:05:18 +0100
Message-Id: <20230110180039.813960043@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

[ Upstream commit ff99316700799b84e842f819a44db608557bae3e ]

In later commit we are going to instantiate multiple attr instances
for flow instead of single attr.
Make sure mlx5e_tc_add_flow_mod_hdr() use the correct attr and not flow->attr.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 2951b2e142ec ("net/mlx5e: Always clear dest encap in neigh-update-del")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c      | 12 ++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h      |  4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 700c463ea367..3b63d9c20580 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -1342,7 +1342,7 @@ static void mlx5e_reoffload_encap(struct mlx5e_priv *priv,
 			continue;
 		}
 
-		err = mlx5e_tc_add_flow_mod_hdr(priv, parse_attr, flow);
+		err = mlx5e_tc_add_flow_mod_hdr(priv, flow, attr);
 		if (err) {
 			mlx5_core_warn(priv->mdev, "Failed to update flow mod_hdr err=%d",
 				       err);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 843c8435387f..8f2f99689aba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1342,10 +1342,10 @@ int mlx5e_tc_query_route_vport(struct net_device *out_dev, struct net_device *ro
 }
 
 int mlx5e_tc_add_flow_mod_hdr(struct mlx5e_priv *priv,
-			      struct mlx5e_tc_flow_parse_attr *parse_attr,
-			      struct mlx5e_tc_flow *flow)
+			      struct mlx5e_tc_flow *flow,
+			      struct mlx5_flow_attr *attr)
 {
-	struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts = &parse_attr->mod_hdr_acts;
+	struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts = &attr->parse_attr->mod_hdr_acts;
 	struct mlx5_modify_hdr *mod_hdr;
 
 	mod_hdr = mlx5_modify_header_alloc(priv->mdev,
@@ -1355,8 +1355,8 @@ int mlx5e_tc_add_flow_mod_hdr(struct mlx5e_priv *priv,
 	if (IS_ERR(mod_hdr))
 		return PTR_ERR(mod_hdr);
 
-	WARN_ON(flow->attr->modify_hdr);
-	flow->attr->modify_hdr = mod_hdr;
+	WARN_ON(attr->modify_hdr);
+	attr->modify_hdr = mod_hdr;
 
 	return 0;
 }
@@ -1457,7 +1457,7 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
 	    !(attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR)) {
 		if (vf_tun) {
-			err = mlx5e_tc_add_flow_mod_hdr(priv, parse_attr, flow);
+			err = mlx5e_tc_add_flow_mod_hdr(priv, flow, attr);
 			if (err)
 				goto err_out;
 		} else {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 1a4cd882f0fb..f48af82781f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -241,8 +241,8 @@ int mlx5e_tc_match_to_reg_set_and_get_id(struct mlx5_core_dev *mdev,
 					 u32 data);
 
 int mlx5e_tc_add_flow_mod_hdr(struct mlx5e_priv *priv,
-			      struct mlx5e_tc_flow_parse_attr *parse_attr,
-			      struct mlx5e_tc_flow *flow);
+			      struct mlx5e_tc_flow *flow,
+			      struct mlx5_flow_attr *attr);
 
 int alloc_mod_hdr_actions(struct mlx5_core_dev *mdev,
 			  int namespace,
-- 
2.35.1



