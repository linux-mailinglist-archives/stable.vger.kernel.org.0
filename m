Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D58939617F
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbhEaOld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:41:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234139AbhEaOja (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:39:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E30761C5A;
        Mon, 31 May 2021 13:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469150;
        bh=d2nawnXXADBk0RGIBscywxEwhRc6o5WLal3NtqIXGhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sMNBjhF6WKuBjiHJv4/ZI1YF83lIWxitZ/7DM77QvMnQyPPYYSqb1t9iq5BlbjjiW
         RVoIIXcN6Ao8PTFFlzgJG3lw3Zz+iVHKAzGC46EddX4EEWdjoW2SxPc4I86fGLGAk2
         tbHVvVK3Ng3mNleModYUihsIMk2ivXU3Q12QCTaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerry Hoemann <jerry.hoemann@hpe.com>,
        Randy Wright <rwright@hpe.com>
Subject: [PATCH 5.12 087/296] serial: 8250_pci: Add support for new HPE serial device
Date:   Mon, 31 May 2021 15:12:22 +0200
Message-Id: <20210531130706.813206100@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Wright <rwright@hpe.com>

commit e0e24208792080135248f23fdf6d51aa2e04df05 upstream.

Add support for new HPE serial device.  It is MSI enabled,
but otherwise similar to legacy HP server serial devices.

Tested-by: Jerry Hoemann <jerry.hoemann@hpe.com>
Signed-off-by: Randy Wright <rwright@hpe.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1621009614-28836-1-git-send-email-rwright@hpe.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

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
@@ -63,6 +65,8 @@ static const struct pci_device_id pci_us
 			 0xA000, 0x1000) },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9922,
 			 0xA000, 0x1000) },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_HP_3PAR, PCI_DEVICE_ID_HPE_PCI_SERIAL,
+			 PCI_ANY_ID, PCI_ANY_ID) },
 	{ }
 };
 
@@ -1998,6 +2002,16 @@ static struct pci_serial_quirk pci_seria
 		.setup		= pci_hp_diva_setup,
 	},
 	/*
+	 * HPE PCI serial device
+	 */
+	{
+		.vendor         = PCI_VENDOR_ID_HP_3PAR,
+		.device         = PCI_DEVICE_ID_HPE_PCI_SERIAL,
+		.subvendor      = PCI_ANY_ID,
+		.subdevice      = PCI_ANY_ID,
+		.setup		= pci_hp_diva_setup,
+	},
+	/*
 	 * Intel
 	 */
 	{
@@ -4973,6 +4987,10 @@ static const struct pci_device_id serial
 	{	PCI_VENDOR_ID_HP, PCI_DEVICE_ID_HP_DIVA_AUX,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b2_1_115200 },
+	/* HPE PCI serial device */
+	{	PCI_VENDOR_ID_HP_3PAR, PCI_DEVICE_ID_HPE_PCI_SERIAL,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b1_1_115200 },
 
 	{	PCI_VENDOR_ID_DCI, PCI_DEVICE_ID_DCI_PCCOM2,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,


