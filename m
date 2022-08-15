Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF2E594ABD
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355370AbiHPAGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352027AbiHPAAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:00:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0773D43E5B;
        Mon, 15 Aug 2022 13:21:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9560161007;
        Mon, 15 Aug 2022 20:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D831C433D6;
        Mon, 15 Aug 2022 20:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594881;
        bh=FX9Ax3Z/cmlPDDEf6qOtcz300bPFrJUo0VquF6pu9PY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bh8E6bmX5bt9hFSRYiT+Jcsi+1IVqUfezjltrry+AQ9Z1qYzeSO2J/fJoLAO4v3db
         HKqonC3KbROjB782bc+P5EfQzTiCTuHquZvf4RWW0x0BzPsRAeLAbgg5+njlrIW8Rc
         uNlsOKl1uT7IGOUXVuMvbUGFt8l/3Gvbm6BOIw/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0555/1157] net/mlx5: Fix driver use of uninitialized timeout
Date:   Mon, 15 Aug 2022 19:58:31 +0200
Message-Id: <20220815180501.828367540@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 42b4f7f66a43cdb9216e76e595c8a9af154806da ]

Currently, driver is setting default values to all timeouts during
function setup. The offending commit is using a timeout before
function setup, meaning: the timeout is 0 (or garbage), since no
value have been set.
This may result in failure to probe the driver:
mlx5_function_setup:1034:(pid 69850): Firmware over 4294967296 MS in pre-initializing state, aborting
probe_one:1591:(pid 69850): mlx5_init_one failed with error code -16

Hence, set default values to timeouts during tout_init()

Fixes: 37ca95e62ee2 ("net/mlx5: Increase FW pre-init timeout for health recovery")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c | 11 ++++-------
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  2 --
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c
index d758848d34d0..696e45e2bd06 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c
@@ -32,20 +32,17 @@ static void tout_set(struct mlx5_core_dev *dev, u64 val, enum mlx5_timeouts_type
 	dev->timeouts->to[type] = val;
 }
 
-void mlx5_tout_set_def_val(struct mlx5_core_dev *dev)
+int mlx5_tout_init(struct mlx5_core_dev *dev)
 {
 	int i;
 
-	for (i = 0; i < MAX_TIMEOUT_TYPES; i++)
-		tout_set(dev, tout_def_sw_val[i], i);
-}
-
-int mlx5_tout_init(struct mlx5_core_dev *dev)
-{
 	dev->timeouts = kmalloc(sizeof(*dev->timeouts), GFP_KERNEL);
 	if (!dev->timeouts)
 		return -ENOMEM;
 
+	for (i = 0; i < MAX_TIMEOUT_TYPES; i++)
+		tout_set(dev, tout_def_sw_val[i], i);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h
index 257c03eeab36..bc9e9aeda847 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h
@@ -35,7 +35,6 @@ int mlx5_tout_init(struct mlx5_core_dev *dev);
 void mlx5_tout_cleanup(struct mlx5_core_dev *dev);
 void mlx5_tout_query_iseg(struct mlx5_core_dev *dev);
 int mlx5_tout_query_dtor(struct mlx5_core_dev *dev);
-void mlx5_tout_set_def_val(struct mlx5_core_dev *dev);
 u64 _mlx5_tout_ms(struct mlx5_core_dev *dev, enum mlx5_timeouts_types type);
 
 #define mlx5_tout_ms(dev, type) _mlx5_tout_ms(dev, MLX5_TO_##type##_MS)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 95f26624b57c..ba2e5232b90b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1023,8 +1023,6 @@ static int mlx5_function_setup(struct mlx5_core_dev *dev, u64 timeout)
 	if (mlx5_core_is_pf(dev))
 		pcie_print_link_status(dev->pdev);
 
-	mlx5_tout_set_def_val(dev);
-
 	/* wait for firmware to accept initialization segments configurations
 	 */
 	err = wait_fw_init(dev, timeout,
-- 
2.35.1



