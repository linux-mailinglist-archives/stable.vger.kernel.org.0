Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD7C17FAFB
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730590AbgCJNJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:09:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729711AbgCJNJu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:09:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D131B20873;
        Tue, 10 Mar 2020 13:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845790;
        bh=R0xtEeO5tk6dzUgcr5epTAnksL+QGHKhE/f2CIOORsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cM2H8PEMp2yFZ4krHMFIrScadh4O304bmXmqUtVF4xCCEjfH5M16RFnxB9ctRdr7c
         fc4WiKP5DgIkWZbKdndPgtI2KvOdcrg461IR3b9Ah/4bAOqOTBEnd4fEC8sZrrUibB
         My8UDrt71LYc4xl0lYrULx+uHxdaxLU4AODQZ0cw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jay Dolan <jay.dolan@accesio.com>
Subject: [PATCH 4.14 102/126] serial: 8250_exar: add support for ACCES cards
Date:   Tue, 10 Mar 2020 13:42:03 +0100
Message-Id: <20200310124210.177934557@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jay Dolan <jay.dolan@accesio.com>

commit 10c5ccc3c6d32f3d7d6c07de1d3f0f4b52f3e3ab upstream.

Add ACCES VIDs and PIDs that use the Exar chips

Signed-off-by: Jay Dolan <jay.dolan@accesio.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200305140504.22237-1-jay.dolan@accesio.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250/8250_exar.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -27,6 +27,14 @@
 
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
@@ -562,6 +570,22 @@ static int __maybe_unused exar_resume(st
 
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
@@ -632,6 +656,15 @@ static const struct exar8250_board pbn_e
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


