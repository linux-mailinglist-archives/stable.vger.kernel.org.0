Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456976159D4
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiKBDTR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiKBDTG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:19:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65F5DEF5
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:19:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5443AB82076
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F15C433D6;
        Wed,  2 Nov 2022 03:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359141;
        bh=4uJPfMeB9S5ogt1uSlC+xl8SGodLN9/5GsgFN8KcdU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c/lDqthJYLq1se7cwqAKKkVlAUvAZTDeRzA+jCBrffLKQUEO4TBtHwKntfSSjFmBv
         7IW5APIoAk+MEfCVujught/dH+OjXSF+LPCH09cJ2zPcICA4Nb5BbWALR1IsVdawWg
         wdigDV9EJY1EHR+xg8IwDwqis6H1JmUG5qN4JXKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Suresh Devarakonda <ramad@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Bodong Wang <bodong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 83/91] net/mlx5: Fix crash during sync firmware reset
Date:   Wed,  2 Nov 2022 03:34:06 +0100
Message-Id: <20221102022057.410993625@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suresh Devarakonda <ramad@nvidia.com>

[ Upstream commit aefb62a9988749703435e941704624949a80a2a9 ]

When setting Bluefield to DPU NIC mode using mlxconfig tool +  sync
firmware reset flow, we run into scenario where the host was not
eswitch manager at the time of mlx5 driver load but becomes eswitch manager
after the sync firmware reset flow. This results in null pointer
access of mpfs structure during mac filter add. This change prevents null
pointer access but mpfs table entries will not be added.

Fixes: 5ec697446f46 ("net/mlx5: Add support for devlink reload action fw activate")
Signed-off-by: Suresh Devarakonda <ramad@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Bodong Wang <bodong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Link: https://lore.kernel.org/r/20221026135153.154807-12-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
index 839a01da110f..8ff16318e32d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
@@ -122,7 +122,7 @@ void mlx5_mpfs_cleanup(struct mlx5_core_dev *dev)
 {
 	struct mlx5_mpfs *mpfs = dev->priv.mpfs;
 
-	if (!MLX5_ESWITCH_MANAGER(dev))
+	if (!mpfs)
 		return;
 
 	WARN_ON(!hlist_empty(mpfs->hash));
@@ -137,7 +137,7 @@ int mlx5_mpfs_add_mac(struct mlx5_core_dev *dev, u8 *mac)
 	int err = 0;
 	u32 index;
 
-	if (!MLX5_ESWITCH_MANAGER(dev))
+	if (!mpfs)
 		return 0;
 
 	mutex_lock(&mpfs->lock);
@@ -185,7 +185,7 @@ int mlx5_mpfs_del_mac(struct mlx5_core_dev *dev, u8 *mac)
 	int err = 0;
 	u32 index;
 
-	if (!MLX5_ESWITCH_MANAGER(dev))
+	if (!mpfs)
 		return 0;
 
 	mutex_lock(&mpfs->lock);
-- 
2.35.1



