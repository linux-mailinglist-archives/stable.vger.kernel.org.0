Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F505EFF0F
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 23:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiI2VIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 17:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiI2VIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 17:08:04 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F091B95C3;
        Thu, 29 Sep 2022 14:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664485683; x=1696021683;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OD2nGZZXm6zw1C8qBm6H7lQ3q3LetXLCwRu3g78LU1w=;
  b=ntsE4Bt0U8eoIYVwFcFbvTd39E0SlA5RpPm5tbgCZ9eucPrSiDY1heN+
   84bSUzlQS6yqnz7Jv3DpuSF/56DEayN5cOqh0dWgjW95bFQgc0ZFMS2KW
   D8zc4sZ5ioIDZWHS+JSadk0JshFoPq/0P2wYANe9W+1EcNJUYYXkK6a0T
   M=;
X-IronPort-AV: E=Sophos;i="5.93,356,1654560000"; 
   d="scan'208";a="135465344"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-b09d0114.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 21:07:58 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-b09d0114.us-east-1.amazon.com (Postfix) with ESMTPS id 18A0181453;
        Thu, 29 Sep 2022 21:07:54 +0000 (UTC)
Received: from EX19D012UWC003.ant.amazon.com (10.13.138.175) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 29 Sep 2022 21:07:54 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX19D012UWC003.ant.amazon.com (10.13.138.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.12; Thu, 29 Sep 2022 21:07:54 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1497.38 via Frontend Transport; Thu, 29 Sep 2022 21:07:53
 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 2425627B3; Thu, 29 Sep 2022 21:07:52 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>, <benh@amazon.com>,
        <mbacco@amazon.com>, Lukas Wunner <lukas@wunner.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        <linux-pci@vger.kernel.org>
Subject: [PATCH 2/6] genirq: Synchronize only with single thread on free_irq()
Date:   Thu, 29 Sep 2022 21:06:47 +0000
Message-ID: <20220929210651.12308-3-risbhat@amazon.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220929210651.12308-1-risbhat@amazon.com>
References: <20220929210651.12308-1-risbhat@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-12.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 519cc8652b3a1d3d0a02257afbe9573ad644da26 upstream.

When pciehp is converted to threaded IRQ handling, removal of unplugged
devices below a PCIe hotplug port happens synchronously in the IRQ thread.
Removal of devices typically entails a call to free_irq() by their drivers.

If those devices share their IRQ with the hotplug port, __free_irq()
deadlocks because it calls synchronize_irq() to wait for all hard IRQ
handlers as well as all threads sharing the IRQ to finish.

Actually it's sufficient to wait only for the IRQ thread of the removed
device, so call synchronize_hardirq() to wait for all hard IRQ handlers to
finish, but no longer for any threads.  Compensate by rearranging the
control flow in irq_wait_for_interrupt() such that the device's thread is
allowed to run one last time after kthread_stop() has been called.

kthread_stop() blocks until the IRQ thread has completed.  On completion
the IRQ thread clears its oneshot thread_mask bit.  This is safe because
__free_irq() holds the request_mutex, thereby preventing __setup_irq() from
handing out the same oneshot thread_mask bit to a newly requested action.

Stack trace for posterity:
    INFO: task irq/17-pciehp:94 blocked for more than 120 seconds.
    schedule+0x28/0x80
    synchronize_irq+0x6e/0xa0
    __free_irq+0x15a/0x2b0
    free_irq+0x33/0x70
    pciehp_release_ctrl+0x98/0xb0
    pcie_port_remove_service+0x2f/0x40
    device_release_driver_internal+0x157/0x220
    bus_remove_device+0xe2/0x150
    device_del+0x124/0x340
    device_unregister+0x16/0x60
    remove_iter+0x1a/0x20
    device_for_each_child+0x4b/0x90
    pcie_port_device_remove+0x1e/0x30
    pci_device_remove+0x36/0xb0
    device_release_driver_internal+0x157/0x220
    pci_stop_bus_device+0x7d/0xa0
    pci_stop_bus_device+0x3d/0xa0
    pci_stop_and_remove_bus_device+0xe/0x20
    pciehp_unconfigure_device+0xb8/0x160
    pciehp_disable_slot+0x84/0x130
    pciehp_ist+0x158/0x190
    irq_thread_fn+0x1b/0x50
    irq_thread+0x143/0x1a0
    kthread+0x111/0x130

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-pci@vger.kernel.org
Link: https://lkml.kernel.org/r/d72b41309f077c8d3bee6cc08ad3662d50b5d22a.1529828292.git.lukas@wunner.de
Signed-off by: Rishabh Bhatnagar <risbhat@amazon.com>
---
 kernel/irq/manage.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index cb35db00fdf4..722aeaae92b1 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -791,9 +791,19 @@ static irqreturn_t irq_forced_secondary_handler(int irq, void *dev_id)
 
 static int irq_wait_for_interrupt(struct irqaction *action)
 {
-	set_current_state(TASK_INTERRUPTIBLE);
+	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
 
-	while (!kthread_should_stop()) {
+		if (kthread_should_stop()) {
+			/* may need to run one last time */
+			if (test_and_clear_bit(IRQTF_RUNTHREAD,
+					       &action->thread_flags)) {
+				__set_current_state(TASK_RUNNING);
+				return 0;
+			}
+			__set_current_state(TASK_RUNNING);
+			return -1;
+		}
 
 		if (test_and_clear_bit(IRQTF_RUNTHREAD,
 				       &action->thread_flags)) {
@@ -801,10 +811,7 @@ static int irq_wait_for_interrupt(struct irqaction *action)
 			return 0;
 		}
 		schedule();
-		set_current_state(TASK_INTERRUPTIBLE);
 	}
-	__set_current_state(TASK_RUNNING);
-	return -1;
 }
 
 /*
@@ -1029,7 +1036,7 @@ static int irq_thread(void *data)
 	/*
 	 * This is the regular exit path. __free_irq() is stopping the
 	 * thread via kthread_stop() after calling
-	 * synchronize_irq(). So neither IRQTF_RUNTHREAD nor the
+	 * synchronize_hardirq(). So neither IRQTF_RUNTHREAD nor the
 	 * oneshot mask bit can be set.
 	 */
 	task_work_cancel(current, irq_thread_dtor);
@@ -1253,7 +1260,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 
 	/*
 	 * Protects against a concurrent __free_irq() call which might wait
-	 * for synchronize_irq() to complete without holding the optional
+	 * for synchronize_hardirq() to complete without holding the optional
 	 * chip bus lock and desc->lock. Also protects against handing out
 	 * a recycled oneshot thread_mask bit while it's still in use by
 	 * its previous owner.
@@ -1610,11 +1617,11 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 	/*
 	 * Drop bus_lock here so the changes which were done in the chip
 	 * callbacks above are synced out to the irq chips which hang
-	 * behind a slow bus (I2C, SPI) before calling synchronize_irq().
+	 * behind a slow bus (I2C, SPI) before calling synchronize_hardirq().
 	 *
 	 * Aside of that the bus_lock can also be taken from the threaded
 	 * handler in irq_finalize_oneshot() which results in a deadlock
-	 * because synchronize_irq() would wait forever for the thread to
+	 * because kthread_stop() would wait forever for the thread to
 	 * complete, which is blocked on the bus lock.
 	 *
 	 * The still held desc->request_mutex() protects against a
@@ -1626,7 +1633,7 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 	unregister_handler_proc(irq, action);
 
 	/* Make sure it's not being used on another CPU: */
-	synchronize_irq(irq);
+	synchronize_hardirq(irq);
 
 #ifdef CONFIG_DEBUG_SHIRQ
 	/*
@@ -1644,6 +1651,12 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 	}
 #endif
 
+	/*
+	 * The action has already been removed above, but the thread writes
+	 * its oneshot mask bit when it completes. Though request_mutex is
+	 * held across this which prevents __setup_irq() from handing out
+	 * the same bit to a newly requested action.
+	 */
 	if (action->thread) {
 		kthread_stop(action->thread);
 		put_task_struct(action->thread);
-- 
2.37.1

