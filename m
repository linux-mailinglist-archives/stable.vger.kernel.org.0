Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE6C6D4A6B
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbjDCOq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234025AbjDCOqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:46:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E43280CE
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:46:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2847B81D52
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A04C433D2;
        Mon,  3 Apr 2023 14:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533176;
        bh=TE4xOXYqMwj5XtV3cSDXvMt3tMyHbTy3WEJzGo5XXdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ccq59OANEYHA4dc812RG6CTYtMsM+iL9wgJUXZ0Mqs7k3gWIlZMjkFNgQfeIX3fJx
         Ne7JUf9sRUWC+n6bA7KVdVCKy32jWsxAfQ2ANYYro9a7N9O2PM3sACse/2pgLc1aIf
         uGPRpN2HfhEvqvRAsXUQ5O6TdBjIkxxeNxwV0FLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adham Faris <afaris@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 052/187] net/mlx5e: Lower maximum allowed MTU in XSK to match XDP prerequisites
Date:   Mon,  3 Apr 2023 16:08:17 +0200
Message-Id: <20230403140417.697209115@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adham Faris <afaris@nvidia.com>

[ Upstream commit 78dee7befd56987283c13877b834c0aa97ad51b9 ]

XSK redirecting XDP programs require linearity, hence applies
restrictions on the MTU. For PAGE_SIZE=4K, MTU shouldn't exceed 3498.

Features that contradict with XDP such HW-LRO and HW-GRO are enforced
by the driver in advance, during XSK params validation, except for MTU,
which was not enforced before this patch.

This has been spotted during test scenario described below:
Attaching xdpsock program (PAGE_SIZE=4K), with MTU < 3498, detaching
XDP program, changing the MTU to arbitrary value in the range
[3499, 3754], attaching XDP program again, which ended up with failure
since MTU is > 3498.

This commit lowers the XSK MTU limitation to be aligned with XDP MTU
limitation, since XSK socket is meaningless without XDP program.

Signed-off-by: Adham Faris <afaris@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 47d4b54d15634..1f4233b2842f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4117,13 +4117,17 @@ static bool mlx5e_xsk_validate_mtu(struct net_device *netdev,
 		struct xsk_buff_pool *xsk_pool =
 			mlx5e_xsk_get_pool(&chs->params, chs->params.xsk, ix);
 		struct mlx5e_xsk_param xsk;
+		int max_xdp_mtu;
 
 		if (!xsk_pool)
 			continue;
 
 		mlx5e_build_xsk_param(xsk_pool, &xsk);
+		max_xdp_mtu = mlx5e_xdp_max_mtu(new_params, &xsk);
 
-		if (!mlx5e_validate_xsk_param(new_params, &xsk, mdev)) {
+		/* Validate XSK params and XDP MTU in advance */
+		if (!mlx5e_validate_xsk_param(new_params, &xsk, mdev) ||
+		    new_params->sw_mtu > max_xdp_mtu) {
 			u32 hr = mlx5e_get_linear_rq_headroom(new_params, &xsk);
 			int max_mtu_frame, max_mtu_page, max_mtu;
 
@@ -4133,9 +4137,9 @@ static bool mlx5e_xsk_validate_mtu(struct net_device *netdev,
 			 */
 			max_mtu_frame = MLX5E_HW2SW_MTU(new_params, xsk.chunk_size - hr);
 			max_mtu_page = MLX5E_HW2SW_MTU(new_params, SKB_MAX_HEAD(0));
-			max_mtu = min(max_mtu_frame, max_mtu_page);
+			max_mtu = min3(max_mtu_frame, max_mtu_page, max_xdp_mtu);
 
-			netdev_err(netdev, "MTU %d is too big for an XSK running on channel %u. Try MTU <= %d\n",
+			netdev_err(netdev, "MTU %d is too big for an XSK running on channel %u or its redirection XDP program. Try MTU <= %d\n",
 				   new_params->sw_mtu, ix, max_mtu);
 			return false;
 		}
-- 
2.39.2



