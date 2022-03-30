Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A872E4EC1F2
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244749AbiC3L5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345824AbiC3LzE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:55:04 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0406F26480A;
        Wed, 30 Mar 2022 04:51:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5EACDCE1C71;
        Wed, 30 Mar 2022 11:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98ADC36AE3;
        Wed, 30 Mar 2022 11:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641105;
        bh=dJPumnA6KTq5umrU0fNyR0/UzVzoQ2sShZxOvbIk0d0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PxTbFSoQxvAVxOXtMojvOpiOqvbdTMTOYm/iI035R1xYGprh5zS6H2hkGEjq8dghR
         /IU0mgXzdVlBAuge0GpJP6XCA7WoRRH4kyGJrbkQV3391YnjpQ5E1sq9Mu5MbXkyXw
         CVzftlByLeojHtpzA9UDjBuwh8/5jwSZ4VjbhvmKA8SWZUOGGYXYLnjLRqnFvxYUNJ
         pSmXVJD786H9a2k+kamFbGaU9mIZSM9I+lfbFN7pLbAbSzhbm4bZZnioIht8C7bYeM
         7qDunKFxKHxGpANYn+SUmLRSrAbrQIY16EOfRN/rjRgtw6L1rk3+aIqhq6dcdRhEfi
         ujAmUm9FmT3fw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.10 13/37] media: atomisp_gmin_platform: Add DMI quirk to not turn AXP ELDO2 regulator off on some boards
Date:   Wed, 30 Mar 2022 07:50:58 -0400
Message-Id: <20220330115122.1671763-13-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115122.1671763-1-sashal@kernel.org>
References: <20220330115122.1671763-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 2c39a01154ea57d596470afa1d278e3be3b37f6a ]

The TrekStor SurfTab duo W1 10.1 has a hw bug where turning eldo2 back on
after having turned it off causes the CPLM3218 ambient-light-sensor on
the front camera sensor's I2C bus to crash, hanging the bus.

Add a DMI quirk table for systems on which to leave eldo2 on.

Note an alternative fix is to turn off the CPLM3218 ambient-light-sensor
as long as the camera sensor is being used, this is what Windows seems
to do as a workaround (based on analyzing the DSDT). But that is not
easy to do cleanly under Linux.

Link: https://lore.kernel.org/linux-media/20220116215204.307649-10-hdegoede@redhat.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/atomisp/pci/atomisp_gmin_platform.c  | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/pci/atomisp_gmin_platform.c
index 34480ca16474..c9ee85037644 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_gmin_platform.c
@@ -729,6 +729,21 @@ static int axp_regulator_set(struct device *dev, struct gmin_subdev *gs,
 	return 0;
 }
 
+/*
+ * Some boards contain a hw-bug where turning eldo2 back on after having turned
+ * it off causes the CPLM3218 ambient-light-sensor on the image-sensor's I2C bus
+ * to crash, hanging the bus. Do not turn eldo2 off on these systems.
+ */
+static const struct dmi_system_id axp_leave_eldo2_on_ids[] = {
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TrekStor"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "SurfTab duo W1 10.1 (VT4)"),
+		},
+	},
+	{ }
+};
+
 static int axp_v1p8_on(struct device *dev, struct gmin_subdev *gs)
 {
 	int ret;
@@ -763,6 +778,9 @@ static int axp_v1p8_off(struct device *dev, struct gmin_subdev *gs)
 	if (ret)
 		return ret;
 
+	if (dmi_check_system(axp_leave_eldo2_on_ids))
+		return 0;
+
 	ret = axp_regulator_set(dev, gs, gs->eldo2_sel_reg, gs->eldo2_1p8v,
 				ELDO_CTRL_REG, gs->eldo2_ctrl_shift, false);
 	return ret;
-- 
2.34.1

