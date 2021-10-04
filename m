Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4744D420F3D
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237719AbhJDNca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:32:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237779AbhJDNae (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:30:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45B2B61B98;
        Mon,  4 Oct 2021 13:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353233;
        bh=2iwA1Qy+a765qThMzGVroZ6eJPLsSgRAlizBSs5Cjn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SHqJTP5vdzL50RhXGMKR9/FAE3+k/3gYWt26c3Z3mRpX/EPjq+6Kn/rGNHoTVlHPV
         UHI+AWTyA7eiH9Zx9fEsGZ7TnZh5lKLlRUEgl5FFQbqgpY7NToIqOUu9g6oZGgdrqX
         6GCOHvRVEo2uaU+xnh29X2uad9Up0SeQH1fE5hU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Gurtzick <magic@wizardtales.com>,
        Hans de Goede <hdegoede@redhat.com>,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>
Subject: [PATCH 5.14 047/172] platform/x86/intel: hid: Add DMI switches allow list
Date:   Mon,  4 Oct 2021 14:51:37 +0200
Message-Id: <20211004125046.509981455@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

Reported-by: Tobias Gurtzick <magic@wizardtales.com>
Suggested-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Tobias Gurtzick <magic@wizardtales.com>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Link: https://lore.kernel.org/r/20210920160312.9787-1-jose.exposito89@gmail.com
[hdegoede@redhat.com: Check dmi_switches_auto_add_allow_list only once]
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel-hid.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

--- a/drivers/platform/x86/intel-hid.c
+++ b/drivers/platform/x86/intel-hid.c
@@ -118,12 +118,30 @@ static const struct dmi_system_id dmi_vg
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
@@ -452,10 +470,8 @@ static void notify_handler(acpi_handle h
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
@@ -596,7 +612,8 @@ static int intel_hid_probe(struct platfo
 		return -ENOMEM;
 	dev_set_drvdata(&device->dev, priv);
 
-	priv->dual_accel = dual_accel_detect();
+	/* See dual_accel_detect.h for more info on the dual_accel check. */
+	priv->auto_add_switch = dmi_check_system(dmi_auto_add_switch) && !dual_accel_detect();
 
 	err = intel_hid_input_setup(device);
 	if (err) {


