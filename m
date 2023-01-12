Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066B36677ED
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240056AbjALOvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbjALOuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:50:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E3112AC0
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:37:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06835B81E69
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301DEC433D2;
        Thu, 12 Jan 2023 14:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534228;
        bh=d4BGcs+M06Mf3CtZ0TPp7Mt4/qZhlU8bmRkaPF561f0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kc7iFHGiMDA/1ONyLyFqo2yIAid1XRszl9YTiSXkylHVApevJDFBFp6rAe9QPLsrT
         +V0V1/BZIbkoG+bWx2gJ11Og8ejrtahkQnYhmX/sbk6Z0z0MXqW7ZWRIMrkqsrDU3P
         IGVF1NRZcPLm02Deg5jX15rkOsASKJBvkGumrinA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dragos Tatulea <dtatulea@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 739/783] net/mlx5e: IPoIB, Dont allow CQE compression to be turned on by default
Date:   Thu, 12 Jan 2023 14:57:35 +0100
Message-Id: <20230112135558.615248911@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit b12d581e83e3ae1080c32ab83f123005bd89a840 ]

mlx5e_build_nic_params will turn CQE compression on if the hardware
capability is enabled and the slow_pci_heuristic condition is detected.
As IPoIB doesn't support CQE compression, make sure to disable the
feature in the IPoIB profile init.

Please note that the feature is not exposed to the user for IPoIB
interfaces, so it can't be subsequently turned on.

Fixes: b797a684b0dd ("net/mlx5e: Enable CQE compression when PCI is slower than link")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 5c6a376aa62e..0e7fd200b426 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -69,6 +69,10 @@ static void mlx5i_build_nic_params(struct mlx5_core_dev *mdev,
 	params->lro_en = false;
 	params->hard_mtu = MLX5_IB_GRH_BYTES + MLX5_IPOIB_HARD_LEN;
 	params->tunneled_offload_en = false;
+
+	/* CQE compression is not supported for IPoIB */
+	params->rx_cqe_compress_def = false;
+	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS, params->rx_cqe_compress_def);
 }
 
 /* Called directly after IPoIB netdevice was created to initialize SW structs */
-- 
2.35.1



