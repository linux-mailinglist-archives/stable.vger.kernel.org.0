Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77133AC3F9
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 08:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbhFRGfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 02:35:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231697AbhFRGf3 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Fri, 18 Jun 2021 02:35:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4B8160E08;
        Fri, 18 Jun 2021 06:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623998000;
        bh=wooSAhtnnLPTL/i3QftqVZsmHTmYOl+X+wIsQs/kAf4=;
        h=Subject:To:From:Date:From;
        b=VP+JZotw/pz+dkvqixnfTPvxzfUjgp32vvbj5EnHgo1mh4n0eSYLvNNqP8SZlOhFB
         a5jynrZcEusg9ciuGd5tks2JAVXCrvsiKDwoYXG4C3JUJQ5td3ODkXUGa6RxBOBRG/
         AJA2iwX71uhS8JrbGBrJoo0NOp4OsxxWiZgw4mxw=
Subject: patch "iio: ltr501: mark register holding upper 8 bits of ALS_DATA{0,1} and" added to staging-next
To:     mkl@pengutronix.de, Jonathan.Cameron@huawei.com,
        Oliver.Lang@gossenmetrawatt.com, Stable@vger.kernel.org,
        andy.shevchenko@gmail.com, nikita@trvn.ru
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Jun 2021 08:31:13 +0200
Message-ID: <162399787312939@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: ltr501: mark register holding upper 8 bits of ALS_DATA{0,1} and

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 2ac0b029a04b673ce83b5089368f467c5dca720c Mon Sep 17 00:00:00 2001
From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Thu, 10 Jun 2021 15:46:16 +0200
Subject: iio: ltr501: mark register holding upper 8 bits of ALS_DATA{0,1} and
 PS_DATA as volatile, too

The regmap is configured for 8 bit registers, uses a RB-Tree cache and
marks several registers as volatile (i.e. do not cache).

The ALS and PS data registers in the chip are 16 bit wide and spans
two regmap registers. In the current driver only the base register is
marked as volatile, resulting in the upper register only read once.

Further the data sheet notes:

| When the I2C read operation starts, all four ALS data registers are
| locked until the I2C read operation of register 0x8B is completed.

Which results in the registers never update after the 2nd read.

This patch fixes the problem by marking the upper 8 bits of the ALS
and PS registers as volatile, too.

Fixes: 2f2c96338afc ("iio: ltr501: Add regmap support.")
Reported-by: Oliver Lang <Oliver.Lang@gossenmetrawatt.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Tested-by: Nikita Travkin <nikita@trvn.ru> # ltr559
Link: https://lore.kernel.org/r/20210610134619.2101372-2-mkl@pengutronix.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/light/ltr501.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/iio/light/ltr501.c b/drivers/iio/light/ltr501.c
index b4323d2db0b1..0ed3392a33cf 100644
--- a/drivers/iio/light/ltr501.c
+++ b/drivers/iio/light/ltr501.c
@@ -32,9 +32,12 @@
 #define LTR501_PART_ID 0x86
 #define LTR501_MANUFAC_ID 0x87
 #define LTR501_ALS_DATA1 0x88 /* 16-bit, little endian */
+#define LTR501_ALS_DATA1_UPPER 0x89 /* upper 8 bits of LTR501_ALS_DATA1 */
 #define LTR501_ALS_DATA0 0x8a /* 16-bit, little endian */
+#define LTR501_ALS_DATA0_UPPER 0x8b /* upper 8 bits of LTR501_ALS_DATA0 */
 #define LTR501_ALS_PS_STATUS 0x8c
 #define LTR501_PS_DATA 0x8d /* 16-bit, little endian */
+#define LTR501_PS_DATA_UPPER 0x8e /* upper 8 bits of LTR501_PS_DATA */
 #define LTR501_INTR 0x8f /* output mode, polarity, mode */
 #define LTR501_PS_THRESH_UP 0x90 /* 11 bit, ps upper threshold */
 #define LTR501_PS_THRESH_LOW 0x92 /* 11 bit, ps lower threshold */
@@ -1354,9 +1357,12 @@ static bool ltr501_is_volatile_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
 	case LTR501_ALS_DATA1:
+	case LTR501_ALS_DATA1_UPPER:
 	case LTR501_ALS_DATA0:
+	case LTR501_ALS_DATA0_UPPER:
 	case LTR501_ALS_PS_STATUS:
 	case LTR501_PS_DATA:
+	case LTR501_PS_DATA_UPPER:
 		return true;
 	default:
 		return false;
-- 
2.32.0


