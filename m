Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC8A3F63BB
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbhHXQ57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:57:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234198AbhHXQ52 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05B39613BD;
        Tue, 24 Aug 2021 16:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824203;
        bh=t3noXGdLBRLRITPrJfjfQexRoeVHQQ0XyOD38fN0Ckk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SU+rqDtIL0F2DOszCouyWRzMG+2mtOchtSogxQAhB3OOgm7MKGIqEdeK9hJKFX+7w
         Alz2wDP3rkfkw1sZT7qrALkrUXXHlTTrIpyAg47m4fge3h4hgPmhb9JfdsgWEwlSsS
         X+H7plaTNEPlNeQ9dowNisCfLGezNhk4JcIjpYJAKvv6UhcnTLRbpfKsZ3Lfjl0Kea
         AMdtYbZWqaRSMyAcTTSjfqP7ipy8T84FVhKFtxLE+gL2ih3AQOgLSW2Iu57mo2VHiL
         6pxMOblQ79wOYP4W151eaGr6XD+zi2zL9A7RqJuvBCJIj3bYR2vJE3cLQp3pKhUdah
         QosJIuWsoXAoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Kochetkov <fido_max@inbox.ru>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Saravana Kannan <saravanak@google.com>,
        Li Yang <leoyang.li@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 036/127] soc: fsl: qe: convert QE interrupt controller to platform_device
Date:   Tue, 24 Aug 2021 12:54:36 -0400
Message-Id: <20210824165607.709387-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Kochetkov <fido_max@inbox.ru>

[ Upstream commit be7ecbd240b2f9ec544d3ce6fccf4cec3cd15dca ]

Since 5.13 QE's ucc nodes can't get interrupts from devicetree:

	ucc@2000 {
		cell-index = <1>;
		reg = <0x2000 0x200>;
		interrupts = <32>;
		interrupt-parent = <&qeic>;
	};

Now fw_devlink expects driver to create and probe a struct device
for interrupt controller.

So lets convert this driver to simple platform_device with probe().
Also use platform_get_ and devm_ family function to get/allocate
resources and drop unused .compatible = "qeic".

[1] - https://lore.kernel.org/lkml/CAGETcx9PiX==mLxB9PO8Myyk6u2vhPVwTMsA5NkD-ywH5xhusw@mail.gmail.com
Fixes: e590474768f1 ("driver core: Set fw_devlink=on by default")
Fixes: ea718c699055 ("Revert "Revert "driver core: Set fw_devlink=on by default""")
Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qe/qe_ic.c | 75 ++++++++++++++++++++++----------------
 1 file changed, 44 insertions(+), 31 deletions(-)

diff --git a/drivers/soc/fsl/qe/qe_ic.c b/drivers/soc/fsl/qe/qe_ic.c
index 3f711c1a0996..e710d554425d 100644
--- a/drivers/soc/fsl/qe/qe_ic.c
+++ b/drivers/soc/fsl/qe/qe_ic.c
@@ -23,6 +23,7 @@
 #include <linux/signal.h>
 #include <linux/device.h>
 #include <linux/spinlock.h>
+#include <linux/platform_device.h>
 #include <asm/irq.h>
 #include <asm/io.h>
 #include <soc/fsl/qe/qe.h>
@@ -404,41 +405,40 @@ static void qe_ic_cascade_muxed_mpic(struct irq_desc *desc)
 	chip->irq_eoi(&desc->irq_data);
 }
 
-static void __init qe_ic_init(struct device_node *node)
+static int qe_ic_init(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
 	void (*low_handler)(struct irq_desc *desc);
 	void (*high_handler)(struct irq_desc *desc);
 	struct qe_ic *qe_ic;
-	struct resource res;
-	u32 ret;
+	struct resource *res;
+	struct device_node *node = pdev->dev.of_node;
 
-	ret = of_address_to_resource(node, 0, &res);
-	if (ret)
-		return;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(dev, "no memory resource defined\n");
+		return -ENODEV;
+	}
 
-	qe_ic = kzalloc(sizeof(*qe_ic), GFP_KERNEL);
+	qe_ic = devm_kzalloc(dev, sizeof(*qe_ic), GFP_KERNEL);
 	if (qe_ic == NULL)
-		return;
+		return -ENOMEM;
 
-	qe_ic->irqhost = irq_domain_add_linear(node, NR_QE_IC_INTS,
-					       &qe_ic_host_ops, qe_ic);
-	if (qe_ic->irqhost == NULL) {
-		kfree(qe_ic);
-		return;
+	qe_ic->regs = devm_ioremap(dev, res->start, resource_size(res));
+	if (qe_ic->regs == NULL) {
+		dev_err(dev, "failed to ioremap() registers\n");
+		return -ENODEV;
 	}
 
-	qe_ic->regs = ioremap(res.start, resource_size(&res));
-
 	qe_ic->hc_irq = qe_ic_irq_chip;
 
-	qe_ic->virq_high = irq_of_parse_and_map(node, 0);
-	qe_ic->virq_low = irq_of_parse_and_map(node, 1);
+	qe_ic->virq_high = platform_get_irq(pdev, 0);
+	qe_ic->virq_low = platform_get_irq(pdev, 1);
 
-	if (!qe_ic->virq_low) {
-		printk(KERN_ERR "Failed to map QE_IC low IRQ\n");
-		kfree(qe_ic);
-		return;
+	if (qe_ic->virq_low < 0) {
+		return -ENODEV;
 	}
+
 	if (qe_ic->virq_high != qe_ic->virq_low) {
 		low_handler = qe_ic_cascade_low;
 		high_handler = qe_ic_cascade_high;
@@ -447,6 +447,13 @@ static void __init qe_ic_init(struct device_node *node)
 		high_handler = NULL;
 	}
 
+	qe_ic->irqhost = irq_domain_add_linear(node, NR_QE_IC_INTS,
+					       &qe_ic_host_ops, qe_ic);
+	if (qe_ic->irqhost == NULL) {
+		dev_err(dev, "failed to add irq domain\n");
+		return -ENODEV;
+	}
+
 	qe_ic_write(qe_ic->regs, QEIC_CICR, 0);
 
 	irq_set_handler_data(qe_ic->virq_low, qe_ic);
@@ -456,20 +463,26 @@ static void __init qe_ic_init(struct device_node *node)
 		irq_set_handler_data(qe_ic->virq_high, qe_ic);
 		irq_set_chained_handler(qe_ic->virq_high, high_handler);
 	}
+	return 0;
 }
+static const struct of_device_id qe_ic_ids[] = {
+	{ .compatible = "fsl,qe-ic"},
+	{ .type = "qeic"},
+	{},
+};
 
-static int __init qe_ic_of_init(void)
+static struct platform_driver qe_ic_driver =
 {
-	struct device_node *np;
+	.driver	= {
+		.name		= "qe-ic",
+		.of_match_table	= qe_ic_ids,
+	},
+	.probe	= qe_ic_init,
+};
 
-	np = of_find_compatible_node(NULL, NULL, "fsl,qe-ic");
-	if (!np) {
-		np = of_find_node_by_type(NULL, "qeic");
-		if (!np)
-			return -ENODEV;
-	}
-	qe_ic_init(np);
-	of_node_put(np);
+static int __init qe_ic_of_init(void)
+{
+	platform_driver_register(&qe_ic_driver);
 	return 0;
 }
 subsys_initcall(qe_ic_of_init);
-- 
2.30.2

