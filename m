Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF606DE256
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 19:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjDKRVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 13:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjDKRVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 13:21:23 -0400
X-Greylist: delayed 1033 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 11 Apr 2023 10:21:21 PDT
Received: from www.linuxtv.org (www.linuxtv.org [130.149.80.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B943122
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 10:21:21 -0700 (PDT)
Received: from hverkuil by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <hverkuil@linuxtv.org>)
        id 1pmHPb-00Gs2a-4l; Tue, 11 Apr 2023 17:04:07 +0000
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Date:   Tue, 11 Apr 2023 16:54:00 +0000
Subject: [git:media_stage/master] media: ov8856: Do not check for for module version
To:     linuxtv-commits@linuxtv.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1pmHPb-00Gs2a-4l@www.linuxtv.org>
X-Spam-Status: No, score=-2.0 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: ov8856: Do not check for for module version
Author:  Ricardo Ribalda <ribalda@chromium.org>
Date:    Thu Mar 23 23:44:20 2023 +0100

It the device is probed in non-zero ACPI D state, the module
identification is delayed until the first streamon.

The module identification has two parts: deviceID and version. To rea
the version we have to enable OTP read. This cannot be done during
streamon, becase it modifies REG_MODE_SELECT.

Since the driver has the same behaviour for all the module versions, do
not read the module version from the sensor's OTP.

Cc: stable@vger.kernel.org
Fixes: 0e014f1a8d54 ("media: ov8856: support device probe in non-zero ACPI D state")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

 drivers/media/i2c/ov8856.c | 40 ----------------------------------------
 1 file changed, 40 deletions(-)

---

diff --git a/drivers/media/i2c/ov8856.c b/drivers/media/i2c/ov8856.c
index cf8384e09413..b5c7881383ca 100644
--- a/drivers/media/i2c/ov8856.c
+++ b/drivers/media/i2c/ov8856.c
@@ -1709,46 +1709,6 @@ static int ov8856_identify_module(struct ov8856 *ov8856)
 		return -ENXIO;
 	}
 
-	ret = ov8856_write_reg(ov8856, OV8856_REG_MODE_SELECT,
-			       OV8856_REG_VALUE_08BIT, OV8856_MODE_STREAMING);
-	if (ret)
-		return ret;
-
-	ret = ov8856_write_reg(ov8856, OV8856_OTP_MODE_CTRL,
-			       OV8856_REG_VALUE_08BIT, OV8856_OTP_MODE_AUTO);
-	if (ret) {
-		dev_err(&client->dev, "failed to set otp mode");
-		return ret;
-	}
-
-	ret = ov8856_write_reg(ov8856, OV8856_OTP_LOAD_CTRL,
-			       OV8856_REG_VALUE_08BIT,
-			       OV8856_OTP_LOAD_CTRL_ENABLE);
-	if (ret) {
-		dev_err(&client->dev, "failed to enable load control");
-		return ret;
-	}
-
-	ret = ov8856_read_reg(ov8856, OV8856_MODULE_REVISION,
-			      OV8856_REG_VALUE_08BIT, &val);
-	if (ret) {
-		dev_err(&client->dev, "failed to read module revision");
-		return ret;
-	}
-
-	dev_info(&client->dev, "OV8856 revision %x (%s) at address 0x%02x\n",
-		 val,
-		 val == OV8856_2A_MODULE ? "2A" :
-		 val == OV8856_1B_MODULE ? "1B" : "unknown revision",
-		 client->addr);
-
-	ret = ov8856_write_reg(ov8856, OV8856_REG_MODE_SELECT,
-			       OV8856_REG_VALUE_08BIT, OV8856_MODE_STANDBY);
-	if (ret) {
-		dev_err(&client->dev, "failed to exit streaming mode");
-		return ret;
-	}
-
 	ov8856->identified = true;
 
 	return 0;
