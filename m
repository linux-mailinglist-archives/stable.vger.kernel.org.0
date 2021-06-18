Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397513AC3F3
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 08:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbhFRGe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 02:34:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231553AbhFRGe5 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Fri, 18 Jun 2021 02:34:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED7A961004;
        Fri, 18 Jun 2021 06:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623997967;
        bh=bojAuRY/3FUmxU6HJSdD9L9PDTWx/9mPfJhd2nJWj/U=;
        h=Subject:To:From:Date:From;
        b=EReEJ7PWFuUvH0WM7JwJc2dnCj+8+lm9/yC2oOocAiL7ZfkrYcaNTiH544xL00B9i
         15X5CuriUZxqb9Mi2X3P2BvfPk3m3yt5AM69U2Gx/kOk/ENwOxHHjwUVtnfyIc/9mf
         LqtPzwvmR35OotAn+lSg4J3jSIZl7FZj0mI8hNHo=
Subject: patch "iio: accel: bma180: Fix BMA25x bandwidth register values" added to staging-next
To:     stephan@gerhold.net, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, linus.walleij@linaro.org, pmeerw@pmeerw.net
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Jun 2021 08:31:05 +0200
Message-ID: <162399786510897@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: accel: bma180: Fix BMA25x bandwidth register values

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 8090d67421ddab0ae932abab5a60200598bf0bbb Mon Sep 17 00:00:00 2001
From: Stephan Gerhold <stephan@gerhold.net>
Date: Wed, 26 May 2021 11:44:07 +0200
Subject: iio: accel: bma180: Fix BMA25x bandwidth register values
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
---
 drivers/iio/accel/bma180.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/accel/bma180.c b/drivers/iio/accel/bma180.c
index 4a07e60c0e21..e7c6b3096cb7 100644
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
@@ -287,7 +289,8 @@ static int bma180_set_bw(struct bma180_data *data, int val)
 	for (i = 0; i < data->part_info->num_bw; ++i) {
 		if (data->part_info->bw_table[i] == val) {
 			ret = bma180_set_bits(data, data->part_info->bw_reg,
-				data->part_info->bw_mask, i);
+				data->part_info->bw_mask,
+				i + data->part_info->bw_offset);
 			if (ret) {
 				dev_err(&data->client->dev,
 					"failed to set bandwidth\n");
@@ -880,6 +883,7 @@ static const struct bma180_part_info bma180_part_info[] = {
 		.sleep_mask = BMA250_SUSPEND_MASK,
 		.bw_reg = BMA250_BW_REG,
 		.bw_mask = BMA250_BW_MASK,
+		.bw_offset = BMA250_BW_OFFSET,
 		.scale_reg = BMA250_RANGE_REG,
 		.scale_mask = BMA250_RANGE_MASK,
 		.power_reg = BMA250_POWER_REG,
@@ -909,6 +913,7 @@ static const struct bma180_part_info bma180_part_info[] = {
 		.sleep_mask = BMA254_SUSPEND_MASK,
 		.bw_reg = BMA254_BW_REG,
 		.bw_mask = BMA254_BW_MASK,
+		.bw_offset = BMA254_BW_OFFSET,
 		.scale_reg = BMA254_RANGE_REG,
 		.scale_mask = BMA254_RANGE_MASK,
 		.power_reg = BMA254_POWER_REG,
-- 
2.32.0


