Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E101FBA28
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731774AbgFPQJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:09:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732067AbgFPPpT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:45:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34E112098B;
        Tue, 16 Jun 2020 15:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322318;
        bh=VgkC+fRBKLBKgQ0OEx+Emu859oW44liBSJU0qTAPumQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZF4KBO2tlutyw080GgJ+kvxl/kaHZMLne/cPlCoCcdVk6pSFAj8HhFQoftsBsDlW
         PyPSj29Qn+K5A4qBUhsnn9a2fGow+s+XKabdPP82BRZEvUBHki+003+yqI3OGVTniB
         4/Rks7Q/lsqOxJdBgrxR3n65cPVY8V9+RYS4n0a4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.7 084/163] spi: bcm2835: Fix controller unregister order
Date:   Tue, 16 Jun 2020 17:34:18 +0200
Message-Id: <20200616153110.867877823@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 9dd277ff92d06f6aa95b39936ad83981d781f49b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-bcm2835.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -1347,7 +1347,7 @@ static int bcm2835_spi_probe(struct plat
 		goto out_dma_release;
 	}
 
-	err = devm_spi_register_controller(&pdev->dev, ctlr);
+	err = spi_register_controller(ctlr);
 	if (err) {
 		dev_err(&pdev->dev, "could not register SPI controller: %d\n",
 			err);
@@ -1374,6 +1374,8 @@ static int bcm2835_spi_remove(struct pla
 
 	bcm2835_debugfs_remove(bs);
 
+	spi_unregister_controller(ctlr);
+
 	/* Clear FIFOs, and disable the HW block */
 	bcm2835_wr(bs, BCM2835_SPI_CS,
 		   BCM2835_SPI_CS_CLEAR_RX | BCM2835_SPI_CS_CLEAR_TX);


