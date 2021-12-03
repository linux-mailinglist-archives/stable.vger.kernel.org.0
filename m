Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FFC467818
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 14:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244156AbhLCNXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 08:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237744AbhLCNXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 08:23:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B83C06173E
        for <stable@vger.kernel.org>; Fri,  3 Dec 2021 05:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 102A2B826EF
        for <stable@vger.kernel.org>; Fri,  3 Dec 2021 13:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53563C53FAD;
        Fri,  3 Dec 2021 13:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638537616;
        bh=3uY3Q5VZ8Z/Vmb+nGzRihP+B0cgdILEH4TolkKDFCDA=;
        h=Subject:To:From:Date:From;
        b=dFvVLFBnBz1UpdJ1a5OzeDvavZogg56uiNuH2qruH6AZ1RhNGu2Br/EzuNNyQCHaK
         qrCCz2FA0kSg7kOPkCc8wSdoiQUyTBPEg+Nh7voE0KHNOC+DST45c76evyIIV/LR7y
         ltDUk3lNYVtGPFv8xBbcbgdIK7qOTStWSqRj8OtQ=
Subject: patch "nvmem: eeprom: at25: fix FRAM byte_len" added to char-misc-linus
To:     ralph.siemsen@linaro.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Dec 2021 14:20:04 +0100
Message-ID: <1638537604213144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    nvmem: eeprom: at25: fix FRAM byte_len

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9a626577398c24ecab63c0a684436c8928092367 Mon Sep 17 00:00:00 2001
From: Ralph Siemsen <ralph.siemsen@linaro.org>
Date: Mon, 8 Nov 2021 13:16:27 -0500
Subject: nvmem: eeprom: at25: fix FRAM byte_len

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
 drivers/misc/eeprom/at25.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index 632325474233..b38978a3b3ff 100644
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
@@ -389,15 +388,18 @@ static int at25_probe(struct spi_device *spi)
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
@@ -409,12 +411,7 @@ static int at25_probe(struct spi_device *spi)
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
 
@@ -431,7 +428,7 @@ static int at25_probe(struct spi_device *spi)
 			dev_err(&spi->dev, "Error: unsupported size (id %02x)\n", id[7]);
 			return -ENODEV;
 		}
-		chip.byte_len = int_pow(2, id[7] - 0x21 + 4) * 1024;
+		at25->chip.byte_len = int_pow(2, id[7] - 0x21 + 4) * 1024;
 
 		if (at25->chip.byte_len > 64 * 1024)
 			at25->chip.flags |= EE_ADDR3;
@@ -464,7 +461,7 @@ static int at25_probe(struct spi_device *spi)
 	at25->nvmem_config.type = is_fram ? NVMEM_TYPE_FRAM : NVMEM_TYPE_EEPROM;
 	at25->nvmem_config.name = dev_name(&spi->dev);
 	at25->nvmem_config.dev = &spi->dev;
-	at25->nvmem_config.read_only = chip.flags & EE_READONLY;
+	at25->nvmem_config.read_only = at25->chip.flags & EE_READONLY;
 	at25->nvmem_config.root_only = true;
 	at25->nvmem_config.owner = THIS_MODULE;
 	at25->nvmem_config.compat = true;
@@ -474,17 +471,18 @@ static int at25_probe(struct spi_device *spi)
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
-- 
2.34.1


