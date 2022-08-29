Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D125A483F
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbiH2LHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiH2LHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:07:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DFA93B95A;
        Mon, 29 Aug 2022 04:05:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28378611B2;
        Mon, 29 Aug 2022 11:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFA2C433C1;
        Mon, 29 Aug 2022 11:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771008;
        bh=SYgJSW96kZotwCCYKH6JZ1z3AKWck1OSNhjo4yZ/WZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2v8KCbLmAAi96T6OSMDtt1kevXbvalVfcCjTdt9b64jahvl4KFrg1248Gku5k4hzr
         v5NdQv9Ve5bu0IN5KgqH7xvOUUFwtl1klAVMTufgSoUxlnsS3DUy9R0TcbMi7kUhSW
         Q0+y2uarJocFsIsCu5uxlzI1+KE+7dWaLvDLiPJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/136] net/mlx5e: Fix wrong tc flag used when set hw-tc-offload off
Date:   Mon, 29 Aug 2022 12:58:34 +0200
Message-Id: <20220829105806.547269593@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit 550f96432e6f6770efdaee0e65239d61431062a1 ]

The cited commit reintroduced the ability to set hw-tc-offload
in switchdev mode by reusing NIC mode calls without modifying it
to support both modes, this can cause an illegal memory access
when trying to turn hw-tc-offload off.

Fix this by using the right TC_FLAG when checking if tc rules
are installed while disabling hw-tc-offload.

Fixes: d3cbd4254df8 ("net/mlx5e: Add ndo_set_feature for uplink representor")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index fdf8d9866042c..c1c4f380803a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3325,7 +3325,9 @@ static int set_feature_hw_tc(struct net_device *netdev, bool enable)
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
 #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
-	if (!enable && mlx5e_tc_num_filters(priv, MLX5_TC_FLAG(NIC_OFFLOAD))) {
+	int tc_flag = mlx5e_is_uplink_rep(priv) ? MLX5_TC_FLAG(ESW_OFFLOAD) :
+						  MLX5_TC_FLAG(NIC_OFFLOAD);
+	if (!enable && mlx5e_tc_num_filters(priv, tc_flag)) {
 		netdev_err(netdev,
 			   "Active offloaded tc filters, can't turn hw_tc_offload off\n");
 		return -EINVAL;
-- 
2.35.1



