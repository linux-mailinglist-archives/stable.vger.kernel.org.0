Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7396C5E9153
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 09:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiIYHMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 03:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiIYHL7 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 25 Sep 2022 03:11:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C12325C5E
        for <Stable@vger.kernel.org>; Sun, 25 Sep 2022 00:11:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC0AA60B9A
        for <Stable@vger.kernel.org>; Sun, 25 Sep 2022 07:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B5FC433D6;
        Sun, 25 Sep 2022 07:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664089917;
        bh=V7tE8zOiizg0rA2VDoUhWNh+SL0LgbplurY2m7C1Z60=;
        h=Subject:To:From:Date:From;
        b=I6XmisU2qxZAtzV20Xi8mYNBpNckdYZEb28xn5VqNGffkVmd3DwXOXqqWtNrE9Oiu
         3zh4R6ETfDC5cRavF9INoo1sL+BJfgHaOHbz5WCUmBMoxzxmd5QvJlKYHa+vlJ3E2e
         JJAnPHjbS86CZu2z1UrfsikCFYYCmtD0EL0O1Pvs=
Subject: patch "iio: dac: ad5593r: Fix i2c read protocol requirements" added to char-misc-testing
To:     michael.hennerich@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, nuno.sa@analog.com
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 25 Sep 2022 09:09:56 +0200
Message-ID: <1664089796246210@kroah.com>
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


This is a note to let you know that I've just added the patch titled

    iio: dac: ad5593r: Fix i2c read protocol requirements

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 558a25f903b4af6361b7fbeea08a6446a0745653 Mon Sep 17 00:00:00 2001
From: Michael Hennerich <michael.hennerich@analog.com>
Date: Tue, 13 Sep 2022 09:34:12 +0200
Subject: iio: dac: ad5593r: Fix i2c read protocol requirements
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
---
 drivers/iio/dac/ad5593r.c | 46 +++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/iio/dac/ad5593r.c b/drivers/iio/dac/ad5593r.c
index 34e1319a9712..356dc0bab115 100644
--- a/drivers/iio/dac/ad5593r.c
+++ b/drivers/iio/dac/ad5593r.c
@@ -13,6 +13,8 @@
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
 
+#include <asm/unaligned.h>
+
 #define AD5593R_MODE_CONF		(0 << 4)
 #define AD5593R_MODE_DAC_WRITE		(1 << 4)
 #define AD5593R_MODE_ADC_READBACK	(4 << 4)
@@ -20,6 +22,24 @@
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
@@ -38,13 +58,7 @@ static int ad5593r_read_adc(struct ad5592r_state *st, unsigned chan, u16 *value)
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
@@ -58,25 +72,19 @@ static int ad5593r_reg_write(struct ad5592r_state *st, u8 reg, u16 value)
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
 
-- 
2.37.3


