Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343621FB69C
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730796AbgFPPiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:38:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729966AbgFPPix (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:38:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AFEC20B1F;
        Tue, 16 Jun 2020 15:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321932;
        bh=ROD4OS853yfOamcyXBqlH9ryzTfV4idnYgurUQsATrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKpRu1SmHHvcWAL9iS/gYG5dexsoLQENAg0+b3AyCAbfNPadDoRGjGBB4ehuqBLmg
         DRdjfUJw1OLOxPoGSuuTRDlGCMQ51of3DajiPZ9dPY+IIf81FcmXVrxHx2Dtendlxb
         eJCM+MC2Il6+XLIRawUXwLTOOc32FxhtlwNEJtD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 071/134] spi: pxa2xx: Fix controller unregister order
Date:   Tue, 16 Jun 2020 17:34:15 +0200
Message-Id: <20200616153104.177737040@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 32e5b57232c0411e7dea96625c415510430ac079 upstream.

The PXA2xx SPI driver uses devm_spi_register_controller() on bind.
As a consequence, on unbind, __device_release_driver() first invokes
pxa2xx_spi_remove() before unregistering the SPI controller via
devres_release_all().

This order is incorrect:  pxa2xx_spi_remove() disables the chip,
rendering the SPI bus inaccessible even though the SPI controller is
still registered.  When the SPI controller is subsequently unregistered,
it unbinds all its slave devices.  Because their drivers cannot access
the SPI bus, e.g. to quiesce interrupts, the slave devices may be left
in an improper state.

As a rule, devm_spi_register_controller() must not be used if the
->remove() hook performs teardown steps which shall be performed after
unregistering the controller and specifically after unbinding of slaves.

Fix by reverting to the non-devm variant of spi_register_controller().

An alternative approach would be to use device-managed functions for all
steps in pxa2xx_spi_remove(), e.g. by calling devm_add_action_or_reset()
on probe.  However that approach would add more LoC to the driver and
it wouldn't lend itself as well to backporting to stable.

The improper use of devm_spi_register_controller() was introduced in 2013
by commit a807fcd090d6 ("spi: pxa2xx: use devm_spi_register_master()"),
but all earlier versions of the driver going back to 2006 were likewise
broken because they invoked spi_unregister_master() at the end of
pxa2xx_spi_remove(), rather than at the beginning.

Fixes: e0c9905e87ac ("[PATCH] SPI: add PXA2xx SSP SPI Driver")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@vger.kernel.org # v2.6.17+
Cc: Tsuchiya Yuto <kitakar@gmail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206403#c1
Link: https://lore.kernel.org/r/834c446b1cf3284d2660f1bee1ebe3e737cd02a9.1590408496.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-pxa2xx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1880,7 +1880,7 @@ static int pxa2xx_spi_probe(struct platf
 
 	/* Register with the SPI framework */
 	platform_set_drvdata(pdev, drv_data);
-	status = devm_spi_register_controller(&pdev->dev, controller);
+	status = spi_register_controller(controller);
 	if (status != 0) {
 		dev_err(&pdev->dev, "problem registering spi controller\n");
 		goto out_error_pm_runtime_enabled;
@@ -1916,6 +1916,8 @@ static int pxa2xx_spi_remove(struct plat
 
 	pm_runtime_get_sync(&pdev->dev);
 
+	spi_unregister_controller(drv_data->controller);
+
 	/* Disable the SSP at the peripheral and SOC level */
 	pxa2xx_spi_write(drv_data, SSCR0, 0);
 	clk_disable_unprepare(ssp->clk);


