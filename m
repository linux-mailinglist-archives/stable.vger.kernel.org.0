Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4CBC147F7D
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388114AbgAXLCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:02:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:36256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731019AbgAXLCl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:02:41 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7BAB2071A;
        Fri, 24 Jan 2020 11:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863761;
        bh=/5ZOUuQX2Qh4Mdr6BMYVLDp97RXB+XtgKCkNx9o5lIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=etELZomIBm2eni1WKPpQUmVPzriq6U7rYbrj9VS47nWnvxkOrOkN6W1wtEj38vfIT
         j9Uygzo0F/8czBksarsVodW1GbAt+wMXYWPX4bf53ZhXqKISb7g1F+GBuXNhEKlfPZ
         5CrJ5zy7ma8IbTPqZ2IokEa30z+98Vdua52NoOUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 068/639] bus: ti-sysc: Add mcasp optional clocks flag
Date:   Fri, 24 Jan 2020 10:23:58 +0100
Message-Id: <20200124093055.933755318@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 2c63a833e4500b341a62bf97e67488909ae12086 ]

We have OPT_CLKS_NEEDED in legacy platform data, but it's missing
from the ti-sysc driver for device tree based configuration.

In order to pass OPT_CLKS_NEEDED quirk flag we need to update omap4 module
data and add a new compatible for dra7 as the module layout is different
from sysc_regbits_omap4_mcasp.

Fixes: 70a65240efb1 ("bus: ti-sysc: Add register bits for interconnect
target modules")
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/bus/ti-sysc.txt |  1 +
 drivers/bus/ti-sysc.c                             | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/Documentation/devicetree/bindings/bus/ti-sysc.txt b/Documentation/devicetree/bindings/bus/ti-sysc.txt
index 91dc2333af012..85a23f551f024 100644
--- a/Documentation/devicetree/bindings/bus/ti-sysc.txt
+++ b/Documentation/devicetree/bindings/bus/ti-sysc.txt
@@ -35,6 +35,7 @@ Required standard properties:
 		"ti,sysc-omap3-sham"
 		"ti,sysc-omap-aes"
 		"ti,sysc-mcasp"
+		"ti,sysc-dra7-mcasp"
 		"ti,sysc-usb-host-fs"
 		"ti,sysc-dra7-mcan"
 
diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index b6f63e7620214..926c83398b27b 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1593,6 +1593,16 @@ static const struct sysc_regbits sysc_regbits_omap4_mcasp = {
 static const struct sysc_capabilities sysc_omap4_mcasp = {
 	.type = TI_SYSC_OMAP4_MCASP,
 	.regbits = &sysc_regbits_omap4_mcasp,
+	.mod_quirks = SYSC_QUIRK_OPT_CLKS_NEEDED,
+};
+
+/*
+ * McASP found on dra7 and later
+ */
+static const struct sysc_capabilities sysc_dra7_mcasp = {
+	.type = TI_SYSC_OMAP4_SIMPLE,
+	.regbits = &sysc_regbits_omap4_simple,
+	.mod_quirks = SYSC_QUIRK_OPT_CLKS_NEEDED,
 };
 
 /*
@@ -1821,6 +1831,7 @@ static const struct of_device_id sysc_match[] = {
 	{ .compatible = "ti,sysc-omap3-sham", .data = &sysc_omap3_sham, },
 	{ .compatible = "ti,sysc-omap-aes", .data = &sysc_omap3_aes, },
 	{ .compatible = "ti,sysc-mcasp", .data = &sysc_omap4_mcasp, },
+	{ .compatible = "ti,sysc-dra7-mcasp", .data = &sysc_dra7_mcasp, },
 	{ .compatible = "ti,sysc-usb-host-fs",
 	  .data = &sysc_omap4_usb_host_fs, },
 	{ .compatible = "ti,sysc-dra7-mcan", .data = &sysc_dra7_mcan, },
-- 
2.20.1



