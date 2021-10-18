Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03054431E8A
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234312AbhJROCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:02:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234399AbhJROAR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:00:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3509860F56;
        Mon, 18 Oct 2021 13:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564531;
        bh=PcqQIb1IhiaRoWComIAtp2rMlcfK8hqwRoXaYragQ1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B1QvUQtAcRDAzde4ZmbjIKzOx41rsl4+DLGaGnfA1EV+kqIe+Vh3K/RqpfArZh6gp
         vvxWECL0miM699onXJiua8qw2G0Lh9JRgDiHxkF5Dmqm2ImcCGQr+g0nsCwd/aGUZK
         HtQFFhVQk7GihvQn64OV1OLJ8R9t4SHz2m+QphCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Dasu <kdasu@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.14 124/151] spi: bcm-qspi: clear MSPI spifie interrupt during probe
Date:   Mon, 18 Oct 2021 15:25:03 +0200
Message-Id: <20211018132344.700584835@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Dasu <kdasu@broadcom.com>

commit 75b3cb97eb1f05042745c0655a7145b0262d4c5c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcm-qspi.c |   77 ++++++++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 32 deletions(-)

--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1250,10 +1250,14 @@ static void bcm_qspi_hw_init(struct bcm_
 
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
@@ -1397,6 +1401,47 @@ int bcm_qspi_probe(struct platform_devic
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
@@ -1433,38 +1478,6 @@ int bcm_qspi_probe(struct platform_devic
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


