Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D28F5594A83
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350992AbiHPAE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351694AbiHOX7V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:59:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393ACC741C;
        Mon, 15 Aug 2022 13:20:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8837CCE130B;
        Mon, 15 Aug 2022 20:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742DEC433D6;
        Mon, 15 Aug 2022 20:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594827;
        bh=gb8kqsQeIBkkMJtqGKKEuM1f6Odku+Ff+tkn48TKFCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1kwfT0r3rWvYsk4Qp57DPsIswul/1J22DNgBxZHk2LvY316tSW4fsqc0iPEhFYsg6
         hNTMKVuR482H8S7zWuDSK4CgwNnI3QevAb1YEO7Bhcq0hQBYCK/8aC0NPibmAFSrzw
         9un6nV3IilntPhNOUqZO1HyALVCHK3lwZS83u6oU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0571/1157] net/mlx5e: xsk: Discard unaligned XSK frames on striding RQ
Date:   Mon, 15 Aug 2022 19:58:47 +0200
Message-Id: <20220815180502.462219017@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit 8eaa1d110800fac050bab44001732747a1c39894 ]

Striding RQ uses MTT page mapping, where each page corresponds to an XSK
frame. MTT pages have alignment requirements, and XSK frames don't have
any alignment guarantees in the unaligned mode. Frames with improper
alignment must be discarded, otherwise the packet data will be written
at a wrong address.

Fixes: 282c0c798f8e ("net/mlx5e: Allow XSK frames smaller than a page")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/r/20220729121356.3990867-1-maximmi@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    | 14 ++++++++++++++
 include/net/xdp_sock_drv.h                         | 11 +++++++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
index a8cfab4a393c..cc18d97d8ee0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
@@ -7,6 +7,8 @@
 #include "en.h"
 #include <net/xdp_sock_drv.h>
 
+#define MLX5E_MTT_PTAG_MASK 0xfffffffffffffff8ULL
+
 /* RX data path */
 
 struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
@@ -21,6 +23,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 static inline int mlx5e_xsk_page_alloc_pool(struct mlx5e_rq *rq,
 					    struct mlx5e_dma_info *dma_info)
 {
+retry:
 	dma_info->xsk = xsk_buff_alloc(rq->xsk_pool);
 	if (!dma_info->xsk)
 		return -ENOMEM;
@@ -32,6 +35,17 @@ static inline int mlx5e_xsk_page_alloc_pool(struct mlx5e_rq *rq,
 	 */
 	dma_info->addr = xsk_buff_xdp_get_frame_dma(dma_info->xsk);
 
+	/* MTT page mapping has alignment requirements. If they are not
+	 * satisfied, leak the descriptor so that it won't come again, and try
+	 * to allocate a new one.
+	 */
+	if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
+		if (unlikely(dma_info->addr & ~MLX5E_MTT_PTAG_MASK)) {
+			xsk_buff_discard(dma_info->xsk);
+			goto retry;
+		}
+	}
+
 	return 0;
 }
 
diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 4aa031849668..0774ce97c2f1 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -95,6 +95,13 @@ static inline void xsk_buff_free(struct xdp_buff *xdp)
 	xp_free(xskb);
 }
 
+static inline void xsk_buff_discard(struct xdp_buff *xdp)
+{
+	struct xdp_buff_xsk *xskb = container_of(xdp, struct xdp_buff_xsk, xdp);
+
+	xp_release(xskb);
+}
+
 static inline void xsk_buff_set_size(struct xdp_buff *xdp, u32 size)
 {
 	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
@@ -238,6 +245,10 @@ static inline void xsk_buff_free(struct xdp_buff *xdp)
 {
 }
 
+static inline void xsk_buff_discard(struct xdp_buff *xdp)
+{
+}
+
 static inline void xsk_buff_set_size(struct xdp_buff *xdp, u32 size)
 {
 }
-- 
2.35.1



