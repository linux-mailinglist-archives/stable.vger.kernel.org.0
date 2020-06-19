Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCBD8200E93
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391852AbgFSPJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:09:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391842AbgFSPJG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:09:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45DCD21941;
        Fri, 19 Jun 2020 15:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579345;
        bh=IAEpftuEgs7V9lricUgp8vMtOl5jcTrUca3ypizERdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/VCwXehOxvxW9FCrAWhDpCLUHtIVWSat8Cq65qfqIyItbJPorjoDemzs0ZMJu8vK
         hB9LLkbcOfNmsmPbmk/d9f3z1xeIIOBwd9BpnY+A2P+k7yYxDFWRJU1gyN7SyoTFVo
         xkDZehI/IC4o0GjNjP8g9jMg2dwal+w3VrgZ31Kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 101/261] platform/x86: intel-vbtn: Do not advertise switches to userspace if they are not there
Date:   Fri, 19 Jun 2020 16:31:52 +0200
Message-Id: <20200619141654.695220610@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 990fbb48067bf8cfa34b7d1e6e1674eaaef2f450 ]

Commit de9647efeaa9 ("platform/x86: intel-vbtn: Only activate tablet mode
switch on 2-in-1's") added a DMI chassis-type check to avoid accidentally
reporting SW_TABLET_MODE = 1 to userspace on laptops (specifically on the
Dell XPS 9360), to avoid e.g. userspace ignoring touchpad events because
userspace thought the device was in tablet-mode.

But if we are not getting the initial status of the switch because the
device does not have a tablet mode, then we really should not advertise
the presence of a tablet-mode switch to userspace at all, as userspace may
use the mere presence of this switch for certain heuristics.

Fixes: de9647efeaa9 ("platform/x86: intel-vbtn: Only activate tablet mode switch on 2-in-1's")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel-vbtn.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/intel-vbtn.c b/drivers/platform/x86/intel-vbtn.c
index 2ab3dbd26b5e..ab33349035b1 100644
--- a/drivers/platform/x86/intel-vbtn.c
+++ b/drivers/platform/x86/intel-vbtn.c
@@ -54,6 +54,7 @@ static const struct key_entry intel_vbtn_switchmap[] = {
 struct intel_vbtn_priv {
 	struct key_entry keymap[KEYMAP_LEN];
 	struct input_dev *input_dev;
+	bool has_switches;
 	bool wakeup_mode;
 };
 
@@ -69,7 +70,7 @@ static int intel_vbtn_input_setup(struct platform_device *device)
 		keymap_len += ARRAY_SIZE(intel_vbtn_keymap);
 	}
 
-	if (true) {
+	if (priv->has_switches) {
 		memcpy(&priv->keymap[keymap_len], intel_vbtn_switchmap,
 		       ARRAY_SIZE(intel_vbtn_switchmap) *
 		       sizeof(struct key_entry));
@@ -137,16 +138,12 @@ out_unknown:
 
 static void detect_tablet_mode(struct platform_device *device)
 {
-	const char *chassis_type = dmi_get_system_info(DMI_CHASSIS_TYPE);
 	struct intel_vbtn_priv *priv = dev_get_drvdata(&device->dev);
 	acpi_handle handle = ACPI_HANDLE(&device->dev);
 	unsigned long long vgbs;
 	acpi_status status;
 	int m;
 
-	if (!(chassis_type && strcmp(chassis_type, "31") == 0))
-		return;
-
 	status = acpi_evaluate_integer(handle, "VGBS", NULL, &vgbs);
 	if (ACPI_FAILURE(status))
 		return;
@@ -157,6 +154,19 @@ static void detect_tablet_mode(struct platform_device *device)
 	input_report_switch(priv->input_dev, SW_DOCK, m);
 }
 
+static bool intel_vbtn_has_switches(acpi_handle handle)
+{
+	const char *chassis_type = dmi_get_system_info(DMI_CHASSIS_TYPE);
+	unsigned long long vgbs;
+	acpi_status status;
+
+	if (!(chassis_type && strcmp(chassis_type, "31") == 0))
+		return false;
+
+	status = acpi_evaluate_integer(handle, "VGBS", NULL, &vgbs);
+	return ACPI_SUCCESS(status);
+}
+
 static int intel_vbtn_probe(struct platform_device *device)
 {
 	acpi_handle handle = ACPI_HANDLE(&device->dev);
@@ -175,13 +185,16 @@ static int intel_vbtn_probe(struct platform_device *device)
 		return -ENOMEM;
 	dev_set_drvdata(&device->dev, priv);
 
+	priv->has_switches = intel_vbtn_has_switches(handle);
+
 	err = intel_vbtn_input_setup(device);
 	if (err) {
 		pr_err("Failed to setup Intel Virtual Button\n");
 		return err;
 	}
 
-	detect_tablet_mode(device);
+	if (priv->has_switches)
+		detect_tablet_mode(device);
 
 	status = acpi_install_notify_handler(handle,
 					     ACPI_DEVICE_NOTIFY,
-- 
2.25.1



