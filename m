Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCACB6AEB4E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbjCGRm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbjCGRmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:42:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FB799BE9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:38:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C6F961525
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:38:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623F6C4339C;
        Tue,  7 Mar 2023 17:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210702;
        bh=HfELA5bv6JNGGKsubN/vePsaoGTwJhQONqPLJajGitU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpGJdTsTptsrNCZB653hyCXNhSObtNHKhpqdbX0Z0c7hHd8IZNdKrddRR5DvfQBRt
         KP5uUZJlW31bel6XPL/cEITKR7eyx4DAxLMLF4Pd2iB/QAN2Xzu0rZIG0rH2TctOP8
         zbC5Hvj4VTt6UCiFu8wB8wTE+c/YjtokI3MaxkaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nishanth Menon <nm@ti.com>,
        Jai Luthra <j-luthra@ti.com>,
        Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0596/1001] media: ov5640: Handle delays when no reset_gpio set
Date:   Tue,  7 Mar 2023 17:56:08 +0100
Message-Id: <20230307170047.357957072@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 75dada60298b5..c159f297ab92a 100644
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



