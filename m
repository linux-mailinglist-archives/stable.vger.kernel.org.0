Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5CB38B2E0
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 17:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbhETPUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 11:20:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231298AbhETPUN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 11:20:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7457B6023E;
        Thu, 20 May 2021 15:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621523931;
        bh=+O4Urop0uUUUBM0j8zlDK0Hnrj0ECqrvLfV1hu1INDQ=;
        h=Subject:To:From:Date:From;
        b=Tm1OBYF9WwKGUcYVqqb55nWMl0sEHFX1q73L/VEltD4kX8noEViemTPhKZQz+ytao
         bgSIvLtbNGayiSuWW3akshishUQh/9BUZHoenKYPJ7OVY5SZ7/QwhlIW2mnGpO+Itk
         kztX+KPL1+sOLdQz1yupcffUhJZOFkF/wGRX9eew=
Subject: patch "serial: 8250_pci: Add support for new HPE serial device" added to tty-linus
To:     rwright@hpe.com, gregkh@linuxfoundation.org, jerry.hoemann@hpe.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 20 May 2021 17:18:41 +0200
Message-ID: <1621523921112168@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: 8250_pci: Add support for new HPE serial device

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e0e24208792080135248f23fdf6d51aa2e04df05 Mon Sep 17 00:00:00 2001
From: Randy Wright <rwright@hpe.com>
Date: Fri, 14 May 2021 10:26:54 -0600
Subject: serial: 8250_pci: Add support for new HPE serial device

Add support for new HPE serial device.  It is MSI enabled,
but otherwise similar to legacy HP server serial devices.

Tested-by: Jerry Hoemann <jerry.hoemann@hpe.com>
Signed-off-by: Randy Wright <rwright@hpe.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1621009614-28836-1-git-send-email-rwright@hpe.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 689d8227f95f..04fe42469990 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -56,6 +56,8 @@ struct serial_private {
 	int			line[];
 };
 
+#define PCI_DEVICE_ID_HPE_PCI_SERIAL	0x37e
+
 static const struct pci_device_id pci_use_msi[] = {
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9900,
 			 0xA000, 0x1000) },
@@ -63,6 +65,8 @@ static const struct pci_device_id pci_use_msi[] = {
 			 0xA000, 0x1000) },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9922,
 			 0xA000, 0x1000) },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_HP_3PAR, PCI_DEVICE_ID_HPE_PCI_SERIAL,
+			 PCI_ANY_ID, PCI_ANY_ID) },
 	{ }
 };
 
@@ -1997,6 +2001,16 @@ static struct pci_serial_quirk pci_serial_quirks[] = {
 		.init		= pci_hp_diva_init,
 		.setup		= pci_hp_diva_setup,
 	},
+	/*
+	 * HPE PCI serial device
+	 */
+	{
+		.vendor         = PCI_VENDOR_ID_HP_3PAR,
+		.device         = PCI_DEVICE_ID_HPE_PCI_SERIAL,
+		.subvendor      = PCI_ANY_ID,
+		.subdevice      = PCI_ANY_ID,
+		.setup		= pci_hp_diva_setup,
+	},
 	/*
 	 * Intel
 	 */
@@ -4973,6 +4987,10 @@ static const struct pci_device_id serial_pci_tbl[] = {
 	{	PCI_VENDOR_ID_HP, PCI_DEVICE_ID_HP_DIVA_AUX,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b2_1_115200 },
+	/* HPE PCI serial device */
+	{	PCI_VENDOR_ID_HP_3PAR, PCI_DEVICE_ID_HPE_PCI_SERIAL,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b1_1_115200 },
 
 	{	PCI_VENDOR_ID_DCI, PCI_DEVICE_ID_DCI_PCCOM2,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-- 
2.31.1


