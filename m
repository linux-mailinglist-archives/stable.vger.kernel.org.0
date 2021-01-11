Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11472F14A0
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731503AbhAKN12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:27:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:33156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732426AbhAKNQe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:16:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECF7D225AC;
        Mon, 11 Jan 2021 13:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370978;
        bh=Ctj68VZACeIPAZijUdrZcGNznPfeL/T+LUrKGqmYa40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JScpsWkmNp9aXFJBUwcgoi18K0Hjs1x0GzB80aKNAhFe2zaRrx4mNPor2IRuMBBFX
         nmTgYjNNEwhVe+0i0eTxKGmsJJ4fg29beAJkEKGEB2hKxIG4OAt7fs2fDkDdSvZDH5
         xgE5EZO4eH2xDO/0yRwnkcOPpd+XRE5/Hz0NdNDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>
Subject: [PATCH 5.10 087/145] usb: dwc3: ulpi: Fix USB2.0 HS/FS/LS PHY suspend regression
Date:   Mon, 11 Jan 2021 14:01:51 +0100
Message-Id: <20210111130052.712944468@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

commit e5f4ca3fce90a37b23a77bfcc86800d484a80514 upstream.

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
 drivers/usb/dwc3/ulpi.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

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
@@ -33,6 +33,10 @@ static int dwc3_ulpi_busyloop(struct dwc
 	if (read)
 		ns += DWC3_ULPI_BASE_DELAY;
 
+	reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
+	if (reg & DWC3_GUSB2PHYCFG_SUSPHY)
+		usleep_range(1000, 1200);
+
 	while (count--) {
 		ndelay(ns);
 		reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYACC(0));
@@ -50,12 +54,6 @@ static int dwc3_ulpi_read(struct device
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
 
@@ -73,12 +71,6 @@ static int dwc3_ulpi_write(struct device
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


