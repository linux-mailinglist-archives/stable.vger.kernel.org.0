Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD0616948EF
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbjBMOyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:54:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjBMOyb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:54:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B9EB756
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:54:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C3BF610A4
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E305C4339B;
        Mon, 13 Feb 2023 14:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300064;
        bh=d7W5NaHrr8Jq3aFJdnR9fvNnANo53BwF8scEfx/B5jE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yiqBgelAeLNkt+XorpQXu5KP/8jnICmDEJItxMTM9dw0AEgLs9a8tc+C/fV21p11W
         KyveynX/6hWTRPb8mRs+xJJaafFKMBPcrV8ZLWem5W2gvydbioQ7WNRkvS6RLHdD73
         pAhC3+zyq3pWURxfZE29X2s8162NdjhtZ8vFBCDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maher Sanalla <msanalla@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/114] net/mlx5: Expose SF firmware pages counter
Date:   Mon, 13 Feb 2023 15:48:05 +0100
Message-Id: <20230213144744.769748268@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
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

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit 9965bbebae59b3563a4d95e4aed121e8965dfdc2 ]

Currently, each core device has VF pages counter which stores number of
fw pages used by its VFs and SFs.

The current design led to a hang when performing firmware reset on DPU,
where the DPU PFs stalled in sriov unload flow due to waiting on release
of SFs pages instead of waiting on only VFs pages.

Thus, Add a separate counter for SF firmware pages, which will prevent
the stall scenario described above.

Fixes: 1958fc2f0712 ("net/mlx5: SF, Add auxiliary device driver")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c   | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c | 2 +-
 include/linux/mlx5/driver.h                         | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index c3e7c24a0971e..bb95b40d25eb5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -246,6 +246,7 @@ void mlx5_pages_debugfs_init(struct mlx5_core_dev *dev)
 
 	debugfs_create_u32("fw_pages_total", 0400, pages, &dev->priv.fw_pages);
 	debugfs_create_u32("fw_pages_vfs", 0400, pages, &dev->priv.page_counters[MLX5_VF]);
+	debugfs_create_u32("fw_pages_sfs", 0400, pages, &dev->priv.page_counters[MLX5_SF]);
 	debugfs_create_u32("fw_pages_host_pf", 0400, pages, &dev->priv.page_counters[MLX5_HOST_PF]);
 	debugfs_create_u32("fw_pages_alloc_failed", 0400, pages, &dev->priv.fw_pages_alloc_failed);
 	debugfs_create_u32("fw_pages_give_dropped", 0400, pages, &dev->priv.give_pages_dropped);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 9f99292ab5ced..0eb50be175cc4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -79,7 +79,7 @@ static u16 func_id_to_type(struct mlx5_core_dev *dev, u16 func_id, bool ec_funct
 	if (!func_id)
 		return mlx5_core_is_ecpf(dev) && !ec_function ? MLX5_HOST_PF : MLX5_PF;
 
-	return MLX5_VF;
+	return func_id <= mlx5_core_max_vfs(dev) ?  MLX5_VF : MLX5_SF;
 }
 
 static struct rb_root *page_root_per_function(struct mlx5_core_dev *dev, u32 function)
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 9b300aa4eb953..fff61e6d6d4de 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -576,6 +576,7 @@ struct mlx5_debugfs_entries {
 enum mlx5_func_type {
 	MLX5_PF,
 	MLX5_VF,
+	MLX5_SF,
 	MLX5_HOST_PF,
 	MLX5_FUNC_TYPE_NUM,
 };
-- 
2.39.0



