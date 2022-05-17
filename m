Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281A7529C04
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 10:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242826AbiEQIOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 04:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242998AbiEQIN3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 04:13:29 -0400
Received: from www.linuxtv.org (www.linuxtv.org [130.149.80.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C00F49924
        for <stable@vger.kernel.org>; Tue, 17 May 2022 01:12:36 -0700 (PDT)
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1nqsJm-00FM41-Md; Tue, 17 May 2022 08:12:34 +0000
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Tue, 17 May 2022 07:07:03 +0000
Subject: [git:media_stage/master] media: i2c: imx412: Fix reset GPIO polarity
To:     linuxtv-commits@linuxtv.org
Cc:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Jacopo Mondi <jacopo@jmondi.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1nqsJm-00FM41-Md@www.linuxtv.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: i2c: imx412: Fix reset GPIO polarity
Author:  Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Date:    Fri Apr 15 13:59:51 2022 +0200

The imx412/imx577 sensor has a reset line that is active low not active
high. Currently the logic for this is inverted.

The right way to define the reset line is to declare it active low in the
DTS and invert the logic currently contained in the driver.

The DTS should represent the hardware does i.e. reset is active low.
So:
+               reset-gpios = <&tlmm 78 GPIO_ACTIVE_LOW>;
not:
-               reset-gpios = <&tlmm 78 GPIO_ACTIVE_HIGH>;

I was a bit reticent about changing this logic since I thought it might
negatively impact @intel.com users. Googling a bit though I believe this
sensor is used on "Keem Bay" which is clearly a DTS based system and is not
upstream yet.

Fixes: 9214e86c0cc1 ("media: i2c: Add imx412 camera sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
Reviewed-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

 drivers/media/i2c/imx412.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

---

diff --git a/drivers/media/i2c/imx412.c b/drivers/media/i2c/imx412.c
index be3f6ea55559..e6be6b4250f5 100644
--- a/drivers/media/i2c/imx412.c
+++ b/drivers/media/i2c/imx412.c
@@ -1011,7 +1011,7 @@ static int imx412_power_on(struct device *dev)
 	struct imx412 *imx412 = to_imx412(sd);
 	int ret;
 
-	gpiod_set_value_cansleep(imx412->reset_gpio, 1);
+	gpiod_set_value_cansleep(imx412->reset_gpio, 0);
 
 	ret = clk_prepare_enable(imx412->inclk);
 	if (ret) {
@@ -1024,7 +1024,7 @@ static int imx412_power_on(struct device *dev)
 	return 0;
 
 error_reset:
-	gpiod_set_value_cansleep(imx412->reset_gpio, 0);
+	gpiod_set_value_cansleep(imx412->reset_gpio, 1);
 
 	return ret;
 }
@@ -1040,7 +1040,7 @@ static int imx412_power_off(struct device *dev)
 	struct v4l2_subdev *sd = dev_get_drvdata(dev);
 	struct imx412 *imx412 = to_imx412(sd);
 
-	gpiod_set_value_cansleep(imx412->reset_gpio, 0);
+	gpiod_set_value_cansleep(imx412->reset_gpio, 1);
 
 	clk_disable_unprepare(imx412->inclk);
 
