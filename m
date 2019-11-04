Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00F1EEE04E
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 13:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbfKDMoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 07:44:13 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34436 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728927AbfKDMoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 07:44:13 -0500
Received: by mail-pf1-f194.google.com with SMTP id n13so417678pff.1
        for <stable@vger.kernel.org>; Mon, 04 Nov 2019 04:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3nvCVp/ELCF7Jr2CFRQbgC/FjQFAJp3vtQW84P76ukE=;
        b=SyoF90nQtHDC28CB90BtpZHN0vOYIsUL6oMxgZknLvRLyYzqa0fsFjFXcWtqAwCA6h
         qT4XYA8gDyUWMOIURv4nIFpMae068g69LYd7fgZeNYOJdUJvVsVJgF5/xCHBIJX1wPu2
         bkRHFpTFD5YnAORcpB3UgJWraEUYRMD96pAR9V4S1KRSE/MStdVtGn6WV9ybuZa4FElz
         Us6jvWIZJaf19G2VZaz7szD3H6w3ml2rxPQeBbTejM67JaYAo1JmEyALK3iHbUAx+50f
         VSfH3QIgcFzJ1XRh7LJq2/BFaUZL+OyNW4NuK1F6xJarItQ99kwvu1tRybusUXAhvu72
         8JyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3nvCVp/ELCF7Jr2CFRQbgC/FjQFAJp3vtQW84P76ukE=;
        b=VXvx03s+lRSdxPuCnWYwrxrKaQBpMLqcIuXHriqnFM2ffNThpgOkj0PVHfjo8WIs8o
         Llk6h88hvsrc9/oQQ2wuIkURRuqMfUIoqCmbfMDimNZ4WM86JkrVZVLvPaYCwF1rtLN5
         WjJRg4A5mYrY0QQ/YlKJSXb7QUc023HF1m3DgmNumBt9S/tlQBVNDRYO3lPWTpBugLNV
         HcP17UI0UcZHTxMfRFOajJBpmUIISo8I+wVNum5xbt1vhhXUhtfQ9SZ3LgzWs46ZuLu+
         V37fChmSSci+CKXmHDcKKbilwa+LY9Y/WwBs7/VEi4iZCliQ23oMOCSLw5lNvJL5XYP7
         F3xQ==
X-Gm-Message-State: APjAAAWds5H6xPRUJ1t0AZ7GM9HV9mzxKOPasJ0c+3mwiDPPg10gm+32
        YhW9xJ+NCn7IzQxbuFs4S29buCavm4g=
X-Google-Smtp-Source: APXvYqwCjQ2tuuv6ATtgGpHn3gAc7L+jNFUYU+lCxcqQ980G4P+Cj0ZaoR96NFbVKIacSq3k5ZZt1w==
X-Received: by 2002:a63:a05c:: with SMTP id u28mr599443pgn.333.1572871451883;
        Mon, 04 Nov 2019 04:44:11 -0800 (PST)
Received: from example.com (ec2-13-228-47-58.ap-southeast-1.compute.amazonaws.com. [13.228.47.58])
        by smtp.gmail.com with ESMTPSA id y138sm16372930pfb.174.2019.11.04.04.44.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 04:44:10 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19] spi: spi-gpio: fix crash when num-chipselects is 0
Date:   Mon,  4 Nov 2019 20:44:03 +0800
Message-Id: <20191104124403.13502-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 249e2632dcd0509b8f8f296f5aabf4d48dfd6da8 upstream.

If an spi-gpio was specified with num-chipselects = <0> in dts, kernel will crash:

Unable to handle kernel paging request at virtual address 32697073
pgd = (ptrval)
[32697073] *pgd=00000000
Internal error: Oops: 5 [#1] SMP ARM
Modules linked in:
CPU: 2 PID: 1 Comm: swapper/0 Not tainted 4.19.72 #0
Hardware name: Generic DT based system
PC is at validate_desc+0x28/0x80
LR is at gpiod_direction_output+0x14/0x128
...
[<c0544db4>] (validate_desc) from [<c0545228>] (gpiod_direction_output+0x14/0x128)
[<c0545228>] (gpiod_direction_output) from [<c05fa714>] (spi_gpio_setup+0x58/0x64)
[<c05fa714>] (spi_gpio_setup) from [<c05f7258>] (spi_setup+0x12c/0x148)
[<c05f7258>] (spi_setup) from [<c05f7330>] (spi_add_device+0xbc/0x12c)
[<c05f7330>] (spi_add_device) from [<c05f7f74>] (spi_register_controller+0x838/0x924)
[<c05f7f74>] (spi_register_controller) from [<c05fa494>] (spi_bitbang_start+0x108/0x120)
[<c05fa494>] (spi_bitbang_start) from [<c05faa34>] (spi_gpio_probe+0x314/0x338)
[<c05faa34>] (spi_gpio_probe) from [<c05a844c>] (platform_drv_probe+0x34/0x70)

The cause is spi_gpio_setup() did not check if the spi-gpio has chipselect pins
before setting their direction and results in derefing an invalid pointer.

The bug is spotted in kernel 4.19.72 on OpenWrt, and does not occur in 4.14.

Fixes: 9b00bc7b901ff ("spi: spi-gpio: Rewrite to use GPIO descriptors")

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/spi/spi-gpio.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-gpio.c b/drivers/spi/spi-gpio.c
index 77838d8fd..3b7f0d077 100644
--- a/drivers/spi/spi-gpio.c
+++ b/drivers/spi/spi-gpio.c
@@ -242,10 +242,12 @@ static int spi_gpio_setup(struct spi_device *spi)
 	 * The CS GPIOs have already been
 	 * initialized from the descriptor lookup.
 	 */
-	cs = spi_gpio->cs_gpios[spi->chip_select];
-	if (!spi->controller_state && cs)
-		status = gpiod_direction_output(cs,
-						!(spi->mode & SPI_CS_HIGH));
+	if (spi_gpio->has_cs) {
+		cs = spi_gpio->cs_gpios[spi->chip_select];
+		if (!spi->controller_state && cs)
+			status = gpiod_direction_output(cs,
+						  !(spi->mode & SPI_CS_HIGH));
+	}
 
 	if (!status)
 		status = spi_bitbang_setup(spi);
-- 
2.23.0

