Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4CA02F56F
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbfE3DL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:11:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728551AbfE3DL1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:27 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D37E244FF;
        Thu, 30 May 2019 03:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185886;
        bh=B7dNO3kXNyfXTlNOL5kR74EmahW3u0qcRg/nMy1bMtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTnNFvyaHCmo1i8TpzCQfNcHdiQEOMkizd7iU3tH/cbtVydTkZuCT2Oze3N7Qo0qN
         TYhhYv80UYVxyTdaUAC7/ylhCRRJFEx7UKqV+OpGciC1mzTOMAm4/P3bbrHgr02Snv
         KdhkP+BbNmjYNZXt76jDwsK5o0H9oU7ZrLxYAy/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Smirnov <andrew.smirnov@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Chris Healy <cphealy@gmail.com>, linux-spi@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 236/405] spi: Dont call spi_get_gpio_descs() before device name is set
Date:   Wed, 29 May 2019 20:03:54 -0700
Message-Id: <20190530030552.951884503@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0a919ae49223d32ac0e8be3494547fcd1e4aa0aa ]

Move code calling spi_get_gpio_descs() to happen after ctlr->dev's
name is set in order to have proper GPIO consumer names.

Before:

cat /sys/kernel/debug/gpio
gpiochip0: GPIOs 0-31, parent: platform/40049000.gpio, vf610-gpio:
 gpio-6   (                    |regulator-usb0-vbus ) out lo

gpiochip1: GPIOs 32-63, parent: platform/4004a000.gpio, vf610-gpio:
 gpio-36  (                    |scl                 ) in  hi
 gpio-37  (                    |sda                 ) in  hi
 gpio-40  (                    |(null) CS1          ) out lo
 gpio-41  (                    |(null) CS0          ) out lo ACTIVE LOW
 gpio-42  (                    |miso                ) in  hi
 gpio-43  (                    |mosi                ) in  lo
 gpio-44  (                    |sck                 ) out lo

After:

cat /sys/kernel/debug/gpio
gpiochip0: GPIOs 0-31, parent: platform/40049000.gpio, vf610-gpio:
 gpio-6   (                    |regulator-usb0-vbus ) out lo

gpiochip1: GPIOs 32-63, parent: platform/4004a000.gpio, vf610-gpio:
 gpio-36  (                    |scl                 ) in  hi
 gpio-37  (                    |sda                 ) in  hi
 gpio-40  (                    |spi0 CS1            ) out lo
 gpio-41  (                    |spi0 CS0            ) out lo ACTIVE LOW
 gpio-42  (                    |miso                ) in  hi
 gpio-43  (                    |mosi                ) in  lo
 gpio-44  (                    |sck                 ) out lo

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Chris Healy <cphealy@gmail.com>
Cc: linux-spi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 93986f879b09e..d17f68775a4bb 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2275,24 +2275,6 @@ int spi_register_controller(struct spi_controller *ctlr)
 	if (status)
 		return status;
 
-	if (!spi_controller_is_slave(ctlr)) {
-		if (ctlr->use_gpio_descriptors) {
-			status = spi_get_gpio_descs(ctlr);
-			if (status)
-				return status;
-			/*
-			 * A controller using GPIO descriptors always
-			 * supports SPI_CS_HIGH if need be.
-			 */
-			ctlr->mode_bits |= SPI_CS_HIGH;
-		} else {
-			/* Legacy code path for GPIOs from DT */
-			status = of_spi_register_master(ctlr);
-			if (status)
-				return status;
-		}
-	}
-
 	/* even if it's just one always-selected device, there must
 	 * be at least one chipselect
 	 */
@@ -2349,6 +2331,25 @@ int spi_register_controller(struct spi_controller *ctlr)
 	 * registration fails if the bus ID is in use.
 	 */
 	dev_set_name(&ctlr->dev, "spi%u", ctlr->bus_num);
+
+	if (!spi_controller_is_slave(ctlr)) {
+		if (ctlr->use_gpio_descriptors) {
+			status = spi_get_gpio_descs(ctlr);
+			if (status)
+				return status;
+			/*
+			 * A controller using GPIO descriptors always
+			 * supports SPI_CS_HIGH if need be.
+			 */
+			ctlr->mode_bits |= SPI_CS_HIGH;
+		} else {
+			/* Legacy code path for GPIOs from DT */
+			status = of_spi_register_master(ctlr);
+			if (status)
+				return status;
+		}
+	}
+
 	status = device_add(&ctlr->dev);
 	if (status < 0) {
 		/* free bus id */
-- 
2.20.1



