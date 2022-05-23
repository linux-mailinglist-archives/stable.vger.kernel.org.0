Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 864EA531A5B
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241270AbiEWRj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241784AbiEWRgD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:36:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EEB8FD66;
        Mon, 23 May 2022 10:30:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 083AD611E6;
        Mon, 23 May 2022 17:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC61C385A9;
        Mon, 23 May 2022 17:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326941;
        bh=iGoQwlvfqcP4hlbNazx0sB6oj/lSpmf3r72OruQpJEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pX5F67BAIAgjk+rZs3MTzb41JQvqrCDsLk0Ibd86Gy8zpq/ANFGMimiElHbNAJfXg
         Xj7k4RVJhW+8Xipth2bhbEqWlZuijpd6fak1CHgRYhSCTJtrd7Q4SaYEnkP3HAek6i
         CTcVQ2cnJEsB4MsPk/dM1p2XRY+DQ5bYjg/3qoac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 107/158] net/mlx5e: Properly block HW GRO when XDP is enabled
Date:   Mon, 23 May 2022 19:04:24 +0200
Message-Id: <20220523165848.887505261@linuxfoundation.org>
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

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit b0617e7b35001c92c8fa777e1a095d3e693813df ]

HW GRO is incompatible and mutually exclusive with XDP and XSK. However,
the needed checks are only made when enabling XDP. If HW GRO is enabled
when XDP is already active, the command will succeed, and XDP will be
skipped in the data path, although still enabled.

This commit fixes the bug by checking the XDP and XSK status in
mlx5e_fix_features and disabling HW GRO if XDP is enabled.

Fixes: 83439f3c37aa ("net/mlx5e: Add HW-GRO offload")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 1f8fc8d77bc3..4b83dd05afcd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3870,6 +3870,18 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 			netdev_warn(netdev, "LRO is incompatible with XDP\n");
 			features &= ~NETIF_F_LRO;
 		}
+		if (features & NETIF_F_GRO_HW) {
+			netdev_warn(netdev, "HW GRO is incompatible with XDP\n");
+			features &= ~NETIF_F_GRO_HW;
+		}
+	}
+
+	if (priv->xsk.refcnt) {
+		if (features & NETIF_F_GRO_HW) {
+			netdev_warn(netdev, "HW GRO is incompatible with AF_XDP (%u XSKs are active)\n",
+				    priv->xsk.refcnt);
+			features &= ~NETIF_F_GRO_HW;
+		}
 	}
 
 	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS)) {
-- 
2.35.1



