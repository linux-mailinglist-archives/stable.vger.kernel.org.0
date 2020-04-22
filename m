Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAC51B40B1
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbgDVKrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:47:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729010AbgDVKP5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:15:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE3052075A;
        Wed, 22 Apr 2020 10:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550556;
        bh=SbJ/jaCJ3OrrVtjET4HQ68htaBYLYMg22O0Pj/OIO/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b0d98bbJWDe6pSD+pC0m3Hos7K4lFCTdmU4ucIT3vu+0fNg8yrbnGF/OYSOhbC5FJ
         5p5JUjhHSwj2fCD8DEvlyo57YiCkJ6mTkWYpi0EwsODuz+UUCodL2UkT6dLS3kzhzn
         NLByAF/Ku/vpVpyeXJV+ANx3lOBcw2puFZ4PWmRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Goyette <simon.goyette@gmail.com>,
        =?UTF-8?q?Maxime=20Roussin-B=C3=A9langer?= 
        <maxime.roussinbelanger@gmail.com>,
        Guillaume Champagne <champagne.guillaume.c@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 57/64] iio: si1133: read 24-bit signed integer for measurement
Date:   Wed, 22 Apr 2020 11:57:41 +0200
Message-Id: <20200422095023.323074129@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095008.799686511@linuxfoundation.org>
References: <20200422095008.799686511@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Roussin-Bélanger <maxime.roussinbelanger@gmail.com>

commit 328b50e9a0ad1fe8accdf8c19923deebab5e0c01 upstream.

The chip is configured in 24 bit mode. The values read from
it must always be treated as is. This fixes the issue by
replacing the previous 16 bits value by a 24 bits buffer.

This changes affects the value output by previous version of
the driver, since the least significant byte was missing.
The upper half of 16 bit values previously output are now
the upper half of a 24 bit value.

Fixes: e01e7eaf37d8 ("iio: light: introduce si1133")

Reported-by: Simon Goyette <simon.goyette@gmail.com>
Co-authored-by: Guillaume Champagne <champagne.guillaume.c@gmail.com>
Signed-off-by: Maxime Roussin-Bélanger <maxime.roussinbelanger@gmail.com>
Signed-off-by: Guillaume Champagne <champagne.guillaume.c@gmail.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/light/si1133.c |   37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

--- a/drivers/iio/light/si1133.c
+++ b/drivers/iio/light/si1133.c
@@ -102,6 +102,9 @@
 #define SI1133_INPUT_FRACTION_LOW	15
 #define SI1133_LUX_OUTPUT_FRACTION	12
 #define SI1133_LUX_BUFFER_SIZE		9
+#define SI1133_MEASURE_BUFFER_SIZE	3
+
+#define SI1133_SIGN_BIT_INDEX 23
 
 static const int si1133_scale_available[] = {
 	1, 2, 4, 8, 16, 32, 64, 128};
@@ -234,13 +237,13 @@ static const struct si1133_lux_coeff lux
 	}
 };
 
-static int si1133_calculate_polynomial_inner(u32 input, u8 fraction, u16 mag,
+static int si1133_calculate_polynomial_inner(s32 input, u8 fraction, u16 mag,
 					     s8 shift)
 {
 	return ((input << fraction) / mag) << shift;
 }
 
-static int si1133_calculate_output(u32 x, u32 y, u8 x_order, u8 y_order,
+static int si1133_calculate_output(s32 x, s32 y, u8 x_order, u8 y_order,
 				   u8 input_fraction, s8 sign,
 				   const struct si1133_coeff *coeffs)
 {
@@ -276,7 +279,7 @@ static int si1133_calculate_output(u32 x
  * The algorithm is from:
  * https://siliconlabs.github.io/Gecko_SDK_Doc/efm32zg/html/si1133_8c_source.html#l00716
  */
-static int si1133_calc_polynomial(u32 x, u32 y, u8 input_fraction, u8 num_coeff,
+static int si1133_calc_polynomial(s32 x, s32 y, u8 input_fraction, u8 num_coeff,
 				  const struct si1133_coeff *coeffs)
 {
 	u8 x_order, y_order;
@@ -614,7 +617,7 @@ static int si1133_measure(struct si1133_
 {
 	int err;
 
-	__be16 resp;
+	u8 buffer[SI1133_MEASURE_BUFFER_SIZE];
 
 	err = si1133_set_adcmux(data, 0, chan->channel);
 	if (err)
@@ -625,12 +628,13 @@ static int si1133_measure(struct si1133_
 	if (err)
 		return err;
 
-	err = si1133_bulk_read(data, SI1133_REG_HOSTOUT(0), sizeof(resp),
-			       (u8 *)&resp);
+	err = si1133_bulk_read(data, SI1133_REG_HOSTOUT(0), sizeof(buffer),
+			       buffer);
 	if (err)
 		return err;
 
-	*val = be16_to_cpu(resp);
+	*val = sign_extend32((buffer[0] << 16) | (buffer[1] << 8) | buffer[2],
+			     SI1133_SIGN_BIT_INDEX);
 
 	return err;
 }
@@ -704,9 +708,9 @@ static int si1133_get_lux(struct si1133_
 {
 	int err;
 	int lux;
-	u32 high_vis;
-	u32 low_vis;
-	u32 ir;
+	s32 high_vis;
+	s32 low_vis;
+	s32 ir;
 	u8 buffer[SI1133_LUX_BUFFER_SIZE];
 
 	/* Activate lux channels */
@@ -719,9 +723,16 @@ static int si1133_get_lux(struct si1133_
 	if (err)
 		return err;
 
-	high_vis = (buffer[0] << 16) | (buffer[1] << 8) | buffer[2];
-	low_vis = (buffer[3] << 16) | (buffer[4] << 8) | buffer[5];
-	ir = (buffer[6] << 16) | (buffer[7] << 8) | buffer[8];
+	high_vis =
+		sign_extend32((buffer[0] << 16) | (buffer[1] << 8) | buffer[2],
+			      SI1133_SIGN_BIT_INDEX);
+
+	low_vis =
+		sign_extend32((buffer[3] << 16) | (buffer[4] << 8) | buffer[5],
+			      SI1133_SIGN_BIT_INDEX);
+
+	ir = sign_extend32((buffer[6] << 16) | (buffer[7] << 8) | buffer[8],
+			   SI1133_SIGN_BIT_INDEX);
 
 	if (high_vis > SI1133_ADC_THRESHOLD || ir > SI1133_ADC_THRESHOLD)
 		lux = si1133_calc_polynomial(high_vis, ir,


