Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEEC594AA9
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346781AbiHPAFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353598AbiHOX7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:59:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C6C80512;
        Mon, 15 Aug 2022 13:21:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07ADF61058;
        Mon, 15 Aug 2022 20:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E05C433D6;
        Mon, 15 Aug 2022 20:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594868;
        bh=t6X4DYWsdAQrVcgJ5oFrczsQEWu0s0WebpG6qMScSiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c45kaFDMJowyHtchEvtDVervsid4THi7kYTAuyyuPhHXFcXXMmO2unY0X1e6lR+mU
         gwV+An5NuGKgUKXGCELj10SaUfz68WqYh27ag8bj50ZUIrGtDu1c7DsoVFRQ3o9okz
         f+jHv+0Yu1TeBiHuzA7US2t6aATiRRxepqd2QQP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0551/1157] net/mlx5e: Fix calculations related to max MPWQE size
Date:   Mon, 15 Aug 2022 19:58:27 +0200
Message-Id: <20220815180501.681037943@linuxfoundation.org>
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

[ Upstream commit 677e78c8d44f326a73a77d71acf3a49ea562c1d9 ]

Before commit 76c31e5f7585 ("net/mlx5e: Use FW limitation for max MPW
WQEBBs"), the maximum size of MPWQE in WQEBBs was hardcoded as a driver
constant. That commit started using the firmware capability that can
further limit the size, however, it unintentionally changed a few
things:

1. The calculation of MLX5E_MAX_KLM_PER_WQE used the size in DS, which
was replaced by the size in WQEBBs, making the resulting value 4 times
smaller.

2. MLX5E_TX_MPW_MAX_WQEBBS used to be aligned to the cache line size
(either 64 or 128 bytes, i.e. 1 or 2 WQEBBs), but it's no longer the
case if the firmware capability is smaller than the driver maximum.

Fix both issues by using the correct units for MLX5E_MAX_KLM_PER_WQE and
by aligning mlx5e_get_sw_max_sq_mpw_wqebbs after taking the minimum.

Besides fixing the arithmetics in calculation of MLX5E_MAX_KLM_PER_WQE,
also use appropriate constants: `size of BSF * num of DS per WQEBB *
number of WQEBBs` (the calculation before the blamed commit) doesn't
make much sense to calculate the WQE size in bytes, so just use `size of
WQEBB * number of WQEBBs`.

While at it, replace the types that hold the number of WQEBBs by u8.
These values don't exceed 16, and it allows to fill holes in two
structs.

Fixes: 76c31e5f7585 ("net/mlx5e: Use FW limitation for max MPW WQEBBs")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index f794ffaf1e04..29b10ef787b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -174,8 +174,8 @@ struct page_pool;
 	ALIGN_DOWN(MLX5E_KLM_MAX_ENTRIES_PER_WQE(wqe_size), MLX5_UMR_KLM_ALIGNMENT)
 
 #define MLX5E_MAX_KLM_PER_WQE(mdev) \
-	MLX5E_KLM_ENTRIES_PER_WQE(mlx5e_get_sw_max_sq_mpw_wqebbs(mlx5e_get_max_sq_wqebbs(mdev)) \
-				   << MLX5_MKEY_BSF_OCTO_SIZE)
+	MLX5E_KLM_ENTRIES_PER_WQE(MLX5_SEND_WQE_BB * \
+		mlx5e_get_sw_max_sq_mpw_wqebbs(mlx5e_get_max_sq_wqebbs(mdev)))
 
 #define MLX5E_MSG_LEVEL			NETIF_MSG_LINK
 
@@ -233,7 +233,7 @@ static inline u16 mlx5e_get_max_sq_wqebbs(struct mlx5_core_dev *mdev)
 		     MLX5_CAP_GEN(mdev, max_wqe_sz_sq) / MLX5_SEND_WQE_BB);
 }
 
-static inline u16 mlx5e_get_sw_max_sq_mpw_wqebbs(u16 max_sq_wqebbs)
+static inline u8 mlx5e_get_sw_max_sq_mpw_wqebbs(u8 max_sq_wqebbs)
 {
 /* The return value will be multiplied by MLX5_SEND_WQEBB_NUM_DS.
  * Since max_sq_wqebbs may be up to MLX5_SEND_WQE_MAX_WQEBBS == 16,
@@ -242,11 +242,12 @@ static inline u16 mlx5e_get_sw_max_sq_mpw_wqebbs(u16 max_sq_wqebbs)
  * than MLX5_SEND_WQE_MAX_WQEBBS to let a full-session WQE be
  * cache-aligned.
  */
-#if L1_CACHE_BYTES < 128
-	return min_t(u16, max_sq_wqebbs, MLX5_SEND_WQE_MAX_WQEBBS - 1);
-#else
-	return min_t(u16, max_sq_wqebbs, MLX5_SEND_WQE_MAX_WQEBBS - 2);
+	u8 wqebbs = min_t(u8, max_sq_wqebbs, MLX5_SEND_WQE_MAX_WQEBBS - 1);
+
+#if L1_CACHE_BYTES >= 128
+	wqebbs = ALIGN_DOWN(wqebbs, 2);
 #endif
+	return wqebbs;
 }
 
 struct mlx5e_tx_wqe {
@@ -455,7 +456,7 @@ struct mlx5e_txqsq {
 	struct netdev_queue       *txq;
 	u32                        sqn;
 	u16                        stop_room;
-	u16                        max_sq_mpw_wqebbs;
+	u8                         max_sq_mpw_wqebbs;
 	u8                         min_inline_mode;
 	struct device             *pdev;
 	__be32                     mkey_be;
@@ -570,7 +571,7 @@ struct mlx5e_xdpsq {
 	struct device             *pdev;
 	__be32                     mkey_be;
 	u16                        stop_room;
-	u16                        max_sq_mpw_wqebbs;
+	u8                         max_sq_mpw_wqebbs;
 	u8                         min_inline_mode;
 	unsigned long              state;
 	unsigned int               hw_mtu;
-- 
2.35.1



