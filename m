Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379DF6B41F5
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbjCJN6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbjCJN6P (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:58:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB426EB7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:58:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BCFAB822BA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C44C4339B;
        Fri, 10 Mar 2023 13:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456686;
        bh=UKEoYjS25wgGroJqPbxWtKDzt69mI2UKt5Q+dewr1z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2lj66c8BBM2X6FS7+P0VzJOCN8OENWGamP3zrMbnzjt2LSi6am6kUSYJMnIgOiarD
         Nt0EFVsqB8+4veHvIFLKwrVDGLv3owS3ENnEMx0eMpZQxhbXvdNCtY56reOa3plIUp
         XnPwJmorwvg483KHNEbJWYxh+45QQ8BuOtSx8Dgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maher Sanalla <msanalla@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 089/211] net/mlx5: ECPF, wait for VF pages only after disabling host PFs
Date:   Fri, 10 Mar 2023 14:37:49 +0100
Message-Id: <20230310133721.491004758@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit e1ed30c8c09abc85a01c897845bdbd08c0333353 ]

Currently,  during the early stages of their unloading, particularly
during SRIOV disablement, PFs/ECPFs wait on the release of all of
their VFs memory pages. Furthermore, ECPFs are considered the page
supplier for host VFs, hence the host VFs memory pages are freed only
during ECPF cleanup when host interfaces get disabled.

Thus, disabling SRIOV early in unload timeline causes the DPU ECPF
to stall on driver unload while waiting on the release of host VF pages
that won't be freed before host interfaces get disabled later on.

Therefore, for ECPFs, wait on the release of VFs pages only after the
disablement of host PFs during ECPF cleanup flow. Then, host PFs and VFs
are disabled and their memory shall be freed accordingly.

Fixes: 143a41d7623d ("net/mlx5: Disable SRIOV before PF removal")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c  | 4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
index cdc87ecae5d39..d000236ddbac5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
@@ -90,4 +90,8 @@ void mlx5_ec_cleanup(struct mlx5_core_dev *dev)
 	err = mlx5_wait_for_pages(dev, &dev->priv.page_counters[MLX5_HOST_PF]);
 	if (err)
 		mlx5_core_warn(dev, "Timeout reclaiming external host PF pages err(%d)\n", err);
+
+	err = mlx5_wait_for_pages(dev, &dev->priv.page_counters[MLX5_VF]);
+	if (err)
+		mlx5_core_warn(dev, "Timeout reclaiming external host VFs pages err(%d)\n", err);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index 3008e9ce2bbff..20d7662c10fb6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -147,6 +147,10 @@ mlx5_device_disable_sriov(struct mlx5_core_dev *dev, int num_vfs, bool clear_vf)
 
 	mlx5_eswitch_disable_sriov(dev->priv.eswitch, clear_vf);
 
+	/* For ECPFs, skip waiting for host VF pages until ECPF is destroyed */
+	if (mlx5_core_is_ecpf(dev))
+		return;
+
 	if (mlx5_wait_for_pages(dev, &dev->priv.page_counters[MLX5_VF]))
 		mlx5_core_warn(dev, "timeout reclaiming VFs pages\n");
 }
-- 
2.39.2



