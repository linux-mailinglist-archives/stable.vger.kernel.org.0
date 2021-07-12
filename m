Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735D33C50FB
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345013AbhGLHgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346696AbhGLHeT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:34:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEE9C613E0;
        Mon, 12 Jul 2021 07:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075072;
        bh=HtTGf5KnrovaUHmzR0sqHT16Xs/f/f2D5nlTR5SEGmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lza4jLrncArEccwAk+lfK01SjpTvWAvt1Ie0+q25Csl9Gf4oCBRaHug22iy/P1/19
         MnJGed6MF747akovE2HuQfHRNOIxku1wdQ4in7FD5CKVIuIR78fX1aHmfXVaweG4u/
         0Fc0+gjtdzo1MoWhZ2paLWomenMokQQdNUJYYQgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Stephan Gerhold <stephan@gerhold.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.13 096/800] iio: accel: bma180: Fix BMA25x bandwidth register values
Date:   Mon, 12 Jul 2021 08:01:59 +0200
Message-Id: <20210712060926.557502902@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

commit 8090d67421ddab0ae932abab5a60200598bf0bbb upstream.

According to the BMA253 datasheet [1] and BMA250 datasheet [2] the
bandwidth value for BMA25x should be set as 01xxx:

  "Settings 00xxx result in a bandwidth of 7.81 Hz; [...]
   It is recommended [...] to use the range from ´01000b´ to ´01111b´
   only in order to be compatible with future products."

However, at the moment the drivers sets bandwidth values from 0 to 6,
which is not recommended and always results into 7.81 Hz bandwidth
according to the datasheet.

Fix this by introducing a bw_offset = 8 = 01000b for BMA25x,
so the additional bit is always set for BMA25x.

[1]: https://www.bosch-sensortec.com/media/boschsensortec/downloads/datasheets/bst-bma253-ds000.pdf
[2]: https://datasheet.octopart.com/BMA250-Bosch-datasheet-15540103.pdf

Cc: Peter Meerwald <pmeerw@pmeerw.net>
Fixes: 2017cff24cc0 ("iio:bma180: Add BMA250 chip support")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20210526094408.34298-2-stephan@gerhold.net
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/accel/bma180.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/iio/accel/bma180.c
+++ b/drivers/iio/accel/bma180.c
@@ -55,7 +55,7 @@ struct bma180_part_info {
 
 	u8 int_reset_reg, int_reset_mask;
 	u8 sleep_reg, sleep_mask;
-	u8 bw_reg, bw_mask;
+	u8 bw_reg, bw_mask, bw_offset;
 	u8 scale_reg, scale_mask;
 	u8 power_reg, power_mask, lowpower_val;
 	u8 int_enable_reg, int_enable_mask;
@@ -127,6 +127,7 @@ struct bma180_part_info {
 
 #define BMA250_RANGE_MASK	GENMASK(3, 0) /* Range of accel values */
 #define BMA250_BW_MASK		GENMASK(4, 0) /* Accel bandwidth */
+#define BMA250_BW_OFFSET	8
 #define BMA250_SUSPEND_MASK	BIT(7) /* chip will sleep */
 #define BMA250_LOWPOWER_MASK	BIT(6)
 #define BMA250_DATA_INTEN_MASK	BIT(4)
@@ -143,6 +144,7 @@ struct bma180_part_info {
 
 #define BMA254_RANGE_MASK	GENMASK(3, 0) /* Range of accel values */
 #define BMA254_BW_MASK		GENMASK(4, 0) /* Accel bandwidth */
+#define BMA254_BW_OFFSET	8
 #define BMA254_SUSPEND_MASK	BIT(7) /* chip will sleep */
 #define BMA254_LOWPOWER_MASK	BIT(6)
 #define BMA254_DATA_INTEN_MASK	BIT(4)
@@ -283,7 +285,8 @@ static int bma180_set_bw(struct bma180_d
 	for (i = 0; i < data->part_info->num_bw; ++i) {
 		if (data->part_info->bw_table[i] == val) {
 			ret = bma180_set_bits(data, data->part_info->bw_reg,
-				data->part_info->bw_mask, i);
+				data->part_info->bw_mask,
+				i + data->part_info->bw_offset);
 			if (ret) {
 				dev_err(&data->client->dev,
 					"failed to set bandwidth\n");
@@ -876,6 +879,7 @@ static const struct bma180_part_info bma
 		.sleep_mask = BMA250_SUSPEND_MASK,
 		.bw_reg = BMA250_BW_REG,
 		.bw_mask = BMA250_BW_MASK,
+		.bw_offset = BMA250_BW_OFFSET,
 		.scale_reg = BMA250_RANGE_REG,
 		.scale_mask = BMA250_RANGE_MASK,
 		.power_reg = BMA250_POWER_REG,
@@ -905,6 +909,7 @@ static const struct bma180_part_info bma
 		.sleep_mask = BMA254_SUSPEND_MASK,
 		.bw_reg = BMA254_BW_REG,
 		.bw_mask = BMA254_BW_MASK,
+		.bw_offset = BMA254_BW_OFFSET,
 		.scale_reg = BMA254_RANGE_REG,
 		.scale_mask = BMA254_RANGE_MASK,
 		.power_reg = BMA254_POWER_REG,


