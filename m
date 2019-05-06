Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0B7A14ED9
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfEFOid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:38:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727632AbfEFOic (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:38:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4683C206A3;
        Mon,  6 May 2019 14:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153511;
        bh=PfLeZyYVsYOyH47/cY4Cr0MKkIiL4NuQjQGlWyG1dHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oN7VkqupQiJSDix0MuwGxZfhAIEp0GppTDNSJvYJtgUluU20KIGTsdSZoWvBKSEC/
         W2TFfxvbNkoHM5UU6eOnxSP7nd5bWyCV65Xm3rEGwGNuMqZRYArGyH+0E6zUqg0igy
         8fvWWNM1m39mLViC7AmPeFL8y9TuiXq/nR2Y6Urk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?David=20M=C3=BCller?= <dave.mueller@gmx.ch>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.0 117/122] clk: x86: Add system specific quirk to mark clocks as critical
Date:   Mon,  6 May 2019 16:32:55 +0200
Message-Id: <20190506143104.880055534@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Müller <dave.mueller@gmx.ch>

commit 7c2e07130090ae001a97a6b65597830d6815e93e upstream.

Since commit 648e921888ad ("clk: x86: Stop marking clocks as
CLK_IS_CRITICAL"), the pmc_plt_clocks of the Bay Trail SoC are
unconditionally gated off. Unfortunately this will break systems where these
clocks are used for external purposes beyond the kernel's knowledge. Fix it
by implementing a system specific quirk to mark the necessary pmc_plt_clks as
critical.

Fixes: 648e921888ad ("clk: x86: Stop marking clocks as CLK_IS_CRITICAL")
Signed-off-by: David Müller <dave.mueller@gmx.ch>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/x86/clk-pmc-atom.c                 |   14 +++++++++++---
 drivers/platform/x86/pmc_atom.c                |   21 +++++++++++++++++++++
 include/linux/platform_data/x86/clk-pmc-atom.h |    3 +++
 3 files changed, 35 insertions(+), 3 deletions(-)

--- a/drivers/clk/x86/clk-pmc-atom.c
+++ b/drivers/clk/x86/clk-pmc-atom.c
@@ -165,7 +165,7 @@ static const struct clk_ops plt_clk_ops
 };
 
 static struct clk_plt *plt_clk_register(struct platform_device *pdev, int id,
-					void __iomem *base,
+					const struct pmc_clk_data *pmc_data,
 					const char **parent_names,
 					int num_parents)
 {
@@ -184,9 +184,17 @@ static struct clk_plt *plt_clk_register(
 	init.num_parents = num_parents;
 
 	pclk->hw.init = &init;
-	pclk->reg = base + PMC_CLK_CTL_OFFSET + id * PMC_CLK_CTL_SIZE;
+	pclk->reg = pmc_data->base + PMC_CLK_CTL_OFFSET + id * PMC_CLK_CTL_SIZE;
 	spin_lock_init(&pclk->lock);
 
+	/*
+	 * On some systems, the pmc_plt_clocks already enabled by the
+	 * firmware are being marked as critical to avoid them being
+	 * gated by the clock framework.
+	 */
+	if (pmc_data->critical && plt_clk_is_enabled(&pclk->hw))
+		init.flags |= CLK_IS_CRITICAL;
+
 	ret = devm_clk_hw_register(&pdev->dev, &pclk->hw);
 	if (ret) {
 		pclk = ERR_PTR(ret);
@@ -332,7 +340,7 @@ static int plt_clk_probe(struct platform
 		return PTR_ERR(parent_names);
 
 	for (i = 0; i < PMC_CLK_NUM; i++) {
-		data->clks[i] = plt_clk_register(pdev, i, pmc_data->base,
+		data->clks[i] = plt_clk_register(pdev, i, pmc_data,
 						 parent_names, data->nparents);
 		if (IS_ERR(data->clks[i])) {
 			err = PTR_ERR(data->clks[i]);
--- a/drivers/platform/x86/pmc_atom.c
+++ b/drivers/platform/x86/pmc_atom.c
@@ -17,6 +17,7 @@
 
 #include <linux/debugfs.h>
 #include <linux/device.h>
+#include <linux/dmi.h>
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/platform_data/x86/clk-pmc-atom.h>
@@ -391,11 +392,27 @@ static int pmc_dbgfs_register(struct pmc
 }
 #endif /* CONFIG_DEBUG_FS */
 
+/*
+ * Some systems need one or more of their pmc_plt_clks to be
+ * marked as critical.
+ */
+static const struct dmi_system_id critclk_systems[] __initconst = {
+	{
+		.ident = "MPL CEC1x",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MPL AG"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "CEC10 Family"),
+		},
+	},
+	{ /*sentinel*/ }
+};
+
 static int pmc_setup_clks(struct pci_dev *pdev, void __iomem *pmc_regmap,
 			  const struct pmc_data *pmc_data)
 {
 	struct platform_device *clkdev;
 	struct pmc_clk_data *clk_data;
+	const struct dmi_system_id *d = dmi_first_match(critclk_systems);
 
 	clk_data = kzalloc(sizeof(*clk_data), GFP_KERNEL);
 	if (!clk_data)
@@ -403,6 +420,10 @@ static int pmc_setup_clks(struct pci_dev
 
 	clk_data->base = pmc_regmap; /* offset is added by client */
 	clk_data->clks = pmc_data->clks;
+	if (d) {
+		clk_data->critical = true;
+		pr_info("%s critclks quirk enabled\n", d->ident);
+	}
 
 	clkdev = platform_device_register_data(&pdev->dev, "clk-pmc-atom",
 					       PLATFORM_DEVID_NONE,
--- a/include/linux/platform_data/x86/clk-pmc-atom.h
+++ b/include/linux/platform_data/x86/clk-pmc-atom.h
@@ -35,10 +35,13 @@ struct pmc_clk {
  *
  * @base:	PMC clock register base offset
  * @clks:	pointer to set of registered clocks, typically 0..5
+ * @critical:	flag to indicate if firmware enabled pmc_plt_clks
+ *		should be marked as critial or not
  */
 struct pmc_clk_data {
 	void __iomem *base;
 	const struct pmc_clk *clks;
+	bool critical;
 };
 
 #endif /* __PLATFORM_DATA_X86_CLK_PMC_ATOM_H */


