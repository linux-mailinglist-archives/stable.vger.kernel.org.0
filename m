Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FF42015C1
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390166AbgFSO5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:57:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390167AbgFSO47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:56:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29401218AC;
        Fri, 19 Jun 2020 14:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578619;
        bh=zl0ACyDj7vFcEaBdi95zIaIux1rc3z6IveIFcj/66R8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GmNNTnKOfbRpwdqi4i7A9dHHGUGrbIivUSl3LaW92dbZHlpJk2h0S6vBaiXDu+dxk
         PE67Htdua00T0h0cPFsEJMomyvErGgWnbi+ni+rGTv9EQCT1apfRZSvj5qpFpsok8R
         J9jgt6d9+SmXboD/iz+sUWQRZLlyUN46h6HrmmlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 061/267] spi: bcm2835: Fix controller unregister order
Date:   Fri, 19 Jun 2020 16:30:46 +0200
Message-Id: <20200619141651.799401937@linuxfoundation.org>
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

[ Upstream commit 9dd277ff92d06f6aa95b39936ad83981d781f49b ]

The BCM2835 SPI driver uses devm_spi_register_controller() on bind.
As a consequence, on unbind, __device_release_driver() first invokes
bcm2835_spi_remove() before unregistering the SPI controller via
devres_release_all().

This order is incorrect:  bcm2835_spi_remove() tears down the DMA
channels and turns off the SPI controller, including its interrupts
and clock.  The SPI controller is thus no longer usable.

When the SPI controller is subsequently unregistered, it unbinds all
its slave devices.  If their drivers need to access the SPI bus,
e.g. to quiesce their interrupts, unbinding will fail.

As a rule, devm_spi_register_controller() must not be used if the
->remove() hook performs teardown steps which shall be performed
after unbinding of slaves.

Fix by using the non-devm variant spi_register_controller().  Note that
the struct spi_controller as well as the driver-private data are not
freed until after bcm2835_spi_remove() has finished, so accessing them
is safe.

Fixes: 247263dba208 ("spi: bcm2835: use devm_spi_register_master()")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v3.13+
Link: https://lore.kernel.org/r/2397dd70cdbe95e0bc4da2b9fca0f31cb94e5aed.1589557526.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm2835.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index eab27d41ba83..df6abc75bc16 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -793,7 +793,7 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 		goto out_clk_disable;
 	}
 
-	err = devm_spi_register_master(&pdev->dev, master);
+	err = spi_register_master(master);
 	if (err) {
 		dev_err(&pdev->dev, "could not register SPI master: %d\n", err);
 		goto out_clk_disable;
@@ -813,6 +813,8 @@ static int bcm2835_spi_remove(struct platform_device *pdev)
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct bcm2835_spi *bs = spi_master_get_devdata(master);
 
+	spi_unregister_master(master);
+
 	/* Clear FIFOs, and disable the HW block */
 	bcm2835_wr(bs, BCM2835_SPI_CS,
 		   BCM2835_SPI_CS_CLEAR_RX | BCM2835_SPI_CS_CLEAR_TX);
-- 
2.25.1



