Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D6766C507
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbjAPQAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbjAPQAm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:00:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9251023645
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:00:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3016E61045
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435A3C433EF;
        Mon, 16 Jan 2023 16:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884840;
        bh=BLL8NSXUqPQaocHu3FTUWn9hCq929yJSxLlcPAU54Mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uz9eI1NSSJykF3KWQVsz+LyeEPChvwvYFbB0In+47tNFnpb17fkodOQa3BEcycXTu
         rfMXWWC6KwU0D03uRkQDeAQen4g6sHP+N4Iw86rAJo72oEwyZc+TFdQZmPWrrKWNfD
         rcupGoILn+42qW1/3ekFwzv49cjFrVAbJ/wVq3Hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Emeel Hakim <ehakim@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 159/183] net/mlx5e: Fix macsec ssci attribute handling in offload path
Date:   Mon, 16 Jan 2023 16:51:22 +0100
Message-Id: <20230116154810.030935498@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Emeel Hakim <ehakim@nvidia.com>

[ Upstream commit f5e1ed04aa2ea665a796f0109091ca3f2b01024a ]

Currently when macsec offload is set with extended packet number (epn)
enabled, the driver wrongly deduce the short secure channel identifier
(ssci) from the salt instead of the stand alone ssci attribute as it
should, consequently creating a mismatch between the kernel and driver's
ssci values.
Fix by using the ssci value from the relevant attribute.

Fixes: 4411a6c0abd3 ("net/mlx5e: Support MACsec offload extended packet number (EPN)")
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/macsec.c  | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index f900709639f6..7c0085ba2fc5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -62,6 +62,7 @@ struct mlx5e_macsec_sa {
 	u32 enc_key_id;
 	u32 next_pn;
 	sci_t sci;
+	ssci_t ssci;
 	salt_t salt;
 
 	struct rhash_head hash;
@@ -499,10 +500,11 @@ mlx5e_macsec_get_macsec_device_context(const struct mlx5e_macsec *macsec,
 }
 
 static void update_macsec_epn(struct mlx5e_macsec_sa *sa, const struct macsec_key *key,
-			      const pn_t *next_pn_halves)
+			      const pn_t *next_pn_halves, ssci_t ssci)
 {
 	struct mlx5e_macsec_epn_state *epn_state = &sa->epn_state;
 
+	sa->ssci = ssci;
 	sa->salt = key->salt;
 	epn_state->epn_enabled = 1;
 	epn_state->epn_msb = next_pn_halves->upper;
@@ -550,7 +552,8 @@ static int mlx5e_macsec_add_txsa(struct macsec_context *ctx)
 	tx_sa->assoc_num = assoc_num;
 
 	if (secy->xpn)
-		update_macsec_epn(tx_sa, &ctx_tx_sa->key, &ctx_tx_sa->next_pn_halves);
+		update_macsec_epn(tx_sa, &ctx_tx_sa->key, &ctx_tx_sa->next_pn_halves,
+				  ctx_tx_sa->ssci);
 
 	err = mlx5_create_encryption_key(mdev, ctx->sa.key, secy->key_len,
 					 MLX5_ACCEL_OBJ_MACSEC_KEY,
@@ -945,7 +948,8 @@ static int mlx5e_macsec_add_rxsa(struct macsec_context *ctx)
 	rx_sa->fs_id = rx_sc->sc_xarray_element->fs_id;
 
 	if (ctx->secy->xpn)
-		update_macsec_epn(rx_sa, &ctx_rx_sa->key, &ctx_rx_sa->next_pn_halves);
+		update_macsec_epn(rx_sa, &ctx_rx_sa->key, &ctx_rx_sa->next_pn_halves,
+				  ctx_rx_sa->ssci);
 
 	err = mlx5_create_encryption_key(mdev, ctx->sa.key, ctx->secy->key_len,
 					 MLX5_ACCEL_OBJ_MACSEC_KEY,
-- 
2.35.1



