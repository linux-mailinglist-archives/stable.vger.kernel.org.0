Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8196C1841
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbjCTPW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232643AbjCTPW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:22:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2308C32E63
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:16:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12181B80E55
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81204C433EF;
        Mon, 20 Mar 2023 15:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325311;
        bh=rplCljH2EC5yqaWR7ek8N9qLKjH4R8tPzBeeeB/CTTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cqsum9RwpYbnyARmQkQ3haS1hk1rXyb2BQhnhcTOg8zMCtOXzqq+sBQ7V7m0oudBL
         V6DlthZBbuPamK/H9Rudcdq4LewI1crqAphz5943mSAoXdeivoukS4vPSSkfZOduAJ
         iYWg3cyJldAPlRQmreC6Wg1R6nzAgo77/7HyitIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Emeel Hakim <ehakim@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/198] net/mlx5e: Fix macsec ASO context alignment
Date:   Mon, 20 Mar 2023 15:53:25 +0100
Message-Id: <20230320145510.339290591@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
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

From: Emeel Hakim <ehakim@nvidia.com>

[ Upstream commit 37beabe9a891b92174cd1aafbfa881fe9e05aa87 ]

Currently mlx5e_macsec_umr struct does not satisfy hardware memory
alignment requirement. Hence the result of querying advanced steering
operation (ASO) is not copied to the memory region as expected.

Fix by satisfying hardware memory alignment requirement and move
context to be first field in struct for better readability.

Fixes: 1f53da676439 ("net/mlx5e: Create advanced steering operation (ASO) object for MACsec")
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index b92d541b5286e..0c23340bfcc75 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -89,8 +89,8 @@ struct mlx5e_macsec_rx_sc {
 };
 
 struct mlx5e_macsec_umr {
+	u8 __aligned(64) ctx[MLX5_ST_SZ_BYTES(macsec_aso)];
 	dma_addr_t dma_addr;
-	u8 ctx[MLX5_ST_SZ_BYTES(macsec_aso)];
 	u32 mkey;
 };
 
-- 
2.39.2



