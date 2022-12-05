Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC2E6432E5
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbiLETbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:31:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234242AbiLETb2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:31:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522D8252B6
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:27:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC49BB80EFD
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05874C433D6;
        Mon,  5 Dec 2022 19:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268418;
        bh=y4KLJomoHTT8cA5/NKCnpPzh7+wVYDc6gBSNuyodz30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=thNAouAnN4KFTs1BJJ1zsvJdB5Y4ww1Lt8ohLW7XWSixj+X62tGldv4D528JMNRRx
         KVCjZw2BKCBaDqLrNaqumPyopGWnYRlVG7tJg1IjU/QMk9OT297vhmYv15Rb6EdP+6
         tVhLXcBIU5rXIrKTR4jUy77PKylUpil/rS8q6OHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chris Mi <cmi@nvidia.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 067/124] net/mlx5: Lag, Fix for loop when checking lag
Date:   Mon,  5 Dec 2022 20:09:33 +0100
Message-Id: <20221205190810.322623995@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
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

From: Chris Mi <cmi@nvidia.com>

[ Upstream commit 0e682f04b4b59eac0b0a030251513589c4607458 ]

The cited commit adds a for loop to check if each port supports lag
or not. But dev is not initialized correctly. Fix it by initializing
dev for each iteration.

Fixes: e87c6a832f88 ("net/mlx5: E-switch, Fix duplicate lag creation")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reported-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Link: https://lore.kernel.org/r/20221129093006.378840-2-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index a879e0b0f702..48f86e12f5c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -648,11 +648,13 @@ static bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
 			return false;
 
 #ifdef CONFIG_MLX5_ESWITCH
-	dev = ldev->pf[MLX5_LAG_P1].dev;
-	for (i = 0; i  < ldev->ports; i++)
+	for (i = 0; i < ldev->ports; i++) {
+		dev = ldev->pf[i].dev;
 		if (mlx5_eswitch_num_vfs(dev->priv.eswitch) && !is_mdev_switchdev_mode(dev))
 			return false;
+	}
 
+	dev = ldev->pf[MLX5_LAG_P1].dev;
 	mode = mlx5_eswitch_mode(dev);
 	for (i = 0; i < ldev->ports; i++)
 		if (mlx5_eswitch_mode(ldev->pf[i].dev) != mode)
-- 
2.35.1



