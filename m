Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297DF594208
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245003AbiHOVUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343941AbiHOVRR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:17:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B1529829;
        Mon, 15 Aug 2022 12:20:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3550B810A3;
        Mon, 15 Aug 2022 19:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAD8C433C1;
        Mon, 15 Aug 2022 19:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591231;
        bh=77p0F+fhXx8FwC7ansFUH3g5OXXvP6hKPXv1B2Jh3cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sQMS38i4JHbgM7Qhdn68Z63JifgT9mUqkSmb930Ur4aWVzTtCnk4usiX76eUXAptt
         IUuMbpZsu9TemAaC1+MaeCIHRMaBqIlmN/bOsOtTpdZtnB066jxDuwbNFr2S9ZbkbR
         WUosSeb1VwkCKiu1PgKkWdwvFFlsu5BESIhQ3YxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0514/1095] net/mlx5e: xsk: Account for XSK RQ UMRs when calculating ICOSQ size
Date:   Mon, 15 Aug 2022 19:58:33 +0200
Message-Id: <20220815180450.804339679@linuxfoundation.org>
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

[ Upstream commit 52586d2f56b3e4f528ca7268d65074e92c936681 ]

ICOSQ is used to post UMR WQEs for both regular RQ and XSK RQ. However,
space in ICOSQ is reserved only for the regular RQ, which may cause
ICOSQ overflows when using XSK (the most risk is on activating
channels).

This commit fixes the issue by reserving space for XSK UMR WQEs as well.
As XSK may be enabled without restarting the channel and recreating the
ICOSQ, this space is reserved unconditionally.

Fixes: db05815b36cb ("net/mlx5e: Add XSK zero-copy support")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 08fd1370a8b0..75da12e1b0c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -797,8 +797,20 @@ static u8 mlx5e_build_icosq_log_wq_sz(struct mlx5_core_dev *mdev,
 		return MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE;
 
 	wqebbs = MLX5E_UMR_WQEBBS * BIT(mlx5e_get_rq_log_wq_sz(rqp->rqc));
+
+	/* If XDP program is attached, XSK may be turned on at any time without
+	 * restarting the channel. ICOSQ must be big enough to fit UMR WQEs of
+	 * both regular RQ and XSK RQ.
+	 * Although mlx5e_mpwqe_get_log_rq_size accepts mlx5e_xsk_param, it
+	 * doesn't affect its return value, as long as params->xdp_prog != NULL,
+	 * so we can just multiply by 2.
+	 */
+	if (params->xdp_prog)
+		wqebbs *= 2;
+
 	if (params->packet_merge.type == MLX5E_PACKET_MERGE_SHAMPO)
 		wqebbs += mlx5e_shampo_icosq_sz(mdev, params, rqp);
+
 	return max_t(u8, MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE, order_base_2(wqebbs));
 }
 
-- 
2.35.1



