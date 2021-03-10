Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7EA6333DED
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbhCJNZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:45702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232841AbhCJNYg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D64764FEF;
        Wed, 10 Mar 2021 13:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382675;
        bh=JjlIU+rvSzZPnqj5dEbYj+4logLnkYApVGih9bwwn4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hzJO8onIS5qskLKn4Qiq1hu2cYiQn419vJH4QlFKt0JgvhvniRjRG45hojso1pAal
         GB5p3SdVTZz5uzL5hvdaBe3S9VSW3KztoXchIjO5uPwkbf1JyRGkYZe2O4V369l7CU
         6oSX8c8/W/AwE60ZjHhh3p0iEX86STEjKE4vMKnU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 16/49] platform/x86: acer-wmi: Cleanup accelerometer device handling
Date:   Wed, 10 Mar 2021 14:23:27 +0100
Message-Id: <20210310132322.477968640@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
References: <20210310132321.948258062@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 9feb0763e4985ccfae632de3bb2f029cc8389842 ]

Cleanup accelerometer device handling:
-Drop acer_wmi_accel_destroy instead directly call input_unregister_device.
-The information tracked by the CAP_ACCEL flag mirrors acer_wmi_accel_dev
 being NULL. Drop the CAP flag, this is a preparation change for allowing
 users to override the capability flags. Dropping the flag stops users
 from causing a NULL pointer dereference by forcing the capability.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20201019185628.264473-3-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/acer-wmi.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 75b1f6ceb76e..184ec08d02a4 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -211,7 +211,6 @@ struct hotkey_function_type_aa {
 #define ACER_CAP_BLUETOOTH		BIT(2)
 #define ACER_CAP_BRIGHTNESS		BIT(3)
 #define ACER_CAP_THREEG			BIT(4)
-#define ACER_CAP_ACCEL			BIT(5)
 
 /*
  * Interface type flags
@@ -1516,7 +1515,7 @@ static int acer_gsensor_event(void)
 	struct acpi_buffer output;
 	union acpi_object out_obj[5];
 
-	if (!has_cap(ACER_CAP_ACCEL))
+	if (!acer_wmi_accel_dev)
 		return -1;
 
 	output.length = sizeof(out_obj);
@@ -1890,8 +1889,6 @@ static int __init acer_wmi_accel_setup(void)
 	gsensor_handle = acpi_device_handle(adev);
 	acpi_dev_put(adev);
 
-	interface->capability |= ACER_CAP_ACCEL;
-
 	acer_wmi_accel_dev = input_allocate_device();
 	if (!acer_wmi_accel_dev)
 		return -ENOMEM;
@@ -1917,11 +1914,6 @@ err_free_dev:
 	return err;
 }
 
-static void acer_wmi_accel_destroy(void)
-{
-	input_unregister_device(acer_wmi_accel_dev);
-}
-
 static int __init acer_wmi_input_setup(void)
 {
 	acpi_status status;
@@ -2076,7 +2068,7 @@ static int acer_resume(struct device *dev)
 	if (has_cap(ACER_CAP_BRIGHTNESS))
 		set_u32(data->brightness, ACER_CAP_BRIGHTNESS);
 
-	if (has_cap(ACER_CAP_ACCEL))
+	if (acer_wmi_accel_dev)
 		acer_gsensor_init();
 
 	return 0;
@@ -2266,8 +2258,8 @@ error_device_alloc:
 error_platform_register:
 	if (wmi_has_guid(ACERWMID_EVENT_GUID))
 		acer_wmi_input_destroy();
-	if (has_cap(ACER_CAP_ACCEL))
-		acer_wmi_accel_destroy();
+	if (acer_wmi_accel_dev)
+		input_unregister_device(acer_wmi_accel_dev);
 
 	return err;
 }
@@ -2277,8 +2269,8 @@ static void __exit acer_wmi_exit(void)
 	if (wmi_has_guid(ACERWMID_EVENT_GUID))
 		acer_wmi_input_destroy();
 
-	if (has_cap(ACER_CAP_ACCEL))
-		acer_wmi_accel_destroy();
+	if (acer_wmi_accel_dev)
+		input_unregister_device(acer_wmi_accel_dev);
 
 	remove_debugfs();
 	platform_device_unregister(acer_platform_device);
-- 
2.30.1



