Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A53A40C72E
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 16:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbhIOOSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 10:18:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233741AbhIOOSF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 10:18:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31F35604DA;
        Wed, 15 Sep 2021 14:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631715406;
        bh=u7diw6uMgxBOVCsmMjwzroytw3ygyYdMVsF9u9/ilTE=;
        h=Subject:To:Cc:From:Date:From;
        b=Ugobt3LSTzZiw5PP6Wv94ksn3gA4uG64wyRDZmeM0ZGMV/mIwEM7NZagjr5491hgu
         PI8EsWjrtSowPMGEXbb+L83cavxFY/p35gQq/lePIarChBLNWJRKNm6QOpMfvddLdK
         62Rz23XMnMUYLz/Qh+8WkITcsKe6vHbWiQbaF5wg=
Subject: FAILED: patch "[PATCH] PCI: xilinx-nwl: Enable the clock through CCF" failed to apply to 4.9-stable tree
To:     hyun.kwon@xilinx.com, bharat.kumar.gogada@xilinx.com,
        lorenzo.pieralisi@arm.com, michal.simek@xilinx.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Sep 2021 16:16:43 +0200
Message-ID: <1631715403212121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From de0a01f5296651d3a539f2d23d0db8f359483696 Mon Sep 17 00:00:00 2001
From: Hyun Kwon <hyun.kwon@xilinx.com>
Date: Fri, 25 Jun 2021 12:48:23 +0200
Subject: [PATCH] PCI: xilinx-nwl: Enable the clock through CCF

Enable PCIe reference clock. There is no remove function that's why
this should be enough for simple operation.
Normally this clock is enabled by default by firmware but there are
usecases where this clock should be enabled by driver itself.
It is also good that PCIe clock is recorded in a clock framework.

Link: https://lore.kernel.org/r/ee6997a08fab582b1c6de05f8be184f3fe8d5357.1624618100.git.michal.simek@xilinx.com
Fixes: ab597d35ef11 ("PCI: xilinx-nwl: Add support for Xilinx NWL PCIe Host Controller")
Signed-off-by: Hyun Kwon <hyun.kwon@xilinx.com>
Signed-off-by: Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/pci/controller/pcie-xilinx-nwl.c b/drivers/pci/controller/pcie-xilinx-nwl.c
index 8689311c5ef6..1c3d5b87ef20 100644
--- a/drivers/pci/controller/pcie-xilinx-nwl.c
+++ b/drivers/pci/controller/pcie-xilinx-nwl.c
@@ -6,6 +6,7 @@
  * (C) Copyright 2014 - 2015, Xilinx, Inc.
  */
 
+#include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
@@ -169,6 +170,7 @@ struct nwl_pcie {
 	u8 last_busno;
 	struct nwl_msi msi;
 	struct irq_domain *legacy_irq_domain;
+	struct clk *clk;
 	raw_spinlock_t leg_mask_lock;
 };
 
@@ -823,6 +825,16 @@ static int nwl_pcie_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	pcie->clk = devm_clk_get(dev, NULL);
+	if (IS_ERR(pcie->clk))
+		return PTR_ERR(pcie->clk);
+
+	err = clk_prepare_enable(pcie->clk);
+	if (err) {
+		dev_err(dev, "can't enable PCIe ref clock\n");
+		return err;
+	}
+
 	err = nwl_pcie_bridge_init(pcie);
 	if (err) {
 		dev_err(dev, "HW Initialization failed\n");

