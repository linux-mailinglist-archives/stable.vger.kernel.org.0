Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD744CF76A
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238397AbiCGJqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241133AbiCGJlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854C42BD5;
        Mon,  7 Mar 2022 01:40:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 261D4B810B2;
        Mon,  7 Mar 2022 09:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC60C340E9;
        Mon,  7 Mar 2022 09:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646030;
        bh=7aK5WAf+nonAj2USSSeA70CH5uGtCo/IGBvok/zj0bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u+s4YIz55NtLeLgjTy7g1R1DFd+xb0N9+g46nzF8I7vb/6o0IyFYig2qrDteJY2sz
         kh6Qr1Xucm+T123k7Q/30OUnT/R1PGNbdJpupZtWGuvgeioymSvjUg3mau57mWX6RT
         H+uSKVBI/QKuEch84QnH34UXyypVQX1tz32KB2m8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 111/262] net/mlx5e: IPsec: Fix crypto offload for non TCP/UDP encapsulated traffic
Date:   Mon,  7 Mar 2022 10:17:35 +0100
Message-Id: <20220307091705.604989043@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

[ Upstream commit 5352859b3bfa0ca188b2f1d2c1436fddc781e3b6 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h    | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index b98db50c3418d..428881e0adcbe 100644
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
-- 
2.34.1



