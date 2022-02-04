Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0937A4A9691
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357921AbiBDJ1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:27:17 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44736 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358146AbiBDJZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:25:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D85A0615ED;
        Fri,  4 Feb 2022 09:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB2FC004E1;
        Fri,  4 Feb 2022 09:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966748;
        bh=419SQMNUJTad//hSB8VlDwF9adSrpO28yi8oXMmav/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GY1s2z/VYpebiOHdeYLuya6dQXoIHoNRfSacXEzdoaOj5t9ja7KX/wn0eK8Rr6zL1
         5yviVTFZoLwsW4BAE5T8FwYSFSYLwHmmXNczwe9TIQ2tKaAbw+duGN5GiUPLO3pD7Q
         7gQRN16NVPMw1BayYyTyR53ERj5meveSmyNu552Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Khalid Manaa <khalidm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.16 26/43] net/mlx5e: Fix broken SKB allocation in HW-GRO
Date:   Fri,  4 Feb 2022 10:22:33 +0100
Message-Id: <20220204091918.021305558@linuxfoundation.org>
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

commit 7957837b816f11eecb9146235bb0715478f4c81f upstream.

In case the HW doesn't perform header-data split, it will write the whole
packet into the data buffer in the WQ, in this case the SHAMPO CQE handler
couldn't use the header entry to build the SKB, instead it should allocate
a new memory to build the SKB using the function:
mlx5e_skb_from_cqe_mpwrq_nonlinear.

Fixes: f97d5c2a453e ("net/mlx5e: Add handle SHAMPO cqe support")
Signed-off-by: Khalid Manaa <khalidm@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c |   26 +++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1866,7 +1866,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct m
 	return skb;
 }
 
-static void
+static struct sk_buff *
 mlx5e_skb_from_cqe_shampo(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 			  struct mlx5_cqe64 *cqe, u16 header_index)
 {
@@ -1890,7 +1890,7 @@ mlx5e_skb_from_cqe_shampo(struct mlx5e_r
 		skb = mlx5e_build_linear_skb(rq, hdr, frag_size, rx_headroom, head_size);
 
 		if (unlikely(!skb))
-			return;
+			return NULL;
 
 		/* queue up for recycling/reuse */
 		page_ref_inc(head->page);
@@ -1902,7 +1902,7 @@ mlx5e_skb_from_cqe_shampo(struct mlx5e_r
 				     ALIGN(head_size, sizeof(long)));
 		if (unlikely(!skb)) {
 			rq->stats->buff_alloc_err++;
-			return;
+			return NULL;
 		}
 
 		prefetchw(skb->data);
@@ -1913,9 +1913,7 @@ mlx5e_skb_from_cqe_shampo(struct mlx5e_r
 		skb->tail += head_size;
 		skb->len  += head_size;
 	}
-	rq->hw_gro_data->skb = skb;
-	NAPI_GRO_CB(skb)->count = 1;
-	skb_shinfo(skb)->gso_size = mpwrq_get_cqe_byte_cnt(cqe) - head_size;
+	return skb;
 }
 
 static void
@@ -1975,6 +1973,7 @@ static void mlx5e_handle_rx_cqe_mpwrq_sh
 	u32 cqe_bcnt		= mpwrq_get_cqe_byte_cnt(cqe);
 	u16 wqe_id		= be16_to_cpu(cqe->wqe_id);
 	u32 page_idx		= wqe_offset >> PAGE_SHIFT;
+	u16 head_size		= cqe->shampo.header_size;
 	struct sk_buff **skb	= &rq->hw_gro_data->skb;
 	bool flush		= cqe->shampo.flush;
 	bool match		= cqe->shampo.match;
@@ -2007,9 +2006,16 @@ static void mlx5e_handle_rx_cqe_mpwrq_sh
 	}
 
 	if (!*skb) {
-		mlx5e_skb_from_cqe_shampo(rq, wi, cqe, header_index);
+		if (likely(head_size))
+			*skb = mlx5e_skb_from_cqe_shampo(rq, wi, cqe, header_index);
+		else
+			*skb = mlx5e_skb_from_cqe_mpwrq_nonlinear(rq, wi, cqe_bcnt, data_offset,
+								  page_idx);
 		if (unlikely(!*skb))
 			goto free_hd_entry;
+
+		NAPI_GRO_CB(*skb)->count = 1;
+		skb_shinfo(*skb)->gso_size = cqe_bcnt - head_size;
 	} else {
 		NAPI_GRO_CB(*skb)->count++;
 		if (NAPI_GRO_CB(*skb)->count == 2 &&
@@ -2023,8 +2029,10 @@ static void mlx5e_handle_rx_cqe_mpwrq_sh
 		}
 	}
 
-	di = &wi->umr.dma_info[page_idx];
-	mlx5e_fill_skb_data(*skb, rq, di, data_bcnt, data_offset);
+	if (likely(head_size)) {
+		di = &wi->umr.dma_info[page_idx];
+		mlx5e_fill_skb_data(*skb, rq, di, data_bcnt, data_offset);
+	}
 
 	mlx5e_shampo_complete_rx_cqe(rq, cqe, cqe_bcnt, *skb);
 	if (flush)


