Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C907412149
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350451AbhITSDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:03:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350360AbhITSBw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:01:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11D91613B3;
        Mon, 20 Sep 2021 17:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158169;
        bh=pB60Zso4c46j1gSOTCobNwTBswnNMKtjyGulBiit2T8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gg4tTsO0RPaAk9RUhz9ICkcvheV2ULMP23VT5IiRdVJldJNjwdgjNIV5EgVzXPlFF
         RPfGhboicpjN89KQW0sjimJcJB8pznB63oP1SEADMu9xszVSarhMC71caQcY37Vw65
         dXVEP2UzhI/9+BkqSWTy2rSvE9TpYPUyD9VDP93o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyun Kwon <hyun.kwon@xilinx.com>,
        Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.4 032/260] PCI: xilinx-nwl: Enable the clock through CCF
Date:   Mon, 20 Sep 2021 18:40:50 +0200
Message-Id: <20210920163932.210872945@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hyun Kwon <hyun.kwon@xilinx.com>

commit de0a01f5296651d3a539f2d23d0db8f359483696 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-xilinx-nwl.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

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
 	u8 root_busno;
 	struct nwl_msi msi;
 	struct irq_domain *legacy_irq_domain;
+	struct clk *clk;
 	raw_spinlock_t leg_mask_lock;
 };
 
@@ -839,6 +841,16 @@ static int nwl_pcie_probe(struct platfor
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


