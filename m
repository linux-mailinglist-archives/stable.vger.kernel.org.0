Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8382E4F398A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241757AbiDELfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353042AbiDEKFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:05:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C224BD7D9;
        Tue,  5 Apr 2022 02:54:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D4E961743;
        Tue,  5 Apr 2022 09:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4D6C385A1;
        Tue,  5 Apr 2022 09:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152450;
        bh=9kDFyJtz5aRFD1HOBnwM1kO3is+NlX0c7whwfOn5IIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eD2XDz5cYFX0eWXcZI330shMgpH2GN1EBy0bddRUryRhZ2OE3SsMybpAjk2WT4Pf8
         tI7Oqp17cGnJiaXRgrFEfZiRJqC+NnBI2FfVU0Hl3QVqaP4ZRYZmnu9OKoDqrb3J23
         UzN78wlZgbw1o8gP94QV4QorTfDMFkHM6K4LVxuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 744/913] media: atomisp_gmin_platform: Add DMI quirk to not turn AXP ELDO2 regulator off on some boards
Date:   Tue,  5 Apr 2022 09:30:06 +0200
Message-Id: <20220405070402.135881972@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 62dc06e22476..cd0a771454da 100644
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



