Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 743FC579BCF
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238879AbiGSMcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240072AbiGSMb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:31:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3808652883;
        Tue, 19 Jul 2022 05:11:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC8F7B81B2E;
        Tue, 19 Jul 2022 12:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3CEC341CB;
        Tue, 19 Jul 2022 12:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232705;
        bh=xXka3hcQsxFrFK2ApKm8SInwLLCYwCp3TXJmICQEvU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DnBbOM3CyeK7eBqyFyvMHjN873dY/beM9a6dPR07B6GgWaID2X/GGpxVSEoOYhq+J
         cCyNk6Af6Ey9kI6yV/eNB8Fxt/ZyrlgryjXEiTADJ29ve3bgsswbHDtyJdEPhY7mOt
         vIbSW7+du+A7Dh9zxfXDcHI3iHiamwxfqxD0MWIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/167] net/mlx5e: Fix enabling sriov while tc nic rules are offloaded
Date:   Tue, 19 Jul 2022 13:52:49 +0200
Message-Id: <20220719114700.290640439@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

[ Upstream commit 0c9d876545a56aebed30fa306d0460a4d28d271a ]

There is a total of four 4M entries flow tables. In sriov disabled
mode, ct, ct_nat and post_act take three of them. When adding the
first tc nic rule in this mode, it will take another 4M table
for the tc <chain,prio> table. If user then enables sriov, the legacy
flow table tries to take another 4M and fails, and so enablement fails.

To fix that, have legacy fdb take the next available maximum
size from the fs ft pool.

Fixes: 4a98544d1827 ("net/mlx5: Move chains ft pool to be used by all firmware steering")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
index 0c4c743ca31e..3a2575dc5355 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
@@ -11,6 +11,7 @@
 #include "mlx5_core.h"
 #include "eswitch.h"
 #include "fs_core.h"
+#include "fs_ft_pool.h"
 #include "esw/qos.h"
 
 enum {
@@ -95,8 +96,7 @@ static int esw_create_legacy_fdb_table(struct mlx5_eswitch *esw)
 	if (!flow_group_in)
 		return -ENOMEM;
 
-	table_size = BIT(MLX5_CAP_ESW_FLOWTABLE_FDB(dev, log_max_ft_size));
-	ft_attr.max_fte = table_size;
+	ft_attr.max_fte = POOL_NEXT_SIZE;
 	ft_attr.prio = LEGACY_FDB_PRIO;
 	fdb = mlx5_create_flow_table(root_ns, &ft_attr);
 	if (IS_ERR(fdb)) {
@@ -105,6 +105,7 @@ static int esw_create_legacy_fdb_table(struct mlx5_eswitch *esw)
 		goto out;
 	}
 	esw->fdb_table.legacy.fdb = fdb;
+	table_size = fdb->max_fte;
 
 	/* Addresses group : Full match unicast/multicast addresses */
 	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
-- 
2.35.1



