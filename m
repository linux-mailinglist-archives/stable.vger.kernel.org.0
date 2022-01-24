Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD72497DB1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 12:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237244AbiAXLQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 06:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbiAXLQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 06:16:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEB4C06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 03:16:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC6F8B80B22
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 11:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CA2C340E1;
        Mon, 24 Jan 2022 11:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643022966;
        bh=mwfLMNGjRVPTd+tRYd9WztlksSjA7VpdeGIo5psGTjs=;
        h=Subject:To:Cc:From:Date:From;
        b=GuE4dv2O/789gDjPYZ0g9GAZsmB0oMsMzLOE36TFTyDqVKB/eLNSiSAfkAT625Rb9
         FP0W/IxZHU5kHWGDy37FoaXseoTe2InRDqIseYMts/1M03MqnmR/uYBWZ+Fm1Hralu
         w+2+UFpsyAa8FEGzF1zQrlCxt9gySLDhm4ADO0jo=
Subject: FAILED: patch "[PATCH] platform/x86: pmc_atom: improve critclk_systems matching for" failed to apply to 5.16-stable tree
To:     henning.schild@siemens.com, hdegoede@redhat.com,
        michael.haener@siemens.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 12:15:55 +0100
Message-ID: <164302295515836@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4ba0b8187d98cb4c5e33c0e98895ac5dcb86af83 Mon Sep 17 00:00:00 2001
From: Henning Schild <henning.schild@siemens.com>
Date: Mon, 13 Dec 2021 13:05:02 +0100
Subject: [PATCH] platform/x86: pmc_atom: improve critclk_systems matching for
 Siemens PCs

Siemens industrial PCs unfortunately can not always be properly
identified the way we used to. An earlier commit introduced code that
allows proper identification without looking at DMI strings that could
differ based on product branding.
Switch over to that proper way and revert commits that used to collect
the machines based on unstable strings.

Fixes: 648e921888ad ("clk: x86: Stop marking clocks as CLK_IS_CRITICAL")
Fixes: e8796c6c69d1 ("platform/x86: pmc_atom: Add Siemens CONNECT ...")
Fixes: f110d252ae79 ("platform/x86: pmc_atom: Add Siemens SIMATIC ...")
Fixes: ad0d315b4d4e ("platform/x86: pmc_atom: Add Siemens SIMATIC ...")
Tested-by: Michael Haener <michael.haener@siemens.com>
Signed-off-by: Henning Schild <henning.schild@siemens.com>
Link: https://lore.kernel.org/r/20211213120502.20661-5-henning.schild@siemens.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>

diff --git a/drivers/platform/x86/pmc_atom.c b/drivers/platform/x86/pmc_atom.c
index a9d2a4b98e57..a40fae6edc84 100644
--- a/drivers/platform/x86/pmc_atom.c
+++ b/drivers/platform/x86/pmc_atom.c
@@ -13,6 +13,7 @@
 #include <linux/io.h>
 #include <linux/platform_data/x86/clk-pmc-atom.h>
 #include <linux/platform_data/x86/pmc_atom.h>
+#include <linux/platform_data/x86/simatic-ipc.h>
 #include <linux/platform_device.h>
 #include <linux/pci.h>
 #include <linux/seq_file.h>
@@ -362,6 +363,30 @@ static void pmc_dbgfs_register(struct pmc_dev *pmc)
 }
 #endif /* CONFIG_DEBUG_FS */
 
+static bool pmc_clk_is_critical = true;
+
+static int dmi_callback(const struct dmi_system_id *d)
+{
+	pr_info("%s critclks quirk enabled\n", d->ident);
+
+	return 1;
+}
+
+static int dmi_callback_siemens(const struct dmi_system_id *d)
+{
+	u32 st_id;
+
+	if (dmi_walk(simatic_ipc_find_dmi_entry_helper, &st_id))
+		goto out;
+
+	if (st_id == SIMATIC_IPC_IPC227E || st_id == SIMATIC_IPC_IPC277E)
+		return dmi_callback(d);
+
+out:
+	pmc_clk_is_critical = false;
+	return 1;
+}
+
 /*
  * Some systems need one or more of their pmc_plt_clks to be
  * marked as critical.
@@ -370,6 +395,7 @@ static const struct dmi_system_id critclk_systems[] = {
 	{
 		/* pmc_plt_clk0 is used for an external HSIC USB HUB */
 		.ident = "MPL CEC1x",
+		.callback = dmi_callback,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "MPL AG"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "CEC10 Family"),
@@ -378,6 +404,7 @@ static const struct dmi_system_id critclk_systems[] = {
 	{
 		/* pmc_plt_clk0 - 3 are used for the 4 ethernet controllers */
 		.ident = "Lex 3I380D",
+		.callback = dmi_callback,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Lex BayTrail"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "3I380D"),
@@ -386,6 +413,7 @@ static const struct dmi_system_id critclk_systems[] = {
 	{
 		/* pmc_plt_clk* - are used for ethernet controllers */
 		.ident = "Lex 2I385SW",
+		.callback = dmi_callback,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Lex BayTrail"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "2I385SW"),
@@ -394,30 +422,17 @@ static const struct dmi_system_id critclk_systems[] = {
 	{
 		/* pmc_plt_clk* - are used for ethernet controllers */
 		.ident = "Beckhoff Baytrail",
+		.callback = dmi_callback,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Beckhoff Automation"),
 			DMI_MATCH(DMI_PRODUCT_FAMILY, "CBxx63"),
 		},
 	},
 	{
-		.ident = "SIMATIC IPC227E",
+		.ident = "SIEMENS AG",
+		.callback = dmi_callback_siemens,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "SIEMENS AG"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "6ES7647-8B"),
-		},
-	},
-	{
-		.ident = "SIMATIC IPC277E",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SIEMENS AG"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "6AV7882-0"),
-		},
-	},
-	{
-		.ident = "CONNECT X300",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SIEMENS AG"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "A5E45074588"),
 		},
 	},
 
@@ -429,7 +444,6 @@ static int pmc_setup_clks(struct pci_dev *pdev, void __iomem *pmc_regmap,
 {
 	struct platform_device *clkdev;
 	struct pmc_clk_data *clk_data;
-	const struct dmi_system_id *d = dmi_first_match(critclk_systems);
 
 	clk_data = kzalloc(sizeof(*clk_data), GFP_KERNEL);
 	if (!clk_data)
@@ -437,10 +451,8 @@ static int pmc_setup_clks(struct pci_dev *pdev, void __iomem *pmc_regmap,
 
 	clk_data->base = pmc_regmap; /* offset is added by client */
 	clk_data->clks = pmc_data->clks;
-	if (d) {
-		clk_data->critical = true;
-		pr_info("%s critclks quirk enabled\n", d->ident);
-	}
+	if (dmi_check_system(critclk_systems))
+		clk_data->critical = pmc_clk_is_critical;
 
 	clkdev = platform_device_register_data(&pdev->dev, "clk-pmc-atom",
 					       PLATFORM_DEVID_NONE,

