Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A12411DB2
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349345AbhITRWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:22:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347027AbhITRUv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:20:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90AD06140F;
        Mon, 20 Sep 2021 17:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157240;
        bh=R8SVc7jjCFfqYbEn86cu7/h+JZSJQokXW6RfvsCjOP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YGvz5BhN+bFr9nm9qg7FTIK5gKjnT5+k4fu6HZNXFfyoIgP7fvN9lxoGMurR7K+z7
         C5LVuZ6Cnl4aZHysevkF3bfykOFigeFpFXtTiiaNrDht3lgpF1X6I/8NIYbbBDhJdM
         pRZ2eVDXPWKX12vQpCI5Wn8mDDqot21X1tVv5fGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyun Kwon <hyun.kwon@xilinx.com>,
        Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 4.14 118/217] PCI: xilinx-nwl: Enable the clock through CCF
Date:   Mon, 20 Sep 2021 18:42:19 +0200
Message-Id: <20210920163928.660419640@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
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
 drivers/pci/host/pcie-xilinx-nwl.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/pci/host/pcie-xilinx-nwl.c
+++ b/drivers/pci/host/pcie-xilinx-nwl.c
@@ -10,6 +10,7 @@
  * (at your option) any later version.
  */
 
+#include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
@@ -171,6 +172,7 @@ struct nwl_pcie {
 	u8 root_busno;
 	struct nwl_msi msi;
 	struct irq_domain *legacy_irq_domain;
+	struct clk *clk;
 	raw_spinlock_t leg_mask_lock;
 };
 
@@ -852,6 +854,16 @@ static int nwl_pcie_probe(struct platfor
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


