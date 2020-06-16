Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04ECE1FACEF
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 11:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgFPJl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 05:41:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726052AbgFPJlz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 05:41:55 -0400
Received: from PC-kkoz.proceq.com (unknown [213.160.61.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 201D1207BC;
        Tue, 16 Jun 2020 09:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592300514;
        bh=Sk4uiVB4B7/+E1RJwwK7lA3+sa9J1bh2Mauaa7YcTGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uuH6hJ7BzxsYm5ac/1w5A0PPdWJGvffe+XiYFt1N1U4jLkUN/SqqpE7p4nhks72/X
         wWj5/HjGnQVaGiZpRrFHy2qo57RMQWZt6ScWdYBz4e8ccAN2/kz8Rq/r+us9FwB+kE
         rK3uK/BdzjNysHtJCXZd2KoUiqOG9d6d2xld1B4w=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Mark Brown <broonie@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Krzysztof Kozlowski <krzk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v3 2/2] spi: spi-fsl-dspi: Initialize completion before possible interrupt
Date:   Tue, 16 Jun 2020 11:41:07 +0200
Message-Id: <1592300467-29196-2-git-send-email-krzk@kernel.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1592300467-29196-1-git-send-email-krzk@kernel.org>
References: <1592300467-29196-1-git-send-email-krzk@kernel.org>
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

Changes since v2:
1. None

Changes since v1:
1. Rework the commit msg.
---
 drivers/spi/spi-fsl-dspi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 7ecc90ec8f2f..51e0bf617b16 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1389,6 +1389,8 @@ static int dspi_probe(struct platform_device *pdev)
 		goto poll_mode;
 	}
 
+	init_completion(&dspi->xfer_done);
+
 	ret = request_threaded_irq(dspi->irq, dspi_interrupt, NULL,
 				   IRQF_SHARED, pdev->name, dspi);
 	if (ret < 0) {
@@ -1396,8 +1398,6 @@ static int dspi_probe(struct platform_device *pdev)
 		goto out_clk_put;
 	}
 
-	init_completion(&dspi->xfer_done);
-
 poll_mode:
 
 	if (dspi->devtype_data->trans_mode == DSPI_DMA_MODE) {
-- 
2.7.4

