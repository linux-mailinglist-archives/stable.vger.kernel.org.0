Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 366415A4A47
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiH2Lg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbiH2Lfz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:35:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6210163F1E;
        Mon, 29 Aug 2022 04:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A12EBB80F2B;
        Mon, 29 Aug 2022 11:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0644EC433D6;
        Mon, 29 Aug 2022 11:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771421;
        bh=7VKZhXCGzisaoxFdEPdF86+73ELz64gAFPvK7/uHejM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Awj+hfU4MhB3jzcixXh7z2pBf/hcyvQRHMbnrdjLmaW/tMuOdVJ6/2SatLEWgmVcn
         d8sFBleXsjbODB5G24avz+4mnHpUXuoOagtQxYnyxeR+P0M7pR2V9AhLO8/ZEV55fW
         rOaSZSydVudM61NvXlsoEE+JMqh7aPpVzT66be1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 029/158] net/mlx5e: Properly disable vlan strip on non-UL reps
Date:   Mon, 29 Aug 2022 12:57:59 +0200
Message-Id: <20220829105810.003844350@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit f37044fd759b6bc40b6398a978e0b1acdf717372 ]

When querying mlx5 non-uplink representors capabilities with ethtool
rx-vlan-offload is marked as "off [fixed]". However, it is actually always
enabled because mlx5e_params->vlan_strip_disable is 0 by default when
initializing struct mlx5e_params instance. Fix the issue by explicitly
setting the vlan_strip_disable to 'true' for non-uplink representors.

Fixes: cb67b832921c ("net/mlx5e: Introduce SRIOV VF representors")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index f797fd97d305b..7da3dc6261929 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -662,6 +662,8 @@ static void mlx5e_build_rep_params(struct net_device *netdev)
 
 	params->mqprio.num_tc       = 1;
 	params->tunneled_offload_en = false;
+	if (rep->vport != MLX5_VPORT_UPLINK)
+		params->vlan_strip_disable = true;
 
 	mlx5_query_min_inline(mdev, &params->tx_min_inline_mode);
 }
-- 
2.35.1



