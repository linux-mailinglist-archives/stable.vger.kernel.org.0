Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381123C4836
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235715AbhGLGhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:37:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237548AbhGLGeg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:34:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44A6961156;
        Mon, 12 Jul 2021 06:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071445;
        bh=oy3KLG7O4RGLwE+4QEYQG92pZCKMBsd6z1Ea1INhmY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WclbI/L5MwFAzJn0H07EKbQw6S1znMrKJakMGIJtmr0r7zbeLFjBUoKGO5JJyELEy
         irk5m5s0KwYHvdVra7xUhOIldnZQ0mt/vHa8NMqZQR9pEaGD0xhmNOTm2tMoxDY7xI
         YWusJfWIJjEWO46fZICs16ik6SqsnJWCvnXM+K0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oliver Lang <Oliver.Lang@gossenmetrawatt.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Nikita Travkin <nikita@trvn.ru>
Subject: [PATCH 5.10 074/593] iio: ltr501: mark register holding upper 8 bits of ALS_DATA{0,1} and PS_DATA as volatile, too
Date:   Mon, 12 Jul 2021 08:03:54 +0200
Message-Id: <20210712060851.277965899@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 2ac0b029a04b673ce83b5089368f467c5dca720c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/light/ltr501.c |    6 ++++++
 1 file changed, 6 insertions(+)

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
@@ -1354,9 +1357,12 @@ static bool ltr501_is_volatile_reg(struc
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


