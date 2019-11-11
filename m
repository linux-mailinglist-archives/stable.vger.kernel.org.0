Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAE7AF7B89
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbfKKShI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:37:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:55752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbfKKShH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:37:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A7222196E;
        Mon, 11 Nov 2019 18:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497424;
        bh=9LITEAuRyIZhYRJVxwQK6W2uLPQIgX/2QCfk2ObGUsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRxXkXzPv4IV39Tutox3+NOd31/0tHImTCKCI4VmDIJaFe8xa5TUd0G8i1S8XOlyb
         wZWCBnSGGPe+giAbocpvoWhF15yuTNhMbyYni3kNW9dPzzXQbyEO8eYdDM2iUHIhF7
         VYecCn4/p1y1wLTg12dMfiLAESjXPqNQPLXc1ND0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vignesh R <vigneshr@ti.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Cyrille Pitchen <cyrille.pitchen@wedev4u.fr>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 4.14 050/105] mtd: spi-nor: cadence-quadspi: add a delay in write sequence
Date:   Mon, 11 Nov 2019 19:28:20 +0100
Message-Id: <20191111181442.336862799@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh R <vigneshr@ti.com>

commit 61dc8493bae9ba82a1c72edbc6c6065f6a94456a upstream

As per 66AK2G02 TRM[1] SPRUHY8F section 11.15.5.3 Indirect Access
Controller programming sequence, a delay equal to couple of QSPI master
clock(~5ns) is required after setting CQSPI_REG_INDIRECTWR_START bit and
writing data to the flash. Introduce a quirk flag CQSPI_NEEDS_WR_DELAY
to handle this and set this flag for TI 66AK2G SoC.

[1]http://www.ti.com/lit/ug/spruhy8f/spruhy8f.pdf

Signed-off-by: Vignesh R <vigneshr@ti.com>
Acked-by: Marek Vasut <marek.vasut@gmail.com>
Signed-off-by: Cyrille Pitchen <cyrille.pitchen@wedev4u.fr>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/cadence-quadspi.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

--- a/drivers/mtd/spi-nor/cadence-quadspi.c
+++ b/drivers/mtd/spi-nor/cadence-quadspi.c
@@ -38,6 +38,9 @@
 #define CQSPI_NAME			"cadence-qspi"
 #define CQSPI_MAX_CHIPSELECT		16
 
+/* Quirks */
+#define CQSPI_NEEDS_WR_DELAY		BIT(0)
+
 struct cqspi_st;
 
 struct cqspi_flash_pdata {
@@ -76,6 +79,7 @@ struct cqspi_st {
 	u32			fifo_depth;
 	u32			fifo_width;
 	u32			trigger_address;
+	u32			wr_delay;
 	struct cqspi_flash_pdata f_pdata[CQSPI_MAX_CHIPSELECT];
 };
 
@@ -623,6 +627,15 @@ static int cqspi_indirect_write_execute(
 	reinit_completion(&cqspi->transfer_complete);
 	writel(CQSPI_REG_INDIRECTWR_START_MASK,
 	       reg_base + CQSPI_REG_INDIRECTWR);
+	/*
+	 * As per 66AK2G02 TRM SPRUHY8F section 11.15.5.3 Indirect Access
+	 * Controller programming sequence, couple of cycles of
+	 * QSPI_REF_CLK delay is required for the above bit to
+	 * be internally synchronized by the QSPI module. Provide 5
+	 * cycles of delay.
+	 */
+	if (cqspi->wr_delay)
+		ndelay(cqspi->wr_delay);
 
 	while (remaining > 0) {
 		size_t write_words, mod_bytes;
@@ -1184,6 +1197,7 @@ static int cqspi_probe(struct platform_d
 	struct cqspi_st *cqspi;
 	struct resource *res;
 	struct resource *res_ahb;
+	unsigned long data;
 	int ret;
 	int irq;
 
@@ -1241,6 +1255,10 @@ static int cqspi_probe(struct platform_d
 	}
 
 	cqspi->master_ref_clk_hz = clk_get_rate(cqspi->clk);
+	data  = (unsigned long)of_device_get_match_data(dev);
+	if (data & CQSPI_NEEDS_WR_DELAY)
+		cqspi->wr_delay = 5 * DIV_ROUND_UP(NSEC_PER_SEC,
+						   cqspi->master_ref_clk_hz);
 
 	ret = devm_request_irq(dev, irq, cqspi_irq_handler, 0,
 			       pdev->name, cqspi);
@@ -1312,7 +1330,14 @@ static const struct dev_pm_ops cqspi__de
 #endif
 
 static const struct of_device_id cqspi_dt_ids[] = {
-	{.compatible = "cdns,qspi-nor",},
+	{
+		.compatible = "cdns,qspi-nor",
+		.data = (void *)0,
+	},
+	{
+		.compatible = "ti,k2g-qspi",
+		.data = (void *)CQSPI_NEEDS_WR_DELAY,
+	},
 	{ /* end of table */ }
 };
 


