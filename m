Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38FF2C0A52
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732341AbgKWMjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:39:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:52466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732303AbgKWMjq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:39:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A26CB217A0;
        Mon, 23 Nov 2020 12:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135186;
        bh=bLd/IA/GBN91CmWxjZ77W/baBskahdfQejsxLh0CS6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wlkUXbcY+7bDDKmxBGoV0LSfULfp5rwmEH9TlsY1OQ9DgQDh0t+Q0vzIHCarajMXF
         q2uNa6zxfEYeoj9T7aF4CqUeRyL/kq0lp+jkoRZI5bJrLO6zP5s4wIWdX2kygVE+4C
         smxeBocH8yCI71SlOSQr/OTNbrHFH90jBc3LM+sA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 136/158] spi: bcm2835aux: Fix use-after-free on unbind
Date:   Mon, 23 Nov 2020 13:22:44 +0100
Message-Id: <20201123121826.494943875@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit e13ee6cc4781edaf8c7321bee19217e3702ed481 upstream.

bcm2835aux_spi_remove() accesses the driver's private data after calling
spi_unregister_master() even though that function releases the last
reference on the spi_master and thereby frees the private data.

Fix by switching over to the new devm_spi_alloc_master() helper which
keeps the private data accessible until the driver has unbound.

Fixes: b9dd3f6d4172 ("spi: bcm2835aux: Fix controller unregister order")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v4.4+: 123456789abc: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v4.4+: b9dd3f6d4172: spi: bcm2835aux: Fix controller unregister order
Cc: <stable@vger.kernel.org> # v4.4+
Link: https://lore.kernel.org/r/b290b06357d0c0bdee9cecc539b840a90630f101.1605121038.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-bcm2835aux.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- a/drivers/spi/spi-bcm2835aux.c
+++ b/drivers/spi/spi-bcm2835aux.c
@@ -494,7 +494,7 @@ static int bcm2835aux_spi_probe(struct p
 	unsigned long clk_hz;
 	int err;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*bs));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*bs));
 	if (!master)
 		return -ENOMEM;
 
@@ -524,29 +524,24 @@ static int bcm2835aux_spi_probe(struct p
 
 	/* the main area */
 	bs->regs = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(bs->regs)) {
-		err = PTR_ERR(bs->regs);
-		goto out_master_put;
-	}
+	if (IS_ERR(bs->regs))
+		return PTR_ERR(bs->regs);
 
 	bs->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(bs->clk)) {
-		err = PTR_ERR(bs->clk);
 		dev_err(&pdev->dev, "could not get clk: %d\n", err);
-		goto out_master_put;
+		return PTR_ERR(bs->clk);
 	}
 
 	bs->irq = platform_get_irq(pdev, 0);
-	if (bs->irq <= 0) {
-		err = bs->irq ? bs->irq : -ENODEV;
-		goto out_master_put;
-	}
+	if (bs->irq <= 0)
+		return bs->irq ? bs->irq : -ENODEV;
 
 	/* this also enables the HW block */
 	err = clk_prepare_enable(bs->clk);
 	if (err) {
 		dev_err(&pdev->dev, "could not prepare clock: %d\n", err);
-		goto out_master_put;
+		return err;
 	}
 
 	/* just checking if the clock returns a sane value */
@@ -581,8 +576,6 @@ static int bcm2835aux_spi_probe(struct p
 
 out_clk_disable:
 	clk_disable_unprepare(bs->clk);
-out_master_put:
-	spi_master_put(master);
 	return err;
 }
 


