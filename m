Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D421664AF7
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239449AbjAJSiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:38:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239637AbjAJShZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:37:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05B85B496
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:32:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C266B81902
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E9DC433EF;
        Tue, 10 Jan 2023 18:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375561;
        bh=TLcAoKOOrytHrR5zm0L7Fa5L0yWYku3xqp1n/7eTZXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNVMNXlGOHPKwo4bZ6DkZgaZpQtCaoNuAFKoqUlRBe9bgmqDkDYG6cXGztaL0EndB
         Az+MDd/5mt1Ic6mAx/uEYPauhlXSXwkDvSAsK3y6o8W8uMo7414KHPhq/kI2vFxSIn
         plSt5GqaF3dogWI9RES4TNJcT9vnkZS2Cr6olul4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adham Faris <afaris@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 228/290] net/mlx5e: Fix hw mtu initializing at XDP SQ allocation
Date:   Tue, 10 Jan 2023 19:05:20 +0100
Message-Id: <20230110180039.887020518@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: Adham Faris <afaris@nvidia.com>

[ Upstream commit 1e267ab88dc44c48f556218f7b7f14c76f7aa066 ]

Current xdp xmit functions logic (mlx5e_xmit_xdp_frame_mpwqe or
mlx5e_xmit_xdp_frame), validates xdp packet length by comparing it to
hw mtu (configured at xdp sq allocation) before xmiting it. This check
does not account for ethernet fcs length (calculated and filled by the
nic). Hence, when we try sending packets with length > (hw-mtu -
ethernet-fcs-size), the device port drops it and tx_errors_phy is
incremented. Desired behavior is to catch these packets and drop them
by the driver.

Fix this behavior in XDP SQ allocation function (mlx5e_alloc_xdpsq) by
subtracting ethernet FCS header size (4 Bytes) from current hw mtu
value, since ethernet FCS is calculated and written to ethernet frames
by the nic.

Fixes: d8bec2b29a82 ("net/mlx5e: Support bpf_xdp_adjust_head()")
Signed-off-by: Adham Faris <afaris@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c1c4f380803a..be19f5cf9d15 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -977,7 +977,7 @@ static int mlx5e_alloc_xdpsq(struct mlx5e_channel *c,
 	sq->channel   = c;
 	sq->uar_map   = mdev->mlx5e_res.hw_objs.bfreg.map;
 	sq->min_inline_mode = params->tx_min_inline_mode;
-	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu);
+	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu) - ETH_FCS_LEN;
 	sq->xsk_pool  = xsk_pool;
 
 	sq->stats = sq->xsk_pool ?
-- 
2.35.1



