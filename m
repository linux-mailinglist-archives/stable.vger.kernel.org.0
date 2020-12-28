Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6852E3E9A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503544AbgL1OaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:30:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503479AbgL1OaF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:30:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E3C320791;
        Mon, 28 Dec 2020 14:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165790;
        bh=OD/8JqmLw/fSfLhRr3bWNJIQ0pJiqbzcAHeMDFV1myo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2cCViBgNc3VfGSifvLKa7YqebpqoAvy70u8WAgSFITJZQwsd2dtVGzZxuRNdbZPgd
         doKwG4LsuPlGQLid/ezw8C/Du1G8iSyUDe61o3LIvgvtqsaMF/s/gfnG8k1p3scT0J
         AitgoW23gkNy2raf7gieItdsFwkF2KKsa+8BdzX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 656/717] spi: spi-qcom-qspi: Fix use-after-free on unbind
Date:   Mon, 28 Dec 2020 13:50:54 +0100
Message-Id: <20201228125052.378435782@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 6cfd39e212dee2e77a0227ce4e0f55fa06d79f46 upstream.

qcom_qspi_remove() accesses the driver's private data after calling
spi_unregister_master() even though that function releases the last
reference on the spi_master and thereby frees the private data.

Fix by switching over to the new devm_spi_alloc_master() helper which
keeps the private data accessible until the driver has unbound.

Fixes: f79a158d37c2 ("spi: spi-qcom-qspi: Use OPP API to set clk/perf state")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v5.9+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v5.9+
Cc: Rajendra Nayak <rnayak@codeaurora.org>
Link: https://lore.kernel.org/r/b6d3c4dce571d78a532fd74f27def0d5dc8d8a24.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-qcom-qspi.c |   42 ++++++++++++++++--------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

--- a/drivers/spi/spi-qcom-qspi.c
+++ b/drivers/spi/spi-qcom-qspi.c
@@ -462,7 +462,7 @@ static int qcom_qspi_probe(struct platfo
 
 	dev = &pdev->dev;
 
-	master = spi_alloc_master(dev, sizeof(*ctrl));
+	master = devm_spi_alloc_master(dev, sizeof(*ctrl));
 	if (!master)
 		return -ENOMEM;
 
@@ -473,54 +473,49 @@ static int qcom_qspi_probe(struct platfo
 	spin_lock_init(&ctrl->lock);
 	ctrl->dev = dev;
 	ctrl->base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(ctrl->base)) {
-		ret = PTR_ERR(ctrl->base);
-		goto exit_probe_master_put;
-	}
+	if (IS_ERR(ctrl->base))
+		return PTR_ERR(ctrl->base);
 
 	ctrl->clks = devm_kcalloc(dev, QSPI_NUM_CLKS,
 				  sizeof(*ctrl->clks), GFP_KERNEL);
-	if (!ctrl->clks) {
-		ret = -ENOMEM;
-		goto exit_probe_master_put;
-	}
+	if (!ctrl->clks)
+		return -ENOMEM;
 
 	ctrl->clks[QSPI_CLK_CORE].id = "core";
 	ctrl->clks[QSPI_CLK_IFACE].id = "iface";
 	ret = devm_clk_bulk_get(dev, QSPI_NUM_CLKS, ctrl->clks);
 	if (ret)
-		goto exit_probe_master_put;
+		return ret;
 
 	ctrl->icc_path_cpu_to_qspi = devm_of_icc_get(dev, "qspi-config");
-	if (IS_ERR(ctrl->icc_path_cpu_to_qspi)) {
-		ret = dev_err_probe(dev, PTR_ERR(ctrl->icc_path_cpu_to_qspi),
-				    "Failed to get cpu path\n");
-		goto exit_probe_master_put;
-	}
+	if (IS_ERR(ctrl->icc_path_cpu_to_qspi))
+		return dev_err_probe(dev, PTR_ERR(ctrl->icc_path_cpu_to_qspi),
+				     "Failed to get cpu path\n");
+
 	/* Set BW vote for register access */
 	ret = icc_set_bw(ctrl->icc_path_cpu_to_qspi, Bps_to_icc(1000),
 				Bps_to_icc(1000));
 	if (ret) {
 		dev_err(ctrl->dev, "%s: ICC BW voting failed for cpu: %d\n",
 				__func__, ret);
-		goto exit_probe_master_put;
+		return ret;
 	}
 
 	ret = icc_disable(ctrl->icc_path_cpu_to_qspi);
 	if (ret) {
 		dev_err(ctrl->dev, "%s: ICC disable failed for cpu: %d\n",
 				__func__, ret);
-		goto exit_probe_master_put;
+		return ret;
 	}
 
 	ret = platform_get_irq(pdev, 0);
 	if (ret < 0)
-		goto exit_probe_master_put;
+		return ret;
 	ret = devm_request_irq(dev, ret, qcom_qspi_irq,
 			IRQF_TRIGGER_HIGH, dev_name(dev), ctrl);
 	if (ret) {
 		dev_err(dev, "Failed to request irq %d\n", ret);
-		goto exit_probe_master_put;
+		return ret;
 	}
 
 	master->max_speed_hz = 300000000;
@@ -537,10 +532,8 @@ static int qcom_qspi_probe(struct platfo
 	master->auto_runtime_pm = true;
 
 	ctrl->opp_table = dev_pm_opp_set_clkname(&pdev->dev, "core");
-	if (IS_ERR(ctrl->opp_table)) {
-		ret = PTR_ERR(ctrl->opp_table);
-		goto exit_probe_master_put;
-	}
+	if (IS_ERR(ctrl->opp_table))
+		return PTR_ERR(ctrl->opp_table);
 	/* OPP table is optional */
 	ret = dev_pm_opp_of_add_table(&pdev->dev);
 	if (ret && ret != -ENODEV) {
@@ -562,9 +555,6 @@ static int qcom_qspi_probe(struct platfo
 exit_probe_put_clkname:
 	dev_pm_opp_put_clkname(ctrl->opp_table);
 
-exit_probe_master_put:
-	spi_master_put(master);
-
 	return ret;
 }
 


