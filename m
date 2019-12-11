Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF8B11B5E7
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730962AbfLKP5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:57:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:41124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730503AbfLKPPL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:15:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C31A2465E;
        Wed, 11 Dec 2019 15:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077310;
        bh=lFZkm7q6Kd6ZAtelJLFxe7PszsPAW7e1i73I2nPoQKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U/D+8Fm3jW43WlSJRIY61Y6NCapVyJeYBiKC6typYdbjNBpb19j87hDTHV0FWRNbj
         FhVBhS6L4aDJiS98+kDKu4cg4o6lYSElp6cnQBA84EE91JgqzY8P3/UQGZyWGCqVEW
         2JZ5Tufq5QUqv1bNJ6FgIg2m0nnn2P7nTX3a/Y9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "kernelci.org bot" <bot@kernelci.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.3 097/105] spi: Fix NULL pointer when setting SPI_CS_HIGH for GPIO CS
Date:   Wed, 11 Dec 2019 16:06:26 +0100
Message-Id: <20191211150302.501151205@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gregory CLEMENT <gregory.clement@bootlin.com>

commit 15f794bd977a0135328fbdd8a83cc64c1d267b39 upstream.

Even if the flag use_gpio_descriptors is set, it is possible that
cs_gpiods was not allocated, which leads to a kernel crash.

Reported-by: "kernelci.org bot" <bot@kernelci.org>
Fixes: 3e5ec1db8bfe ("spi: Fix SPI_CS_HIGH setting when using native and GPIO CS")
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Link: https://lore.kernel.org/r/20191024141309.22434-1-gregory.clement@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1779,7 +1779,8 @@ static int of_spi_parse_dt(struct spi_co
 	 * handled in the gpiolib, so all gpio chip selects are "active high"
 	 * in the logical sense, the gpiolib will invert the line if need be.
 	 */
-	if ((ctlr->use_gpio_descriptors) && ctlr->cs_gpiods[spi->chip_select])
+	if ((ctlr->use_gpio_descriptors) && ctlr->cs_gpiods &&
+	    ctlr->cs_gpiods[spi->chip_select])
 		spi->mode |= SPI_CS_HIGH;
 
 	/* Device speed */


