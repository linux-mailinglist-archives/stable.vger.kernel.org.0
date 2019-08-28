Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE615A0BD1
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 22:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfH1UtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 16:49:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbfH1UtE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 16:49:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5FC02339E;
        Wed, 28 Aug 2019 20:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567025343;
        bh=T/mAwFwAYnz5o9Z7dFRS95luqDFiroqUgm/iNKlWzqQ=;
        h=Subject:To:From:Date:From;
        b=IfL+tzVexjD2uYg3apTIhIwMSwOxNBJQ8QK0+IiTje4ApPaAeeBuU0ZYJXmp2mp6m
         tuLQiJx5BfUHCqFvNUXjmAegB+Pwf/fn+udwUQ6N94CGECdNNq15yFhFo7/i+t1mt+
         NpL5myu0OGpaYR6RpUNwYLobRuXH2RAG4+lFxSyY=
Subject: patch "usb: host: ohci: fix a race condition between shutdown and irq" added to usb-linus
To:     yoshihiro.shimoda.uh@renesas.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Aug 2019 22:48:58 +0200
Message-ID: <156702533880174@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: host: ohci: fix a race condition between shutdown and irq

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a349b95d7ca0cea71be4a7dac29830703de7eb62 Mon Sep 17 00:00:00 2001
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date: Tue, 27 Aug 2019 12:51:50 +0900
Subject: usb: host: ohci: fix a race condition between shutdown and irq

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
Cc: stable <stable@vger.kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/1566877910-6020-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-hcd.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index b457fdaff297..1fe3deec35cf 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -419,8 +419,7 @@ static void ohci_usb_reset (struct ohci_hcd *ohci)
  * other cases where the next software may expect clean state from the
  * "firmware".  this is bus-neutral, unlike shutdown() methods.
  */
-static void
-ohci_shutdown (struct usb_hcd *hcd)
+static void _ohci_shutdown(struct usb_hcd *hcd)
 {
 	struct ohci_hcd *ohci;
 
@@ -436,6 +435,16 @@ ohci_shutdown (struct usb_hcd *hcd)
 	ohci->rh_state = OHCI_RH_HALTED;
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
 /*-------------------------------------------------------------------------*
  * HC functions
  *-------------------------------------------------------------------------*/
@@ -760,7 +769,7 @@ static void io_watchdog_func(struct timer_list *t)
  died:
 			usb_hc_died(ohci_to_hcd(ohci));
 			ohci_dump(ohci);
-			ohci_shutdown(ohci_to_hcd(ohci));
+			_ohci_shutdown(ohci_to_hcd(ohci));
 			goto done;
 		} else {
 			/* No write back because the done queue was empty */
-- 
2.23.0


