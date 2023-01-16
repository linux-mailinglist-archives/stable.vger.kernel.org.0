Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B60A66C504
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbjAPQAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbjAPQAf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:00:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940392386F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:00:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3156961041
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490F8C433EF;
        Mon, 16 Jan 2023 16:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884832;
        bh=d6wSSIntMoO5jZhc69D3khx0devrlm1gIlC7lDi5zvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2F0TbPpEFV6ofwtzqHUTVZm5ofhpjppF0fZxthgLCkkQVu4CsYTWQ+pAdY+cLEzy
         iXsOmRsaT0yAXTcr+ZDunExIIYc+O0NYIswEoH8C5kqBlsI6UMuMwjMIDycWVwN4Lc
         fITvcaEaIMQ9GRhAd6yRe7eK12EzrOBGdc4aoEbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dragos Tatulea <dtatulea@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 156/183] net/mlx5e: IPoIB, Fix child PKEY interface stats on rx path
Date:   Mon, 16 Jan 2023 16:51:19 +0100
Message-Id: <20230116154809.907034066@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit b5e23931c45a2f99f60a2f2b98a9e4d5a62a5b13 ]

The current code always does the accounting using the
stats from the parent interface (linked in the rq). This
doesn't work when there are child interfaces configured.

Fix this behavior by always using the stats from the child
interface priv. This will also work for parent only
interfaces: the child (netdev) and parent netdev (rq->netdev)
will point to the same thing.

Fixes: be98737a4faa ("net/mlx5e: Use dynamic per-channel allocations in stats")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index a61a43fc8d5c..56d1bd22c7c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2300,7 +2300,7 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
 
 	priv = mlx5i_epriv(netdev);
 	tstamp = &priv->tstamp;
-	stats = rq->stats;
+	stats = &priv->channel_stats[rq->ix]->rq;
 
 	flags_rqpn = be32_to_cpu(cqe->flags_rqpn);
 	g = (flags_rqpn >> 28) & 3;
-- 
2.35.1



