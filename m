Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCA82265F0
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732088AbgGTP6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:58:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731822AbgGTP6u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:58:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4131C22CBE;
        Mon, 20 Jul 2020 15:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260729;
        bh=fs2m2U3cttH/YIGjFgCMYiaw81ed++gEfUeuBthHVOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RIwjQoAfHu8V0AihtJgDjlnS6j7OtrDsWhs/lZ4R5xgNA3z7aIoljcFiTEe53bsHL
         8TNk655EcoAuY8SOcRnigujKzM3e9CS2BbVmdiyyhQhqzpRfmURFVemMclDFJqihhC
         TpzvlLuV0bBV0nLDaHP7TwuWDxk3g2Dte7Vk2RRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 075/215] bus: ti-sysc: Consider non-existing registers too when matching quirks
Date:   Mon, 20 Jul 2020 17:35:57 +0200
Message-Id: <20200720152823.783608993@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 590e15c76f1231329d1543570a54058dba2e4ff6 ]

We are currently setting -1 for non-existing sysconfig related registers
for quirks, but setting -ENODEV elsewhere. And for matching the quirks,
we're now just ignoring the non-existing registers. This will cause issues
with misdetecting DSS registers as the hardware revision numbers can have
duplicates.

To avoid this, let's standardize on using -ENODEV also for the quirks
instead of -1. That way we can always just test for a match without adding
any more complicated logic.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 120 ++++++++++++++++++++----------------------
 1 file changed, 57 insertions(+), 63 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index c7f408d758396..588dde5a252b6 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1231,16 +1231,16 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 		   SYSC_QUIRK_LEGACY_IDLE),
 	SYSC_QUIRK("sham", 0, 0x100, 0x110, 0x114, 0x40000c03, 0xffffffff,
 		   SYSC_QUIRK_LEGACY_IDLE),
-	SYSC_QUIRK("smartreflex", 0, -1, 0x24, -1, 0x00000000, 0xffffffff,
+	SYSC_QUIRK("smartreflex", 0, -ENODEV, 0x24, -ENODEV, 0x00000000, 0xffffffff,
 		   SYSC_QUIRK_LEGACY_IDLE),
-	SYSC_QUIRK("smartreflex", 0, -1, 0x38, -1, 0x00000000, 0xffffffff,
+	SYSC_QUIRK("smartreflex", 0, -ENODEV, 0x38, -ENODEV, 0x00000000, 0xffffffff,
 		   SYSC_QUIRK_LEGACY_IDLE),
 	SYSC_QUIRK("timer", 0, 0, 0x10, 0x14, 0x00000015, 0xffffffff,
 		   0),
 	/* Some timers on omap4 and later */
-	SYSC_QUIRK("timer", 0, 0, 0x10, -1, 0x50002100, 0xffffffff,
+	SYSC_QUIRK("timer", 0, 0, 0x10, -ENODEV, 0x50002100, 0xffffffff,
 		   0),
-	SYSC_QUIRK("timer", 0, 0, 0x10, -1, 0x4fff1301, 0xffff00ff,
+	SYSC_QUIRK("timer", 0, 0, 0x10, -ENODEV, 0x4fff1301, 0xffff00ff,
 		   0),
 	SYSC_QUIRK("uart", 0, 0x50, 0x54, 0x58, 0x00000046, 0xffffffff,
 		   SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_LEGACY_IDLE),
@@ -1253,18 +1253,18 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 		   SYSC_QUIRK_SWSUP_SIDLE_ACT | SYSC_QUIRK_LEGACY_IDLE),
 
 	/* Quirks that need to be set based on the module address */
-	SYSC_QUIRK("mcpdm", 0x40132000, 0, 0x10, -1, 0x50000800, 0xffffffff,
+	SYSC_QUIRK("mcpdm", 0x40132000, 0, 0x10, -ENODEV, 0x50000800, 0xffffffff,
 		   SYSC_QUIRK_EXT_OPT_CLOCK | SYSC_QUIRK_NO_RESET_ON_INIT |
 		   SYSC_QUIRK_SWSUP_SIDLE),
 
 	/* Quirks that need to be set based on detected module */
-	SYSC_QUIRK("aess", 0, 0, 0x10, -1, 0x40000000, 0xffffffff,
+	SYSC_QUIRK("aess", 0, 0, 0x10, -ENODEV, 0x40000000, 0xffffffff,
 		   SYSC_MODULE_QUIRK_AESS),
-	SYSC_QUIRK("dcan", 0x48480000, 0x20, -1, -1, 0xa3170504, 0xffffffff,
+	SYSC_QUIRK("dcan", 0x48480000, 0x20, -ENODEV, -ENODEV, 0xa3170504, 0xffffffff,
 		   SYSC_QUIRK_CLKDM_NOAUTO),
-	SYSC_QUIRK("dwc3", 0x48880000, 0, 0x10, -1, 0x500a0200, 0xffffffff,
+	SYSC_QUIRK("dwc3", 0x48880000, 0, 0x10, -ENODEV, 0x500a0200, 0xffffffff,
 		   SYSC_QUIRK_CLKDM_NOAUTO),
-	SYSC_QUIRK("dwc3", 0x488c0000, 0, 0x10, -1, 0x500a0200, 0xffffffff,
+	SYSC_QUIRK("dwc3", 0x488c0000, 0, 0x10, -ENODEV, 0x500a0200, 0xffffffff,
 		   SYSC_QUIRK_CLKDM_NOAUTO),
 	SYSC_QUIRK("hdq1w", 0, 0, 0x14, 0x18, 0x00000006, 0xffffffff,
 		   SYSC_MODULE_QUIRK_HDQ1W),
@@ -1278,12 +1278,12 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 		   SYSC_MODULE_QUIRK_I2C),
 	SYSC_QUIRK("i2c", 0, 0, 0x10, 0x90, 0x5040000a, 0xfffff0f0,
 		   SYSC_MODULE_QUIRK_I2C),
-	SYSC_QUIRK("gpu", 0x50000000, 0x14, -1, -1, 0x00010201, 0xffffffff, 0),
-	SYSC_QUIRK("gpu", 0x50000000, 0xfe00, 0xfe10, -1, 0x40000000 , 0xffffffff,
+	SYSC_QUIRK("gpu", 0x50000000, 0x14, -ENODEV, -ENODEV, 0x00010201, 0xffffffff, 0),
+	SYSC_QUIRK("gpu", 0x50000000, 0xfe00, 0xfe10, -ENODEV, 0x40000000 , 0xffffffff,
 		   SYSC_MODULE_QUIRK_SGX),
 	SYSC_QUIRK("usb_otg_hs", 0, 0x400, 0x404, 0x408, 0x00000050,
 		   0xffffffff, SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_SWSUP_MSTANDBY),
-	SYSC_QUIRK("usb_otg_hs", 0, 0, 0x10, -1, 0x4ea2080d, 0xffffffff,
+	SYSC_QUIRK("usb_otg_hs", 0, 0, 0x10, -ENODEV, 0x4ea2080d, 0xffffffff,
 		   SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_SWSUP_MSTANDBY),
 	SYSC_QUIRK("wdt", 0, 0, 0x10, 0x14, 0x502a0500, 0xfffff0f0,
 		   SYSC_MODULE_QUIRK_WDT),
@@ -1292,57 +1292,57 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 		   SYSC_MODULE_QUIRK_WDT | SYSC_QUIRK_SWSUP_SIDLE),
 
 #ifdef DEBUG
-	SYSC_QUIRK("adc", 0, 0, 0x10, -1, 0x47300001, 0xffffffff, 0),
-	SYSC_QUIRK("atl", 0, 0, -1, -1, 0x0a070100, 0xffffffff, 0),
-	SYSC_QUIRK("cm", 0, 0, -1, -1, 0x40000301, 0xffffffff, 0),
-	SYSC_QUIRK("control", 0, 0, 0x10, -1, 0x40000900, 0xffffffff, 0),
+	SYSC_QUIRK("adc", 0, 0, 0x10, -ENODEV, 0x47300001, 0xffffffff, 0),
+	SYSC_QUIRK("atl", 0, 0, -ENODEV, -ENODEV, 0x0a070100, 0xffffffff, 0),
+	SYSC_QUIRK("cm", 0, 0, -ENODEV, -ENODEV, 0x40000301, 0xffffffff, 0),
+	SYSC_QUIRK("control", 0, 0, 0x10, -ENODEV, 0x40000900, 0xffffffff, 0),
 	SYSC_QUIRK("cpgmac", 0, 0x1200, 0x1208, 0x1204, 0x4edb1902,
 		   0xffff00f0, 0),
-	SYSC_QUIRK("dcan", 0, 0x20, -1, -1, 0xa3170504, 0xffffffff, 0),
-	SYSC_QUIRK("dcan", 0, 0x20, -1, -1, 0x4edb1902, 0xffffffff, 0),
-	SYSC_QUIRK("dmic", 0, 0, 0x10, -1, 0x50010000, 0xffffffff, 0),
-	SYSC_QUIRK("dwc3", 0, 0, 0x10, -1, 0x500a0200, 0xffffffff, 0),
+	SYSC_QUIRK("dcan", 0, 0x20, -ENODEV, -ENODEV, 0xa3170504, 0xffffffff, 0),
+	SYSC_QUIRK("dcan", 0, 0x20, -ENODEV, -ENODEV, 0x4edb1902, 0xffffffff, 0),
+	SYSC_QUIRK("dmic", 0, 0, 0x10, -ENODEV, 0x50010000, 0xffffffff, 0),
+	SYSC_QUIRK("dwc3", 0, 0, 0x10, -ENODEV, 0x500a0200, 0xffffffff, 0),
 	SYSC_QUIRK("d2d", 0x4a0b6000, 0, 0x10, 0x14, 0x00000010, 0xffffffff, 0),
 	SYSC_QUIRK("d2d", 0x4a0cd000, 0, 0x10, 0x14, 0x00000010, 0xffffffff, 0),
-	SYSC_QUIRK("epwmss", 0, 0, 0x4, -1, 0x47400001, 0xffffffff, 0),
-	SYSC_QUIRK("gpu", 0, 0x1fc00, 0x1fc10, -1, 0, 0, 0),
-	SYSC_QUIRK("gpu", 0, 0xfe00, 0xfe10, -1, 0x40000000 , 0xffffffff, 0),
+	SYSC_QUIRK("epwmss", 0, 0, 0x4, -ENODEV, 0x47400001, 0xffffffff, 0),
+	SYSC_QUIRK("gpu", 0, 0x1fc00, 0x1fc10, -ENODEV, 0, 0, 0),
+	SYSC_QUIRK("gpu", 0, 0xfe00, 0xfe10, -ENODEV, 0x40000000 , 0xffffffff, 0),
 	SYSC_QUIRK("hsi", 0, 0, 0x10, 0x14, 0x50043101, 0xffffffff, 0),
-	SYSC_QUIRK("iss", 0, 0, 0x10, -1, 0x40000101, 0xffffffff, 0),
-	SYSC_QUIRK("lcdc", 0, 0, 0x54, -1, 0x4f201000, 0xffffffff, 0),
-	SYSC_QUIRK("mcasp", 0, 0, 0x4, -1, 0x44306302, 0xffffffff, 0),
-	SYSC_QUIRK("mcasp", 0, 0, 0x4, -1, 0x44307b02, 0xffffffff, 0),
-	SYSC_QUIRK("mcbsp", 0, -1, 0x8c, -1, 0, 0, 0),
-	SYSC_QUIRK("mcspi", 0, 0, 0x10, -1, 0x40300a0b, 0xffff00ff, 0),
+	SYSC_QUIRK("iss", 0, 0, 0x10, -ENODEV, 0x40000101, 0xffffffff, 0),
+	SYSC_QUIRK("lcdc", 0, 0, 0x54, -ENODEV, 0x4f201000, 0xffffffff, 0),
+	SYSC_QUIRK("mcasp", 0, 0, 0x4, -ENODEV, 0x44306302, 0xffffffff, 0),
+	SYSC_QUIRK("mcasp", 0, 0, 0x4, -ENODEV, 0x44307b02, 0xffffffff, 0),
+	SYSC_QUIRK("mcbsp", 0, -ENODEV, 0x8c, -ENODEV, 0, 0, 0),
+	SYSC_QUIRK("mcspi", 0, 0, 0x10, -ENODEV, 0x40300a0b, 0xffff00ff, 0),
 	SYSC_QUIRK("mcspi", 0, 0, 0x110, 0x114, 0x40300a0b, 0xffffffff, 0),
-	SYSC_QUIRK("mailbox", 0, 0, 0x10, -1, 0x00000400, 0xffffffff, 0),
-	SYSC_QUIRK("m3", 0, 0, -1, -1, 0x5f580105, 0x0fff0f00, 0),
+	SYSC_QUIRK("mailbox", 0, 0, 0x10, -ENODEV, 0x00000400, 0xffffffff, 0),
+	SYSC_QUIRK("m3", 0, 0, -ENODEV, -ENODEV, 0x5f580105, 0x0fff0f00, 0),
 	SYSC_QUIRK("ocp2scp", 0, 0, 0x10, 0x14, 0x50060005, 0xfffffff0, 0),
-	SYSC_QUIRK("ocp2scp", 0, 0, -1, -1, 0x50060007, 0xffffffff, 0),
-	SYSC_QUIRK("padconf", 0, 0, 0x10, -1, 0x4fff0800, 0xffffffff, 0),
-	SYSC_QUIRK("padconf", 0, 0, -1, -1, 0x40001100, 0xffffffff, 0),
-	SYSC_QUIRK("prcm", 0, 0, -1, -1, 0x40000100, 0xffffffff, 0),
-	SYSC_QUIRK("prcm", 0, 0, -1, -1, 0x00004102, 0xffffffff, 0),
-	SYSC_QUIRK("prcm", 0, 0, -1, -1, 0x40000400, 0xffffffff, 0),
-	SYSC_QUIRK("scm", 0, 0, 0x10, -1, 0x40000900, 0xffffffff, 0),
-	SYSC_QUIRK("scm", 0, 0, -1, -1, 0x4e8b0100, 0xffffffff, 0),
-	SYSC_QUIRK("scm", 0, 0, -1, -1, 0x4f000100, 0xffffffff, 0),
-	SYSC_QUIRK("scm", 0, 0, -1, -1, 0x40000900, 0xffffffff, 0),
-	SYSC_QUIRK("scrm", 0, 0, -1, -1, 0x00000010, 0xffffffff, 0),
-	SYSC_QUIRK("sdio", 0, 0, 0x10, -1, 0x40202301, 0xffff0ff0, 0),
+	SYSC_QUIRK("ocp2scp", 0, 0, -ENODEV, -ENODEV, 0x50060007, 0xffffffff, 0),
+	SYSC_QUIRK("padconf", 0, 0, 0x10, -ENODEV, 0x4fff0800, 0xffffffff, 0),
+	SYSC_QUIRK("padconf", 0, 0, -ENODEV, -ENODEV, 0x40001100, 0xffffffff, 0),
+	SYSC_QUIRK("prcm", 0, 0, -ENODEV, -ENODEV, 0x40000100, 0xffffffff, 0),
+	SYSC_QUIRK("prcm", 0, 0, -ENODEV, -ENODEV, 0x00004102, 0xffffffff, 0),
+	SYSC_QUIRK("prcm", 0, 0, -ENODEV, -ENODEV, 0x40000400, 0xffffffff, 0),
+	SYSC_QUIRK("scm", 0, 0, 0x10, -ENODEV, 0x40000900, 0xffffffff, 0),
+	SYSC_QUIRK("scm", 0, 0, -ENODEV, -ENODEV, 0x4e8b0100, 0xffffffff, 0),
+	SYSC_QUIRK("scm", 0, 0, -ENODEV, -ENODEV, 0x4f000100, 0xffffffff, 0),
+	SYSC_QUIRK("scm", 0, 0, -ENODEV, -ENODEV, 0x40000900, 0xffffffff, 0),
+	SYSC_QUIRK("scrm", 0, 0, -ENODEV, -ENODEV, 0x00000010, 0xffffffff, 0),
+	SYSC_QUIRK("sdio", 0, 0, 0x10, -ENODEV, 0x40202301, 0xffff0ff0, 0),
 	SYSC_QUIRK("sdio", 0, 0x2fc, 0x110, 0x114, 0x31010000, 0xffffffff, 0),
 	SYSC_QUIRK("sdma", 0, 0, 0x2c, 0x28, 0x00010900, 0xffffffff, 0),
-	SYSC_QUIRK("slimbus", 0, 0, 0x10, -1, 0x40000902, 0xffffffff, 0),
-	SYSC_QUIRK("slimbus", 0, 0, 0x10, -1, 0x40002903, 0xffffffff, 0),
-	SYSC_QUIRK("spinlock", 0, 0, 0x10, -1, 0x50020000, 0xffffffff, 0),
-	SYSC_QUIRK("rng", 0, 0x1fe0, 0x1fe4, -1, 0x00000020, 0xffffffff, 0),
-	SYSC_QUIRK("rtc", 0, 0x74, 0x78, -1, 0x4eb01908, 0xffff00f0, 0),
-	SYSC_QUIRK("timer32k", 0, 0, 0x4, -1, 0x00000060, 0xffffffff, 0),
+	SYSC_QUIRK("slimbus", 0, 0, 0x10, -ENODEV, 0x40000902, 0xffffffff, 0),
+	SYSC_QUIRK("slimbus", 0, 0, 0x10, -ENODEV, 0x40002903, 0xffffffff, 0),
+	SYSC_QUIRK("spinlock", 0, 0, 0x10, -ENODEV, 0x50020000, 0xffffffff, 0),
+	SYSC_QUIRK("rng", 0, 0x1fe0, 0x1fe4, -ENODEV, 0x00000020, 0xffffffff, 0),
+	SYSC_QUIRK("rtc", 0, 0x74, 0x78, -ENODEV, 0x4eb01908, 0xffff00f0, 0),
+	SYSC_QUIRK("timer32k", 0, 0, 0x4, -ENODEV, 0x00000060, 0xffffffff, 0),
 	SYSC_QUIRK("usbhstll", 0, 0, 0x10, 0x14, 0x00000004, 0xffffffff, 0),
 	SYSC_QUIRK("usbhstll", 0, 0, 0x10, 0x14, 0x00000008, 0xffffffff, 0),
 	SYSC_QUIRK("usb_host_hs", 0, 0, 0x10, 0x14, 0x50700100, 0xffffffff, 0),
-	SYSC_QUIRK("usb_host_hs", 0, 0, 0x10, -1, 0x50700101, 0xffffffff, 0),
-	SYSC_QUIRK("vfpe", 0, 0, 0x104, -1, 0x4d001200, 0xffffffff, 0),
+	SYSC_QUIRK("usb_host_hs", 0, 0, 0x10, -ENODEV, 0x50700101, 0xffffffff, 0),
+	SYSC_QUIRK("vfpe", 0, 0, 0x104, -ENODEV, 0x4d001200, 0xffffffff, 0),
 #endif
 };
 
@@ -1364,16 +1364,13 @@ static void sysc_init_early_quirks(struct sysc *ddata)
 		if (q->base != ddata->module_pa)
 			continue;
 
-		if (q->rev_offset >= 0 &&
-		    q->rev_offset != ddata->offsets[SYSC_REVISION])
+		if (q->rev_offset != ddata->offsets[SYSC_REVISION])
 			continue;
 
-		if (q->sysc_offset >= 0 &&
-		    q->sysc_offset != ddata->offsets[SYSC_SYSCONFIG])
+		if (q->sysc_offset != ddata->offsets[SYSC_SYSCONFIG])
 			continue;
 
-		if (q->syss_offset >= 0 &&
-		    q->syss_offset != ddata->offsets[SYSC_SYSSTATUS])
+		if (q->syss_offset != ddata->offsets[SYSC_SYSSTATUS])
 			continue;
 
 		ddata->name = q->name;
@@ -1393,16 +1390,13 @@ static void sysc_init_revision_quirks(struct sysc *ddata)
 		if (q->base && q->base != ddata->module_pa)
 			continue;
 
-		if (q->rev_offset >= 0 &&
-		    q->rev_offset != ddata->offsets[SYSC_REVISION])
+		if (q->rev_offset != ddata->offsets[SYSC_REVISION])
 			continue;
 
-		if (q->sysc_offset >= 0 &&
-		    q->sysc_offset != ddata->offsets[SYSC_SYSCONFIG])
+		if (q->sysc_offset != ddata->offsets[SYSC_SYSCONFIG])
 			continue;
 
-		if (q->syss_offset >= 0 &&
-		    q->syss_offset != ddata->offsets[SYSC_SYSSTATUS])
+		if (q->syss_offset != ddata->offsets[SYSC_SYSSTATUS])
 			continue;
 
 		if (q->revision == ddata->revision ||
-- 
2.25.1



