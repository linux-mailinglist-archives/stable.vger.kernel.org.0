Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F4E2E40B0
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732057AbgL1Oz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:55:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:52552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408059AbgL1Oz0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:55:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D86B221F0;
        Mon, 28 Dec 2020 14:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609167286;
        bh=QheuNuf0BZK7pEIl5pG3BY9ULh4+TnZYqSLNlqqBS1c=;
        h=Subject:To:From:Date:From;
        b=R+7E8MnF61S+0xN8ze7jSlOjSnUqKD0OZUYRC+WoFl6iQzMtY/8VpyMCaRS3x7d3J
         FR65tf88d8to8S3v4QrV9toJNDsUCHSskR1kyfBLbzP3N1OZxf0RCnEG9f/X/w2KiA
         SueukgMc9Wd6+ysqHenyAprENQmZV2a7/MEzMPMk=
Subject: patch "usb: dwc3: ulpi: Fix USB2.0 HS/FS/LS PHY suspend regression" added to usb-linus
To:     Sergey.Semin@baikalelectronics.ru, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 15:55:59 +0100
Message-ID: <160916735914768@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: ulpi: Fix USB2.0 HS/FS/LS PHY suspend regression

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e5f4ca3fce90a37b23a77bfcc86800d484a80514 Mon Sep 17 00:00:00 2001
From: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Date: Thu, 10 Dec 2020 11:50:08 +0300
Subject: usb: dwc3: ulpi: Fix USB2.0 HS/FS/LS PHY suspend regression

First of all the commit e0082698b689 ("usb: dwc3: ulpi: conditionally
resume ULPI PHY") introduced the Suspend USB2.0 HS/FS/LS PHY regression,
as by design of the fix any attempt to read/write from/to the PHY control
registers will completely disable the PHY suspension, which consequently
will increase the USB bus power consumption. Secondly the fix won't work
well for the very first attempt of the ULPI PHY control registers IO,
because after disabling the USB2.0 PHY suspension functionality it will
still take some time for the bus to resume from the sleep state if one has
been reached before it. So the very first PHY register read/write
operation will take more time than the busy-loop provides and the IO
timeout error might be returned anyway.

Here we suggest to fix the denoted problems in the following way. First of
all let's not disable the Suspend USB2.0 HS/FS/LS PHY functionality so to
make the controller and the USB2.0 bus more power efficient. Secondly
instead of that we'll extend the PHY IO op wait procedure with 1 - 1.2 ms
sleep if the PHY suspension is enabled (1ms should be enough as by LPM
specification it is at most how long it takes for the USB2.0 bus to resume
from L1 (Sleep) state). Finally in case if the USB2.0 PHY suspension
functionality has been disabled on the DWC USB3 controller setup procedure
we'll compensate the USB bus resume process latency by extending the
busy-loop attempts counter.

Fixes: e0082698b689 ("usb: dwc3: ulpi: conditionally resume ULPI PHY")
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Link: https://lore.kernel.org/r/20201210085008.13264-4-Sergey.Semin@baikalelectronics.ru
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/ulpi.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/dwc3/ulpi.c b/drivers/usb/dwc3/ulpi.c
index 54c877f7b51d..f23f4c9a557e 100644
--- a/drivers/usb/dwc3/ulpi.c
+++ b/drivers/usb/dwc3/ulpi.c
@@ -24,7 +24,7 @@
 static int dwc3_ulpi_busyloop(struct dwc3 *dwc, u8 addr, bool read)
 {
 	unsigned long ns = 5L * DWC3_ULPI_BASE_DELAY;
-	unsigned int count = 1000;
+	unsigned int count = 10000;
 	u32 reg;
 
 	if (addr >= ULPI_EXT_VENDOR_SPECIFIC)
@@ -33,6 +33,10 @@ static int dwc3_ulpi_busyloop(struct dwc3 *dwc, u8 addr, bool read)
 	if (read)
 		ns += DWC3_ULPI_BASE_DELAY;
 
+	reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
+	if (reg & DWC3_GUSB2PHYCFG_SUSPHY)
+		usleep_range(1000, 1200);
+
 	while (count--) {
 		ndelay(ns);
 		reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYACC(0));
@@ -50,12 +54,6 @@ static int dwc3_ulpi_read(struct device *dev, u8 addr)
 	u32 reg;
 	int ret;
 
-	reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
-	if (reg & DWC3_GUSB2PHYCFG_SUSPHY) {
-		reg &= ~DWC3_GUSB2PHYCFG_SUSPHY;
-		dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
-	}
-
 	reg = DWC3_GUSB2PHYACC_NEWREGREQ | DWC3_ULPI_ADDR(addr);
 	dwc3_writel(dwc->regs, DWC3_GUSB2PHYACC(0), reg);
 
@@ -73,12 +71,6 @@ static int dwc3_ulpi_write(struct device *dev, u8 addr, u8 val)
 	struct dwc3 *dwc = dev_get_drvdata(dev);
 	u32 reg;
 
-	reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
-	if (reg & DWC3_GUSB2PHYCFG_SUSPHY) {
-		reg &= ~DWC3_GUSB2PHYCFG_SUSPHY;
-		dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
-	}
-
 	reg = DWC3_GUSB2PHYACC_NEWREGREQ | DWC3_ULPI_ADDR(addr);
 	reg |= DWC3_GUSB2PHYACC_WRITE | val;
 	dwc3_writel(dwc->regs, DWC3_GUSB2PHYACC(0), reg);
-- 
2.29.2


