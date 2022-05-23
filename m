Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802DD531A42
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241304AbiEWRaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240915AbiEWR0J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:26:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8292343ADD;
        Mon, 23 May 2022 10:21:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 279E4B8121D;
        Mon, 23 May 2022 17:21:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C1FC385A9;
        Mon, 23 May 2022 17:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326468;
        bh=JnNWw/t2HA0rSws4pPMJwzJIgFsdxCM4zHANsZhxPDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HOymOp7Jmuc2PAu1SFiPP8a5F25xuaM6JdXsA29U161/fIZnFX5Pfu4s/vMgNTvuI
         TUioVtPEoKFTHOH2tgkzSgzW66t+9DgYYK/tlhUGDaCAEfnSYIQFDsJe0gfMl/FutL
         8uHzZRe9hW0Wzc7Dr1YlfYSYzxMxB1qfXtqYGrM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/132] net/mlx5e: Properly block LRO when XDP is enabled
Date:   Mon, 23 May 2022 19:05:00 +0200
Message-Id: <20220523165838.377088716@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
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

[ Upstream commit cf6e34c8c22fba66bd21244b95ea47e235f68974 ]

LRO is incompatible and mutually exclusive with XDP. However, the needed
checks are only made when enabling XDP. If LRO is enabled when XDP is
already active, the command will succeed, and XDP will be skipped in the
data path, although still enabled.

This commit fixes the bug by checking the XDP status in
mlx5e_fix_features and disabling LRO if XDP is enabled.

Fixes: 86994156c736 ("net/mlx5e: XDP fast RX drop bpf programs support")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 01301bee420c..7efb898e9f96 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3542,6 +3542,13 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 		}
 	}
 
+	if (params->xdp_prog) {
+		if (features & NETIF_F_LRO) {
+			netdev_warn(netdev, "LRO is incompatible with XDP\n");
+			features &= ~NETIF_F_LRO;
+		}
+	}
+
 	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS)) {
 		features &= ~NETIF_F_RXHASH;
 		if (netdev->features & NETIF_F_RXHASH)
-- 
2.35.1



