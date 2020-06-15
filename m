Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3E51F9109
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 10:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbgFOIIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 04:08:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728260AbgFOIIG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 04:08:06 -0400
Received: from PC-kkoz.proceq.com (unknown [213.160.61.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCD7E20739;
        Mon, 15 Jun 2020 08:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592208485;
        bh=LUPoJCPiZ/wjm5oTIJ2xHNWoOg9h7BTPPnxEp9CP1Rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/jRKJDCe1kmUUnZACX5iG5uZnbo8a87qS/eLcoyn8WyMxZ8TZqNtsWgAUlDDoQVi
         r66uEnd1Cs4XmeFA0kJMzcRSXFaeiBJnZCMJLs7b6z4O8bku20AJTaoqMlngop29bs
         gWdzFS9HnTnB+NDjbSZN+b5DKNdGaWf6c+5Um3Qo=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Mark Brown <broonie@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>, kernel@pengutronix.de,
        Krzysztof Kozlowski <krzk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2 2/3] spi: spi-fsl-dspi: Initialize completion before possible interrupt
Date:   Mon, 15 Jun 2020 10:07:18 +0200
Message-Id: <1592208439-17594-2-git-send-email-krzk@kernel.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1592208439-17594-1-git-send-email-krzk@kernel.org>
References: <1592208439-17594-1-git-send-email-krzk@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The interrupt handler calls completion and is IRQ requested before the
completion is initialized.  Logically it should be the other way.

Fixes: 4f5ee75ea171 ("spi: spi-fsl-dspi: Replace interruptible wait queue with a simple completion")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

Changes since v1:
1. Rework the commit msg.
---
 drivers/spi/spi-fsl-dspi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 023e05c53b85..080c5624bd1e 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1385,6 +1385,8 @@ static int dspi_probe(struct platform_device *pdev)
 		goto poll_mode;
 	}
 
+	init_completion(&dspi->xfer_done);
+
 	ret = devm_request_irq(&pdev->dev, dspi->irq, dspi_interrupt,
 			       IRQF_SHARED, pdev->name, dspi);
 	if (ret < 0) {
@@ -1392,8 +1394,6 @@ static int dspi_probe(struct platform_device *pdev)
 		goto out_clk_put;
 	}
 
-	init_completion(&dspi->xfer_done);
-
 poll_mode:
 
 	if (dspi->devtype_data->trans_mode == DSPI_DMA_MODE) {
-- 
2.7.4

