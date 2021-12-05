Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0FC468B15
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 14:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbhLENij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 08:38:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37140 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbhLENij (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 08:38:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67C4FB80E53
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 13:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B70C341C1;
        Sun,  5 Dec 2021 13:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638711310;
        bh=4iZaoVd0iQV1h345LPdPXeoPKMnjN186MigTBeEznwc=;
        h=Subject:To:Cc:From:Date:From;
        b=b/G11wlG35ylHuiS2Hqt8Gg4+LSZYIaUxB2MPdTQCzHfvHZh2ejhjeg2mqA1P7k8D
         nmAdov2Pnhsv8LRkzXEGgBJxb5npV0AHnKTxDUb5E28VJuTrHumMaW5snCvBVXIoKz
         ZXx7wTjm2BZvEAU1D0/1ApUd0gsOZ6K7ijv0J4QM=
Subject: FAILED: patch "[PATCH] net/mlx5e: IPsec: Fix Software parser inner l3 type setting" failed to apply to 5.10-stable tree
To:     raeds@nvidia.com, maord@nvidia.com, saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 05 Dec 2021 14:34:54 +0100
Message-ID: <163871129487199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c65d638ab39034cbaa36773b980d28106cfc81fa Mon Sep 17 00:00:00 2001
From: Raed Salem <raeds@nvidia.com>
Date: Wed, 17 Nov 2021 13:33:57 +0200
Subject: [PATCH] net/mlx5e: IPsec: Fix Software parser inner l3 type setting
 in case of encapsulation

Current code wrongly uses the skb->protocol field which reflects the
outer l3 protocol to set the inner l3 type in Software Parser (SWP)
fields settings in the ethernet segment (eseg) in flows where inner
l3 exists like in Vxlan over ESP flow, the above method wrongly use
the outer protocol type instead of the inner one. thus breaking cases
where inner and outer headers have different protocols.

Fix by setting the inner l3 type in SWP according to the inner l3 ip
header version.

Fixes: 2ac9cfe78223 ("net/mlx5e: IPSec, Add Innova IPSec offload TX data path")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index fb5397324aa4..2db9573a3fe6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -191,7 +191,7 @@ static void mlx5e_ipsec_set_swp(struct sk_buff *skb,
 			eseg->swp_inner_l3_offset = skb_inner_network_offset(skb) / 2;
 			eseg->swp_inner_l4_offset =
 				(skb->csum_start + skb->head - skb->data) / 2;
-			if (skb->protocol == htons(ETH_P_IPV6))
+			if (inner_ip_hdr(skb)->version == 6)
 				eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L3_IPV6;
 			break;
 		default:

