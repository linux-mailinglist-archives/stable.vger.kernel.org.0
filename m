Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECD52E42DB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392728AbgL1P3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:29:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:58476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406733AbgL1N4z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:56:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB1CC20791;
        Mon, 28 Dec 2020 13:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163774;
        bh=/P8tw5j8a33bjUfju7ChaCo8HSR2Zz1Rf3Z3F+5yHyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OxoPXT7lrtRKcF+ME3D7XiG9q5l7lgOxnCfJEBzxF0gxuucN/y+OwUJC2O0pPrK2+
         lB7NcSY09R2QBcng5ZR80YUNRFJs9XDpXM7JUfsyso4h2WxAUc7iTLEqLPP6Nx/n+x
         f46pIsloVLgxf7lgBKa1WuZZ2GxBW3Q/KvlvGQN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 401/453] spi: pxa2xx: Fix use-after-free on unbind
Date:   Mon, 28 Dec 2020 13:50:37 +0100
Message-Id: <20201228124956.505583443@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 5626308bb94d9f930aa5f7c77327df4c6daa7759 upstream.

pxa2xx_spi_remove() accesses the driver's private data after calling
spi_unregister_controller() even though that function releases the last
reference on the spi_controller and thereby frees the private data.

Fix by switching over to the new devm_spi_alloc_master/slave() helper
which keeps the private data accessible until the driver has unbound.

Fixes: 32e5b57232c0 ("spi: pxa2xx: Fix controller unregister order")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v2.6.17+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v2.6.17+: 32e5b57232c0: spi: pxa2xx: Fix controller unregister order
Cc: <stable@vger.kernel.org> # v2.6.17+
Link: https://lore.kernel.org/r/5764b04d4a6e43069ebb7808f64c2f774ac6f193.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-pxa2xx.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1675,9 +1675,9 @@ static int pxa2xx_spi_probe(struct platf
 	}
 
 	if (platform_info->is_slave)
-		controller = spi_alloc_slave(dev, sizeof(struct driver_data));
+		controller = devm_spi_alloc_slave(dev, sizeof(*drv_data));
 	else
-		controller = spi_alloc_master(dev, sizeof(struct driver_data));
+		controller = devm_spi_alloc_master(dev, sizeof(*drv_data));
 
 	if (!controller) {
 		dev_err(&pdev->dev, "cannot alloc spi_controller\n");
@@ -1900,7 +1900,6 @@ out_error_dma_irq_alloc:
 	free_irq(ssp->irq, drv_data);
 
 out_error_controller_alloc:
-	spi_controller_put(controller);
 	pxa_ssp_free(ssp);
 	return status;
 }


