Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A66951FA05
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 12:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiEIKfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 06:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232459AbiEIKe4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 06:34:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14932A3758
        for <stable@vger.kernel.org>; Mon,  9 May 2022 03:30:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81ABEB810E2
        for <stable@vger.kernel.org>; Mon,  9 May 2022 10:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26D3C385AB;
        Mon,  9 May 2022 10:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652092237;
        bh=47d0m1J01aBGyNB87KLJ+CzOnQBKSOjKtVtSW/91nw4=;
        h=Subject:To:Cc:From:Date:From;
        b=R2QOZEw1obHZ7pUkVtQRFJZoO0XcC+BEeHQb0B16333LeCawUFyCPCsVEv2ZuIun3
         S+mmBHbq6jU+lqAiWTSVcQfVogzmletnYKg8iejop1oInXTaILpzvJ+YQutahjuyLh
         wdZdRlutbV9b5bpSTKZgqo9JbVV0olckx5XoFIso=
Subject: FAILED: patch "[PATCH] net/mlx5e: Fix trust state reset in reload" failed to apply to 5.4-stable tree
To:     moshet@nvidia.com, saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 12:30:34 +0200
Message-ID: <165209223445213@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b781bff882d16175277ca129c382886cb4c74a2c Mon Sep 17 00:00:00 2001
From: Moshe Tal <moshet@nvidia.com>
Date: Wed, 9 Feb 2022 19:23:56 +0200
Subject: [PATCH] net/mlx5e: Fix trust state reset in reload

Setting dscp2prio during the driver reload can cause dcb ieee app list to
be not empty after the reload finish and as a result to a conflict between
the priority trust state reported by the app and the state in the device
register.

Reset the dcb ieee app list on initialization in case this is
conflicting with the register status.

Fixes: 2a5e7a1344f4 ("net/mlx5e: Add dcbnl dscp to priority support")
Signed-off-by: Moshe Tal <moshet@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index d659fe07d464..8ead2c82a52a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -1200,6 +1200,16 @@ static int mlx5e_trust_initialize(struct mlx5e_priv *priv)
 		return err;
 	WRITE_ONCE(priv->dcbx_dp.trust_state, trust_state);
 
+	if (priv->dcbx_dp.trust_state == MLX5_QPTS_TRUST_PCP && priv->dcbx.dscp_app_cnt) {
+		/*
+		 * Align the driver state with the register state.
+		 * Temporary state change is required to enable the app list reset.
+		 */
+		priv->dcbx_dp.trust_state = MLX5_QPTS_TRUST_DSCP;
+		mlx5e_dcbnl_delete_app(priv);
+		priv->dcbx_dp.trust_state = MLX5_QPTS_TRUST_PCP;
+	}
+
 	mlx5e_params_calc_trust_tx_min_inline_mode(priv->mdev, &priv->channels.params,
 						   priv->dcbx_dp.trust_state);
 

