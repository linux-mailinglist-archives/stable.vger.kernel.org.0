Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3337A664924
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239194AbjAJSSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239205AbjAJSRb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:17:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B7865B6
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:16:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8D60B818FF
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CB6C433D2;
        Tue, 10 Jan 2023 18:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374561;
        bh=1vPwRMs2yjD0xjGBksJHtpbk0dkBM+7GvvZTraCV8AU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYpDFdnCvQn+9yvNoIJF9ZnsVpD7hPZWtb3ojEm4+9YkFPzCv1+pa4S/Q9pAU0ZUG
         TszUUWLTBgwZ+UYDQ49BzS2QXl1dIurBNeQ8v0uFwtTT4FavE6fs1DgjrYToaSnwQq
         xCiHlgFyaIIRAe+a8MZj/ft4fxQ6OCCuQYFJq3Z4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dragos Tatulea <dtatulea@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/159] net/mlx5e: IPoIB, Dont allow CQE compression to be turned on by default
Date:   Tue, 10 Jan 2023 19:03:24 +0100
Message-Id: <20230110180020.091877265@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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
index 4e3a75496dd9..84f5352b0ce1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -71,6 +71,10 @@ static void mlx5i_build_nic_params(struct mlx5_core_dev *mdev,
 	params->packet_merge.type = MLX5E_PACKET_MERGE_NONE;
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



