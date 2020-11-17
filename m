Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBE82B642A
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732964AbgKQNhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:37:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:48600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732464AbgKQNhc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:37:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 835712468E;
        Tue, 17 Nov 2020 13:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620252;
        bh=wBCGJoC6DRausSoyvfuzZK2ihaMc0VAMnRmBzhpIhmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ByMdVORj+H147NSHjVB/XpZDq7B47E727xQFlF27MiNo59bDeYjPhbo+5Rs1+t0o2
         53nTYakHSig1p/eZbW4YsxuwFGxZnN4xMfFYr/wr8GeCzQJPavTRcRLx6ts+0p+gYM
         qItF9zLliLXYQOsqVxI+9YgDek2/+Uc+ZoLWXu2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunyan Zhang <zhang.lyra@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5.9 127/255] mfd: sprd: Add wakeup capability for PMIC IRQ
Date:   Tue, 17 Nov 2020 14:04:27 +0100
Message-Id: <20201117122145.114280552@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baolin Wang <baolin.wang7@gmail.com>

commit a75bfc824a2d33f57ebdc003bfe6b7a9e11e9cb9 upstream.

When changing to use suspend-to-idle to save power, the PMIC irq can not
wakeup the system due to lack of wakeup capability, which will cause
the sub-irqs (such as power key) of the PMIC can not wake up the system.
Thus we can add the wakeup capability for PMIC irq to solve this issue,
as well as removing the IRQF_NO_SUSPEND flag to allow PMIC irq to be
a wakeup source.

Reported-by: Chunyan Zhang <zhang.lyra@gmail.com>
Signed-off-by: Baolin Wang <baolin.wang7@gmail.com>
Tested-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/sprd-sc27xx-spi.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- a/drivers/mfd/sprd-sc27xx-spi.c
+++ b/drivers/mfd/sprd-sc27xx-spi.c
@@ -189,7 +189,7 @@ static int sprd_pmic_probe(struct spi_de
 		ddata->irqs[i].mask = BIT(i);
 
 	ret = devm_regmap_add_irq_chip(&spi->dev, ddata->regmap, ddata->irq,
-				       IRQF_ONESHOT | IRQF_NO_SUSPEND, 0,
+				       IRQF_ONESHOT, 0,
 				       &ddata->irq_chip, &ddata->irq_data);
 	if (ret) {
 		dev_err(&spi->dev, "Failed to add PMIC irq chip %d\n", ret);
@@ -202,9 +202,34 @@ static int sprd_pmic_probe(struct spi_de
 		return ret;
 	}
 
+	device_init_wakeup(&spi->dev, true);
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int sprd_pmic_suspend(struct device *dev)
+{
+	struct sprd_pmic *ddata = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		enable_irq_wake(ddata->irq);
+
+	return 0;
+}
+
+static int sprd_pmic_resume(struct device *dev)
+{
+	struct sprd_pmic *ddata = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		disable_irq_wake(ddata->irq);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(sprd_pmic_pm_ops, sprd_pmic_suspend, sprd_pmic_resume);
+
 static const struct of_device_id sprd_pmic_match[] = {
 	{ .compatible = "sprd,sc2731", .data = &sc2731_data },
 	{},
@@ -215,6 +240,7 @@ static struct spi_driver sprd_pmic_drive
 	.driver = {
 		.name = "sc27xx-pmic",
 		.of_match_table = sprd_pmic_match,
+		.pm = &sprd_pmic_pm_ops,
 	},
 	.probe = sprd_pmic_probe,
 };


