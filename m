Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B205241EAAF
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 12:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353285AbhJAKLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 06:11:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30689 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230073AbhJAKLV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Oct 2021 06:11:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633082976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=b14EzvT2GgzChfN1socPvNOLlgA3D2n94sk8MOsWBCg=;
        b=BAzZ0JJbknYa02FLI3jhJvM7+XVvtftCNTYBpgOX+A0Ql1zE7z45LOXMELiNLrnjWoyJ1t
        S6gKmXRM2QsEero0iqmCCXnCkH6j9ImCXXPMixP3M94HfGhkw/4ybZJtJLeCMi69uKHdrM
        rLomoz8vUAC4K6j3eJIqPKz1MOePsrc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-0VGfWj8RMEeqFNceTz2VxQ-1; Fri, 01 Oct 2021 06:09:35 -0400
X-MC-Unique: 0VGfWj8RMEeqFNceTz2VxQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E8E7184215E;
        Fri,  1 Oct 2021 10:09:34 +0000 (UTC)
Received: from x1.localdomain (unknown [10.39.193.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63B89608BA;
        Fri,  1 Oct 2021 10:09:33 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Tobias Gurtzick <magic@wizardtales.com>
Subject: [PATCH] platform/x86/intel: hid: Add DMI switches allow list
Date:   Fri,  1 Oct 2021 12:09:32 +0200
Message-Id: <20211001100932.7907-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

commit b201cb0ebe87b209e252d85668e517ac1929e250 upstream.

Some devices, even non convertible ones, can send incorrect
SW_TABLET_MODE reports.

Add an allow list and accept such reports only from devices in it.

Bug reported for Dell XPS 17 9710 on:
https://gitlab.freedesktop.org/libinput/libinput/-/issues/662

Fixes: ac32bae00083 ("platform/x86: intel-hid: Add alternative method to enable switches")
Depends-on: 153cca9caa81 ("platform/x86: Add and use a dual_accel_detect() helper")
Reported-by: Tobias Gurtzick <magic@wizardtales.com>
Suggested-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Tobias Gurtzick <magic@wizardtales.com>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Link: https://lore.kernel.org/r/20210920160312.9787-1-jose.exposito89@gmail.com
[hdegoede@redhat.com: Check dmi_switches_auto_add_allow_list only once]
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/intel-hid.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/intel-hid.c b/drivers/platform/x86/intel-hid.c
index 2e4e97a626a5..7b03b497d93b 100644
--- a/drivers/platform/x86/intel-hid.c
+++ b/drivers/platform/x86/intel-hid.c
@@ -118,12 +118,30 @@ static const struct dmi_system_id dmi_vgbs_allow_list[] = {
 	{ }
 };
 
+/*
+ * Some devices, even non convertible ones, can send incorrect SW_TABLET_MODE
+ * reports. Accept such reports only from devices in this list.
+ */
+static const struct dmi_system_id dmi_auto_add_switch[] = {
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_CHASSIS_TYPE, "31" /* Convertible */),
+		},
+	},
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_CHASSIS_TYPE, "32" /* Detachable */),
+		},
+	},
+	{} /* Array terminator */
+};
+
 struct intel_hid_priv {
 	struct input_dev *input_dev;
 	struct input_dev *array;
 	struct input_dev *switches;
 	bool wakeup_mode;
-	bool dual_accel;
+	bool auto_add_switch;
 };
 
 #define HID_EVENT_FILTER_UUID	"eeec56b3-4442-408f-a792-4edd4d758054"
@@ -452,10 +470,8 @@ static void notify_handler(acpi_handle handle, u32 event, void *context)
 	 * Some convertible have unreliable VGBS return which could cause incorrect
 	 * SW_TABLET_MODE report, in these cases we enable support when receiving
 	 * the first event instead of during driver setup.
-	 *
-	 * See dual_accel_detect.h for more info on the dual_accel check.
 	 */
-	if (!priv->switches && !priv->dual_accel && (event == 0xcc || event == 0xcd)) {
+	if (!priv->switches && priv->auto_add_switch && (event == 0xcc || event == 0xcd)) {
 		dev_info(&device->dev, "switch event received, enable switches supports\n");
 		err = intel_hid_switches_setup(device);
 		if (err)
@@ -596,7 +612,8 @@ static int intel_hid_probe(struct platform_device *device)
 		return -ENOMEM;
 	dev_set_drvdata(&device->dev, priv);
 
-	priv->dual_accel = dual_accel_detect();
+	/* See dual_accel_detect.h for more info on the dual_accel check. */
+	priv->auto_add_switch = dmi_check_system(dmi_auto_add_switch) && !dual_accel_detect();
 
 	err = intel_hid_input_setup(device);
 	if (err) {
-- 
2.31.1

