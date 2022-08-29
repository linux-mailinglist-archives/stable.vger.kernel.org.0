Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21BF5A48FB
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiH2LTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbiH2LSM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:18:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F0A71737;
        Mon, 29 Aug 2022 04:11:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72DBA6120B;
        Mon, 29 Aug 2022 11:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8030AC433D6;
        Mon, 29 Aug 2022 11:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771479;
        bh=1a3nIOVY8zJS/Dvwl230croADpNtrzVnGD4Z+FJSfws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C2v1sq/2XUMEVBsM0cUV+61RjjKPyNbu54WUJSLtp4h6MzRLeBeETkdB1aBpwY2Kk
         /F6iH9ROdtpaOnN+I1DpBTfFLJbNtjX/15gBOHuj4bHxJtBa0sPrlvPaNramNVka1K
         81QkD/FeoOOmoypSiHVZUFi9OriyAnXvhGGb94B8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 035/158] net/mlx5e: Fix wrong application of the LRO state
Date:   Mon, 29 Aug 2022 12:58:05 +0200
Message-Id: <20220829105810.263164318@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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
index 087952b84ccb0..62aab20025345 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4733,14 +4733,6 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
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



