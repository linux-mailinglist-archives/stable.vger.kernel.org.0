Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17BDC56FCC8
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbiGKJsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233625AbiGKJrg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:47:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6C7AB7D2;
        Mon, 11 Jul 2022 02:23:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CD4F6134C;
        Mon, 11 Jul 2022 09:23:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D2AC34115;
        Mon, 11 Jul 2022 09:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531393;
        bh=WPtd9kgKbniwNf3BMQri7+fVEcYbfkFdC15EP5tNh+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZWx9vhc/a5lpeYmXK14FzqM+dU4PaF/uzL/cW3o4ciQPl9KU5wa4EZRGIYKVqPf+
         V9sw0E1R9FDPBMXppvlgkSpJV6HkI9CYaC8f0hSyfledhIIxYwxDWHUSHdmsCDebHa
         1QvxqjkR5WnUvu0eNKoOCuzhigwRV0G3/dmXcP5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/230] net/mlx5e: Check action fwd/drop flag exists also for nic flows
Date:   Mon, 11 Jul 2022 11:05:05 +0200
Message-Id: <20220711090605.473699898@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

[ Upstream commit 6b50cf45b6a0e99f3cab848a72ecca8da56b7460 ]

The driver should add offloaded rules with either a fwd or drop action.
The check existed in parsing fdb flows but not when parsing nic flows.
Move the test into actions_match_supported() which is called for
checking nic flows and fdb flows.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3aa8d0b83d10..fe52db591121 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3305,6 +3305,12 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 	ct_flow = flow_flag_test(flow, CT) && !ct_clear;
 	actions = flow->attr->action;
 
+	if (!(actions &
+	      (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_DROP))) {
+		NL_SET_ERR_MSG_MOD(extack, "Rule must have at least one forward/drop action");
+		return false;
+	}
+
 	if (mlx5e_is_eswitch_flow(flow)) {
 		if (flow->attr->esw_attr->split_count && ct_flow &&
 		    !MLX5_CAP_GEN(flow->attr->esw_attr->in_mdev, reg_c_preserve)) {
@@ -4207,13 +4213,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	}
 
-	if (!(attr->action &
-	      (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_DROP))) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Rule must have at least one forward/drop action");
-		return -EOPNOTSUPP;
-	}
-
 	if (esw_attr->split_count > 0 && !mlx5_esw_has_fwd_fdb(priv->mdev)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "current firmware doesn't support split rule for port mirroring");
-- 
2.35.1



