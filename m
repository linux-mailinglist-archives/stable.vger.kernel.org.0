Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A1C52190E
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbiEJNng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237155AbiEJNmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:42:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837282AC56;
        Tue, 10 May 2022 06:30:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 51133CE1EE2;
        Tue, 10 May 2022 13:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633FCC385A6;
        Tue, 10 May 2022 13:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189442;
        bh=jM41X8xSEpy3J9hlpygsg9SJe+WGApjUCWGFi3pw+j8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zKat5v57Y9LwY+SpdOHR/owd2wbKMWYVNTUXGvZ+2Pb59J6fW+U6BPqZQYAJ/lUiD
         uUjF1COCRMQLpZycAR13FKVl2mSoGKZb7wYMGtB0b3GMC618tX5C26KhsXuYEPKfQA
         Mvxz1VyfeXL13FyvsCFvs1wOaHL3tc+s4I5UvYJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Maher Sanalla <msanalla@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.15 053/135] net/mlx5: Fix deadlock in sync reset flow
Date:   Tue, 10 May 2022 15:07:15 +0200
Message-Id: <20220510130741.925693143@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

commit cb7786a76ea39f394f0a059787fe24fa8e340fb6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   34 ++++++++++-----------
 1 file changed, 17 insertions(+), 17 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -111,22 +111,6 @@ static void mlx5_fw_reset_complete_reloa
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
@@ -149,6 +133,23 @@ static int mlx5_sync_reset_clear_reset_r
 	return 0;
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
@@ -163,7 +164,6 @@ static void poll_sync_reset(struct timer
 
 	if (fatal_error) {
 		mlx5_core_warn(dev, "Got Device Reset\n");
-		mlx5_sync_reset_clear_reset_requested(dev, false);
 		queue_work(fw_reset->wq, &fw_reset->reset_reload_work);
 		return;
 	}


