Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019F75A4812
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiH2LFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiH2LEy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:04:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F816527E;
        Mon, 29 Aug 2022 04:03:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05B3CB80EFA;
        Mon, 29 Aug 2022 11:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3EFC433C1;
        Mon, 29 Aug 2022 11:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661770999;
        bh=jhb7aOIEiskUjh6w4LldF/Qs++mSvVac9e5Tc76y//0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=No5mKV9vDhz1QVDtUAreChpTXzp9krhOrngYzyZWoq/bZX99th6yU+wSSBZCvrQmq
         iSrwivaTGBpL+X32ZZHVnUOAZsrSrz17HyiXQvYQWDLRFqU8VU0ZqD4+RiyrwQst2q
         3fx7yb/n4vb2SNwa2mq6P6LuVgBuU9yph+9C9Ba8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/136] net/mlx5e: Fix wrong application of the LRO state
Date:   Mon, 29 Aug 2022 12:58:33 +0200
Message-Id: <20220829105806.499981507@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 7b3707fc79044871ab8f3d5fa5e9603155bb5577 ]

Driver caches packet merge type in mlx5e_params instance which must be
in perfect sync with the netdev_feature's bit.
Prior to this patch, in certain conditions (*) LRO state was set in
mlx5e_params, while netdev_feature's bit was off. Causing the LRO to
be applied on the RQs (HW level).

(*) This can happen only on profile init (mlx5e_build_nic_params()),
when RQ expect non-linear SKB and PCI is fast enough in comparison to
link width.

Solution: remove setting of packet merge type from
mlx5e_build_nic_params() as netdev features are not updated.

Fixes: 619a8f2a42f1 ("net/mlx5e: Use linear SKB in Striding RQ")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index e00648094fc2a..fdf8d9866042c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4350,14 +4350,6 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
 	/* RQ */
 	mlx5e_build_rq_params(mdev, params);
 
-	/* HW LRO */
-	if (MLX5_CAP_ETH(mdev, lro_cap) &&
-	    params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
-		/* No XSK params: checking the availability of striding RQ in general. */
-		if (!mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL))
-			params->packet_merge.type = slow_pci_heuristic(mdev) ?
-				MLX5E_PACKET_MERGE_NONE : MLX5E_PACKET_MERGE_LRO;
-	}
 	params->packet_merge.timeout = mlx5e_choose_lro_timeout(mdev, MLX5E_DEFAULT_LRO_TIMEOUT);
 
 	/* CQ moderation params */
-- 
2.35.1



