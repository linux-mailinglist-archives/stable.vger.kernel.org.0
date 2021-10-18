Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32C443172D
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 13:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhJRL0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 07:26:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229473AbhJRL0v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 07:26:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7C2D60F8F;
        Mon, 18 Oct 2021 11:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634556280;
        bh=UAauE9cIdHPRpf5ixsXEDJag5Z31g7N67VK13tLKHVc=;
        h=Subject:To:Cc:From:Date:From;
        b=ebMT6z5SrWg0xaChNXKtW1U5r9J1DaY+RvvXMSql3MLofyrjzwr+zfbsOG51R5H3D
         qHFt417YZ3As9XX5gBbT8tov4Vsw0vJVkrUpQIqDcCcJowUvlgOqIkdc+WcEjfuEpE
         VQiNGwdnRoD2XE6GcP4E4bMrnSeJLMB5/I6RnpOc=
Subject: FAILED: patch "[PATCH] spi: bcm-qspi: clear MSPI spifie interrupt during probe" failed to apply to 4.9-stable tree
To:     kdasu@broadcom.com, broonie@kernel.org, f.fainelli@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 13:24:37 +0200
Message-ID: <16345562774799@kroah.com>
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

From 75b3cb97eb1f05042745c0655a7145b0262d4c5c Mon Sep 17 00:00:00 2001
From: Kamal Dasu <kdasu@broadcom.com>
Date: Fri, 8 Oct 2021 16:36:02 -0400
Subject: [PATCH] spi: bcm-qspi: clear MSPI spifie interrupt during probe

Intermittent Kernel crash has been observed on probe in
bcm_qspi_mspi_l2_isr() handler when the MSPI spifie interrupt bit
has not been cleared before registering for interrupts.
Fix the driver to move SoC specific custom interrupt handling code
before we register IRQ in probe. Also clear MSPI interrupt status
resgiter prior to registering IRQ handlers.

Fixes: cc20a38612db ("spi: iproc-qspi: Add Broadcom iProc SoCs support")
Signed-off-by: Kamal Dasu <kdasu@broadcom.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20211008203603.40915-3-kdasu.kdev@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index a78e56f566dd..3043677ba222 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1250,10 +1250,14 @@ static void bcm_qspi_hw_init(struct bcm_qspi *qspi)
 
 static void bcm_qspi_hw_uninit(struct bcm_qspi *qspi)
 {
+	u32 status = bcm_qspi_read(qspi, MSPI, MSPI_MSPI_STATUS);
+
 	bcm_qspi_write(qspi, MSPI, MSPI_SPCR2, 0);
 	if (has_bspi(qspi))
 		bcm_qspi_write(qspi, MSPI, MSPI_WRITE_LOCK, 0);
 
+	/* clear interrupt */
+	bcm_qspi_write(qspi, MSPI, MSPI_MSPI_STATUS, status & ~1);
 }
 
 static const struct spi_controller_mem_ops bcm_qspi_mem_ops = {
@@ -1397,6 +1401,47 @@ int bcm_qspi_probe(struct platform_device *pdev,
 	if (!qspi->dev_ids)
 		return -ENOMEM;
 
+	/*
+	 * Some SoCs integrate spi controller (e.g., its interrupt bits)
+	 * in specific ways
+	 */
+	if (soc_intc) {
+		qspi->soc_intc = soc_intc;
+		soc_intc->bcm_qspi_int_set(soc_intc, MSPI_DONE, true);
+	} else {
+		qspi->soc_intc = NULL;
+	}
+
+	if (qspi->clk) {
+		ret = clk_prepare_enable(qspi->clk);
+		if (ret) {
+			dev_err(dev, "failed to prepare clock\n");
+			goto qspi_probe_err;
+		}
+		qspi->base_clk = clk_get_rate(qspi->clk);
+	} else {
+		qspi->base_clk = MSPI_BASE_FREQ;
+	}
+
+	if (data->has_mspi_rev) {
+		rev = bcm_qspi_read(qspi, MSPI, MSPI_REV);
+		/* some older revs do not have a MSPI_REV register */
+		if ((rev & 0xff) == 0xff)
+			rev = 0;
+	}
+
+	qspi->mspi_maj_rev = (rev >> 4) & 0xf;
+	qspi->mspi_min_rev = rev & 0xf;
+	qspi->mspi_spcr3_sysclk = data->has_spcr3_sysclk;
+
+	qspi->max_speed_hz = qspi->base_clk / (bcm_qspi_spbr_min(qspi) * 2);
+
+	/*
+	 * On SW resets it is possible to have the mask still enabled
+	 * Need to disable the mask and clear the status while we init
+	 */
+	bcm_qspi_hw_uninit(qspi);
+
 	for (val = 0; val < num_irqs; val++) {
 		irq = -1;
 		name = qspi_irq_tab[val].irq_name;
@@ -1433,38 +1478,6 @@ int bcm_qspi_probe(struct platform_device *pdev,
 		goto qspi_probe_err;
 	}
 
-	/*
-	 * Some SoCs integrate spi controller (e.g., its interrupt bits)
-	 * in specific ways
-	 */
-	if (soc_intc) {
-		qspi->soc_intc = soc_intc;
-		soc_intc->bcm_qspi_int_set(soc_intc, MSPI_DONE, true);
-	} else {
-		qspi->soc_intc = NULL;
-	}
-
-	ret = clk_prepare_enable(qspi->clk);
-	if (ret) {
-		dev_err(dev, "failed to prepare clock\n");
-		goto qspi_probe_err;
-	}
-
-	qspi->base_clk = clk_get_rate(qspi->clk);
-
-	if (data->has_mspi_rev) {
-		rev = bcm_qspi_read(qspi, MSPI, MSPI_REV);
-		/* some older revs do not have a MSPI_REV register */
-		if ((rev & 0xff) == 0xff)
-			rev = 0;
-	}
-
-	qspi->mspi_maj_rev = (rev >> 4) & 0xf;
-	qspi->mspi_min_rev = rev & 0xf;
-	qspi->mspi_spcr3_sysclk = data->has_spcr3_sysclk;
-
-	qspi->max_speed_hz = qspi->base_clk / (bcm_qspi_spbr_min(qspi) * 2);
-
 	bcm_qspi_hw_init(qspi);
 	init_completion(&qspi->mspi_done);
 	init_completion(&qspi->bspi_done);

