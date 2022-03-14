Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A704D82D9
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240750AbiCNMLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242004AbiCNMJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:09:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDBF6506DA;
        Mon, 14 Mar 2022 05:06:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BDDF612FF;
        Mon, 14 Mar 2022 12:06:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E729C340E9;
        Mon, 14 Mar 2022 12:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259586;
        bh=Eb3QsL3Gokqu+VNIPcIeAZHx3c4CIYro4yhWODlIKHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mWfaHR5QOyD/FuJZ3No/98Iy/YaRcVTdcPA5SIvLirsxxWyBzbv05U2jJd6jvPKwy
         FjQY819C7KkkQYyohzhMeuAOl7H0DO9liMjxkpduXGh6VvHbw0AXgT6oSg6ERYnzpO
         SisRgbU5Jr8x6Pu3wf8hr6qtbwkZT4xq0/I7r+6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/110] net/mlx5e: Lag, Only handle events from highest priority multipath entry
Date:   Mon, 14 Mar 2022 12:53:44 +0100
Message-Id: <20220314112744.212409403@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

[ Upstream commit ad11c4f1d8fd1f03639460e425a36f7fd0ea83f5 ]

There could be multiple multipath entries but changing the port affinity
for each one doesn't make much sense and there should be a default one.
So only track the entry with lowest priority value.
The commit doesn't affect existing users with a single entry.

Fixes: 544fe7c2e654 ("net/mlx5e: Activate HW multipath and handle port affinity based on FIB events")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index 30282d86e6b9..cb0a48d374a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -126,6 +126,10 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
 		return;
 	}
 
+	/* Handle multipath entry with lower priority value */
+	if (mp->mfi && mp->mfi != fi && fi->fib_priority >= mp->mfi->fib_priority)
+		return;
+
 	/* Handle add/replace event */
 	nhs = fib_info_num_path(fi);
 	if (nhs == 1) {
@@ -135,12 +139,13 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
 			int i = mlx5_lag_dev_get_netdev_idx(ldev, nh_dev);
 
 			if (i < 0)
-				i = MLX5_LAG_NORMAL_AFFINITY;
-			else
-				++i;
+				return;
 
+			i++;
 			mlx5_lag_set_port_affinity(ldev, i);
 		}
+
+		mp->mfi = fi;
 		return;
 	}
 
-- 
2.34.1



