Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 583125941A4
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244930AbiHOVUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343832AbiHOVRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:17:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165982872C;
        Mon, 15 Aug 2022 12:20:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5F5260BB7;
        Mon, 15 Aug 2022 19:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF15C433C1;
        Mon, 15 Aug 2022 19:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591228;
        bh=qKnz3Qd/vicMq8SoVA929etJpzVjlrcNsCj63xN+ZYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=orXBox5KfL4HRuVK0dlXrq8qWZPQZiC1pwqIyjsZSIPi7GBWusYMCpciaGfgtVppF
         ftl92yHMgsdHD2AWosdtIwN3t744ClNdt+vJ718C4bOsGgnJmOMf9fTY6OdHj0otd7
         2dCVkvzTD5HQkw95Hvv7YDWBFQoEioy8EkhhvR9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0513/1095] net/mlx5e: Fix the value of MLX5E_MAX_RQ_NUM_MTTS
Date:   Mon, 15 Aug 2022 19:58:32 +0200
Message-Id: <20220815180450.754935009@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index d0d14325a0d9..d73571e542bd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -109,7 +109,7 @@ struct page_pool;
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



