Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF2B531A16
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240807AbiEWRdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241376AbiEWR0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:26:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D7B71A3C;
        Mon, 23 May 2022 10:21:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5546B811CE;
        Mon, 23 May 2022 17:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB3FC385A9;
        Mon, 23 May 2022 17:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326027;
        bh=/GDkSZHAzbamarORSCxgSsnl12Nd3mgbPNSPPbVHg7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fes8fK5LbUrLEr7aim30OdLeOsGhYW5LFPCoJaLi8dHZsMF5lexDKgMV36fArRzXx
         Hy/mqBFj+pSmEUXtsz69yu67iDE6zFPilRpC6mtxoaOLXDp6328QlVi+CNJUFZ8Fg9
         ik8mR7HRsOCQp1PDmmkmyqwovp/27aIMQH8BEE3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 44/68] net/mlx5e: Properly block LRO when XDP is enabled
Date:   Mon, 23 May 2022 19:05:11 +0200
Message-Id: <20220523165809.884987901@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165802.500642349@linuxfoundation.org>
References: <20220523165802.500642349@linuxfoundation.org>
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
index 2465165cbea7..73291051808f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3980,6 +3980,13 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
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



