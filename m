Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33D0213F7F4
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733165AbgAPQ4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:56:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:42118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731212AbgAPQ4H (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:56:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 708E92467C;
        Thu, 16 Jan 2020 16:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193766;
        bh=hNy3boOg+1eisdfY1RLRrbaW7xZyuFkEyITg3X1ViSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yRHKbo4+2MVWl2OmhxQD8t1k8J07ZQb+6u1op+xPU0UIT/dJZFZJLGSWc4Uujhl/Y
         Vo07d0VySvh/gWt223ueBIkwUFL4IH99bJvcNlXb/wSYLnV9JAowI1h09CAVDfUkUa
         XymizwCLPbF1rv1LAO5ceTr1oZZvTZLf56V3LhVA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 051/671] bus: ti-sysc: Add mcasp optional clocks flag
Date:   Thu, 16 Jan 2020 11:44:42 -0500
Message-Id: <20200116165502.8838-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 91dc2333af01..85a23f551f02 100644
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
index b6f63e762021..926c83398b27 100644
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

