Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65F70157DF6
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 15:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbgBJO4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 09:56:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:34132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727636AbgBJO4t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 09:56:49 -0500
Received: from localhost (unknown [104.132.1.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07D2120842;
        Mon, 10 Feb 2020 14:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581346608;
        bh=HDgwBi+QtlvTncUFHo7+d9Z5Onx46xK/9bv9zfGHB18=;
        h=Subject:To:From:Date:From;
        b=Ok3E6wXNdoIgeqz3CkHtzEunkeuTXsxodv/7Ptn6AdovMYAxJPgFr+Az/KPfIo9Jt
         lRk8oL9H47HoaxE7K+TAlwN7rPQdKTxuJQ/jikSTDY1ss+/uKmAuB2fukx7M9PSexV
         mMbCkex+hDKhqQvkS/Rxa26C+xdZ+5WOSgEEPJ50=
Subject: patch "xhci: fix runtime pm enabling for quirky Intel hosts" added to usb-linus
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 Feb 2020 06:56:47 -0800
Message-ID: <1581346607161133@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: fix runtime pm enabling for quirky Intel hosts

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 024d411e9c5d49eb96c825af52a3ce2682895676 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Mon, 10 Feb 2020 15:45:52 +0200
Subject: xhci: fix runtime pm enabling for quirky Intel hosts

Intel hosts that need the XHCI_PME_STUCK_QUIRK flag should enable
runtime pm by calling xhci_pme_acpi_rtd3_enable() before
usb_hcd_pci_probe() calls pci_dev_run_wake().
Otherwise usage count for the device won't be decreased, and runtime
suspend is prevented.

usb_hcd_pci_probe() only decreases the usage count if device can
generate run-time wake-up events, i.e. when pci_dev_run_wake()
returns true.

This issue was exposed by pci_dev_run_wake() change in
commit 8feaec33b986 ("PCI / PM: Always check PME wakeup capability for
runtime wakeup support")
and should be backported to kernels with that change

Cc: <stable@vger.kernel.org> # 4.13+
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200210134553.9144-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 4917c5b033fa..da7c2db41671 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -302,6 +302,9 @@ static int xhci_pci_setup(struct usb_hcd *hcd)
 	if (!usb_hcd_is_primary_hcd(hcd))
 		return 0;
 
+	if (xhci->quirks & XHCI_PME_STUCK_QUIRK)
+		xhci_pme_acpi_rtd3_enable(pdev);
+
 	xhci_dbg(xhci, "Got SBRN %u\n", (unsigned int) xhci->sbrn);
 
 	/* Find any debug ports */
@@ -359,9 +362,6 @@ static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 			HCC_MAX_PSA(xhci->hcc_params) >= 4)
 		xhci->shared_hcd->can_do_streams = 1;
 
-	if (xhci->quirks & XHCI_PME_STUCK_QUIRK)
-		xhci_pme_acpi_rtd3_enable(dev);
-
 	/* USB-2 and USB-3 roothubs initialized, allow runtime pm suspend */
 	pm_runtime_put_noidle(&dev->dev);
 
-- 
2.25.0


