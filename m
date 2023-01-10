Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2561366486C
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238663AbjAJSLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:11:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239064AbjAJSKV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:10:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95CA2726
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:08:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 850A8B81901
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:08:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFA2C433EF;
        Tue, 10 Jan 2023 18:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374136;
        bh=ADW6vxSQp5gVMV3Tl8XJJ9V0rEGhfOB0nyp/GyFp3zE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zVQpdLgxYGqsI5bSynPuuHFl5nbn88ALd4J1v74wXuJU/C631VunZb1Y53U/N+dLG
         cOAl0H4A7FCrBINvOolZK4jumWM/M4lat4dDSlWlwunVSiEfFHQQXx65HG/UFCJaaw
         HgiQtAjeLDEjHXimhVUhzySt2VUnU1Z6I9GyNatY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adham Faris <afaris@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 058/148] net/mlx5e: Fix hw mtu initializing at XDP SQ allocation
Date:   Tue, 10 Jan 2023 19:02:42 +0100
Message-Id: <20230110180019.066705331@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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
index 6cf6a81775a8..5c16efb8be81 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1146,7 +1146,7 @@ static int mlx5e_alloc_xdpsq(struct mlx5e_channel *c,
 	sq->channel   = c;
 	sq->uar_map   = mdev->mlx5e_res.hw_objs.bfreg.map;
 	sq->min_inline_mode = params->tx_min_inline_mode;
-	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu);
+	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu) - ETH_FCS_LEN;
 	sq->xsk_pool  = xsk_pool;
 
 	sq->stats = sq->xsk_pool ?
-- 
2.35.1



