Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C00B689559
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbjBCKSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:18:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232878AbjBCKSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:18:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9CB974F;
        Fri,  3 Feb 2023 02:18:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1430B61E89;
        Fri,  3 Feb 2023 10:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDD6C433D2;
        Fri,  3 Feb 2023 10:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419484;
        bh=fUZ4+J96aaJjEApxIUe+nlTnwTKXGPqDJoYR4Qdp2BU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xc8/CTUXeLuTOyv+wtFmCXNcIZsoSZSa+XVHodGRqSHwF/awK1mxagTJECR/4bvkP
         dPuHILwIrh9qVIl82iYzUNo9jRb2wKiGc/XNbUiQTbmDjj+pVIu9W/ab0ajubD7iaL
         qgPxk5jY+UgTUWsLeY9LE8R/gPDMOmslqgPlP+6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        Eli Cohen <eli@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
        Ira Weiny <ira.weiny@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 21/80] net: mlx5: eliminate anonymous module_init & module_exit
Date:   Fri,  3 Feb 2023 11:12:15 +0100
Message-Id: <20230203101016.094037303@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 2c1e1b949024989e20907b84e11a731a50778416 ]

Eliminate anonymous module_init() and module_exit(), which can lead to
confusion or ambiguity when reading System.map, crashes/oops/bugs,
or an initcall_debug log.

Give each of these init and exit functions unique driver-specific
names to eliminate the anonymous names.

Example 1: (System.map)
 ffffffff832fc78c t init
 ffffffff832fc79e t init
 ffffffff832fc8f8 t init

Example 2: (initcall_debug log)
 calling  init+0x0/0x12 @ 1
 initcall init+0x0/0x12 returned 0 after 15 usecs
 calling  init+0x0/0x60 @ 1
 initcall init+0x0/0x60 returned 0 after 2 usecs
 calling  init+0x0/0x9a @ 1
 initcall init+0x0/0x9a returned 0 after 74 usecs

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Eli Cohen <eli@mellanox.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index a2b25afa2472..e09bd059984e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1683,7 +1683,7 @@ static void mlx5_core_verify_params(void)
 	}
 }
 
-static int __init init(void)
+static int __init mlx5_init(void)
 {
 	int err;
 
@@ -1708,7 +1708,7 @@ static int __init init(void)
 	return err;
 }
 
-static void __exit cleanup(void)
+static void __exit mlx5_cleanup(void)
 {
 #ifdef CONFIG_MLX5_CORE_EN
 	mlx5e_cleanup();
@@ -1717,5 +1717,5 @@ static void __exit cleanup(void)
 	mlx5_unregister_debugfs();
 }
 
-module_init(init);
-module_exit(cleanup);
+module_init(mlx5_init);
+module_exit(mlx5_cleanup);
-- 
2.39.0



