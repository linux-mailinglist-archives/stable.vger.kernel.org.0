Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63A9F579BC3
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239913AbiGSMb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239909AbiGSMaJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:30:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DCF6C125;
        Tue, 19 Jul 2022 05:11:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D92C615F4;
        Tue, 19 Jul 2022 12:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343F4C341C6;
        Tue, 19 Jul 2022 12:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232702;
        bh=pSo7nHyz2Rcd4Tctm5UEPmaFOxR38Pcp/wDMG3bR+dI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S7byWGyDl8u6yXT5mRLWHY/9BWy5fiQhWaG89q2G7nod9MU9yeV5gE6lEAhVZhe9g
         xWxKpIv8l4qbLgGOmwlYNc04z1GU8E7gYPkXi+4cvpprGeRv2i39432ysaIhVPVNMn
         Zwva8MfkIpyju7i8x1cO9S2sIh1Nd9lHnmfVe19o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/167] net/mlx5e: kTLS, Fix build time constant test in RX
Date:   Tue, 19 Jul 2022 13:52:48 +0200
Message-Id: <20220719114700.201844031@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

[ Upstream commit 2ec6cf9b742a5c18982861322fa5de6510f8f57e ]

Use the correct constant (TLS_DRIVER_STATE_SIZE_RX) in the comparison
against the size of the private RX TLS driver context.

Fixes: 1182f3659357 ("net/mlx5e: kTLS, Add kTLS RX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 15711814d2d2..d92b97c56f4c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -231,8 +231,7 @@ mlx5e_set_ktls_rx_priv_ctx(struct tls_context *tls_ctx,
 	struct mlx5e_ktls_offload_context_rx **ctx =
 		__tls_driver_ctx(tls_ctx, TLS_OFFLOAD_CTX_DIR_RX);
 
-	BUILD_BUG_ON(sizeof(struct mlx5e_ktls_offload_context_rx *) >
-		     TLS_OFFLOAD_CONTEXT_SIZE_RX);
+	BUILD_BUG_ON(sizeof(priv_rx) > TLS_DRIVER_STATE_SIZE_RX);
 
 	*ctx = priv_rx;
 }
-- 
2.35.1



