Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D33451F9F3
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 12:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiEIKgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 06:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbiEIKgZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 06:36:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3291CE620
        for <stable@vger.kernel.org>; Mon,  9 May 2022 03:32:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D0E560FA4
        for <stable@vger.kernel.org>; Mon,  9 May 2022 10:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741D6C385AB;
        Mon,  9 May 2022 10:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652092345;
        bh=kRO/Gh7LjLfRxpES1VsebHe948ejc0s4IcTjpVUTWNI=;
        h=Subject:To:Cc:From:Date:From;
        b=ygp7ry/gffzGWA87noDKe/ildhDtCeV+c4Meifbsgr/kLTYuIcOnJK5DtiAIsqWvY
         OdCc0GfPkATiVs10jTvz641b06Pboi44+eE0/af03cV0/XKaRzm5wvQ3AOF13tSPdu
         usiir2JcKO1Xu/Bwj0ij9k1U07k28pgPmFAtaN+Y=
Subject: FAILED: patch "[PATCH] net/mlx5: Fix deadlock in sync reset flow" failed to apply to 5.10-stable tree
To:     moshe@nvidia.com, msanalla@nvidia.com, saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 12:32:23 +0200
Message-ID: <1652092343893@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cb7786a76ea39f394f0a059787fe24fa8e340fb6 Mon Sep 17 00:00:00 2001
From: Moshe Shemesh <moshe@nvidia.com>
Date: Mon, 11 Apr 2022 21:31:06 +0300
Subject: [PATCH] net/mlx5: Fix deadlock in sync reset flow

The sync reset flow can lead to the following deadlock when
poll_sync_reset() is called by timer softirq and waiting on
del_timer_sync() for the same timer. Fix that by moving the part of the
flow that waits for the timer to reset_reload_work.

It fixes the following kernel Trace:
RIP: 0010:del_timer_sync+0x32/0x40
...
Call Trace:
 <IRQ>
 mlx5_sync_reset_clear_reset_requested+0x26/0x50 [mlx5_core]
 poll_sync_reset.cold+0x36/0x52 [mlx5_core]
 call_timer_fn+0x32/0x130
 __run_timers.part.0+0x180/0x280
 ? tick_sched_handle+0x33/0x60
 ? tick_sched_timer+0x3d/0x80
 ? ktime_get+0x3e/0xa0
 run_timer_softirq+0x2a/0x50
 __do_softirq+0xe1/0x2d6
 ? hrtimer_interrupt+0x136/0x220
 irq_exit+0xae/0xb0
 smp_apic_timer_interrupt+0x7b/0x140
 apic_timer_interrupt+0xf/0x20
 </IRQ>

Fixes: 3c5193a87b0f ("net/mlx5: Use del_timer_sync in fw reset flow of halting poll")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 4aa22dce9b77..ec18d4ccbc11 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -155,22 +155,6 @@ static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
 	}
 }
 
-static void mlx5_sync_reset_reload_work(struct work_struct *work)
-{
-	struct mlx5_fw_reset *fw_reset = container_of(work, struct mlx5_fw_reset,
-						      reset_reload_work);
-	struct mlx5_core_dev *dev = fw_reset->dev;
-	int err;
-
-	mlx5_enter_error_state(dev, true);
-	mlx5_unload_one(dev);
-	err = mlx5_health_wait_pci_up(dev);
-	if (err)
-		mlx5_core_err(dev, "reset reload flow aborted, PCI reads still not working\n");
-	fw_reset->ret = err;
-	mlx5_fw_reset_complete_reload(dev);
-}
-
 static void mlx5_stop_sync_reset_poll(struct mlx5_core_dev *dev)
 {
 	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
@@ -188,6 +172,23 @@ static void mlx5_sync_reset_clear_reset_requested(struct mlx5_core_dev *dev, boo
 		mlx5_start_health_poll(dev);
 }
 
+static void mlx5_sync_reset_reload_work(struct work_struct *work)
+{
+	struct mlx5_fw_reset *fw_reset = container_of(work, struct mlx5_fw_reset,
+						      reset_reload_work);
+	struct mlx5_core_dev *dev = fw_reset->dev;
+	int err;
+
+	mlx5_sync_reset_clear_reset_requested(dev, false);
+	mlx5_enter_error_state(dev, true);
+	mlx5_unload_one(dev);
+	err = mlx5_health_wait_pci_up(dev);
+	if (err)
+		mlx5_core_err(dev, "reset reload flow aborted, PCI reads still not working\n");
+	fw_reset->ret = err;
+	mlx5_fw_reset_complete_reload(dev);
+}
+
 #define MLX5_RESET_POLL_INTERVAL	(HZ / 10)
 static void poll_sync_reset(struct timer_list *t)
 {
@@ -202,7 +203,6 @@ static void poll_sync_reset(struct timer_list *t)
 
 	if (fatal_error) {
 		mlx5_core_warn(dev, "Got Device Reset\n");
-		mlx5_sync_reset_clear_reset_requested(dev, false);
 		queue_work(fw_reset->wq, &fw_reset->reset_reload_work);
 		return;
 	}

