Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53795664926
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239197AbjAJSSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239224AbjAJSRg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:17:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25D213FA7
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:16:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 579BE61864
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:16:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A0BC4331D;
        Tue, 10 Jan 2023 18:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374572;
        bh=knHi9VLEo291rWR7ShrUaiH7g/2N6DF7uxcLAwYZ/yY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CUKgQFWBCPl01WHj2fFbO43Uz4KbmdeEvFsk4sgvVHlzAJT3t/lCXiXJLLCp6e/NV
         swYGOWrF234AdtCEfsiUxaRe486wOa50/6ymz67dCsenJiA/VPJS0/WP5kC8O96DTz
         Dri2stAo04Z4wnK/AloGg/O96dxckQnngzhWMJ8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adham Faris <afaris@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/159] net/mlx5e: Fix hw mtu initializing at XDP SQ allocation
Date:   Tue, 10 Jan 2023 19:03:28 +0100
Message-Id: <20230110180020.221244572@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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
index 5e41dfdf79c8..951ede433813 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1298,7 +1298,7 @@ static int mlx5e_alloc_xdpsq(struct mlx5e_channel *c,
 	sq->channel   = c;
 	sq->uar_map   = mdev->mlx5e_res.hw_objs.bfreg.map;
 	sq->min_inline_mode = params->tx_min_inline_mode;
-	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu);
+	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu) - ETH_FCS_LEN;
 	sq->xsk_pool  = xsk_pool;
 
 	sq->stats = sq->xsk_pool ?
-- 
2.35.1



