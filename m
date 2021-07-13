Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541BD3C76B5
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 20:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhGMSyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 14:54:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38500 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229697AbhGMSyS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 14:54:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626202287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc; bh=m2KCkNllqfc9y9Fv2TNxYrId4pKJsIrfXlJbYcD2q8w=;
        b=QxmUs70wMQrRbeUpHL+sGu46RgRTTRffi05kycmCr8qw5lPBAOqRun5vhQZOOGbbAa3hpL
        uGzfs6uG5oj84k9n8t+da4TdhGxlaQ4btt8owUe4o0PVswNateJHRUEsxdav7V9yJVpUna
        hgWGeKKdCsvBXXZcTwY1B22v8PdsEEs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-EVn3WcyzPPSOg7mc3zhrpw-1; Tue, 13 Jul 2021 14:51:26 -0400
X-MC-Unique: EVn3WcyzPPSOg7mc3zhrpw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70672101C8CA;
        Tue, 13 Jul 2021 18:51:25 +0000 (UTC)
Received: from loberhel.redhat.com (ovpn-112-148.phx2.redhat.com [10.3.112.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E7DD5D9CA;
        Tue, 13 Jul 2021 18:51:20 +0000 (UTC)
From:   Laurence Oberman <loberman@redhat.com>
To:     linux-usb@vger.kernel.org, andriy.shevchenko@linux.intel.com,
        stable@vger.kernel.org, loberman@redhat.com, emilne@redhat.com,
        djeffery@redhat.com, apanagio@redhat.com, torez@redhat.com
Subject: [PATCH] usb: hcd: Revert 306c54d0edb6ba94d39877524dddebaad7770cf2: Try MSI interrupts on PCI devices
Date:   Tue, 13 Jul 2021 14:50:42 -0400
Message-Id: <1626202242-14984-1-git-send-email-loberman@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Customers have been reporting that the I/O is radically being
slowed down to HPE virtual USB ILO served DVD images during installation.

Lots of investigation by the Red Hat lab has found that the issue is 
because MSI edge interrupts do not work properly for these 
ILO USB devices.
We start fast and then drop to polling mode and its unusable.

The issue exists currently upstream on 5.13 as tested by Red Hat, 
and reverting the mentioned patch corrects this upstream.

David Jeffery has this explanation:

The problem with the patch turning on MSI appears to be that the ehci 
driver (and possibly other usb controller types too) wasn't written to
support edge-triggered interrupts.
The ehci_irq routine appears to be written in such a way that it will 
be racy with multiple interrupt source bits.
With a level-triggered interrupt, it gets called another time and cleans 
up other interrupt sources.
But with MSI edge, the interrupt state staying high results in no 
new interrupt and ehci has to run based on polling.

static irqreturn_t ehci_irq (struct usb_hcd *hcd)
{
...
        status = ehci_readl(ehci, &ehci->regs->status);

        /* e.g. cardbus physical eject */
        if (status == ~(u32) 0) {
                ehci_dbg (ehci, "device removed\n");
                goto dead;
        }

        /*
         * We don't use STS_FLR, but some controllers don't like it to
         * remain on, so mask it out along with the other status bits.
         */
        masked_status = status & (INTR_MASK | STS_FLR);

        /* Shared IRQ? */
        if (!masked_status || unlikely(ehci->rh_state == EHCI_RH_HALTED)) {
                spin_unlock_irqrestore(&ehci->lock, flags);
                return IRQ_NONE;
        }

        /* clear (just) interrupts */
        ehci_writel(ehci, masked_status, &ehci->regs->status);
...

ehci_irq() reads the interrupt status register and then writes the active 
interrupt-related bits back out to ack the interrupt cause.
But with an edge interrupt, this is racy as another source of interrupt 
could be raised by ehci between the read and the write reaching the 
hardware. 
e.g.  If STS_IAA was set during the initial read, but some other bit like 
STS_INT gets raised by the hardware between the read and the write to the 
interrupt status register, the interrupt signal state won't drop.
The interrupt state says high, and since it is now edged triggered with 
MSI, no new invocation of the interrupt handler gets triggered.

Suggested-by: David Jeffery <djeffery@redhat.com>
Suggested-by: Alexandros Panagiotou <apanagio@redhat.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Laurence Oberman <loberman@redhat.com>
Fixes: 306c54d0edb6ba94d39877524dddebaad7770cf2 PCI: Disable MSI for 
Pericom PCIe-USB adapter 
---
 drivers/usb/core/hcd-pci.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
index d630ccc..522a179 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -195,21 +195,20 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id,
 	 * make sure irq setup is not touched for xhci in generic hcd code
 	 */
 	if ((driver->flags & HCD_MASK) < HCD_USB3) {
-		retval = pci_alloc_irq_vectors(dev, 1, 1, PCI_IRQ_LEGACY | PCI_IRQ_MSI);
-		if (retval < 0) {
+		if (!dev->irq) {
 			dev_err(&dev->dev,
 			"Found HC with no IRQ. Check BIOS/PCI %s setup!\n",
 				pci_name(dev));
 			retval = -ENODEV;
 			goto disable_pci;
 		}
-		hcd_irq = pci_irq_vector(dev, 0);
+		hcd_irq = dev->irq;
 	}
 
 	hcd = usb_create_hcd(driver, &dev->dev, pci_name(dev));
 	if (!hcd) {
 		retval = -ENOMEM;
-		goto free_irq_vectors;
+		goto disable_pci;
 	}
 
 	hcd->amd_resume_bug = (usb_hcd_amd_remote_wakeup_quirk(dev) &&
@@ -288,9 +287,6 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id,
 
 put_hcd:
 	usb_put_hcd(hcd);
-free_irq_vectors:
-	if ((driver->flags & HCD_MASK) < HCD_USB3)
-		pci_free_irq_vectors(dev);
 disable_pci:
 	pci_disable_device(dev);
 	dev_err(&dev->dev, "init %s fail, %d\n", pci_name(dev), retval);
@@ -352,8 +348,6 @@ void usb_hcd_pci_remove(struct pci_dev *dev)
 		up_read(&companions_rwsem);
 	}
 	usb_put_hcd(hcd);
-	if ((hcd_driver_flags & HCD_MASK) < HCD_USB3)
-		pci_free_irq_vectors(dev);
 	pci_disable_device(dev);
 }
 EXPORT_SYMBOL_GPL(usb_hcd_pci_remove);
@@ -465,7 +459,7 @@ static int suspend_common(struct device *dev, bool do_wakeup)
 	 * synchronized here.
 	 */
 	if (!hcd->msix_enabled)
-		synchronize_irq(pci_irq_vector(pci_dev, 0));
+		synchronize_irq(pci_dev->irq);
 
 	/* Downstream ports from this root hub should already be quiesced, so
 	 * there will be no DMA activity.  Now we can shut down the upstream
-- 
1.8.3.1

