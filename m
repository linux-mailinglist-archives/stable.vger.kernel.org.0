Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4468E593C70
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239206AbiHOTwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345696AbiHOTvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:51:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCE613E8E;
        Mon, 15 Aug 2022 11:50:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D65C61222;
        Mon, 15 Aug 2022 18:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723FBC433C1;
        Mon, 15 Aug 2022 18:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589430;
        bh=c0bClNS72sNAo2pxTQ9SWVynqPIMMbNhfPr2VEzrvv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mSiOT0GJKaUS9rwianyWuNUa5EDDgGQzdKM60uTwWXd+1JvblyGmqKxqAch1KZrCV
         rA/xY8OUkDgAGFSEWHckkMaCZJPgnl3gNnbLp8ahDXJ4VZFWCzy9hvm7HZICRI6P5F
         VwveTMA5d+vvwM9ASJ30hHUV+/DAvbkQZOQYtXRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 715/779] serial: 8250: Fold EndRun device support into OxSemi Tornado code
Date:   Mon, 15 Aug 2022 20:05:59 +0200
Message-Id: <20220815180408.028001214@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

[ Upstream commit 1f32c65bad24b9787d3e52843de375430e3df822 ]

The EndRun PTP/1588 dual serial port device is based on the Oxford
Semiconductor OXPCIe952 UART device with the PCI vendor:device ID set
for EndRun Technologies and uses the same sequence to determine the
number of ports available.  Despite that we have duplicate code
specific to the EndRun device.

Remove redundant code then and factor out OxSemi Tornado device
detection.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2204181516220.9383@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_pci.c | 76 ++++++++++--------------------
 1 file changed, 25 insertions(+), 51 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 1994d2db213c..20ce812a069c 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -994,41 +994,29 @@ static void pci_ite887x_exit(struct pci_dev *dev)
 }
 
 /*
- * EndRun Technologies.
- * Determine the number of ports available on the device.
+ * Oxford Semiconductor Inc.
+ * Check if an OxSemi device is part of the Tornado range of devices.
  */
 #define PCI_VENDOR_ID_ENDRUN			0x7401
 #define PCI_DEVICE_ID_ENDRUN_1588	0xe100
 
-static int pci_endrun_init(struct pci_dev *dev)
+static bool pci_oxsemi_tornado_p(struct pci_dev *dev)
 {
-	u8 __iomem *p;
-	unsigned long deviceID;
-	unsigned int  number_uarts = 0;
+	/* OxSemi Tornado devices are all 0xCxxx */
+	if (dev->vendor == PCI_VENDOR_ID_OXSEMI &&
+	    (dev->device & 0xf000) != 0xc000)
+		return false;
 
-	/* EndRun device is all 0xexxx */
+	/* EndRun devices are all 0xExxx */
 	if (dev->vendor == PCI_VENDOR_ID_ENDRUN &&
-		(dev->device & 0xf000) != 0xe000)
-		return 0;
-
-	p = pci_iomap(dev, 0, 5);
-	if (p == NULL)
-		return -ENOMEM;
+	    (dev->device & 0xf000) != 0xe000)
+		return false;
 
-	deviceID = ioread32(p);
-	/* EndRun device */
-	if (deviceID == 0x07000200) {
-		number_uarts = ioread8(p + 4);
-		pci_dbg(dev, "%d ports detected on EndRun PCI Express device\n", number_uarts);
-	}
-	pci_iounmap(dev, p);
-	return number_uarts;
+	return true;
 }
 
 /*
- * Oxford Semiconductor Inc.
- * Check that device is part of the Tornado range of devices, then determine
- * the number of ports available on the device.
+ * Determine the number of ports available on a Tornado device.
  */
 static int pci_oxsemi_tornado_init(struct pci_dev *dev)
 {
@@ -1036,9 +1024,7 @@ static int pci_oxsemi_tornado_init(struct pci_dev *dev)
 	unsigned long deviceID;
 	unsigned int  number_uarts = 0;
 
-	/* OxSemi Tornado devices are all 0xCxxx */
-	if (dev->vendor == PCI_VENDOR_ID_OXSEMI &&
-	    (dev->device & 0xF000) != 0xC000)
+	if (!pci_oxsemi_tornado_p(dev))
 		return 0;
 
 	p = pci_iomap(dev, 0, 5);
@@ -1049,7 +1035,10 @@ static int pci_oxsemi_tornado_init(struct pci_dev *dev)
 	/* Tornado device */
 	if (deviceID == 0x07000200) {
 		number_uarts = ioread8(p + 4);
-		pci_dbg(dev, "%d ports detected on Oxford PCI Express device\n", number_uarts);
+		pci_dbg(dev, "%d ports detected on %s PCI Express device\n",
+			number_uarts,
+			dev->vendor == PCI_VENDOR_ID_ENDRUN ?
+			"EndRun" : "Oxford");
 	}
 	pci_iounmap(dev, p);
 	return number_uarts;
@@ -2506,7 +2495,7 @@ static struct pci_serial_quirk pci_serial_quirks[] = {
 		.device		= PCI_ANY_ID,
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= PCI_ANY_ID,
-		.init		= pci_endrun_init,
+		.init		= pci_oxsemi_tornado_init,
 		.setup		= pci_default_setup,
 	},
 	/*
@@ -2929,7 +2918,6 @@ enum pci_board_num_t {
 	pbn_panacom2,
 	pbn_panacom4,
 	pbn_plx_romulus,
-	pbn_endrun_2_3906250,
 	pbn_oxsemi,
 	pbn_oxsemi_1_3906250,
 	pbn_oxsemi_2_3906250,
@@ -3455,20 +3443,6 @@ static struct pciserial_board pci_boards[] = {
 		.first_offset	= 0x03,
 	},
 
-	/*
-	 * EndRun Technologies
-	* Uses the size of PCI Base region 0 to
-	* signal now many ports are available
-	* 2 port 952 Uart support
-	*/
-	[pbn_endrun_2_3906250] = {
-		.flags		= FL_BASE0,
-		.num_ports	= 2,
-		.base_baud	= 3906250,
-		.uart_offset	= 0x200,
-		.first_offset	= 0x1000,
-	},
-
 	/*
 	 * This board uses the size of PCI Base region 0 to
 	 * signal now many ports are available
@@ -4400,13 +4374,6 @@ static const struct pci_device_id serial_pci_tbl[] = {
 	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_ROMULUS,
 		0x10b5, 0x106a, 0, 0,
 		pbn_plx_romulus },
-	/*
-	* EndRun Technologies. PCI express device range.
-	*    EndRun PTP/1588 has 2 Native UARTs.
-	*/
-	{	PCI_VENDOR_ID_ENDRUN, PCI_DEVICE_ID_ENDRUN_1588,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_endrun_2_3906250 },
 	/*
 	 * Quatech cards. These actually have configurable clocks but for
 	 * now we just use the default.
@@ -4668,6 +4635,13 @@ static const struct pci_device_id serial_pci_tbl[] = {
 	{	PCI_VENDOR_ID_DIGI, PCIE_DEVICE_ID_NEO_2_OX_IBM,
 		PCI_SUBVENDOR_ID_IBM, PCI_ANY_ID, 0, 0,
 		pbn_oxsemi_2_3906250 },
+	/*
+	 * EndRun Technologies. PCI express device range.
+	 * EndRun PTP/1588 has 2 Native UARTs utilizing OxSemi 952.
+	 */
+	{	PCI_VENDOR_ID_ENDRUN, PCI_DEVICE_ID_ENDRUN_1588,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_oxsemi_2_3906250 },
 
 	/*
 	 * SBS Technologies, Inc. P-Octal and PMC-OCTPRO cards,
-- 
2.35.1



