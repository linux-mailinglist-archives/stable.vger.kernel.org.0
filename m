Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02C52E3EC1
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503278AbgL1Oap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:30:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503719AbgL1Oao (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:30:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C59782063A;
        Mon, 28 Dec 2020 14:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165804;
        bh=u1Rb0Gtsl9RKgD2iH9QXEnvnwF01Ibb2MopdOSdHccA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Adwo0DCIPH4aasx/za8uWRfyxsmOfmpP0TT5q+5jpgzEZw724D0DZyRyirSDLIPaU
         tTohKDHAhOZprDoaxv/VYn7J5Dh2loz/nNQOQR/GOdO1bthJzjMRimiXJjd/dzJO1L
         BZtiVSuIYwz9MGuqbGqe7Yk0lYaeyuG20xcZphII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Piotr Bugalski <bugalski.piotr@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 643/717] spi: atmel-quadspi: Fix use-after-free on unbind
Date:   Mon, 28 Dec 2020 13:50:41 +0100
Message-Id: <20201228125051.742956441@linuxfoundation.org>
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

commit c7b884561cb5b641f3dbba950094110794119a6d upstream.

atmel_qspi_remove() accesses the driver's private data after calling
spi_unregister_controller() even though that function releases the last
reference on the spi_controller and thereby frees the private data.

Fix by switching over to the new devm_spi_alloc_master() helper which
keeps the private data accessible until the driver has unbound.

Fixes: 2d30ac5ed633 ("mtd: spi-nor: atmel-quadspi: Use spi-mem interface for atmel-quadspi driver")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v5.0+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v5.0+
Cc: Piotr Bugalski <bugalski.piotr@gmail.com>
Link: https://lore.kernel.org/r/4b05c65cf6f1ea3251484fe9a00b4c65478a1ae3.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/atmel-quadspi.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -535,7 +535,7 @@ static int atmel_qspi_probe(struct platf
 	struct resource *res;
 	int irq, err = 0;
 
-	ctrl = spi_alloc_master(&pdev->dev, sizeof(*aq));
+	ctrl = devm_spi_alloc_master(&pdev->dev, sizeof(*aq));
 	if (!ctrl)
 		return -ENOMEM;
 
@@ -557,8 +557,7 @@ static int atmel_qspi_probe(struct platf
 	aq->regs = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(aq->regs)) {
 		dev_err(&pdev->dev, "missing registers\n");
-		err = PTR_ERR(aq->regs);
-		goto exit;
+		return PTR_ERR(aq->regs);
 	}
 
 	/* Map the AHB memory */
@@ -566,8 +565,7 @@ static int atmel_qspi_probe(struct platf
 	aq->mem = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(aq->mem)) {
 		dev_err(&pdev->dev, "missing AHB memory\n");
-		err = PTR_ERR(aq->mem);
-		goto exit;
+		return PTR_ERR(aq->mem);
 	}
 
 	aq->mmap_size = resource_size(res);
@@ -579,15 +577,14 @@ static int atmel_qspi_probe(struct platf
 
 	if (IS_ERR(aq->pclk)) {
 		dev_err(&pdev->dev, "missing peripheral clock\n");
-		err = PTR_ERR(aq->pclk);
-		goto exit;
+		return PTR_ERR(aq->pclk);
 	}
 
 	/* Enable the peripheral clock */
 	err = clk_prepare_enable(aq->pclk);
 	if (err) {
 		dev_err(&pdev->dev, "failed to enable the peripheral clock\n");
-		goto exit;
+		return err;
 	}
 
 	aq->caps = of_device_get_match_data(&pdev->dev);
@@ -638,8 +635,6 @@ disable_qspick:
 	clk_disable_unprepare(aq->qspick);
 disable_pclk:
 	clk_disable_unprepare(aq->pclk);
-exit:
-	spi_controller_put(ctrl);
 
 	return err;
 }


