Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 782B910663F
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbfKVFtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:49:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:53804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727133AbfKVFti (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:49:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58F9F2068F;
        Fri, 22 Nov 2019 05:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401778;
        bh=w9UMwwV0gSgS/3OjW9RiqA1HnA6vPMzNYVartDRRFf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R7JAGFbQ0hGCCIm5u0Z0mZcXMcLQETmt6m8JuY2PxHVc6394EIcGCopdYBJrdQk/N
         DX8YdMGRvn2G1+b5iPQ+c+5rMjckjSBcn+EuEIzIccuIJN0C64GsRUrQAbhGanFHAf
         P81VDuOb9SJyit4P8j2pku4i3eC3VWRK8rl0QzkU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 027/219] bus: ti-sysc: Check for no-reset and no-idle flags at the child level
Date:   Fri, 22 Nov 2019 00:45:59 -0500
Message-Id: <20191122054911.1750-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 4014c08ba39476a18af546186da625a6833a1529 ]

With ti-sysc, we need to now have the device tree properties for
ti,no-reset-on-init and ti,no-idle-on-init at the module level instead
of the child device level.

Let's check for these properties at the child device level to enable
quirks, and warn about moving the properties to the module level.

Otherwise am335x-evm based boards tagging gpio1 with ti,no-reset-on-init
will have their DDR power disabled if wired up in such a tricky way.

Note that this should not be an issue for earlier kernels as we don't
rely on this until the dts files have been updated to probe with ti-sysc
interconnect target driver.

Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Reported-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index e95b26319cd91..5b31131d0cba2 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -91,6 +91,9 @@ struct sysc {
 	struct delayed_work idle_work;
 };
 
+static void sysc_parse_dts_quirks(struct sysc *ddata, struct device_node *np,
+				  bool is_child);
+
 void sysc_write(struct sysc *ddata, int offset, u32 value)
 {
 	writel_relaxed(value, ddata->module_va + offset);
@@ -374,6 +377,7 @@ static int sysc_check_one_child(struct sysc *ddata,
 		dev_warn(ddata->dev, "really a child ti,hwmods property?");
 
 	sysc_check_quirk_stdout(ddata, np);
+	sysc_parse_dts_quirks(ddata, np, true);
 
 	return 0;
 }
@@ -1343,23 +1347,37 @@ static const struct sysc_dts_quirk sysc_dts_quirks[] = {
 	  .mask = SYSC_QUIRK_NO_RESET_ON_INIT, },
 };
 
-static int sysc_init_dts_quirks(struct sysc *ddata)
+static void sysc_parse_dts_quirks(struct sysc *ddata, struct device_node *np,
+				  bool is_child)
 {
-	struct device_node *np = ddata->dev->of_node;
 	const struct property *prop;
-	int i, len, error;
-	u32 val;
-
-	ddata->legacy_mode = of_get_property(np, "ti,hwmods", NULL);
+	int i, len;
 
 	for (i = 0; i < ARRAY_SIZE(sysc_dts_quirks); i++) {
-		prop = of_get_property(np, sysc_dts_quirks[i].name, &len);
+		const char *name = sysc_dts_quirks[i].name;
+
+		prop = of_get_property(np, name, &len);
 		if (!prop)
 			continue;
 
 		ddata->cfg.quirks |= sysc_dts_quirks[i].mask;
+		if (is_child) {
+			dev_warn(ddata->dev,
+				 "dts flag should be at module level for %s\n",
+				 name);
+		}
 	}
+}
+
+static int sysc_init_dts_quirks(struct sysc *ddata)
+{
+	struct device_node *np = ddata->dev->of_node;
+	int error;
+	u32 val;
+
+	ddata->legacy_mode = of_get_property(np, "ti,hwmods", NULL);
 
+	sysc_parse_dts_quirks(ddata, np, false);
 	error = of_property_read_u32(np, "ti,sysc-delay-us", &val);
 	if (!error) {
 		if (val > 255) {
-- 
2.20.1

