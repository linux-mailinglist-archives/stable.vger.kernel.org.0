Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1412269DB
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729237AbgGTQaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:30:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731807AbgGTP6z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:58:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7806420773;
        Mon, 20 Jul 2020 15:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260735;
        bh=l8E1auhe0fCKA31R/J4peYMsBfDgSMNkDpm2J/GFaUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTCCuQi9a3pVnpPu0QEnqTxBX8GJzVAmFYYKQz5eZathVHfHSfD4hWPEthpl/Onju
         ohVfQJw2Ui3m65dRaWS1ZB0m3KfKpI7MX4kyeOkpEIebwhzV7l1sLpeJ8DOJCJUH9i
         YjFDyCv/8zd6B9Gt8vKyIXmxo0jDnQilx2RAP6ws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jyri Sarha <jsarha@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 077/215] bus: ti-sysc: Detect display subsystem related devices
Date:   Mon, 20 Jul 2020 17:35:59 +0200
Message-Id: <20200720152823.881281370@linuxfoundation.org>
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

[ Upstream commit 77dfece2e6d8bedb6ecd4d61379ae3dc52f389bd ]

In order to prepare probing display subsystem (DSS) with ti-sysc
interconnect target module driver and device tree data, let's
detect DSS related modules.

We need to also add reset quirk handling for DSS, but until that's
done, let's just enable the optional clock quirks for DSS and
omap4 HDMI. The rest is just naming of modules if CONFIG_DEBUG
is set.

Cc: Jyri Sarha <jsarha@ti.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 5c78b5afb85c7..1d31304fdd7c5 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1282,10 +1282,18 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 		   SYSC_MODULE_QUIRK_AESS),
 	SYSC_QUIRK("dcan", 0x48480000, 0x20, -ENODEV, -ENODEV, 0xa3170504, 0xffffffff,
 		   SYSC_QUIRK_CLKDM_NOAUTO),
+	SYSC_QUIRK("dss", 0x4832a000, 0, 0x10, 0x14, 0x00000020, 0xffffffff,
+		   SYSC_QUIRK_OPT_CLKS_IN_RESET),
+	SYSC_QUIRK("dss", 0x58000000, 0, -ENODEV, 0x14, 0x00000040, 0xffffffff,
+		   SYSC_QUIRK_OPT_CLKS_IN_RESET),
+	SYSC_QUIRK("dss", 0x58000000, 0, -ENODEV, 0x14, 0x00000061, 0xffffffff,
+		   SYSC_QUIRK_OPT_CLKS_IN_RESET),
 	SYSC_QUIRK("dwc3", 0x48880000, 0, 0x10, -ENODEV, 0x500a0200, 0xffffffff,
 		   SYSC_QUIRK_CLKDM_NOAUTO),
 	SYSC_QUIRK("dwc3", 0x488c0000, 0, 0x10, -ENODEV, 0x500a0200, 0xffffffff,
 		   SYSC_QUIRK_CLKDM_NOAUTO),
+	SYSC_QUIRK("hdmi", 0, 0, 0x10, -ENODEV, 0x50030200, 0xffffffff,
+		   SYSC_QUIRK_OPT_CLKS_NEEDED),
 	SYSC_QUIRK("hdq1w", 0, 0, 0x14, 0x18, 0x00000006, 0xffffffff,
 		   SYSC_MODULE_QUIRK_HDQ1W),
 	SYSC_QUIRK("hdq1w", 0, 0, 0x14, 0x18, 0x0000000a, 0xffffffff,
@@ -1322,13 +1330,21 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 		   0xffff00f0, 0),
 	SYSC_QUIRK("dcan", 0, 0x20, -ENODEV, -ENODEV, 0xa3170504, 0xffffffff, 0),
 	SYSC_QUIRK("dcan", 0, 0x20, -ENODEV, -ENODEV, 0x4edb1902, 0xffffffff, 0),
+	SYSC_QUIRK("dispc", 0x4832a400, 0, 0x10, 0x14, 0x00000030, 0xffffffff, 0),
+	SYSC_QUIRK("dispc", 0x58001000, 0, 0x10, 0x14, 0x00000040, 0xffffffff, 0),
+	SYSC_QUIRK("dispc", 0x58001000, 0, 0x10, 0x14, 0x00000051, 0xffffffff, 0),
 	SYSC_QUIRK("dmic", 0, 0, 0x10, -ENODEV, 0x50010000, 0xffffffff, 0),
+	SYSC_QUIRK("dsi", 0x58004000, 0, 0x10, 0x14, 0x00000030, 0xffffffff, 0),
+	SYSC_QUIRK("dsi", 0x58005000, 0, 0x10, 0x14, 0x00000030, 0xffffffff, 0),
+	SYSC_QUIRK("dsi", 0x58005000, 0, 0x10, 0x14, 0x00000040, 0xffffffff, 0),
+	SYSC_QUIRK("dsi", 0x58009000, 0, 0x10, 0x14, 0x00000040, 0xffffffff, 0),
 	SYSC_QUIRK("dwc3", 0, 0, 0x10, -ENODEV, 0x500a0200, 0xffffffff, 0),
 	SYSC_QUIRK("d2d", 0x4a0b6000, 0, 0x10, 0x14, 0x00000010, 0xffffffff, 0),
 	SYSC_QUIRK("d2d", 0x4a0cd000, 0, 0x10, 0x14, 0x00000010, 0xffffffff, 0),
 	SYSC_QUIRK("epwmss", 0, 0, 0x4, -ENODEV, 0x47400001, 0xffffffff, 0),
 	SYSC_QUIRK("gpu", 0, 0x1fc00, 0x1fc10, -ENODEV, 0, 0, 0),
 	SYSC_QUIRK("gpu", 0, 0xfe00, 0xfe10, -ENODEV, 0x40000000 , 0xffffffff, 0),
+	SYSC_QUIRK("hdmi", 0, 0, 0x10, -ENODEV, 0x50031d00, 0xffffffff, 0),
 	SYSC_QUIRK("hsi", 0, 0, 0x10, 0x14, 0x50043101, 0xffffffff, 0),
 	SYSC_QUIRK("iss", 0, 0, 0x10, -ENODEV, 0x40000101, 0xffffffff, 0),
 	SYSC_QUIRK("lcdc", 0, 0, 0x54, -ENODEV, 0x4f201000, 0xffffffff, 0),
@@ -1346,6 +1362,8 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 	SYSC_QUIRK("prcm", 0, 0, -ENODEV, -ENODEV, 0x40000100, 0xffffffff, 0),
 	SYSC_QUIRK("prcm", 0, 0, -ENODEV, -ENODEV, 0x00004102, 0xffffffff, 0),
 	SYSC_QUIRK("prcm", 0, 0, -ENODEV, -ENODEV, 0x40000400, 0xffffffff, 0),
+	SYSC_QUIRK("rfbi", 0x4832a800, 0, 0x10, 0x14, 0x00000010, 0xffffffff, 0),
+	SYSC_QUIRK("rfbi", 0x58002000, 0, 0x10, 0x14, 0x00000010, 0xffffffff, 0),
 	SYSC_QUIRK("scm", 0, 0, 0x10, -ENODEV, 0x40000900, 0xffffffff, 0),
 	SYSC_QUIRK("scm", 0, 0, -ENODEV, -ENODEV, 0x4e8b0100, 0xffffffff, 0),
 	SYSC_QUIRK("scm", 0, 0, -ENODEV, -ENODEV, 0x4f000100, 0xffffffff, 0),
@@ -1363,6 +1381,7 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 	SYSC_QUIRK("usbhstll", 0, 0, 0x10, 0x14, 0x00000008, 0xffffffff, 0),
 	SYSC_QUIRK("usb_host_hs", 0, 0, 0x10, 0x14, 0x50700100, 0xffffffff, 0),
 	SYSC_QUIRK("usb_host_hs", 0, 0, 0x10, -ENODEV, 0x50700101, 0xffffffff, 0),
+	SYSC_QUIRK("venc", 0x58003000, 0, -ENODEV, -ENODEV, 0x00000002, 0xffffffff, 0),
 	SYSC_QUIRK("vfpe", 0, 0, 0x104, -ENODEV, 0x4d001200, 0xffffffff, 0),
 #endif
 };
-- 
2.25.1



