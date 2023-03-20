Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEBC06C18D8
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbjCTP16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232643AbjCTP1h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:27:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3827166C6
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:20:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0E27B80EAC
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF43C4339B;
        Mon, 20 Mar 2023 15:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325630;
        bh=EzEDQA1kSzFYQz1avXhL1t6pYR6T7JWiXlanbeMZ358=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gch21DnhRI40n4GXO67vTNBRo7dBKG5J7q778wamVPpb3PSTuahTykWRvCjGgkwae
         DUoZJnlqM/ZUrYVJliLc90GwjarVob4xbEhDeDHKi1BihG7iMbQ5vBbo/mAeq7yJA4
         gAnKACdQhn63pFTb8UPXyk3oyr6Sm0yFVdBKKJqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Parav Pandit <parav@nvidia.com>,
        Daniel Jurgens <danielj@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 073/211] net/mlx5: Fix setting ec_function bit in MANAGE_PAGES
Date:   Mon, 20 Mar 2023 15:53:28 +0100
Message-Id: <20230320145516.314582389@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
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

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit ba5d8f72b82cc197355c9340ef89dab813815865 ]

When ECPF is a page supplier, reclaim pages missed to honor the
ec_function bit provided by the firmware. It always used the ec_function
to true during driver unload flow for ECPF. This is incorrect.

Honor the ec_function bit provided by device during page allocation
request event.

Fixes: d6945242f45d ("net/mlx5: Hold pages RB tree per VF")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/pagealloc.c   | 22 ++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 64d4e7125e9bb..95dc67fb30015 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -82,6 +82,16 @@ static u16 func_id_to_type(struct mlx5_core_dev *dev, u16 func_id, bool ec_funct
 	return func_id <= mlx5_core_max_vfs(dev) ?  MLX5_VF : MLX5_SF;
 }
 
+static u32 mlx5_get_ec_function(u32 function)
+{
+	return function >> 16;
+}
+
+static u32 mlx5_get_func_id(u32 function)
+{
+	return function & 0xffff;
+}
+
 static struct rb_root *page_root_per_function(struct mlx5_core_dev *dev, u32 function)
 {
 	struct rb_root *root;
@@ -665,20 +675,22 @@ static int optimal_reclaimed_pages(void)
 }
 
 static int mlx5_reclaim_root_pages(struct mlx5_core_dev *dev,
-				   struct rb_root *root, u16 func_id)
+				   struct rb_root *root, u32 function)
 {
 	u64 recl_pages_to_jiffies = msecs_to_jiffies(mlx5_tout_ms(dev, RECLAIM_PAGES));
 	unsigned long end = jiffies + recl_pages_to_jiffies;
 
 	while (!RB_EMPTY_ROOT(root)) {
+		u32 ec_function = mlx5_get_ec_function(function);
+		u32 function_id = mlx5_get_func_id(function);
 		int nclaimed;
 		int err;
 
-		err = reclaim_pages(dev, func_id, optimal_reclaimed_pages(),
-				    &nclaimed, false, mlx5_core_is_ecpf(dev));
+		err = reclaim_pages(dev, function_id, optimal_reclaimed_pages(),
+				    &nclaimed, false, ec_function);
 		if (err) {
-			mlx5_core_warn(dev, "failed reclaiming pages (%d) for func id 0x%x\n",
-				       err, func_id);
+			mlx5_core_warn(dev, "reclaim_pages err (%d) func_id=0x%x ec_func=0x%x\n",
+				       err, function_id, ec_function);
 			return err;
 		}
 
-- 
2.39.2



