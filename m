Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0AF320163B
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404698AbgFSQ2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:28:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389896AbgFSOyy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:54:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98300217D8;
        Fri, 19 Jun 2020 14:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578494;
        bh=BHAzJPK3Q3Kd77zzxl86Y03CTOml047K0CEml83WVO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBi9YVmirwpGIfBk6hALAMY7oY/deAjlLCVXTR7Dj3mBKzOiEvHSPaC7rNATyrCop
         2x/UrfwSixLjCv5ZhiTVgitwSEDJmg+DXl+z38tX0v2qOPuJ06rniNDOd2L8Vrk81i
         bPVuSuG2P4JvCh/1bRfgdBULY/cZyluXCqHxZa0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 043/267] spi: dw: Fix controller unregister order
Date:   Fri, 19 Jun 2020 16:30:28 +0200
Message-Id: <20200619141650.949886846@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit ca8b19d61e3fce5d2d7790cde27a0b57bcb3f341 upstream.

The Designware SPI driver uses devm_spi_register_controller() on bind.
As a consequence, on unbind, __device_release_driver() first invokes
dw_spi_remove_host() before unregistering the SPI controller via
devres_release_all().

This order is incorrect:  dw_spi_remove_host() shuts down the chip,
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
steps in dw_spi_remove_host(), e.g. by calling devm_add_action_or_reset()
on probe.  However that approach would add more LoC to the driver and
it wouldn't lend itself as well to backporting to stable.

Fixes: 04f421e7b0b1 ("spi: dw: use managed resources")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@vger.kernel.org # v3.14+
Cc: Baruch Siach <baruch@tkos.co.il>
Link: https://lore.kernel.org/r/3fff8cb8ae44a9893840d0688be15bb88c090a14.1590408496.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-dw.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -536,7 +536,7 @@ int dw_spi_add_host(struct device *dev,
 		}
 	}
 
-	ret = devm_spi_register_controller(dev, master);
+	ret = spi_register_controller(master);
 	if (ret) {
 		dev_err(&master->dev, "problem registering spi master\n");
 		goto err_dma_exit;
@@ -560,6 +560,8 @@ void dw_spi_remove_host(struct dw_spi *d
 {
 	dw_spi_debugfs_remove(dws);
 
+	spi_unregister_controller(dws->master);
+
 	if (dws->dma_ops && dws->dma_ops->dma_exit)
 		dws->dma_ops->dma_exit(dws);
 


