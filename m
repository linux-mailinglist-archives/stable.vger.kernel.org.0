Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8350C6AF0B5
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjCGSed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:34:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbjCGSeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:34:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B98AAD000
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:26:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B317B819D8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6EF6C433A7;
        Tue,  7 Mar 2023 18:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213520;
        bh=sQcxH7vedrnRouSgE6hxqiNfNEwO3psISQDDgVQwpro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AxdVOX2qV5keiGW7XunJaDi/vaIrbOHy3pNUnntUuEKAVxBcaXs9tvNa7a5A2fHC9
         TzR6AFZ23hNgxrvsed4G5wGlqv0AAfwMFrVzCkfci9UbJ+VCymkfj+zfTpt1aYpJ3Q
         m7Im3X6m8NPbJr+FowTE0WN7RvIQvBgD8PvAUcsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nishanth Menon <nm@ti.com>,
        Jai Luthra <j-luthra@ti.com>,
        Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 505/885] media: ov5640: Handle delays when no reset_gpio set
Date:   Tue,  7 Mar 2023 17:57:19 +0100
Message-Id: <20230307170024.393710946@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jai Luthra <j-luthra@ti.com>

[ Upstream commit d7ff69139908842adf824be4f50c7e9ac5886c04 ]

Some module manufacturers [1][2] don't expose the RESETB and PWDN pins
of the sensor directly through the 15-pin FFC connector. Instead wiring
~PWDN gpio to the sensor pins with appropriate delays.

In such cases, reset_gpio will not be available to the driver, but it
will still be toggled when the sensor is powered on, and thus we should
still honor the wait time of >= 5ms + 1ms + 20ms (see figure 2-3 in [3])
before attempting any i/o operations over SCCB.

Also, rename the function to ov5640_powerup_sequence to better match the
datasheet (section 2.7).

[1] https://digilent.com/reference/_media/reference/add-ons/pcam-5c/pcam_5c_sch.pdf
[2] https://www.alinx.com/public/upload/file/AN5641_User_Manual.pdf
[3] https://cdn.sparkfun.com/datasheets/Sensors/LightImaging/OV5640_datasheet.pdf

Fixes: 19a81c1426c1 ("[media] add Omnivision OV5640 sensor driver")
Reported-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Jai Luthra <j-luthra@ti.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5640.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index f31b096e018f2..873087e180561 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2425,11 +2425,22 @@ static void ov5640_power(struct ov5640_dev *sensor, bool enable)
 	gpiod_set_value_cansleep(sensor->pwdn_gpio, enable ? 0 : 1);
 }
 
-static void ov5640_reset(struct ov5640_dev *sensor)
+/*
+ * From section 2.7 power up sequence:
+ * t0 + t1 + t2 >= 5ms	Delay from DOVDD stable to PWDN pull down
+ * t3 >= 1ms		Delay from PWDN pull down to RESETB pull up
+ * t4 >= 20ms		Delay from RESETB pull up to SCCB (i2c) stable
+ *
+ * Some modules don't expose RESETB/PWDN pins directly, instead providing a
+ * "PWUP" GPIO which is wired through appropriate delays and inverters to the
+ * pins.
+ *
+ * In such cases, this gpio should be mapped to pwdn_gpio in the driver, and we
+ * should still toggle the pwdn_gpio below with the appropriate delays, while
+ * the calls to reset_gpio will be ignored.
+ */
+static void ov5640_powerup_sequence(struct ov5640_dev *sensor)
 {
-	if (!sensor->reset_gpio)
-		return;
-
 	if (sensor->pwdn_gpio) {
 		gpiod_set_value_cansleep(sensor->reset_gpio, 0);
 
@@ -2478,8 +2489,7 @@ static int ov5640_set_power_on(struct ov5640_dev *sensor)
 		goto xclk_off;
 	}
 
-	ov5640_reset(sensor);
-	ov5640_power(sensor, true);
+	ov5640_powerup_sequence(sensor);
 
 	ret = ov5640_init_slave_id(sensor);
 	if (ret)
-- 
2.39.2



