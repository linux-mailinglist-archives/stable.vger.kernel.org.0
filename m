Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D3D680F95
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235985AbjA3NzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236520AbjA3Nyw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:54:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6283325E38
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:54:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C706B8114A
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:54:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B08EC4339E;
        Mon, 30 Jan 2023 13:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675086887;
        bh=LnHzplZUs47NFxVACjT+g/5ZU5ZrkyZeZ3zf997n3lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1AqRIOXvMPzxzXfpAIoClIhRV+qJyHZQvmjO4Lqibi65a7jX3QltQ4pJ70lOHf66
         kduGZnXHQ1X9dmR6Q9OSo3rpK9m6/GrpHPp9yQhoE7fVKUu9xpezznsJ1e0zMtWDXw
         QGwMtuIOjAon6KA8lb3D/v8KLTbEbyhbGBH1Hrb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/313] firmware: arm_scmi: Fix virtio channels cleanup on shutdown
Date:   Mon, 30 Jan 2023 14:47:44 +0100
Message-Id: <20230130134338.033490299@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit e325285de2cd82fbdcc4df8898e4c6a597674816 ]

When unloading the SCMI core stack module, configured to use the virtio
SCMI transport, LOCKDEP reports the splat down below about unsafe locks
dependencies.

In order to avoid this possible unsafe locking scenario call upfront
virtio_break_device() before getting hold of vioch->lock.

=====================================================
 WARNING: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected
 6.1.0-00067-g6b934395ba07-dirty #4 Not tainted
 -----------------------------------------------------
 rmmod/307 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
 ffff000080c510e0 (&dev->vqs_list_lock){+.+.}-{3:3}, at: virtio_break_device+0x28/0x68

 and this task is already holding:
 ffff00008288ada0 (&channels[i].lock){-.-.}-{3:3}, at: virtio_chan_free+0x60/0x168 [scmi_module]

 which would create a new lock dependency:
  (&channels[i].lock){-.-.}-{3:3} -> (&dev->vqs_list_lock){+.+.}-{3:3}

 but this new dependency connects a HARDIRQ-irq-safe lock:
  (&channels[i].lock){-.-.}-{3:3}

 ... which became HARDIRQ-irq-safe at:
   lock_acquire+0x128/0x398
   _raw_spin_lock_irqsave+0x78/0x140
   scmi_vio_complete_cb+0xb4/0x3b8 [scmi_module]
   vring_interrupt+0x84/0x120
   vm_interrupt+0x94/0xe8
   __handle_irq_event_percpu+0xb4/0x3d8
   handle_irq_event_percpu+0x20/0x68
   handle_irq_event+0x50/0xb0
   handle_fasteoi_irq+0xac/0x138
   generic_handle_domain_irq+0x34/0x50
   gic_handle_irq+0xa0/0xd8
   call_on_irq_stack+0x2c/0x54
   do_interrupt_handler+0x8c/0x90
   el1_interrupt+0x40/0x78
   el1h_64_irq_handler+0x18/0x28
   el1h_64_irq+0x64/0x68
   _raw_write_unlock_irq+0x48/0x80
   ep_start_scan+0xf0/0x128
   do_epoll_wait+0x390/0x858
   do_compat_epoll_pwait.part.34+0x1c/0xb8
   __arm64_sys_epoll_pwait+0x80/0xd0
   invoke_syscall+0x4c/0x110
   el0_svc_common.constprop.3+0x98/0x120
   do_el0_svc+0x34/0xd0
   el0_svc+0x40/0x98
   el0t_64_sync_handler+0x98/0xc0
   el0t_64_sync+0x170/0x174

 to a HARDIRQ-irq-unsafe lock:
  (&dev->vqs_list_lock){+.+.}-{3:3}

 ... which became HARDIRQ-irq-unsafe at:
 ...
   lock_acquire+0x128/0x398
   _raw_spin_lock+0x58/0x70
   __vring_new_virtqueue+0x130/0x1c0
   vring_create_virtqueue+0xc4/0x2b8
   vm_find_vqs+0x20c/0x430
   init_vq+0x308/0x390
   virtblk_probe+0x114/0x9b0
   virtio_dev_probe+0x1a4/0x248
   really_probe+0xc8/0x3a8
   __driver_probe_device+0x84/0x190
   driver_probe_device+0x44/0x110
   __driver_attach+0x104/0x1e8
   bus_for_each_dev+0x7c/0xd0
   driver_attach+0x2c/0x38
   bus_add_driver+0x1e4/0x258
   driver_register+0x6c/0x128
   register_virtio_driver+0x2c/0x48
   virtio_blk_init+0x70/0xac
   do_one_initcall+0x84/0x420
   kernel_init_freeable+0x2d0/0x340
   kernel_init+0x2c/0x138
   ret_from_fork+0x10/0x20

 other info that might help us debug this:

  Possible interrupt unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&dev->vqs_list_lock);
                                local_irq_disable();
                                lock(&channels[i].lock);
                                lock(&dev->vqs_list_lock);
   <Interrupt>
     lock(&channels[i].lock);

  *** DEADLOCK ***
================

Fixes: 42e90eb53bf3f ("firmware: arm_scmi: Add a virtio channel refcount")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20221222183823.518856-6-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/virtio.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/virtio.c b/drivers/firmware/arm_scmi/virtio.c
index 33c9b81a55cd..1db975c08896 100644
--- a/drivers/firmware/arm_scmi/virtio.c
+++ b/drivers/firmware/arm_scmi/virtio.c
@@ -160,7 +160,6 @@ static void scmi_vio_channel_cleanup_sync(struct scmi_vio_channel *vioch)
 	}
 
 	vioch->shutdown_done = &vioch_shutdown_done;
-	virtio_break_device(vioch->vqueue->vdev);
 	if (!vioch->is_rx && vioch->deferred_tx_wq)
 		/* Cannot be kicked anymore after this...*/
 		vioch->deferred_tx_wq = NULL;
@@ -482,6 +481,12 @@ static int virtio_chan_free(int id, void *p, void *data)
 	struct scmi_chan_info *cinfo = p;
 	struct scmi_vio_channel *vioch = cinfo->transport_info;
 
+	/*
+	 * Break device to inhibit further traffic flowing while shutting down
+	 * the channels: doing it later holding vioch->lock creates unsafe
+	 * locking dependency chains as reported by LOCKDEP.
+	 */
+	virtio_break_device(vioch->vqueue->vdev);
 	scmi_vio_channel_cleanup_sync(vioch);
 
 	scmi_free_channel(cinfo, data, id);
-- 
2.39.0



