Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8CF1FB900
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732790AbgFPPwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:52:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732743AbgFPPwe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:52:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33F5F21527;
        Tue, 16 Jun 2020 15:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322753;
        bh=yJiFaOZloGB2NSKpB3spvtmWAhuXPh/vE7PAJDTvQoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pG0w+FccbNIQ1h5PL2U9BGYnpXLhPdldGpaDPQQ/WcpGGOuwiCxiAoZgGvMj6xGnU
         A0F59XEAWKb0ycqNgobPXF5dIbY0lbj021wmUl9o9YDjXZSh05i8Fm8noeRcyJa8Wi
         Vw9HlEGfPKmZinNXh0u0HYKsN7mLAWnNvOWkKSb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Martin Sperl <kernel@martin.sperl.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.6 090/161] spi: bcm2835aux: Fix controller unregister order
Date:   Tue, 16 Jun 2020 17:34:40 +0200
Message-Id: <20200616153110.664328301@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit b9dd3f6d417258ad0beeb292a1bc74200149f15d upstream.

The BCM2835aux SPI driver uses devm_spi_register_master() on bind.
As a consequence, on unbind, __device_release_driver() first invokes
bcm2835aux_spi_remove() before unregistering the SPI controller via
devres_release_all().

This order is incorrect:  bcm2835aux_spi_remove() turns off the SPI
controller, including its interrupts and clock.  The SPI controller
is thus no longer usable.

When the SPI controller is subsequently unregistered, it unbinds all
its slave devices.  If their drivers need to access the SPI bus,
e.g. to quiesce their interrupts, unbinding will fail.

As a rule, devm_spi_register_master() must not be used if the
->remove() hook performs teardown steps which shall be performed
after unbinding of slaves.

Fix by using the non-devm variant spi_register_master().  Note that the
struct spi_master as well as the driver-private data are not freed until
after bcm2835aux_spi_remove() has finished, so accessing them is safe.

Fixes: 1ea29b39f4c8 ("spi: bcm2835aux: add bcm2835 auxiliary spi device driver")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v4.4+
Cc: Martin Sperl <kernel@martin.sperl.org>
Link: https://lore.kernel.org/r/32f27f4d8242e4d75f9a53f7e8f1f77483b08669.1589557526.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-bcm2835aux.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-bcm2835aux.c
+++ b/drivers/spi/spi-bcm2835aux.c
@@ -569,7 +569,7 @@ static int bcm2835aux_spi_probe(struct p
 		goto out_clk_disable;
 	}
 
-	err = devm_spi_register_master(&pdev->dev, master);
+	err = spi_register_master(master);
 	if (err) {
 		dev_err(&pdev->dev, "could not register SPI master: %d\n", err);
 		goto out_clk_disable;
@@ -593,6 +593,8 @@ static int bcm2835aux_spi_remove(struct
 
 	bcm2835aux_debugfs_remove(bs);
 
+	spi_unregister_master(master);
+
 	bcm2835aux_spi_reset_hw(bs);
 
 	/* disable the HW block by releasing the clock */


