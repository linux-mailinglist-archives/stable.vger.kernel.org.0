Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C96F4667580
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbjALOWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235677AbjALOVr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:21:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56F55952C
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:12:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85661B81DCC
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD405C433D2;
        Thu, 12 Jan 2023 14:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532773;
        bh=cwQ4M/FEja/VD4o82zMsuHB53100mEGIfAEgmcrZGjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PIEpXWXMKd2m5BdJqk9KEDdpL0aBvQLob5Ix/OjnSYcmZDN2ILicIIJB4QY9aDvOA
         xy+An7uOBRJrWQQUO6oIAhyDoVns+6gCMhNzU2NF1h7y3MoEy767hRG6gg4nnv1NB9
         bii4SYA4oge3sTNvC8hW8kD3D4DIMvazEogCXlGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kris Bahnsen <kris@embeddedTS.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 241/783] spi: spi-gpio: Dont set MOSI as an input if not 3WIRE mode
Date:   Thu, 12 Jan 2023 14:49:17 +0100
Message-Id: <20230112135535.557514460@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kris Bahnsen <kris@embeddedTS.com>

[ Upstream commit 3a6f994f848a69deb2bf3cd9d130dd0c09730e55 ]

The addition of 3WIRE support would affect MOSI direction even
when still in standard (4 wire) mode. This can lead to MOSI being
at an invalid logic level when a device driver sets an SPI
message with a NULL tx_buf.

spi.h states that if tx_buf is NULL then "zeros will be shifted
out ... " If MOSI is tristated then the data shifted out is subject
to pull resistors, keepers, or in the absence of those, noise.

This issue came to light when using spi-gpio connected to an
ADS7843 touchscreen controller. MOSI pulled high when clocking
MISO data in caused the SPI device to interpret this as a command
which would put the device in an unexpected and non-functional
state.

Fixes: 4b859db2c606 ("spi: spi-gpio: add SPI_3WIRE support")
Fixes: 5132b3d28371 ("spi: gpio: Support 3WIRE high-impedance turn-around")
Signed-off-by: Kris Bahnsen <kris@embeddedTS.com>
Link: https://lore.kernel.org/r/20221207230853.6174-1-kris@embeddedTS.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-gpio.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-gpio.c b/drivers/spi/spi-gpio.c
index 0584f4d2fde2..3ffdab6caac2 100644
--- a/drivers/spi/spi-gpio.c
+++ b/drivers/spi/spi-gpio.c
@@ -244,9 +244,19 @@ static int spi_gpio_set_direction(struct spi_device *spi, bool output)
 	if (output)
 		return gpiod_direction_output(spi_gpio->mosi, 1);
 
-	ret = gpiod_direction_input(spi_gpio->mosi);
-	if (ret)
-		return ret;
+	/*
+	 * Only change MOSI to an input if using 3WIRE mode.
+	 * Otherwise, MOSI could be left floating if there is
+	 * no pull resistor connected to the I/O pin, or could
+	 * be left logic high if there is a pull-up. Transmitting
+	 * logic high when only clocking MISO data in can put some
+	 * SPI devices in to a bad state.
+	 */
+	if (spi->mode & SPI_3WIRE) {
+		ret = gpiod_direction_input(spi_gpio->mosi);
+		if (ret)
+			return ret;
+	}
 	/*
 	 * Send a turnaround high impedance cycle when switching
 	 * from output to input. Theoretically there should be
-- 
2.35.1



