Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E12B521A3E
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244525AbiEJNye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243906AbiEJNwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:52:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9692992DB;
        Tue, 10 May 2022 06:38:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DA726188F;
        Tue, 10 May 2022 13:38:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C80C385C2;
        Tue, 10 May 2022 13:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189896;
        bh=ZHYzabtid5rGR1vUHabUw8fvas6K2SQA2jyLWJ7U7ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GE4nzintz7gPBbsJ2NP1BRXy3lrgubtVllmi1FWmZGtVPctYtvTLJ1a0jM//PBGtD
         p90dR/OnQrCdi0VkPuZZZJTPYB6wK95M/IJZHCqu+bSm4zT58kpWDzA+Totsoj0Src
         iK480xRRG5Cjt9UBDxET/XacsVnFkABDsfIJ9jyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Tal <moshet@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.17 063/140] net/mlx5e: Fix trust state reset in reload
Date:   Tue, 10 May 2022 15:07:33 +0200
Message-Id: <20220510130743.421684759@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Tal <moshet@nvidia.com>

commit b781bff882d16175277ca129c382886cb4c74a2c upstream.

Setting dscp2prio during the driver reload can cause dcb ieee app list to
be not empty after the reload finish and as a result to a conflict between
the priority trust state reported by the app and the state in the device
register.

Reset the dcb ieee app list on initialization in case this is
conflicting with the register status.

Fixes: 2a5e7a1344f4 ("net/mlx5e: Add dcbnl dscp to priority support")
Signed-off-by: Moshe Tal <moshet@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -1198,6 +1198,16 @@ static int mlx5e_trust_initialize(struct
 	if (err)
 		return err;
 
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
 


