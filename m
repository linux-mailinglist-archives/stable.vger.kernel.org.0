Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48C9C4A967D
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358351AbiBDJ0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:26:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44088 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357988AbiBDJZB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:25:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA6A9615C6;
        Fri,  4 Feb 2022 09:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31F7C004E1;
        Fri,  4 Feb 2022 09:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966700;
        bh=DK7KqKjGWNf9gjmFefzafwrONuqBU3cBkmhqoOB/3bM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJI3PPvYoc0BblEHXnwBY0jGzG2fumi+CK7JARehOoQn0l2JEeEUxoBzaTE07KpUU
         IyAtuSuYBte899YJ338lUzUUYgzzH80NAT7wo1H9z8DzuQwL/PG3GK9kHGTJTvVKxS
         iBzWEptCgOxhE+t+MOe+/qQ+36qgZTfQ1KTtul2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.16 12/43] net/mlx5e: IPsec: Fix crypto offload for non TCP/UDP encapsulated traffic
Date:   Fri,  4 Feb 2022 10:22:19 +0100
Message-Id: <20220204091917.581050256@linuxfoundation.org>
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

commit 5352859b3bfa0ca188b2f1d2c1436fddc781e3b6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

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


