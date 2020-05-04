Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3401C4500
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731501AbgEDSD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:03:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731511AbgEDSD0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:03:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95E8624959;
        Mon,  4 May 2020 18:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615406;
        bh=/R8XU+BggqfQRFq8PBhn4i1kXq57E1OzkleW7rEp2U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sgLuCGysbMhnwFyYXP9e7oBSY4GQi/zIX9Ufph6F1i4jZN7VCFifQlHJ/A9nuS6Nr
         NhScYpfXrV8Mwj2ZjiUZTiaGw0mdg3IYlVMZGTTaWk4f1GSWfIiY39qhQTbbVZ0UsG
         Ru/ceJXsmJdwRhn/QkxvT60mioLfFBqa/WdISRsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>, Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 5.4 25/57] Drivers: hv: vmbus: Fix Suspend-to-Idle for Generation-2 VM
Date:   Mon,  4 May 2020 19:57:29 +0200
Message-Id: <20200504165458.526901749@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165456.783676004@linuxfoundation.org>
References: <20200504165456.783676004@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

commit 1a06d017fb3f388734ffbe5dedee6f8c3af5f2db upstream.

Before the hibernation patchset (e.g. f53335e3289f), in a Generation-2
Linux VM on Hyper-V, the user can run "echo freeze > /sys/power/state" to
freeze the system, i.e. Suspend-to-Idle. The user can press the keyboard
or move the mouse to wake up the VM.

With the hibernation patchset, Linux VM on Hyper-V can hibernate to disk,
but Suspend-to-Idle is broken: when the synthetic keyboard/mouse are
suspended, there is no way to wake up the VM.

Fix the issue by not suspending and resuming the vmbus devices upon
Suspend-to-Idle.

Fixes: f53335e3289f ("Drivers: hv: vmbus: Suspend/resume the vmbus itself for hibernation")
Cc: stable@vger.kernel.org
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Link: https://lore.kernel.org/r/1586663435-36243-1-git-send-email-decui@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/vmbus_drv.c |   43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -978,6 +978,9 @@ static int vmbus_resume(struct device *c
 
 	return drv->resume(dev);
 }
+#else
+#define vmbus_suspend NULL
+#define vmbus_resume NULL
 #endif /* CONFIG_PM_SLEEP */
 
 /*
@@ -995,11 +998,22 @@ static void vmbus_device_release(struct
 }
 
 /*
- * Note: we must use SET_NOIRQ_SYSTEM_SLEEP_PM_OPS rather than
- * SET_SYSTEM_SLEEP_PM_OPS: see the comment before vmbus_bus_pm.
+ * Note: we must use the "noirq" ops: see the comment before vmbus_bus_pm.
+ *
+ * suspend_noirq/resume_noirq are set to NULL to support Suspend-to-Idle: we
+ * shouldn't suspend the vmbus devices upon Suspend-to-Idle, otherwise there
+ * is no way to wake up a Generation-2 VM.
+ *
+ * The other 4 ops are for hibernation.
  */
+
 static const struct dev_pm_ops vmbus_pm = {
-	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(vmbus_suspend, vmbus_resume)
+	.suspend_noirq	= NULL,
+	.resume_noirq	= NULL,
+	.freeze_noirq	= vmbus_suspend,
+	.thaw_noirq	= vmbus_resume,
+	.poweroff_noirq	= vmbus_suspend,
+	.restore_noirq	= vmbus_resume,
 };
 
 /* The one and only one */
@@ -2280,6 +2294,9 @@ static int vmbus_bus_resume(struct devic
 
 	return 0;
 }
+#else
+#define vmbus_bus_suspend NULL
+#define vmbus_bus_resume NULL
 #endif /* CONFIG_PM_SLEEP */
 
 static const struct acpi_device_id vmbus_acpi_device_ids[] = {
@@ -2290,16 +2307,24 @@ static const struct acpi_device_id vmbus
 MODULE_DEVICE_TABLE(acpi, vmbus_acpi_device_ids);
 
 /*
- * Note: we must use SET_NOIRQ_SYSTEM_SLEEP_PM_OPS rather than
- * SET_SYSTEM_SLEEP_PM_OPS, otherwise NIC SR-IOV can not work, because the
- * "pci_dev_pm_ops" uses the "noirq" callbacks: in the resume path, the
- * pci "noirq" restore callback runs before "non-noirq" callbacks (see
+ * Note: we must use the "no_irq" ops, otherwise hibernation can not work with
+ * PCI device assignment, because "pci_dev_pm_ops" uses the "noirq" ops: in
+ * the resume path, the pci "noirq" restore op runs before "non-noirq" op (see
  * resume_target_kernel() -> dpm_resume_start(), and hibernation_restore() ->
  * dpm_resume_end()). This means vmbus_bus_resume() and the pci-hyperv's
- * resume callback must also run via the "noirq" callbacks.
+ * resume callback must also run via the "noirq" ops.
+ *
+ * Set suspend_noirq/resume_noirq to NULL for Suspend-to-Idle: see the comment
+ * earlier in this file before vmbus_pm.
  */
+
 static const struct dev_pm_ops vmbus_bus_pm = {
-	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(vmbus_bus_suspend, vmbus_bus_resume)
+	.suspend_noirq	= NULL,
+	.resume_noirq	= NULL,
+	.freeze_noirq	= vmbus_bus_suspend,
+	.thaw_noirq	= vmbus_bus_resume,
+	.poweroff_noirq	= vmbus_bus_suspend,
+	.restore_noirq	= vmbus_bus_resume
 };
 
 static struct acpi_driver vmbus_acpi_driver = {


