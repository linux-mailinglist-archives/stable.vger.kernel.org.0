Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE054A9545
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 09:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238381AbiBDIhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 03:37:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48030 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238217AbiBDIhm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 03:37:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0632B610A3
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 08:37:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C50C004E1;
        Fri,  4 Feb 2022 08:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643963861;
        bh=DGICHjCxLvD238SBScaPq3OtSk6cP6MzChc7k+v337g=;
        h=Subject:To:Cc:From:Date:From;
        b=uNWvSFJYcv/1wGEfKnX33XdpvJ8k67i5h7A7U7bbyN8/Xuq7YfpMEUaFY9REqJTeu
         eRi5sdwQpVJ6QaX4LfGoijIpyFsv7TqX5X4N3IfSN1Grgvci8c4vt9THpAMDhwp4RE
         CY/zipyli/ScfEBaGLSH55zK7zCivb7pz4lIdSkc=
Subject: FAILED: patch "[PATCH] net/mlx5e: Avoid field-overflowing memcpy()" failed to apply to 4.19-stable tree
To:     keescook@chromium.org, saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Feb 2022 09:37:38 +0100
Message-ID: <164396385823798@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ad5185735f7dab342fdd0dd41044da4c9ccfef67 Mon Sep 17 00:00:00 2001
From: Kees Cook <keescook@chromium.org>
Date: Mon, 24 Jan 2022 09:20:28 -0800
Subject: [PATCH] net/mlx5e: Avoid field-overflowing memcpy()

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Use flexible arrays instead of zero-element arrays (which look like they
are always overflowing) and split the cross-field memcpy() into two halves
that can be appropriately bounds-checked by the compiler.

We were doing:

	#define ETH_HLEN  14
	#define VLAN_HLEN  4
	...
	#define MLX5E_XDP_MIN_INLINE (ETH_HLEN + VLAN_HLEN)
	...
        struct mlx5e_tx_wqe      *wqe  = mlx5_wq_cyc_get_wqe(wq, pi);
	...
        struct mlx5_wqe_eth_seg  *eseg = &wqe->eth;
        struct mlx5_wqe_data_seg *dseg = wqe->data;
	...
	memcpy(eseg->inline_hdr.start, xdptxd->data, MLX5E_XDP_MIN_INLINE);

target is wqe->eth.inline_hdr.start (which the compiler sees as being
2 bytes in size), but copying 18, intending to write across start
(really vlan_tci, 2 bytes). The remaining 16 bytes get written into
wqe->data[0], covering byte_count (4 bytes), lkey (4 bytes), and addr
(8 bytes).

struct mlx5e_tx_wqe {
        struct mlx5_wqe_ctrl_seg   ctrl;                 /*     0    16 */
        struct mlx5_wqe_eth_seg    eth;                  /*    16    16 */
        struct mlx5_wqe_data_seg   data[];               /*    32     0 */

        /* size: 32, cachelines: 1, members: 3 */
        /* last cacheline: 32 bytes */
};

struct mlx5_wqe_eth_seg {
        u8                         swp_outer_l4_offset;  /*     0     1 */
        u8                         swp_outer_l3_offset;  /*     1     1 */
        u8                         swp_inner_l4_offset;  /*     2     1 */
        u8                         swp_inner_l3_offset;  /*     3     1 */
        u8                         cs_flags;             /*     4     1 */
        u8                         swp_flags;            /*     5     1 */
        __be16                     mss;                  /*     6     2 */
        __be32                     flow_table_metadata;  /*     8     4 */
        union {
                struct {
                        __be16     sz;                   /*    12     2 */
                        u8         start[2];             /*    14     2 */
                } inline_hdr;                            /*    12     4 */
                struct {
                        __be16     type;                 /*    12     2 */
                        __be16     vlan_tci;             /*    14     2 */
                } insert;                                /*    12     4 */
                __be32             trailer;              /*    12     4 */
        };                                               /*    12     4 */

        /* size: 16, cachelines: 1, members: 9 */
        /* last cacheline: 16 bytes */
};

struct mlx5_wqe_data_seg {
        __be32                     byte_count;           /*     0     4 */
        __be32                     lkey;                 /*     4     4 */
        __be64                     addr;                 /*     8     8 */

        /* size: 16, cachelines: 1, members: 3 */
        /* last cacheline: 16 bytes */
};

So, split the memcpy() so the compiler can reason about the buffer
sizes.

"pahole" shows no size nor member offset changes to struct mlx5e_tx_wqe
nor struct mlx5e_umr_wqe. "objdump -d" shows no meaningful object
code changes (i.e. only source line number induced differences and
optimizations).

Fixes: b5503b994ed5 ("net/mlx5e: XDP TX forwarding support")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 812e6810cb3b..c14e06ca64d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -224,7 +224,7 @@ static inline int mlx5e_get_max_num_channels(struct mlx5_core_dev *mdev)
 struct mlx5e_tx_wqe {
 	struct mlx5_wqe_ctrl_seg ctrl;
 	struct mlx5_wqe_eth_seg  eth;
-	struct mlx5_wqe_data_seg data[0];
+	struct mlx5_wqe_data_seg data[];
 };
 
 struct mlx5e_rx_wqe_ll {
@@ -241,8 +241,8 @@ struct mlx5e_umr_wqe {
 	struct mlx5_wqe_umr_ctrl_seg   uctrl;
 	struct mlx5_mkey_seg           mkc;
 	union {
-		struct mlx5_mtt inline_mtts[0];
-		struct mlx5_klm inline_klms[0];
+		DECLARE_FLEX_ARRAY(struct mlx5_mtt, inline_mtts);
+		DECLARE_FLEX_ARRAY(struct mlx5_klm, inline_klms);
 	};
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 338d65e2c9ce..56e10c84a706 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -341,8 +341,10 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 
 	/* copy the inline part if required */
 	if (sq->min_inline_mode != MLX5_INLINE_MODE_NONE) {
-		memcpy(eseg->inline_hdr.start, xdptxd->data, MLX5E_XDP_MIN_INLINE);
+		memcpy(eseg->inline_hdr.start, xdptxd->data, sizeof(eseg->inline_hdr.start));
 		eseg->inline_hdr.sz = cpu_to_be16(MLX5E_XDP_MIN_INLINE);
+		memcpy(dseg, xdptxd->data + sizeof(eseg->inline_hdr.start),
+		       MLX5E_XDP_MIN_INLINE - sizeof(eseg->inline_hdr.start));
 		dma_len  -= MLX5E_XDP_MIN_INLINE;
 		dma_addr += MLX5E_XDP_MIN_INLINE;
 		dseg++;

