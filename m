Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90074D8432
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241637AbiCNMXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242779AbiCNMTk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:19:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962925007D;
        Mon, 14 Mar 2022 05:14:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC14160B06;
        Mon, 14 Mar 2022 12:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC680C340EC;
        Mon, 14 Mar 2022 12:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260073;
        bh=7RI4WjNoYbGJ2IO97UY2MisVPVgUVh3CGxFmBuI+nDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R14hM1KuCOjLVG5uG1wmf9V7ZISTBqfz1VuzM7GfVZOx/mbUlZ0xH0BCxhY8IGqZY
         6+5x6HOoPjVZO/7FCvv1sJW1ieHZ06nZUQlx94LWJhJJcmY6yAJdWgNwoYvYa4AWRa
         jwQzC4HOu3ICIFCsf6+2u3UdIEEfgpPsBrs01kwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Ben-Ishay <benishay@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 048/121] net/mlx5e: SHAMPO, reduce TIR indication
Date:   Mon, 14 Mar 2022 12:53:51 +0100
Message-Id: <20220314112745.468096325@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

[ Upstream commit 99a2b9be077ae3a5d97fbf5f7782e0f2e9812978 ]

SHAMPO is an RQ / WQ feature, an indication was added to the TIR in the
first place to enforce suitability between connected TIR and RQ, this
enforcement does not exist in current the Firmware implementation and was
redundant in the first place.

Fixes: 83439f3c37aa ("net/mlx5e: Add HW-GRO offload")
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tir.c  | 3 ---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 3 +--
 include/linux/mlx5/mlx5_ifc.h                     | 1 -
 3 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
index da169b816665..d4239e3b3c88 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
@@ -88,9 +88,6 @@ void mlx5e_tir_builder_build_packet_merge(struct mlx5e_tir_builder *builder,
 			 (MLX5E_PARAMS_DEFAULT_LRO_WQE_SZ - rough_max_l2_l3_hdr_sz) >> 8);
 		MLX5_SET(tirc, tirc, lro_timeout_period_usecs, pkt_merge_param->timeout);
 		break;
-	case MLX5E_PACKET_MERGE_SHAMPO:
-		MLX5_SET(tirc, tirc, packet_merge_mask, MLX5_TIRC_PACKET_MERGE_MASK_SHAMPO);
-		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d92b82cdfd4e..22de7327c5a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3592,8 +3592,7 @@ static int set_feature_hw_gro(struct net_device *netdev, bool enable)
 		goto out;
 	}
 
-	err = mlx5e_safe_switch_params(priv, &new_params,
-				       mlx5e_modify_tirs_packet_merge_ctx, NULL, reset);
+	err = mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, reset);
 out:
 	mutex_unlock(&priv->state_lock);
 	return err;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 58a60e46c319..66522bc56a0b 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -3410,7 +3410,6 @@ enum {
 enum {
 	MLX5_TIRC_PACKET_MERGE_MASK_IPV4_LRO  = BIT(0),
 	MLX5_TIRC_PACKET_MERGE_MASK_IPV6_LRO  = BIT(1),
-	MLX5_TIRC_PACKET_MERGE_MASK_SHAMPO    = BIT(2),
 };
 
 enum {
-- 
2.34.1



