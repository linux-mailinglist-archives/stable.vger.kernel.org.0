Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258944EF3E6
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbiDAOzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352416AbiDAOuT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53EB2B2B7A;
        Fri,  1 Apr 2022 07:41:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72823B82518;
        Fri,  1 Apr 2022 14:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC51C3410F;
        Fri,  1 Apr 2022 14:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824098;
        bh=eSxdwjxtoAX3WJ5wZExLEC81LKayAfMQygkAyerS00E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ACvVk6n7wKY853acj0p0oteQODFhr+j4ZwBSWuCcJBsEa3aimmsnwVrXjv366hBFE
         dN1hLMFmS5e+PSDzTAASvWAxhD6R96y0/z/FP3PaRlGPq2bF5/cyE68H10ZR8ua2MK
         CmEO5Qkp8UpsODSB4M8huhlyEosJzp0QNuVFRGJreqWrJwK3LwAwIhUBRoHxth6V0c
         /GxLFEAXOAI6VVQmyJtza/BOGQ54fHp/6Q/P/yRTthyBBdTqcFRUdp96A+l1iaS8g5
         /+qOVYWXm7+7lbM4QSv8r41zS1FFZv7f6vbmjSzS43pm/j2votFdCCQ2bVLQ3h8xqe
         jxkt8+GD2B2wQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jorge Lopez <jorge.lopez2@hp.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 85/98] platform/x86: hp-wmi: Fix SW_TABLET_MODE detection method
Date:   Fri,  1 Apr 2022 10:37:29 -0400
Message-Id: <20220401143742.1952163-85-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
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

From: Jorge Lopez <jorge.lopez2@hp.com>

[ Upstream commit 520ee4ea1cc60251a6e3c911cf0336278aa52634 ]

The purpose of this patch is to introduce a fix and removal of the
current hack when determining tablet mode status.

Determining the tablet mode status requires reading Byte 0 bit 2 as
reported by HPWMI_HARDWARE_QUERY.  The investigation identified the
failure was rooted in two areas: HPWMI_HARDWARE_QUERY failure (0x05)
and reading Byte 0, bit 2 only to determine the table mode status.
HPWMI_HARDWARE_QUERY WMI failure also rendered the dock state value
invalid.

The latest changes use SMBIOS Type 3 (chassis type) and WMI Command
0x40 (device_mode_status) information to determine if the device is
in tablet mode or not.

hp_wmi_hw_state function was split into two functions;
hp_wmi_get_dock_state and hp_wmi_get_tablet_mode.  The new functions
separate how dock_state and tablet_mode is handled in a cleaner
manner.

All changes were validated on a HP ZBook Workstation notebook,
HP EliteBook x360, and HP EliteBook 850 G8.

Signed-off-by: Jorge Lopez <jorge.lopez2@hp.com>
Link: https://lore.kernel.org/r/20220310210853.28367-3-jorge.lopez2@hp.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp-wmi.c | 71 +++++++++++++++++++++++++----------
 1 file changed, 52 insertions(+), 19 deletions(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 027a1467d009..6bdf0606f6e6 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -33,10 +33,6 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("wmi:95F24279-4D7B-4334-9387-ACCDC67EF61C");
 MODULE_ALIAS("wmi:5FB7F034-2C63-45e9-BE91-3D44E2C707E4");
 
-static int enable_tablet_mode_sw = -1;
-module_param(enable_tablet_mode_sw, int, 0444);
-MODULE_PARM_DESC(enable_tablet_mode_sw, "Enable SW_TABLET_MODE reporting (-1=auto, 0=no, 1=yes)");
-
 #define HPWMI_EVENT_GUID "95F24279-4D7B-4334-9387-ACCDC67EF61C"
 #define HPWMI_BIOS_GUID "5FB7F034-2C63-45e9-BE91-3D44E2C707E4"
 
@@ -86,6 +82,7 @@ enum hp_wmi_commandtype {
 	HPWMI_FEATURE2_QUERY		= 0x0d,
 	HPWMI_WIRELESS2_QUERY		= 0x1b,
 	HPWMI_POSTCODEERROR_QUERY	= 0x2a,
+	HPWMI_SYSTEM_DEVICE_MODE	= 0x40,
 	HPWMI_THERMAL_PROFILE_QUERY	= 0x4c,
 };
 
@@ -182,6 +179,19 @@ struct rfkill2_device {
 static int rfkill2_count;
 static struct rfkill2_device rfkill2[HPWMI_MAX_RFKILL2_DEVICES];
 
+/*
+ * Chassis Types values were obtained from SMBIOS reference
+ * specification version 3.00. A complete list of system enclosures
+ * and chassis types is available on Table 17.
+ */
+static const char * const tablet_chassis_types[] = {
+	"30", /* Tablet*/
+	"31", /* Convertible */
+	"32"  /* Detachable */
+};
+
+#define DEVICE_MODE_TABLET	0x06
+
 /* map output size to the corresponding WMI method id */
 static inline int encode_outsize_for_pvsz(int outsize)
 {
@@ -292,14 +302,39 @@ static int hp_wmi_read_int(int query)
 	return val;
 }
 
-static int hp_wmi_hw_state(int mask)
+static int hp_wmi_get_dock_state(void)
 {
 	int state = hp_wmi_read_int(HPWMI_HARDWARE_QUERY);
 
 	if (state < 0)
 		return state;
 
-	return !!(state & mask);
+	return !!(state & HPWMI_DOCK_MASK);
+}
+
+static int hp_wmi_get_tablet_mode(void)
+{
+	char system_device_mode[4] = { 0 };
+	const char *chassis_type;
+	bool tablet_found;
+	int ret;
+
+	chassis_type = dmi_get_system_info(DMI_CHASSIS_TYPE);
+	if (!chassis_type)
+		return -ENODEV;
+
+	tablet_found = match_string(tablet_chassis_types,
+				    ARRAY_SIZE(tablet_chassis_types),
+				    chassis_type) >= 0;
+	if (!tablet_found)
+		return -ENODEV;
+
+	ret = hp_wmi_perform_query(HPWMI_SYSTEM_DEVICE_MODE, HPWMI_READ,
+				   system_device_mode, 0, sizeof(system_device_mode));
+	if (ret < 0)
+		return ret;
+
+	return system_device_mode[0] == DEVICE_MODE_TABLET;
 }
 
 static int __init hp_wmi_bios_2008_later(void)
@@ -448,7 +483,7 @@ static ssize_t als_show(struct device *dev, struct device_attribute *attr,
 static ssize_t dock_show(struct device *dev, struct device_attribute *attr,
 			 char *buf)
 {
-	int value = hp_wmi_hw_state(HPWMI_DOCK_MASK);
+	int value = hp_wmi_get_dock_state();
 	if (value < 0)
 		return value;
 	return sprintf(buf, "%d\n", value);
@@ -457,7 +492,7 @@ static ssize_t dock_show(struct device *dev, struct device_attribute *attr,
 static ssize_t tablet_show(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
-	int value = hp_wmi_hw_state(HPWMI_TABLET_MASK);
+	int value = hp_wmi_get_tablet_mode();
 	if (value < 0)
 		return value;
 	return sprintf(buf, "%d\n", value);
@@ -579,10 +614,10 @@ static void hp_wmi_notify(u32 value, void *context)
 	case HPWMI_DOCK_EVENT:
 		if (test_bit(SW_DOCK, hp_wmi_input_dev->swbit))
 			input_report_switch(hp_wmi_input_dev, SW_DOCK,
-					    hp_wmi_hw_state(HPWMI_DOCK_MASK));
+					    hp_wmi_get_dock_state());
 		if (test_bit(SW_TABLET_MODE, hp_wmi_input_dev->swbit))
 			input_report_switch(hp_wmi_input_dev, SW_TABLET_MODE,
-					    hp_wmi_hw_state(HPWMI_TABLET_MASK));
+					    hp_wmi_get_tablet_mode());
 		input_sync(hp_wmi_input_dev);
 		break;
 	case HPWMI_PARK_HDD:
@@ -660,19 +695,17 @@ static int __init hp_wmi_input_setup(void)
 	__set_bit(EV_SW, hp_wmi_input_dev->evbit);
 
 	/* Dock */
-	val = hp_wmi_hw_state(HPWMI_DOCK_MASK);
+	val = hp_wmi_get_dock_state();
 	if (!(val < 0)) {
 		__set_bit(SW_DOCK, hp_wmi_input_dev->swbit);
 		input_report_switch(hp_wmi_input_dev, SW_DOCK, val);
 	}
 
 	/* Tablet mode */
-	if (enable_tablet_mode_sw > 0) {
-		val = hp_wmi_hw_state(HPWMI_TABLET_MASK);
-		if (val >= 0) {
-			__set_bit(SW_TABLET_MODE, hp_wmi_input_dev->swbit);
-			input_report_switch(hp_wmi_input_dev, SW_TABLET_MODE, val);
-		}
+	val = hp_wmi_get_tablet_mode();
+	if (!(val < 0)) {
+		__set_bit(SW_TABLET_MODE, hp_wmi_input_dev->swbit);
+		input_report_switch(hp_wmi_input_dev, SW_TABLET_MODE, val);
 	}
 
 	err = sparse_keymap_setup(hp_wmi_input_dev, hp_wmi_keymap, NULL);
@@ -1028,10 +1061,10 @@ static int hp_wmi_resume_handler(struct device *device)
 	if (hp_wmi_input_dev) {
 		if (test_bit(SW_DOCK, hp_wmi_input_dev->swbit))
 			input_report_switch(hp_wmi_input_dev, SW_DOCK,
-					    hp_wmi_hw_state(HPWMI_DOCK_MASK));
+					    hp_wmi_get_dock_state());
 		if (test_bit(SW_TABLET_MODE, hp_wmi_input_dev->swbit))
 			input_report_switch(hp_wmi_input_dev, SW_TABLET_MODE,
-					    hp_wmi_hw_state(HPWMI_TABLET_MASK));
+					    hp_wmi_get_tablet_mode());
 		input_sync(hp_wmi_input_dev);
 	}
 
-- 
2.34.1

