Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072B94A9528
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 09:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbiBDIeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 03:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbiBDIeB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 03:34:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEB5C061714
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 00:33:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 536FF6102D
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 08:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11566C004E1;
        Fri,  4 Feb 2022 08:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643963638;
        bh=uetgDF2jwVEAS3qc6uiRtLbZhfARkLyMnH37mV45qTg=;
        h=Subject:To:Cc:From:Date:From;
        b=Z1XrpdJ1fSuLECOUJj/e3t/ygnEE6DzaqeHv5E93JqN1HpsmOFkZV6aTTnP0qIP0R
         75EcnC2VEwlSLQASCyD4VZ+YHlLGXzaxqyXh6kJXFCunst5MeAc10uXAOlgnYo9I/6
         Iir7QxoSuWepAkd7qDZQGYtoGmxkCRWfjpqNhkhA=
Subject: FAILED: patch "[PATCH] net/mlx5e: IPsec: Fix crypto offload for non TCP/UDP" failed to apply to 5.10-stable tree
To:     raeds@nvidia.com, maord@nvidia.com, saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Feb 2022 09:33:55 +0100
Message-ID: <164396363555170@kroah.com>
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

From 5352859b3bfa0ca188b2f1d2c1436fddc781e3b6 Mon Sep 17 00:00:00 2001
From: Raed Salem <raeds@nvidia.com>
Date: Thu, 2 Dec 2021 17:43:50 +0200
Subject: [PATCH] net/mlx5e: IPsec: Fix crypto offload for non TCP/UDP
 encapsulated traffic

IPsec crypto offload always set the ethernet segment checksum flags with
the inner L4 header checksum flag enabled for encapsulated IPsec offloaded
packet regardless of the encapsulated L4 header type, and even if it
doesn't exists in the first place, this breaks non TCP/UDP traffic as
such.

Set the inner L4 checksum flag only when the encapsulated L4 header
protocol is TCP/UDP using software parser swp_inner_l4_offset field as
indication.

Fixes: 5cfb540ef27b ("net/mlx5e: Set IPsec WAs only in IP's non checksum partial case.")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index b98db50c3418..428881e0adcb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -131,14 +131,17 @@ static inline bool
 mlx5e_ipsec_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 				  struct mlx5_wqe_eth_seg *eseg)
 {
-	struct xfrm_offload *xo = xfrm_offload(skb);
+	u8 inner_ipproto;
 
 	if (!mlx5e_ipsec_eseg_meta(eseg))
 		return false;
 
 	eseg->cs_flags = MLX5_ETH_WQE_L3_CSUM;
-	if (xo->inner_ipproto) {
-		eseg->cs_flags |= MLX5_ETH_WQE_L4_INNER_CSUM | MLX5_ETH_WQE_L3_INNER_CSUM;
+	inner_ipproto = xfrm_offload(skb)->inner_ipproto;
+	if (inner_ipproto) {
+		eseg->cs_flags |= MLX5_ETH_WQE_L3_INNER_CSUM;
+		if (inner_ipproto == IPPROTO_TCP || inner_ipproto == IPPROTO_UDP)
+			eseg->cs_flags |= MLX5_ETH_WQE_L4_INNER_CSUM;
 	} else if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
 		eseg->cs_flags |= MLX5_ETH_WQE_L4_CSUM;
 		sq->stats->csum_partial_inner++;

