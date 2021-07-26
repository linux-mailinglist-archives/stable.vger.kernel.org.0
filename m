Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96973D5D84
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235645AbhGZPBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:01:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235657AbhGZPBt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:01:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36BE460F38;
        Mon, 26 Jul 2021 15:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314137;
        bh=featMGWMQCoXKfBCVveHerhaITxcXAT2LQ7lco8P0B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5/FP1CIzy2Cv11cQeaWMPIseDoDXLCbvk/OcFztN3jaqTIWvNZWPHZo9L9B1J2mN
         5VyAXDLhVhbfUUzaO2fI6CEWWXxEarDpDIJMYd3Fg82aHPfipAzs4ceiDxjxv7TQf9
         emeE9yumgemcxG0q49yHhEweG6SabUrD9pRHdIBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Stephan Gerhold <stephan@gerhold.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.4 46/47] iio: accel: bma180: Fix BMA25x bandwidth register values
Date:   Mon, 26 Jul 2021 17:39:04 +0200
Message-Id: <20210726153824.424251081@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153822.980271128@linuxfoundation.org>
References: <20210726153822.980271128@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

commit 8090d67421ddab0ae932abab5a60200598bf0bbb upstream

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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/bma180.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/iio/accel/bma180.c
+++ b/drivers/iio/accel/bma180.c
@@ -49,7 +49,7 @@ struct bma180_part_info {
 
 	u8 int_reset_reg, int_reset_mask;
 	u8 sleep_reg, sleep_mask;
-	u8 bw_reg, bw_mask;
+	u8 bw_reg, bw_mask, bw_offset;
 	u8 scale_reg, scale_mask;
 	u8 power_reg, power_mask, lowpower_val;
 	u8 int_enable_reg, int_enable_mask;
@@ -105,6 +105,7 @@ struct bma180_part_info {
 
 #define BMA250_RANGE_MASK	GENMASK(3, 0) /* Range of accel values */
 #define BMA250_BW_MASK		GENMASK(4, 0) /* Accel bandwidth */
+#define BMA250_BW_OFFSET	8
 #define BMA250_SUSPEND_MASK	BIT(7) /* chip will sleep */
 #define BMA250_LOWPOWER_MASK	BIT(6)
 #define BMA250_DATA_INTEN_MASK	BIT(4)
@@ -242,7 +243,8 @@ static int bma180_set_bw(struct bma180_d
 	for (i = 0; i < data->part_info->num_bw; ++i) {
 		if (data->part_info->bw_table[i] == val) {
 			ret = bma180_set_bits(data, data->part_info->bw_reg,
-				data->part_info->bw_mask, i);
+				data->part_info->bw_mask,
+				i + data->part_info->bw_offset);
 			if (ret) {
 				dev_err(&data->client->dev,
 					"failed to set bandwidth\n");
@@ -660,6 +662,7 @@ static const struct bma180_part_info bma
 		.sleep_mask = BMA250_SUSPEND_MASK,
 		.bw_reg = BMA250_BW_REG,
 		.bw_mask = BMA250_BW_MASK,
+		.bw_offset = BMA250_BW_OFFSET,
 		.scale_reg = BMA250_RANGE_REG,
 		.scale_mask = BMA250_RANGE_MASK,
 		.power_reg = BMA250_POWER_REG,


