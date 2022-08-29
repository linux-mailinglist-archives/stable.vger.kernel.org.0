Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEC45A4A3F
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbiH2Lf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbiH2LeU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:34:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647604BD15;
        Mon, 29 Aug 2022 04:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5EF0B80F52;
        Mon, 29 Aug 2022 11:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0979AC433D6;
        Mon, 29 Aug 2022 11:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771488;
        bh=K4RxJmbMgaFU6tPeX52e9w/cMTCP4240/24suTnHgEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOf5Rp6HvhwuVNX5q5uz3fsI8FdXF6LpaZfQhCecdh+9fKc1Yyr9t8EiDo42JIaJo
         aiau0/+Oj8gXwZGjyL2VNfLIkanVDZUX0d4TLw6YYV9VLAR1Rr07e6vt5JYqGldzt3
         4mhc1QQpessPbK2hmqqPpRwMMx7tUCclc0kIEFa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 036/158] net/mlx5e: Fix wrong tc flag used when set hw-tc-offload off
Date:   Mon, 29 Aug 2022 12:58:06 +0200
Message-Id: <20220829105810.310022748@linuxfoundation.org>
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
index 62aab20025345..9e6db779b6efa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3678,7 +3678,9 @@ static int set_feature_hw_tc(struct net_device *netdev, bool enable)
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



