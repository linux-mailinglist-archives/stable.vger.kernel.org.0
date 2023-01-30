Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927F968116A
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237270AbjA3ONZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:13:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237289AbjA3ONT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:13:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5C037B5B;
        Mon, 30 Jan 2023 06:13:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 106E5B8117B;
        Mon, 30 Jan 2023 14:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7FFC433D2;
        Mon, 30 Jan 2023 14:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087983;
        bh=sRHtvw+ovoZY11QOQItx8cHaleNwdkkqv03jsMtLQN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mRFplPSpXvabR/8DYkfCIArP0QHvimB63Hd8by3AAnczDn/Z8wngqjqzaOYbQIbQO
         tNfdKlsMekUIEtG8T/mOR0IKiarWxVT9RO6M5NtblUq3SJ/EVW+zG+3DIC8F+ui4NR
         HQ1hkicgH4uF6YvLRSY4v8I+dw4R7/vs82gv59wI=
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
Subject: [PATCH 5.15 068/204] net: mlx5: eliminate anonymous module_init & module_exit
Date:   Mon, 30 Jan 2023 14:50:33 +0100
Message-Id: <20230130134319.313551271@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 145e56f5eeee..9e15eea9743f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1849,7 +1849,7 @@ static void mlx5_core_verify_params(void)
 	}
 }
 
-static int __init init(void)
+static int __init mlx5_init(void)
 {
 	int err;
 
@@ -1885,7 +1885,7 @@ static int __init init(void)
 	return err;
 }
 
-static void __exit cleanup(void)
+static void __exit mlx5_cleanup(void)
 {
 	mlx5e_cleanup();
 	mlx5_sf_driver_unregister();
@@ -1893,5 +1893,5 @@ static void __exit cleanup(void)
 	mlx5_unregister_debugfs();
 }
 
-module_init(init);
-module_exit(cleanup);
+module_init(mlx5_init);
+module_exit(mlx5_cleanup);
-- 
2.39.0



