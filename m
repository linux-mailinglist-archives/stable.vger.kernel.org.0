Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D884A103F25
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731881AbfKTPkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:40:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52958 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731809AbfKTPkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:20 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5U-0004b2-RZ; Wed, 20 Nov 2019 15:40:12 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5U-0004Js-Gu; Wed, 20 Nov 2019 15:40:12 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Yoshihiro Shimoda" <yoshihiro.shimoda.uh@renesas.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Wed, 20 Nov 2019 15:38:04 +0000
Message-ID: <lsq.1574264230.547519144@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 54/83] usb: host: ohci: fix a race condition between
 shutdown and irq
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

commit a349b95d7ca0cea71be4a7dac29830703de7eb62 upstream.

This patch fixes an issue that the following error is
possible to happen when ohci hardware causes an interruption
and the system is shutting down at the same time.

[   34.851754] usb 2-1: USB disconnect, device number 2
[   35.166658] irq 156: nobody cared (try booting with the "irqpoll" option)
[   35.173445] CPU: 0 PID: 22 Comm: kworker/0:1 Not tainted 5.3.0-rc5 #85
[   35.179964] Hardware name: Renesas Salvator-X 2nd version board based on r8a77965 (DT)
[   35.187886] Workqueue: usb_hub_wq hub_event
[   35.192063] Call trace:
[   35.194509]  dump_backtrace+0x0/0x150
[   35.198165]  show_stack+0x14/0x20
[   35.201475]  dump_stack+0xa0/0xc4
[   35.204785]  __report_bad_irq+0x34/0xe8
[   35.208614]  note_interrupt+0x2cc/0x318
[   35.212446]  handle_irq_event_percpu+0x5c/0x88
[   35.216883]  handle_irq_event+0x48/0x78
[   35.220712]  handle_fasteoi_irq+0xb4/0x188
[   35.224802]  generic_handle_irq+0x24/0x38
[   35.228804]  __handle_domain_irq+0x5c/0xb0
[   35.232893]  gic_handle_irq+0x58/0xa8
[   35.236548]  el1_irq+0xb8/0x180
[   35.239681]  __do_softirq+0x94/0x23c
[   35.243253]  irq_exit+0xd0/0xd8
[   35.246387]  __handle_domain_irq+0x60/0xb0
[   35.250475]  gic_handle_irq+0x58/0xa8
[   35.254130]  el1_irq+0xb8/0x180
[   35.257268]  kernfs_find_ns+0x5c/0x120
[   35.261010]  kernfs_find_and_get_ns+0x3c/0x60
[   35.265361]  sysfs_unmerge_group+0x20/0x68
[   35.269454]  dpm_sysfs_remove+0x2c/0x68
[   35.273284]  device_del+0x80/0x370
[   35.276683]  hid_destroy_device+0x28/0x60
[   35.280686]  usbhid_disconnect+0x4c/0x80
[   35.284602]  usb_unbind_interface+0x6c/0x268
[   35.288867]  device_release_driver_internal+0xe4/0x1b0
[   35.293998]  device_release_driver+0x14/0x20
[   35.298261]  bus_remove_device+0x110/0x128
[   35.302350]  device_del+0x148/0x370
[   35.305832]  usb_disable_device+0x8c/0x1d0
[   35.309921]  usb_disconnect+0xc8/0x2d0
[   35.313663]  hub_event+0x6e0/0x1128
[   35.317146]  process_one_work+0x1e0/0x320
[   35.321148]  worker_thread+0x40/0x450
[   35.324805]  kthread+0x124/0x128
[   35.328027]  ret_from_fork+0x10/0x18
[   35.331594] handlers:
[   35.333862] [<0000000079300c1d>] usb_hcd_irq
[   35.338126] [<0000000079300c1d>] usb_hcd_irq
[   35.342389] Disabling IRQ #156

ohci_shutdown() disables all the interrupt and rh_state is set to
OHCI_RH_HALTED. In other hand, ohci_irq() is possible to enable
OHCI_INTR_SF and OHCI_INTR_MIE on ohci_irq(). Note that OHCI_INTR_SF
is possible to be set by start_ed_unlink() which is called:
 ohci_irq()
  -> process_done_list()
   -> takeback_td()
    -> start_ed_unlink()

So, ohci_irq() has the following condition, the issue happens by
&ohci->regs->intrenable = OHCI_INTR_MIE | OHCI_INTR_SF and
ohci->rh_state = OHCI_RH_HALTED:

	/* interrupt for some other device? */
	if (ints == 0 || unlikely(ohci->rh_state == OHCI_RH_HALTED))
		return IRQ_NOTMINE;

To fix the issue, ohci_shutdown() holds the spin lock while disabling
the interruption and changing the rh_state flag to prevent reenable
the OHCI_INTR_MIE unexpectedly. Note that io_watchdog_func() also
calls the ohci_shutdown() and it already held the spin lock, so that
the patch makes a new function as _ohci_shutdown().

This patch is inspired by a Renesas R-Car Gen3 BSP patch
from Tho Vu.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/1566877910-6020-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16:
 - Drop change in io_watchdog_func()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -392,8 +392,7 @@ static void ohci_usb_reset (struct ohci_
  * other cases where the next software may expect clean state from the
  * "firmware".  this is bus-neutral, unlike shutdown() methods.
  */
-static void
-ohci_shutdown (struct usb_hcd *hcd)
+static void _ohci_shutdown(struct usb_hcd *hcd)
 {
 	struct ohci_hcd *ohci;
 
@@ -408,6 +407,16 @@ ohci_shutdown (struct usb_hcd *hcd)
 	ohci_writel(ohci, ohci->fminterval, &ohci->regs->fminterval);
 }
 
+static void ohci_shutdown(struct usb_hcd *hcd)
+{
+	struct ohci_hcd	*ohci = hcd_to_ohci(hcd);
+	unsigned long flags;
+
+	spin_lock_irqsave(&ohci->lock, flags);
+	_ohci_shutdown(hcd);
+	spin_unlock_irqrestore(&ohci->lock, flags);
+}
+
 static int check_ed(struct ohci_hcd *ohci, struct ed *ed)
 {
 	return (hc32_to_cpu(ohci, ed->hwINFO) & ED_IN) != 0

