Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B35317AFBB
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 21:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgCEUbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 15:31:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbgCEUbJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 15:31:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CCB1207FD;
        Thu,  5 Mar 2020 20:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583440268;
        bh=l7wGo1d9ELDxDKVdvCqKLvvi+AEgoSjeSeAC/FQ5FW8=;
        h=Subject:To:From:Date:From;
        b=Nyxc9gWCy+rvAmsuKKbG3cw3ugS3plPed+KkOOB8OTQ0GdMUy7IIZWsAjtM4eHVvt
         +6XVLIJVkLJGWs5dqH+pPtFq8B9IpA66mQ2OqcOG1KAuB3Ie9H72IrvMbaaOr5luKr
         DzvUvm6BHe/0IwPyI3ISA0KQp0OCg1Ff+qhgdS/w=
Subject: patch "serial: 8250_exar: add support for ACCES cards" added to tty-linus
To:     jay.dolan@accesio.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 05 Mar 2020 21:30:58 +0100
Message-ID: <158344025819438@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: 8250_exar: add support for ACCES cards

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 10c5ccc3c6d32f3d7d6c07de1d3f0f4b52f3e3ab Mon Sep 17 00:00:00 2001
From: Jay Dolan <jay.dolan@accesio.com>
Date: Thu, 5 Mar 2020 06:05:04 -0800
Subject: serial: 8250_exar: add support for ACCES cards

Add ACCES VIDs and PIDs that use the Exar chips

Signed-off-by: Jay Dolan <jay.dolan@accesio.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200305140504.22237-1-jay.dolan@accesio.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_exar.c | 33 +++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_exar.c b/drivers/tty/serial/8250/8250_exar.c
index 91e9b070d36d..d330da76d6b6 100644
--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -25,6 +25,14 @@
 
 #include "8250.h"
 
+#define PCI_DEVICE_ID_ACCES_COM_2S		0x1052
+#define PCI_DEVICE_ID_ACCES_COM_4S		0x105d
+#define PCI_DEVICE_ID_ACCES_COM_8S		0x106c
+#define PCI_DEVICE_ID_ACCES_COM232_8		0x10a8
+#define PCI_DEVICE_ID_ACCES_COM_2SM		0x10d2
+#define PCI_DEVICE_ID_ACCES_COM_4SM		0x10db
+#define PCI_DEVICE_ID_ACCES_COM_8SM		0x10ea
+
 #define PCI_DEVICE_ID_COMMTECH_4224PCI335	0x0002
 #define PCI_DEVICE_ID_COMMTECH_4222PCI335	0x0004
 #define PCI_DEVICE_ID_COMMTECH_2324PCI335	0x000a
@@ -677,6 +685,22 @@ static int __maybe_unused exar_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(exar_pci_pm, exar_suspend, exar_resume);
 
+static const struct exar8250_board acces_com_2x = {
+	.num_ports	= 2,
+	.setup		= pci_xr17c154_setup,
+};
+
+static const struct exar8250_board acces_com_4x = {
+	.num_ports	= 4,
+	.setup		= pci_xr17c154_setup,
+};
+
+static const struct exar8250_board acces_com_8x = {
+	.num_ports	= 8,
+	.setup		= pci_xr17c154_setup,
+};
+
+
 static const struct exar8250_board pbn_fastcom335_2 = {
 	.num_ports	= 2,
 	.setup		= pci_fastcom335_setup,
@@ -745,6 +769,15 @@ static const struct exar8250_board pbn_exar_XR17V8358 = {
 	}
 
 static const struct pci_device_id exar_pci_tbl[] = {
+	EXAR_DEVICE(ACCESSIO, ACCES_COM_2S, acces_com_2x),
+	EXAR_DEVICE(ACCESSIO, ACCES_COM_4S, acces_com_4x),
+	EXAR_DEVICE(ACCESSIO, ACCES_COM_8S, acces_com_8x),
+	EXAR_DEVICE(ACCESSIO, ACCES_COM232_8, acces_com_8x),
+	EXAR_DEVICE(ACCESSIO, ACCES_COM_2SM, acces_com_2x),
+	EXAR_DEVICE(ACCESSIO, ACCES_COM_4SM, acces_com_4x),
+	EXAR_DEVICE(ACCESSIO, ACCES_COM_8SM, acces_com_8x),
+
+
 	CONNECT_DEVICE(XR17C152, UART_2_232, pbn_connect),
 	CONNECT_DEVICE(XR17C154, UART_4_232, pbn_connect),
 	CONNECT_DEVICE(XR17C158, UART_8_232, pbn_connect),
-- 
2.25.1


