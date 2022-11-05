Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB5B61D965
	for <lists+stable@lfdr.de>; Sat,  5 Nov 2022 11:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiKEKdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Nov 2022 06:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKEKdH (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sat, 5 Nov 2022 06:33:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213D41AD8A
        for <Stable@vger.kernel.org>; Sat,  5 Nov 2022 03:33:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C132CB8165F
        for <Stable@vger.kernel.org>; Sat,  5 Nov 2022 10:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1199FC433C1;
        Sat,  5 Nov 2022 10:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667644384;
        bh=H36nMjBiWMcQe2MxmY03Jan1YctHvo/uhSSy/pgtX9s=;
        h=Subject:To:From:Date:From;
        b=GqUJkTCb0qYQMc3gzbDSRkxnSdE8m/Goik6nWFeHZ1mgwSKeP7oHKw9yJpvfjfB5B
         H4p74IAuu/WjvNsEEiyb10J6oWYmWmzdlNEnH6Bn6dfSFssjt4NUh07fq/jF6owsHa
         M98orq/XVel/3IwBO9IhBaKM8WwC/ZJZjSJu22u4=
Subject: patch "iio: accel: bma400: Ensure VDDIO is enable defore reading the chip" added to char-misc-linus
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        dan@dlrobertson.com
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Nov 2022 11:32:59 +0100
Message-ID: <1667644379235145@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: accel: bma400: Ensure VDDIO is enable defore reading the chip

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 57572cacd36e6d4be7722d7770d23f4430219827 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Sun, 2 Oct 2022 15:41:33 +0100
Subject: iio: accel: bma400: Ensure VDDIO is enable defore reading the chip
 ID.

The regulator enables were after the check on the chip variant, which was
very unlikely to return a correct value when not powered.
Presumably all the device anyone is testing on have a regulator that
is already powered up when this code runs for reasons beyond the scope
of this driver. Move the read call down a few lines.

Fixes: 3cf7ded15e40 ("iio: accel: bma400: basic regulator support")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dan Robertson <dan@dlrobertson.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221002144133.3771029-1-jic23@kernel.org
---
 drivers/iio/accel/bma400_core.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/iio/accel/bma400_core.c b/drivers/iio/accel/bma400_core.c
index ad8fce3e08cd..490c342ef72a 100644
--- a/drivers/iio/accel/bma400_core.c
+++ b/drivers/iio/accel/bma400_core.c
@@ -869,18 +869,6 @@ static int bma400_init(struct bma400_data *data)
 	unsigned int val;
 	int ret;
 
-	/* Try to read chip_id register. It must return 0x90. */
-	ret = regmap_read(data->regmap, BMA400_CHIP_ID_REG, &val);
-	if (ret) {
-		dev_err(data->dev, "Failed to read chip id register\n");
-		return ret;
-	}
-
-	if (val != BMA400_ID_REG_VAL) {
-		dev_err(data->dev, "Chip ID mismatch\n");
-		return -ENODEV;
-	}
-
 	data->regulators[BMA400_VDD_REGULATOR].supply = "vdd";
 	data->regulators[BMA400_VDDIO_REGULATOR].supply = "vddio";
 	ret = devm_regulator_bulk_get(data->dev,
@@ -906,6 +894,18 @@ static int bma400_init(struct bma400_data *data)
 	if (ret)
 		return ret;
 
+	/* Try to read chip_id register. It must return 0x90. */
+	ret = regmap_read(data->regmap, BMA400_CHIP_ID_REG, &val);
+	if (ret) {
+		dev_err(data->dev, "Failed to read chip id register\n");
+		return ret;
+	}
+
+	if (val != BMA400_ID_REG_VAL) {
+		dev_err(data->dev, "Chip ID mismatch\n");
+		return -ENODEV;
+	}
+
 	ret = bma400_get_power_mode(data);
 	if (ret) {
 		dev_err(data->dev, "Failed to get the initial power-mode\n");
-- 
2.38.1


