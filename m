Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4CB5938DF
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244702AbiHOS6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245246AbiHOS5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:57:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E02491DF;
        Mon, 15 Aug 2022 11:32:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AE18B8106C;
        Mon, 15 Aug 2022 18:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4E2C433C1;
        Mon, 15 Aug 2022 18:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588331;
        bh=LRGjQFW/Bt1RPM33pZ/m6sE7bB45yhugFQvUegs7WBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPVmeQ2AzJI0383/Kk4Vd6Pysvdv0FUWMW12Cblo9u9Mc6Es6psGwcy6pLPipr1Qq
         fPhAboGTZaTgG9zYIVeQZ/Q9SCnbmsJ8w23bTS3y8Is3ZeOcpzXdhj8RknYocN2o3U
         JUnIZWDtG9Qsn/2ottI7ItrWK+aXuRty7sFmG+bQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 369/779] net/mlx5e: Fix the value of MLX5E_MAX_RQ_NUM_MTTS
Date:   Mon, 15 Aug 2022 20:00:13 +0200
Message-Id: <20220815180353.031228453@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

[ Upstream commit 562696c3c62c7c23dd896e9447252ce9268cb812 ]

MLX5E_MAX_RQ_NUM_MTTS should be the maximum value, so that
MLX5_MTT_OCTW(MLX5E_MAX_RQ_NUM_MTTS) fits into u16. The current value of
1 << 17 results in MLX5_MTT_OCTW(1 << 17) = 1 << 16, which doesn't fit
into u16. This commit replaces it with the maximum value that still
fits u16.

Fixes: 73281b78a37a ("net/mlx5e: Derive Striding RQ size from MTU")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 7204bc86e474..c22a38e5337b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -103,7 +103,7 @@ struct page_pool;
 #define MLX5E_REQUIRED_WQE_MTTS		(MLX5_ALIGN_MTTS(MLX5_MPWRQ_PAGES_PER_WQE + 1))
 #define MLX5E_REQUIRED_MTTS(wqes)	(wqes * MLX5E_REQUIRED_WQE_MTTS)
 #define MLX5E_MAX_RQ_NUM_MTTS	\
-	((1 << 16) * 2) /* So that MLX5_MTT_OCTW(num_mtts) fits into u16 */
+	(ALIGN_DOWN(U16_MAX, 4) * 2) /* So that MLX5_MTT_OCTW(num_mtts) fits into u16 */
 #define MLX5E_ORDER2_MAX_PACKET_MTU (order_base_2(10 * 1024))
 #define MLX5E_PARAMS_MAXIMUM_LOG_RQ_SIZE_MPW	\
 		(ilog2(MLX5E_MAX_RQ_NUM_MTTS / MLX5E_REQUIRED_WQE_MTTS))
-- 
2.35.1



