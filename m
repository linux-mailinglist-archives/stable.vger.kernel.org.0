Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453D0307659
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 13:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbhA1Mqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 07:46:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:57974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231463AbhA1Mqv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 07:46:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0403864DE1;
        Thu, 28 Jan 2021 12:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611837970;
        bh=ty6wkOEMMOaoZ4E16UFph43OUwEn/9AtaxpUS/K5uWo=;
        h=Subject:To:From:Date:From;
        b=aocZqLsvdJUnMtnxUf0k7uL41TGfYca7eNPEHVvziU8Wb+auEJJLSZD9WBJac3HAW
         JAyme+iLnv4yJNnl+ZcUq+DD4muaAP3T6u9zifg1A1Rjfslcxd+xe6AA4JNgF0Zwuh
         pxV++oa7D8qRBckH3FyZf6i2x8RdBMXzM7mnT4U4=
Subject: patch "w1: w1_therm: Fix conversion result for negative temperatures" added to char-misc-next
To:     ivan.zaentsev@wirenboard.ru, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, sunwire@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 28 Jan 2021 13:45:39 +0100
Message-ID: <1611837939116247@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    w1: w1_therm: Fix conversion result for negative temperatures

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 2f6055c26f1913763eabc66c7c27d0693561e966 Mon Sep 17 00:00:00 2001
From: Ivan Zaentsev <ivan.zaentsev@wirenboard.ru>
Date: Thu, 21 Jan 2021 12:30:21 +0300
Subject: w1: w1_therm: Fix conversion result for negative temperatures
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

DS18B20 device driver returns an incorrect value for negative temperatures
due to a missing sign-extension in w1_DS18B20_convert_temp().

Fix by using s16 temperature value when converting to int.

Fixes: 9ace0b4dab1c (w1: w1_therm: Add support for GXCAS GX20MH01 device.)
Cc: stable <stable@vger.kernel.org>
Reported-by: Paweł Marciniak <sunwire@gmail.com>
Signed-off-by: Ivan Zaentsev <ivan.zaentsev@wirenboard.ru>
Link: https://lore.kernel.org/r/20210121093021.224764-1-ivan.zaentsev@wirenboard.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/slaves/w1_therm.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index 3712b1e6dc71..976eea28f268 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -667,28 +667,24 @@ static inline int w1_DS18B20_get_resolution(struct w1_slave *sl)
  */
 static inline int w1_DS18B20_convert_temp(u8 rom[9])
 {
-	int t;
-	u32 bv;
+	u16 bv;
+	s16 t;
+
+	/* Signed 16-bit value to unsigned, cpu order */
+	bv = le16_to_cpup((__le16 *)rom);
 
 	/* Config register bit R2 = 1 - GX20MH01 in 13 or 14 bit resolution mode */
 	if (rom[4] & 0x80) {
-		/* Signed 16-bit value to unsigned, cpu order */
-		bv = le16_to_cpup((__le16 *)rom);
-
 		/* Insert two temperature bits from config register */
 		/* Avoid arithmetic shift of signed value */
 		bv = (bv << 2) | (rom[4] & 3);
-
-		t = (int) sign_extend32(bv, 17); /* Degrees, lowest bit is 2^-6 */
-		return (t*1000)/64;  /* Millidegrees */
+		t = (s16) bv;	/* Degrees, lowest bit is 2^-6 */
+		return (int)t * 1000 / 64;	/* Sign-extend to int; millidegrees */
 	}
-
-	t = (int)le16_to_cpup((__le16 *)rom);
-	return t*1000/16;
+	t = (s16)bv;	/* Degrees, lowest bit is 2^-4 */
+	return (int)t * 1000 / 16;	/* Sign-extend to int; millidegrees */
 }
 
-
-
 /**
  * w1_DS18S20_convert_temp() - temperature computation for DS18S20
  * @rom: data read from device RAM (8 data bytes + 1 CRC byte)
-- 
2.30.0


