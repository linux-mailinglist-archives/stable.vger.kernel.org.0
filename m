Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D5A33B9E5
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbhCOOHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:07:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233521AbhCOOBz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F34E664EF1;
        Mon, 15 Mar 2021 14:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816915;
        bh=te4hZo7HFHHW5oJ5jXIkUtYvVvsHLJj1h5NcS6pT4Uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ToMBRbNSHEARAZFlVXP8Rsc+dRi+AknTeHjhn2S+ohzctM6uxAgMrYDnyAs6DNkrn
         Wr8o0yiwBQTgvgNK5ufXx8qGxs7me9x5L0OpK8mG7rJXxdYc9c6k93D0jNq1jK9uRg
         EHDZYFWo4QctYdvr0QeOkse5sx176Gc4gLRWcKs8=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 5.11 199/306] usb: dwc3: qcom: add URS Host support for sdm845 ACPI boot
Date:   Mon, 15 Mar 2021 14:54:22 +0100
Message-Id: <20210315135514.358462202@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Shawn Guo <shawn.guo@linaro.org>

commit c25c210f590e7a37eecd865d84f97d1f40e39786 upstream.

For sdm845 ACPI boot, the URS (USB Role Switch) node in ACPI DSDT table
holds the memory resource, while interrupt resources reside in the child
nodes USB0 and UFN0.  It adds USB0 host support by probing URS node,
creating platform device for USB0 node, and then retrieve interrupt
resources from USB0 platform device.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Link: https://lore.kernel.org/r/20210115035057.10994-1-shawn.guo@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-qcom.c |   59 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 56 insertions(+), 3 deletions(-)

--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -60,12 +60,14 @@ struct dwc3_acpi_pdata {
 	int			dp_hs_phy_irq_index;
 	int			dm_hs_phy_irq_index;
 	int			ss_phy_irq_index;
+	bool			is_urs;
 };
 
 struct dwc3_qcom {
 	struct device		*dev;
 	void __iomem		*qscratch_base;
 	struct platform_device	*dwc3;
+	struct platform_device	*urs_usb;
 	struct clk		**clks;
 	int			num_clocks;
 	struct reset_control	*resets;
@@ -429,13 +431,15 @@ static void dwc3_qcom_select_utmi_clk(st
 static int dwc3_qcom_get_irq(struct platform_device *pdev,
 			     const char *name, int num)
 {
+	struct dwc3_qcom *qcom = platform_get_drvdata(pdev);
+	struct platform_device *pdev_irq = qcom->urs_usb ? qcom->urs_usb : pdev;
 	struct device_node *np = pdev->dev.of_node;
 	int ret;
 
 	if (np)
-		ret = platform_get_irq_byname(pdev, name);
+		ret = platform_get_irq_byname(pdev_irq, name);
 	else
-		ret = platform_get_irq(pdev, num);
+		ret = platform_get_irq(pdev_irq, num);
 
 	return ret;
 }
@@ -568,6 +572,8 @@ static int dwc3_qcom_acpi_register_core(
 	struct dwc3_qcom	*qcom = platform_get_drvdata(pdev);
 	struct device		*dev = &pdev->dev;
 	struct resource		*res, *child_res = NULL;
+	struct platform_device	*pdev_irq = qcom->urs_usb ? qcom->urs_usb :
+							    pdev;
 	int			irq;
 	int			ret;
 
@@ -597,7 +603,7 @@ static int dwc3_qcom_acpi_register_core(
 	child_res[0].end = child_res[0].start +
 		qcom->acpi_pdata->dwc3_core_base_size;
 
-	irq = platform_get_irq(pdev, 0);
+	irq = platform_get_irq(pdev_irq, 0);
 	child_res[1].flags = IORESOURCE_IRQ;
 	child_res[1].start = child_res[1].end = irq;
 
@@ -654,6 +660,33 @@ node_put:
 	return ret;
 }
 
+static struct platform_device *
+dwc3_qcom_create_urs_usb_platdev(struct device *dev)
+{
+	struct fwnode_handle *fwh;
+	struct acpi_device *adev;
+	char name[8];
+	int ret;
+	int id;
+
+	/* Figure out device id */
+	ret = sscanf(fwnode_get_name(dev->fwnode), "URS%d", &id);
+	if (!ret)
+		return NULL;
+
+	/* Find the child using name */
+	snprintf(name, sizeof(name), "USB%d", id);
+	fwh = fwnode_get_named_child_node(dev->fwnode, name);
+	if (!fwh)
+		return NULL;
+
+	adev = to_acpi_device_node(fwh);
+	if (!adev)
+		return NULL;
+
+	return acpi_create_platform_device(adev, NULL);
+}
+
 static int dwc3_qcom_probe(struct platform_device *pdev)
 {
 	struct device_node	*np = pdev->dev.of_node;
@@ -718,6 +751,14 @@ static int dwc3_qcom_probe(struct platfo
 			qcom->acpi_pdata->qscratch_base_offset;
 		parent_res->end = parent_res->start +
 			qcom->acpi_pdata->qscratch_base_size;
+
+		if (qcom->acpi_pdata->is_urs) {
+			qcom->urs_usb = dwc3_qcom_create_urs_usb_platdev(dev);
+			if (!qcom->urs_usb) {
+				dev_err(dev, "failed to create URS USB platdev\n");
+				return -ENODEV;
+			}
+		}
 	}
 
 	qcom->qscratch_base = devm_ioremap_resource(dev, parent_res);
@@ -880,8 +921,20 @@ static const struct dwc3_acpi_pdata sdm8
 	.ss_phy_irq_index = 2
 };
 
+static const struct dwc3_acpi_pdata sdm845_acpi_urs_pdata = {
+	.qscratch_base_offset = SDM845_QSCRATCH_BASE_OFFSET,
+	.qscratch_base_size = SDM845_QSCRATCH_SIZE,
+	.dwc3_core_base_size = SDM845_DWC3_CORE_SIZE,
+	.hs_phy_irq_index = 1,
+	.dp_hs_phy_irq_index = 4,
+	.dm_hs_phy_irq_index = 3,
+	.ss_phy_irq_index = 2,
+	.is_urs = true,
+};
+
 static const struct acpi_device_id dwc3_qcom_acpi_match[] = {
 	{ "QCOM2430", (unsigned long)&sdm845_acpi_pdata },
+	{ "QCOM0304", (unsigned long)&sdm845_acpi_urs_pdata },
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, dwc3_qcom_acpi_match);


