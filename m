Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8594A9696
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346910AbiBDJ1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358197AbiBDJZw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:25:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266D4C0617B9;
        Fri,  4 Feb 2022 01:25:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2845B836EA;
        Fri,  4 Feb 2022 09:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406F9C004E1;
        Fri,  4 Feb 2022 09:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966744;
        bh=5+zBic57DaFCDCTKf73rG2L2m1QDDJ4X68mahAZmo8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fHD2MCYfwrf34Jdlf6rvHMmJTAIjKt3MZeG08J0VW9DKsipPke3P4J74H33hZ4RO8
         0eW7Jl8hpAw4nLRmG8SPctNc2WVsNyH7xqqxykaaXKMELixfg/fHIEu0rkyczLJiGt
         YXkQN+TVN6J+Uy4IwxBioi+TGOyFDTVqq0jRGMWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Khalid Manaa <khalidm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.16 25/43] net/mlx5e: Fix wrong calculation of header index in HW_GRO
Date:   Fri,  4 Feb 2022 10:22:32 +0100
Message-Id: <20220204091917.990963187@linuxfoundation.org>
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

From: Khalid Manaa <khalidm@nvidia.com>

commit b8d91145ed7cfa046cc07bcfb277465b9d45da73 upstream.

The HW doesn't wrap the CQE.shampo.header_index field according to the
headers buffer size, instead it always increases it until reaching overflow
of u16 size.

Thus the mlx5e_handle_rx_cqe_mpwrq_shampo handler should mask the
CQE header_index field to find the actual header index in the headers buffer.

Fixes: f97d5c2a453e ("net/mlx5e: Add handle SHAMPO cqe support")
Signed-off-by: Khalid Manaa <khalidm@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h |    5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   |    4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -167,6 +167,11 @@ static inline u16 mlx5e_txqsq_get_next_p
 	return pi;
 }
 
+static inline u16 mlx5e_shampo_get_cqe_header_index(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
+{
+	return be16_to_cpu(cqe->shampo.header_entry_index) & (rq->mpwqe.shampo->hd_per_wq - 1);
+}
+
 struct mlx5e_shampo_umr {
 	u16 len;
 };
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1116,7 +1116,7 @@ static void mlx5e_shampo_update_ipv6_udp
 static void mlx5e_shampo_update_fin_psh_flags(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 					      struct tcphdr *skb_tcp_hd)
 {
-	u16 header_index = be16_to_cpu(cqe->shampo.header_entry_index);
+	u16 header_index = mlx5e_shampo_get_cqe_header_index(rq, cqe);
 	struct tcphdr *last_tcp_hd;
 	void *last_hd_addr;
 
@@ -1968,7 +1968,7 @@ mlx5e_free_rx_shampo_hd_entry(struct mlx
 static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 {
 	u16 data_bcnt		= mpwrq_get_cqe_byte_cnt(cqe) - cqe->shampo.header_size;
-	u16 header_index	= be16_to_cpu(cqe->shampo.header_entry_index);
+	u16 header_index	= mlx5e_shampo_get_cqe_header_index(rq, cqe);
 	u32 wqe_offset		= be32_to_cpu(cqe->shampo.data_offset);
 	u16 cstrides		= mpwrq_get_cqe_consumed_strides(cqe);
 	u32 data_offset		= wqe_offset & (PAGE_SIZE - 1);


