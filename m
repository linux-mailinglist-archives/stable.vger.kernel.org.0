Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188AA4691B9
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 09:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236377AbhLFIus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 03:50:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55858 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239616AbhLFIus (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 03:50:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5045AB8103C
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 08:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEAEC341C8;
        Mon,  6 Dec 2021 08:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638780438;
        bh=XGdhpVcE/GF/wS0A0bKLyxWnRKBQmRhpmW9GexpXmEI=;
        h=Subject:To:Cc:From:Date:From;
        b=SHjtIq9RYBl+GKdArepdA/3EdS+ADOqgHywLSHt8piTk+/3RV51DabP942PpzvUoj
         ftMj0fldsa5Pih8xiBL7Sw5+PsWx4I8j0sqmNIVMc3LYshZ5p5KVTtg+3KcFaH45W/
         jPpaOhMlft8XL38BrLnuvyprz2bcZqUrjExLCUxc=
Subject: FAILED: patch "[PATCH] serial: 8250_pci: Fix ACCES entries in pci_serial_quirks" failed to apply to 4.19-stable tree
To:     jay.dolan@accesio.com, andriy.shevchenko@linux.intel.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Dec 2021 09:47:05 +0100
Message-ID: <16387804252351@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c525c5d2437f93520388920baac6d9340c65d239 Mon Sep 17 00:00:00 2001
From: Jay Dolan <jay.dolan@accesio.com>
Date: Mon, 22 Nov 2021 14:06:03 +0200
Subject: [PATCH] serial: 8250_pci: Fix ACCES entries in pci_serial_quirks
 array

Fix error in table for PCI_DEVICE_ID_ACCESIO_PCIE_ICM_4S that caused it
and PCI_DEVICE_ID_ACCESIO_PCIE_ICM232_4 to be missing their fourth port.

Fixes: 78d3820b9bd3 ("serial: 8250_pci: Have ACCES cards that use the four port Pericom PI7C9X7954 chip use the pci_pericom_setup()")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Jay Dolan <jay.dolan@accesio.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20211122120604.3909-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 5d43de143f33..b793d848aeb6 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -2291,12 +2291,19 @@ static struct pci_serial_quirk pci_serial_quirks[] = {
 		.setup      = pci_pericom_setup_four_at_eight,
 	},
 	{
-		.vendor     = PCI_DEVICE_ID_ACCESIO_PCIE_ICM_4S,
+		.vendor     = PCI_VENDOR_ID_ACCESIO,
 		.device     = PCI_DEVICE_ID_ACCESIO_PCIE_ICM232_4,
 		.subvendor  = PCI_ANY_ID,
 		.subdevice  = PCI_ANY_ID,
 		.setup      = pci_pericom_setup_four_at_eight,
 	},
+	{
+		.vendor     = PCI_VENDOR_ID_ACCESIO,
+		.device     = PCI_DEVICE_ID_ACCESIO_PCIE_ICM_4S,
+		.subvendor  = PCI_ANY_ID,
+		.subdevice  = PCI_ANY_ID,
+		.setup      = pci_pericom_setup_four_at_eight,
+	},
 	{
 		.vendor     = PCI_VENDOR_ID_ACCESIO,
 		.device     = PCI_DEVICE_ID_ACCESIO_MPCIE_ICM232_4,

