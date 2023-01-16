Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249B366C508
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbjAPQAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbjAPQAq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:00:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077052365A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:00:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0111B8105C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12973C433EF;
        Mon, 16 Jan 2023 16:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884843;
        bh=cS1P93Myt0HzPeEL8NZ4bXLt9OLBFuoUHBIXvf3xhlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kTk5ONhalxCu0SNuVPBJn1sAhgj5owiWOQEmpYZr3znE0d3zVR2LUG+XB3zRTUWcy
         NTv3Dan5JqtSpBNfyGe4DrabJtHVbPv7mpsNuJJ0CgNocopxmPTg3FgcmnAACLMEt/
         WXARFNCb/SwwHj0edtbi0WgW6dOpjx1No7QfHdH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Emeel Hakim <ehakim@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/183] net/mlx5e: Fix macsec possible null dereference when updating MAC security entity (SecY)
Date:   Mon, 16 Jan 2023 16:51:23 +0100
Message-Id: <20230116154810.068747068@linuxfoundation.org>
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

[ Upstream commit 9828994ac492e8e7de47fe66097b7e665328f348 ]

Upon updating MAC security entity (SecY) in hw offload path, the macsec
security association (SA) initialization routine is called. In case of
extended packet number (epn) is enabled the salt and ssci attributes are
retrieved using the MACsec driver rx_sa context which is unavailable when
updating a SecY property such as encoding-sa hence the null dereference.
Fix by using the provided SA to set those attributes.

Fixes: 4411a6c0abd3 ("net/mlx5e: Support MACsec offload extended packet number (EPN)")
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/macsec.c    | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 7c0085ba2fc5..b92d541b5286 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -359,7 +359,6 @@ static int mlx5e_macsec_init_sa(struct macsec_context *ctx,
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5_macsec_obj_attrs obj_attrs;
 	union mlx5e_macsec_rule *macsec_rule;
-	struct macsec_key *key;
 	int err;
 
 	obj_attrs.next_pn = sa->next_pn;
@@ -369,13 +368,9 @@ static int mlx5e_macsec_init_sa(struct macsec_context *ctx,
 	obj_attrs.aso_pdn = macsec->aso.pdn;
 	obj_attrs.epn_state = sa->epn_state;
 
-	key = (is_tx) ? &ctx->sa.tx_sa->key : &ctx->sa.rx_sa->key;
-
 	if (sa->epn_state.epn_enabled) {
-		obj_attrs.ssci = (is_tx) ? cpu_to_be32((__force u32)ctx->sa.tx_sa->ssci) :
-					   cpu_to_be32((__force u32)ctx->sa.rx_sa->ssci);
-
-		memcpy(&obj_attrs.salt, &key->salt, sizeof(key->salt));
+		obj_attrs.ssci = cpu_to_be32((__force u32)sa->ssci);
+		memcpy(&obj_attrs.salt, &sa->salt, sizeof(sa->salt));
 	}
 
 	obj_attrs.replay_window = ctx->secy->replay_window;
-- 
2.35.1



