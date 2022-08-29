Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766455A48F7
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbiH2LS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbiH2LRi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:17:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C814DE1;
        Mon, 29 Aug 2022 04:11:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B15461213;
        Mon, 29 Aug 2022 11:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452E0C433C1;
        Mon, 29 Aug 2022 11:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771470;
        bh=zBeM/HiRUwCSRMPbVp3YsDiJHylPb7UOtGAPSswqkoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dZ6p6vqUga5/Dxh+dVCEO5QrMOmdeWCg1cGViMEA8U9Zyqu8FUYoCALsAGmc1YDOW
         xwV8RtkW6sCRD4eIgUM39QOH1Z2SWHyE/t0dph+t9u80y4r5yQ0ZwmQrJVvj0w0j1H
         vaqRLEiEhNYhGBW/S2Lu8F6HZjcoSkGl0/bYzCXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 034/158] net/mlx5: Avoid false positive lockdep warning by adding lock_class_key
Date:   Mon, 29 Aug 2022 12:58:04 +0200
Message-Id: <20220829105810.225774587@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit d59b73a66e5e0682442b6d7b4965364e57078b80 ]

Add a lock_class_key per mlx5 device to avoid a false positive
"possible circular locking dependency" warning by lockdep, on flows
which lock more than one mlx5 device, such as adding SF.

kernel log:
 ======================================================
 WARNING: possible circular locking dependency detected
 5.19.0-rc8+ #2 Not tainted
 ------------------------------------------------------
 kworker/u20:0/8 is trying to acquire lock:
 ffff88812dfe0d98 (&dev->intf_state_mutex){+.+.}-{3:3}, at: mlx5_init_one+0x2e/0x490 [mlx5_core]

 but task is already holding lock:
 ffff888101aa7898 (&(&notifier->n_head)->rwsem){++++}-{3:3}, at: blocking_notifier_call_chain+0x5a/0x130

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

 -> #1 (&(&notifier->n_head)->rwsem){++++}-{3:3}:
        down_write+0x90/0x150
        blocking_notifier_chain_register+0x53/0xa0
        mlx5_sf_table_init+0x369/0x4a0 [mlx5_core]
        mlx5_init_one+0x261/0x490 [mlx5_core]
        probe_one+0x430/0x680 [mlx5_core]
        local_pci_probe+0xd6/0x170
        work_for_cpu_fn+0x4e/0xa0
        process_one_work+0x7c2/0x1340
        worker_thread+0x6f6/0xec0
        kthread+0x28f/0x330
        ret_from_fork+0x1f/0x30

 -> #0 (&dev->intf_state_mutex){+.+.}-{3:3}:
        __lock_acquire+0x2fc7/0x6720
        lock_acquire+0x1c1/0x550
        __mutex_lock+0x12c/0x14b0
        mlx5_init_one+0x2e/0x490 [mlx5_core]
        mlx5_sf_dev_probe+0x29c/0x370 [mlx5_core]
        auxiliary_bus_probe+0x9d/0xe0
        really_probe+0x1e0/0xaa0
        __driver_probe_device+0x219/0x480
        driver_probe_device+0x49/0x130
        __device_attach_driver+0x1b8/0x280
        bus_for_each_drv+0x123/0x1a0
        __device_attach+0x1a3/0x460
        bus_probe_device+0x1a2/0x260
        device_add+0x9b1/0x1b40
        __auxiliary_device_add+0x88/0xc0
        mlx5_sf_dev_state_change_handler+0x67e/0x9d0 [mlx5_core]
        blocking_notifier_call_chain+0xd5/0x130
        mlx5_vhca_state_work_handler+0x2b0/0x3f0 [mlx5_core]
        process_one_work+0x7c2/0x1340
        worker_thread+0x59d/0xec0
        kthread+0x28f/0x330
        ret_from_fork+0x1f/0x30

  other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&(&notifier->n_head)->rwsem);
                                lock(&dev->intf_state_mutex);
                                lock(&(&notifier->n_head)->rwsem);
   lock(&dev->intf_state_mutex);

  *** DEADLOCK ***

 4 locks held by kworker/u20:0/8:
  #0: ffff888150612938 ((wq_completion)mlx5_events){+.+.}-{0:0}, at: process_one_work+0x6e2/0x1340
  #1: ffff888100cafdb8 ((work_completion)(&work->work)#3){+.+.}-{0:0}, at: process_one_work+0x70f/0x1340
  #2: ffff888101aa7898 (&(&notifier->n_head)->rwsem){++++}-{3:3}, at: blocking_notifier_call_chain+0x5a/0x130
  #3: ffff88813682d0e8 (&dev->mutex){....}-{3:3}, at:__device_attach+0x76/0x460

 stack backtrace:
 CPU: 6 PID: 8 Comm: kworker/u20:0 Not tainted 5.19.0-rc8+
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 Workqueue: mlx5_events mlx5_vhca_state_work_handler [mlx5_core]
 Call Trace:
  <TASK>
  dump_stack_lvl+0x57/0x7d
  check_noncircular+0x278/0x300
  ? print_circular_bug+0x460/0x460
  ? lock_chain_count+0x20/0x20
  ? register_lock_class+0x1880/0x1880
  __lock_acquire+0x2fc7/0x6720
  ? register_lock_class+0x1880/0x1880
  ? register_lock_class+0x1880/0x1880
  lock_acquire+0x1c1/0x550
  ? mlx5_init_one+0x2e/0x490 [mlx5_core]
  ? lockdep_hardirqs_on_prepare+0x400/0x400
  __mutex_lock+0x12c/0x14b0
  ? mlx5_init_one+0x2e/0x490 [mlx5_core]
  ? mlx5_init_one+0x2e/0x490 [mlx5_core]
  ? _raw_read_unlock+0x1f/0x30
  ? mutex_lock_io_nested+0x1320/0x1320
  ? __ioremap_caller.constprop.0+0x306/0x490
  ? mlx5_sf_dev_probe+0x269/0x370 [mlx5_core]
  ? iounmap+0x160/0x160
  mlx5_init_one+0x2e/0x490 [mlx5_core]
  mlx5_sf_dev_probe+0x29c/0x370 [mlx5_core]
  ? mlx5_sf_dev_remove+0x130/0x130 [mlx5_core]
  auxiliary_bus_probe+0x9d/0xe0
  really_probe+0x1e0/0xaa0
  __driver_probe_device+0x219/0x480
  ? auxiliary_match_id+0xe9/0x140
  driver_probe_device+0x49/0x130
  __device_attach_driver+0x1b8/0x280
  ? driver_allows_async_probing+0x140/0x140
  bus_for_each_drv+0x123/0x1a0
  ? bus_for_each_dev+0x1a0/0x1a0
  ? lockdep_hardirqs_on_prepare+0x286/0x400
  ? trace_hardirqs_on+0x2d/0x100
  __device_attach+0x1a3/0x460
  ? device_driver_attach+0x1e0/0x1e0
  ? kobject_uevent_env+0x22d/0xf10
  bus_probe_device+0x1a2/0x260
  device_add+0x9b1/0x1b40
  ? dev_set_name+0xab/0xe0
  ? __fw_devlink_link_to_suppliers+0x260/0x260
  ? memset+0x20/0x40
  ? lockdep_init_map_type+0x21a/0x7d0
  __auxiliary_device_add+0x88/0xc0
  ? auxiliary_device_init+0x86/0xa0
  mlx5_sf_dev_state_change_handler+0x67e/0x9d0 [mlx5_core]
  blocking_notifier_call_chain+0xd5/0x130
  mlx5_vhca_state_work_handler+0x2b0/0x3f0 [mlx5_core]
  ? mlx5_vhca_event_arm+0x100/0x100 [mlx5_core]
  ? lock_downgrade+0x6e0/0x6e0
  ? lockdep_hardirqs_on_prepare+0x286/0x400
  process_one_work+0x7c2/0x1340
  ? lockdep_hardirqs_on_prepare+0x400/0x400
  ? pwq_dec_nr_in_flight+0x230/0x230
  ? rwlock_bug.part.0+0x90/0x90
  worker_thread+0x59d/0xec0
  ? process_one_work+0x1340/0x1340
  kthread+0x28f/0x330
  ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x1f/0x30
  </TASK>

Fixes: 6a3273217469 ("net/mlx5: SF, Port function state change support")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 4 ++++
 include/linux/mlx5/driver.h                    | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index ba2e5232b90be..616207c3b187a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1472,7 +1472,9 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	memcpy(&dev->profile, &profile[profile_idx], sizeof(dev->profile));
 	INIT_LIST_HEAD(&priv->ctx_list);
 	spin_lock_init(&priv->ctx_lock);
+	lockdep_register_key(&dev->lock_key);
 	mutex_init(&dev->intf_state_mutex);
+	lockdep_set_class(&dev->intf_state_mutex, &dev->lock_key);
 
 	mutex_init(&priv->bfregs.reg_head.lock);
 	mutex_init(&priv->bfregs.wc_head.lock);
@@ -1527,6 +1529,7 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	mutex_destroy(&priv->bfregs.wc_head.lock);
 	mutex_destroy(&priv->bfregs.reg_head.lock);
 	mutex_destroy(&dev->intf_state_mutex);
+	lockdep_unregister_key(&dev->lock_key);
 	return err;
 }
 
@@ -1545,6 +1548,7 @@ void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
 	mutex_destroy(&priv->bfregs.wc_head.lock);
 	mutex_destroy(&priv->bfregs.reg_head.lock);
 	mutex_destroy(&dev->intf_state_mutex);
+	lockdep_unregister_key(&dev->lock_key);
 }
 
 static int probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 5040cd774c5a3..b0b4ac92354a2 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -773,6 +773,7 @@ struct mlx5_core_dev {
 	enum mlx5_device_state	state;
 	/* sync interface state */
 	struct mutex		intf_state_mutex;
+	struct lock_class_key	lock_key;
 	unsigned long		intf_state;
 	struct mlx5_priv	priv;
 	struct mlx5_profile	profile;
-- 
2.35.1



