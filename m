Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F97594C6F
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbiHPAmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348315AbiHPAlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:41:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F8F18DC35;
        Mon, 15 Aug 2022 13:39:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8329360F60;
        Mon, 15 Aug 2022 20:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868B6C433D6;
        Mon, 15 Aug 2022 20:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595938;
        bh=HXHscwO9QOfb9zLnH2H8pGByDOuKTqJ/hzGJVmwDK6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HTTk8DkB7UAy0H72Q/JZZJ2/jyBQ/3LsTXj/ItqiQUcvRSl+CWZhEQ3WdQKTuibuz
         776ZxtMvOApYtOrVGvSr+U79gSKlPqIe+4QFVpVnOXJSPzz50yfsj4pkRT2kxEAVaz
         +eSpVbqMZhYbitT2J89TjS8XKqn4CQFK6YYbHbpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0922/1157] vfio/mlx5: Protect mlx5vf_disable_fds() upon close device
Date:   Mon, 15 Aug 2022 20:04:38 +0200
Message-Id: <20220815180516.331712301@linuxfoundation.org>
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

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit 2b1c1906286fa547845f5385ee72db74b2b0251d ]

Protect mlx5vf_disable_fds() upon close device to be called under the
state mutex as done in all other places.

This will prevent a race with any other flow which calls
mlx5vf_disable_fds() as of health/recovery upon
MLX5_PF_NOTIFY_DISABLE_VF event.

Encapsulate this functionality in a separate function named
mlx5vf_cmd_close_migratable() to consider migration caps and for further
usage upon close device.

Fixes: 6fadb021266d ("vfio/mlx5: Implement vfio_pci driver for mlx5 devices")
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://lore.kernel.org/r/20220628155910.171454-2-yishaih@nvidia.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/mlx5/cmd.c  | 10 ++++++++++
 drivers/vfio/pci/mlx5/cmd.h  |  1 +
 drivers/vfio/pci/mlx5/main.c |  2 +-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 9b9f33ca270a..cdd0c667dc77 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -88,6 +88,16 @@ static int mlx5fv_vf_event(struct notifier_block *nb,
 	return 0;
 }
 
+void mlx5vf_cmd_close_migratable(struct mlx5vf_pci_core_device *mvdev)
+{
+	if (!mvdev->migrate_cap)
+		return;
+
+	mutex_lock(&mvdev->state_mutex);
+	mlx5vf_disable_fds(mvdev);
+	mlx5vf_state_mutex_unlock(mvdev);
+}
+
 void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev)
 {
 	if (!mvdev->migrate_cap)
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 6c3112fdd8b1..aa692d9ce656 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -64,6 +64,7 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 					  size_t *state_size);
 void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev);
 void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev);
+void mlx5vf_cmd_close_migratable(struct mlx5vf_pci_core_device *mvdev);
 int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 			       struct mlx5_vf_migration_file *migf);
 int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 0558d0649ddb..d754990f0662 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -570,7 +570,7 @@ static void mlx5vf_pci_close_device(struct vfio_device *core_vdev)
 	struct mlx5vf_pci_core_device *mvdev = container_of(
 		core_vdev, struct mlx5vf_pci_core_device, core_device.vdev);
 
-	mlx5vf_disable_fds(mvdev);
+	mlx5vf_cmd_close_migratable(mvdev);
 	vfio_pci_core_close_device(core_vdev);
 }
 
-- 
2.35.1



