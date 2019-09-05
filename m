Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5AE0AA883
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 18:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388180AbfIEQSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 12:18:12 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37720 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388141AbfIEQSM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 12:18:12 -0400
Received: by mail-pf1-f194.google.com with SMTP id y9so2078657pfl.4
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 09:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NoTtLr1lztWfrS92BUWnGWn3zk0jvQAYseg1lZWuSGs=;
        b=GFbERyZ9NRV2dkkLT4vQsg2O43TovjaGYNn6dZQb4zlipk1hrBEI93ONy4uCdy17BN
         qs6turZaX0cjL2hsvD0XQcPWWyT5eGXz7QIlN5q8rtchZ5viCWRBDwkHQ7obcrcC3Uar
         1ortXnAwgQMvUwFZEFdfF67Zd3yS6nt3iV9SSsbRUiIhAZwUvGND/emO1CKYf2KWOr28
         VxlM82pRtImf20eiipHbpwiiWXaq0nZI2+bBsKhiaerAHkOFKlpVyiIpgMWISCo/STX0
         lWqLo+YlveCj4WJwPQ/Qdyw/LyipxCRHxudVAm/baaKD40BYKWBjg0PjlTT0keABvYme
         Sx5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NoTtLr1lztWfrS92BUWnGWn3zk0jvQAYseg1lZWuSGs=;
        b=h/04M5yIhXv3nNzqvZ2MeOdk257kYl8nPEG5txNGAka4Qg0nw6kLFbRCgorKL6Pfo4
         R2ZFgieEl+5fDF+v2vTcNqI1Go7q6ybolQRcHquMie3Wf2GVUNF+K04UNxta6OudM7IN
         b0BtHtAYQwCLA8tmLjawewYSA/Bk593OcBB6gbGCemb1DJEjPe3QBhopzOKCnlyALdvP
         cZlT9fF8xxlrVoaIqXKZH1f6NXR7aDk3pMmYY4QUIg5txpOYyQFVwRQKjJGlsrPaC0dm
         rsd2soC4WW/KLG8Gl8yVIYbW2AXTfJUj20tGFYHymJqZwy3IEeUIpUu+Gs8HWaF71qYf
         xbIg==
X-Gm-Message-State: APjAAAUknJKvzhPHTYSzzZQmTbVH13v6cjA7x9RzCHZpsnHWm/C2ni2M
        sjPm3q8P6ark3aiD1GVOSBkSFSwQ7RQ=
X-Google-Smtp-Source: APXvYqxTYivq/efmoU5WtwxZv5cSxczPS7YC9boEJTkxinNAbnn0GjS2kdu7p4Li6YOQRyRvVr3Cpw==
X-Received: by 2002:a63:60a:: with SMTP id 10mr3873993pgg.381.1567700290813;
        Thu, 05 Sep 2019 09:18:10 -0700 (PDT)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m129sm6324005pga.39.2019.09.05.09.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 09:18:10 -0700 (PDT)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [BACKPORT 4.14.y 08/18] mtd: spi-nor: cadence-quadspi: add a delay in write sequence
Date:   Thu,  5 Sep 2019 10:17:49 -0600
Message-Id: <20190905161759.28036-9-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905161759.28036-1-mathieu.poirier@linaro.org>
References: <20190905161759.28036-1-mathieu.poirier@linaro.org>
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
---
 drivers/mtd/spi-nor/cadence-quadspi.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/cadence-quadspi.c b/drivers/mtd/spi-nor/cadence-quadspi.c
index f22dd34f4f83..ff4edf4bb23c 100644
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
 
@@ -623,6 +627,15 @@ static int cqspi_indirect_write_execute(struct spi_nor *nor,
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
@@ -1184,6 +1197,7 @@ static int cqspi_probe(struct platform_device *pdev)
 	struct cqspi_st *cqspi;
 	struct resource *res;
 	struct resource *res_ahb;
+	unsigned long data;
 	int ret;
 	int irq;
 
@@ -1241,6 +1255,10 @@ static int cqspi_probe(struct platform_device *pdev)
 	}
 
 	cqspi->master_ref_clk_hz = clk_get_rate(cqspi->clk);
+	data  = (unsigned long)of_device_get_match_data(dev);
+	if (data & CQSPI_NEEDS_WR_DELAY)
+		cqspi->wr_delay = 5 * DIV_ROUND_UP(NSEC_PER_SEC,
+						   cqspi->master_ref_clk_hz);
 
 	ret = devm_request_irq(dev, irq, cqspi_irq_handler, 0,
 			       pdev->name, cqspi);
@@ -1312,7 +1330,14 @@ static const struct dev_pm_ops cqspi__dev_pm_ops = {
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
 
-- 
2.17.1

