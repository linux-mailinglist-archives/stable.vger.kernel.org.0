Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E53C5317AE
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241498AbiEWRn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242795AbiEWRhr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:37:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007165D5F3;
        Mon, 23 May 2022 10:31:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88134608C3;
        Mon, 23 May 2022 17:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86315C385A9;
        Mon, 23 May 2022 17:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326934;
        bh=hcRyfJ/pCYThU0VoLkwhw+m+Amf5znE5EpP8FRpqnL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hGZK86BjFvQU2rpc9Yk91dzqAxgWpyxA387kOxKFEmD7a2GOrCmv4GYlrU5StDLLm
         BcCs6HFW90ipCUC9D9AdOTX8zdDsNpDmLd2+JQsupHfMAkfcl0+BcCwyJxhQYLNj6G
         QGV9vy3syuzdfq2ammgvX4N1rils5/vrwhq+1Tnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 105/158] net/mlx5e: Block rx-gro-hw feature in switchdev mode
Date:   Mon, 23 May 2022 19:04:22 +0200
Message-Id: <20220523165848.622257461@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 15a5078cab30d7aa02ad14bfadebf247d95fc239 ]

When the driver is in switchdev mode and rx-gro-hw is set, the RQ needs
special CQE handling. Till then, block setting of rx-gro-hw feature in
switchdev mode, to avoid failure while setting the feature due to
failure while opening the RQ.

Fixes: f97d5c2a453e ("net/mlx5e: Add handle SHAMPO cqe support")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 169e3524bb1c..d468daa7dc20 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3829,6 +3829,10 @@ static netdev_features_t mlx5e_fix_uplink_rep_features(struct net_device *netdev
 	if (netdev->features & NETIF_F_NTUPLE)
 		netdev_warn(netdev, "Disabling ntuple, not supported in switchdev mode\n");
 
+	features &= ~NETIF_F_GRO_HW;
+	if (netdev->features & NETIF_F_GRO_HW)
+		netdev_warn(netdev, "Disabling HW_GRO, not supported in switchdev mode\n");
+
 	return features;
 }
 
-- 
2.35.1



