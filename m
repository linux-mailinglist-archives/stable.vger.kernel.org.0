Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A99A328E9A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241993AbhCATeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:34:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:48628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241711AbhCAT2u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:28:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7DE464F62;
        Mon,  1 Mar 2021 17:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620126;
        bh=3Mc4cA98KQnMxG8KFclS80cMHAKi4ZGfXjeSx4pzjQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pljif0cNidPC0IYS86n/KKbjtmyUh/WtjIrLmhIbD/DhgKEXSaMrNJVt2EMdGOwBF
         PHpSoFk+n7gRL9XHCIQTwok9NeyLy7eoqTm1YcuwoG5+5/iw/DerikD0tqEFmcJsHa
         GEj+RzArunrIi8HKD9rSSgAnlnIkkpv99X7rXVcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Marciniak?= <sunwire@gmail.com>,
        Ivan Zaentsev <ivan.zaentsev@wirenboard.ru>
Subject: [PATCH 5.11 009/775] w1: w1_therm: Fix conversion result for negative temperatures
Date:   Mon,  1 Mar 2021 17:02:57 +0100
Message-Id: <20210301161202.160848892@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Zaentsev <ivan.zaentsev@wirenboard.ru>

commit 2f6055c26f1913763eabc66c7c27d0693561e966 upstream.

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
 drivers/w1/slaves/w1_therm.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -667,28 +667,24 @@ static inline int w1_DS18B20_get_resolut
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


