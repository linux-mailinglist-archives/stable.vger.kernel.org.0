Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FBE4729FE
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241898AbhLMK3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344351AbhLMK1H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:27:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4085DC08EB5B;
        Mon, 13 Dec 2021 02:01:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D175B80E9E;
        Mon, 13 Dec 2021 10:01:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E9FC34600;
        Mon, 13 Dec 2021 10:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389672;
        bh=Rj8gHYR5w+OZATu63aK9m0T1p7yiSM0z0oc3X0XkVbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PnwICYoydSsyye4JRwEN+mCMKkQYru80jv6/qbuZ6MLnsiiYrdagO3fAsvVmbGVjT
         /heSaOn8hS8xi5CRXuDOAQvvHzLkWsKOA4N6svRKM7jDzNNiyZbWy0kBk9dw7+i0es
         SDjHn2mqoBYMEv2xmPtKk4veeOhBi3Cjd+oSzPdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ralph Siemsen <ralph.siemsen@linaro.org>
Subject: [PATCH 5.15 159/171] nvmem: eeprom: at25: fix FRAM byte_len
Date:   Mon, 13 Dec 2021 10:31:14 +0100
Message-Id: <20211213092950.355830285@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ralph Siemsen <ralph.siemsen@linaro.org>

commit 9a626577398c24ecab63c0a684436c8928092367 upstream.

Commit fd307a4ad332 ("nvmem: prepare basics for FRAM support") added
support for FRAM devices such as the Cypress FM25V. During testing, it
was found that the FRAM detects properly, however reads and writes fail.
Upon further investigation, two problem were found in at25_probe() routine.

1) In the case of an FRAM device without platform data, eg.
       fram == true && spi->dev.platform_data == NULL
the stack local variable "struct spi_eeprom chip" is not initialized
fully, prior to being copied into at25->chip. The chip.flags field in
particular can cause problems.

2) The byte_len of FRAM is computed from its ID register, and is stored
into the stack local "struct spi_eeprom chip" structure. This happens
after the same structure has been copied into at25->chip. As a result,
at25->chip.byte_len does not contain the correct length of the device.
In turn this can cause checks at beginning of at25_ee_read() to fail
(or equally, it could allow reads beyond the end of the device length).

Fix both of these issues by eliminating the on-stack struct spi_eeprom.
Instead use the one inside at25_data structure, which starts of zeroed.

Fixes: fd307a4ad332 ("nvmem: prepare basics for FRAM support")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ralph Siemsen <ralph.siemsen@linaro.org>
Link: https://lore.kernel.org/r/20211108181627.645638-1-ralph.siemsen@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/eeprom/at25.c |   38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -376,7 +376,6 @@ MODULE_DEVICE_TABLE(spi, at25_spi_ids);
 static int at25_probe(struct spi_device *spi)
 {
 	struct at25_data	*at25 = NULL;
-	struct spi_eeprom	chip;
 	int			err;
 	int			sr;
 	u8 id[FM25_ID_LEN];
@@ -389,15 +388,18 @@ static int at25_probe(struct spi_device
 	if (match && !strcmp(match->compatible, "cypress,fm25"))
 		is_fram = 1;
 
+	at25 = devm_kzalloc(&spi->dev, sizeof(struct at25_data), GFP_KERNEL);
+	if (!at25)
+		return -ENOMEM;
+
 	/* Chip description */
-	if (!spi->dev.platform_data) {
-		if (!is_fram) {
-			err = at25_fw_to_chip(&spi->dev, &chip);
-			if (err)
-				return err;
-		}
-	} else
-		chip = *(struct spi_eeprom *)spi->dev.platform_data;
+	if (spi->dev.platform_data) {
+		memcpy(&at25->chip, spi->dev.platform_data, sizeof(at25->chip));
+	} else if (!is_fram) {
+		err = at25_fw_to_chip(&spi->dev, &at25->chip);
+		if (err)
+			return err;
+	}
 
 	/* Ping the chip ... the status register is pretty portable,
 	 * unlike probing manufacturer IDs.  We do expect that system
@@ -409,12 +411,7 @@ static int at25_probe(struct spi_device
 		return -ENXIO;
 	}
 
-	at25 = devm_kzalloc(&spi->dev, sizeof(struct at25_data), GFP_KERNEL);
-	if (!at25)
-		return -ENOMEM;
-
 	mutex_init(&at25->lock);
-	at25->chip = chip;
 	at25->spi = spi;
 	spi_set_drvdata(spi, at25);
 
@@ -431,7 +428,7 @@ static int at25_probe(struct spi_device
 			dev_err(&spi->dev, "Error: unsupported size (id %02x)\n", id[7]);
 			return -ENODEV;
 		}
-		chip.byte_len = int_pow(2, id[7] - 0x21 + 4) * 1024;
+		at25->chip.byte_len = int_pow(2, id[7] - 0x21 + 4) * 1024;
 
 		if (at25->chip.byte_len > 64 * 1024)
 			at25->chip.flags |= EE_ADDR3;
@@ -464,7 +461,7 @@ static int at25_probe(struct spi_device
 	at25->nvmem_config.type = is_fram ? NVMEM_TYPE_FRAM : NVMEM_TYPE_EEPROM;
 	at25->nvmem_config.name = dev_name(&spi->dev);
 	at25->nvmem_config.dev = &spi->dev;
-	at25->nvmem_config.read_only = chip.flags & EE_READONLY;
+	at25->nvmem_config.read_only = at25->chip.flags & EE_READONLY;
 	at25->nvmem_config.root_only = true;
 	at25->nvmem_config.owner = THIS_MODULE;
 	at25->nvmem_config.compat = true;
@@ -474,17 +471,18 @@ static int at25_probe(struct spi_device
 	at25->nvmem_config.priv = at25;
 	at25->nvmem_config.stride = 1;
 	at25->nvmem_config.word_size = 1;
-	at25->nvmem_config.size = chip.byte_len;
+	at25->nvmem_config.size = at25->chip.byte_len;
 
 	at25->nvmem = devm_nvmem_register(&spi->dev, &at25->nvmem_config);
 	if (IS_ERR(at25->nvmem))
 		return PTR_ERR(at25->nvmem);
 
 	dev_info(&spi->dev, "%d %s %s %s%s, pagesize %u\n",
-		 (chip.byte_len < 1024) ? chip.byte_len : (chip.byte_len / 1024),
-		 (chip.byte_len < 1024) ? "Byte" : "KByte",
+		 (at25->chip.byte_len < 1024) ?
+			at25->chip.byte_len : (at25->chip.byte_len / 1024),
+		 (at25->chip.byte_len < 1024) ? "Byte" : "KByte",
 		 at25->chip.name, is_fram ? "fram" : "eeprom",
-		 (chip.flags & EE_READONLY) ? " (readonly)" : "",
+		 (at25->chip.flags & EE_READONLY) ? " (readonly)" : "",
 		 at25->chip.page_size);
 	return 0;
 }


