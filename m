Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B9760A811
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235021AbiJXNBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235318AbiJXM74 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:59:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA08816A7;
        Mon, 24 Oct 2022 05:19:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FCDC612CC;
        Mon, 24 Oct 2022 12:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F02DC433C1;
        Mon, 24 Oct 2022 12:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613108;
        bh=d2zFU1lQNCR2OxIHoZ43iXVPZ2TmY3D6P0W58UNPdaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZTl7kcxqrlZ+dssaWGOPq9ewW1UedXIkatdUNC9ITP/Y4/97k6889ERBvH5iV6lY9
         /MtyaTs62Yf9vT2FfNh6Z3ZhexLetivZQjlKNVpjug2seaLbPxZTkfMQ21v2V4Yub7
         a/xG3i0xI8kGG+oFsF0sSL/HpmA9g39cWi+pOs5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 012/255] iio: dac: ad5593r: Fix i2c read protocol requirements
Date:   Mon, 24 Oct 2022 13:28:42 +0200
Message-Id: <20221024113002.852005537@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

commit 558a25f903b4af6361b7fbeea08a6446a0745653 upstream.

For reliable operation across the full range of supported
interface rates, the AD5593R needs a STOP condition between
address write, and data read (like show in the datasheet Figure 40)
so in turn i2c_smbus_read_word_swapped cannot be used.

While at it, a simple helper was added to make the code simpler.

Fixes: 56ca9db862bf ("iio: dac: Add support for the AD5592R/AD5593R ADCs/DACs")
Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220913073413.140475-2-nuno.sa@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5593r.c |   46 +++++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 19 deletions(-)

--- a/drivers/iio/dac/ad5593r.c
+++ b/drivers/iio/dac/ad5593r.c
@@ -14,6 +14,8 @@
 #include <linux/of.h>
 #include <linux/acpi.h>
 
+#include <asm/unaligned.h>
+
 #define AD5593R_MODE_CONF		(0 << 4)
 #define AD5593R_MODE_DAC_WRITE		(1 << 4)
 #define AD5593R_MODE_ADC_READBACK	(4 << 4)
@@ -21,6 +23,24 @@
 #define AD5593R_MODE_GPIO_READBACK	(6 << 4)
 #define AD5593R_MODE_REG_READBACK	(7 << 4)
 
+static int ad5593r_read_word(struct i2c_client *i2c, u8 reg, u16 *value)
+{
+	int ret;
+	u8 buf[2];
+
+	ret = i2c_smbus_write_byte(i2c, reg);
+	if (ret < 0)
+		return ret;
+
+	ret = i2c_master_recv(i2c, buf, sizeof(buf));
+	if (ret < 0)
+		return ret;
+
+	*value = get_unaligned_be16(buf);
+
+	return 0;
+}
+
 static int ad5593r_write_dac(struct ad5592r_state *st, unsigned chan, u16 value)
 {
 	struct i2c_client *i2c = to_i2c_client(st->dev);
@@ -39,13 +59,7 @@ static int ad5593r_read_adc(struct ad559
 	if (val < 0)
 		return (int) val;
 
-	val = i2c_smbus_read_word_swapped(i2c, AD5593R_MODE_ADC_READBACK);
-	if (val < 0)
-		return (int) val;
-
-	*value = (u16) val;
-
-	return 0;
+	return ad5593r_read_word(i2c, AD5593R_MODE_ADC_READBACK, value);
 }
 
 static int ad5593r_reg_write(struct ad5592r_state *st, u8 reg, u16 value)
@@ -59,25 +73,19 @@ static int ad5593r_reg_write(struct ad55
 static int ad5593r_reg_read(struct ad5592r_state *st, u8 reg, u16 *value)
 {
 	struct i2c_client *i2c = to_i2c_client(st->dev);
-	s32 val;
-
-	val = i2c_smbus_read_word_swapped(i2c, AD5593R_MODE_REG_READBACK | reg);
-	if (val < 0)
-		return (int) val;
 
-	*value = (u16) val;
-
-	return 0;
+	return ad5593r_read_word(i2c, AD5593R_MODE_REG_READBACK | reg, value);
 }
 
 static int ad5593r_gpio_read(struct ad5592r_state *st, u8 *value)
 {
 	struct i2c_client *i2c = to_i2c_client(st->dev);
-	s32 val;
+	u16 val;
+	int ret;
 
-	val = i2c_smbus_read_word_swapped(i2c, AD5593R_MODE_GPIO_READBACK);
-	if (val < 0)
-		return (int) val;
+	ret = ad5593r_read_word(i2c, AD5593R_MODE_GPIO_READBACK, &val);
+	if (ret)
+		return ret;
 
 	*value = (u8) val;
 


