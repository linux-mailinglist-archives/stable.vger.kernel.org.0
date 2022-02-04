Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0744A9682
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358010AbiBDJ0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358022AbiBDJZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:25:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17FCC061794;
        Fri,  4 Feb 2022 01:25:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5889B616AD;
        Fri,  4 Feb 2022 09:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D19C004E1;
        Fri,  4 Feb 2022 09:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966703;
        bh=Fek5eS//BUxZXWLl1ZZY4p+FXu9Z0HSyHuyF3HerRxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NLrXYu1Qd/Qtn0wQ0+dDN94jwSdWnSEYSTOuOHvxKDSgKTRpIbQfrUAD3HWBFbmGS
         G+SHAsd0tV3kUv2g1KPA2u5MK7WwRXGNyQXe4zHHfMPcQ1+u51Wo5Ojzcb1gwR4K+m
         xgo7mXv+Zzgqc/tPQE9Wn5xjv9IlCNAk7k9Wa/UM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.16 13/43] net/mlx5e: IPsec: Fix tunnel mode crypto offload for non TCP/UDP traffic
Date:   Fri,  4 Feb 2022 10:22:20 +0100
Message-Id: <20220204091917.611942479@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

commit de47db0cf7f4a9c555ad204e06baa70b50a70d08 upstream.

IPsec Tunnel mode crypto offload software parser (SWP) setting in data
path currently always set the inner L4 offset regardless of the
encapsulated L4 header type and whether it exists in the first place,
this breaks non TCP/UDP traffic as such.

Set the SWP inner L4 offset only when the IPsec tunnel encapsulated L4
header protocol is TCP/UDP.

While at it fix inner ip protocol read for setting MLX5_ETH_WQE_SWP_INNER_L4_UDP
flag to address the case where the ip header protocol is IPv6.

Fixes: f1267798c980 ("net/mlx5: Fix checksum issue of VXLAN and IPsec crypto offload")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c |   13 ++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -157,11 +157,20 @@ static void mlx5e_ipsec_set_swp(struct s
 	/* Tunnel mode */
 	if (mode == XFRM_MODE_TUNNEL) {
 		eseg->swp_inner_l3_offset = skb_inner_network_offset(skb) / 2;
-		eseg->swp_inner_l4_offset = skb_inner_transport_offset(skb) / 2;
 		if (xo->proto == IPPROTO_IPV6)
 			eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L3_IPV6;
-		if (inner_ip_hdr(skb)->protocol == IPPROTO_UDP)
+
+		switch (xo->inner_ipproto) {
+		case IPPROTO_UDP:
 			eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L4_UDP;
+			fallthrough;
+		case IPPROTO_TCP:
+			/* IP | ESP | IP | [TCP | UDP] */
+			eseg->swp_inner_l4_offset = skb_inner_transport_offset(skb) / 2;
+			break;
+		default:
+			break;
+		}
 		return;
 	}
 


