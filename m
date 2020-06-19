Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3FB200C83
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388887AbgFSOqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:46:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388283AbgFSOqv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:46:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A6A92158C;
        Fri, 19 Jun 2020 14:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578010;
        bh=YnUY4BRqPOLsh/OLQA/Tj+eun+GFMnU9X+/EX2tAM4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FnXrW+BEAF0EuwhkDNSsKkFdSinU7wcXiCpRUq58DojAVix3RZzjNvOkINLZ7joUe
         yOgHPPSQIfau1tgUdHyseyMjZt8biZCXoiJkdTvgFqI1n6r/8sDBxHAFE+VPJty0Dd
         GL1id8nwIM3QcD/KITP8ohM1afxICug2ZEO4DwMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 047/190] spi: pxa2xx: Fix controller unregister order
Date:   Fri, 19 Jun 2020 16:31:32 +0200
Message-Id: <20200619141635.940379920@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 32e5b57232c0411e7dea96625c415510430ac079 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-pxa2xx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 5160e16d3a98..b73fde1de463 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1826,7 +1826,7 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 
 	/* Register with the SPI framework */
 	platform_set_drvdata(pdev, drv_data);
-	status = devm_spi_register_master(&pdev->dev, master);
+	status = spi_register_master(master);
 	if (status != 0) {
 		dev_err(&pdev->dev, "problem registering spi master\n");
 		goto out_error_clock_enabled;
@@ -1856,6 +1856,8 @@ static int pxa2xx_spi_remove(struct platform_device *pdev)
 
 	pm_runtime_get_sync(&pdev->dev);
 
+	spi_unregister_master(drv_data->master);
+
 	/* Disable the SSP at the peripheral and SOC level */
 	pxa2xx_spi_write(drv_data, SSCR0, 0);
 	clk_disable_unprepare(ssp->clk);
-- 
2.25.1



