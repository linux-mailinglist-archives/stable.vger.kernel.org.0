Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E326263211A
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 12:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbiKULqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 06:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbiKULqd (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 21 Nov 2022 06:46:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F1C1115B
        for <Stable@vger.kernel.org>; Mon, 21 Nov 2022 03:46:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CE6E6112C
        for <Stable@vger.kernel.org>; Mon, 21 Nov 2022 11:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A721C433D6;
        Mon, 21 Nov 2022 11:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669031186;
        bh=FtzCKHfhQonle2tPKfgXbuFsN0R7S1cS0/zski6T6LA=;
        h=Subject:To:Cc:From:Date:From;
        b=0gzTJs8FNabIA3xpWfl4w6kYPgBH6iE2YjMCrUowxOMzQxD5O7wmpVOsrkMcxJGPr
         pnxKVKjOp+emRsgJu+2Jym3XmdlCle7pRhvvo7h3gGgkGZy9oMFTY2Fz1SIsWXVd41
         kb404a50hcFESj3fRlqRGProkjyMDK542tH8OdEM=
Subject: FAILED: patch "[PATCH] iio: accel: bma400: Ensure VDDIO is enable defore reading the" failed to apply to 5.10-stable tree
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        dan@dlrobertson.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Nov 2022 12:46:14 +0100
Message-ID: <16690311742213@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

57572cacd36e ("iio: accel: bma400: Ensure VDDIO is enable defore reading the chip ID.")
12c99f859fd3 ("iio: accel: bma400: conversion to device-managed function")
02e2af20f4f9 ("Merge tag 'char-misc-5.18-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 57572cacd36e6d4be7722d7770d23f4430219827 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Sun, 2 Oct 2022 15:41:33 +0100
Subject: [PATCH] iio: accel: bma400: Ensure VDDIO is enable defore reading the
 chip ID.

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

