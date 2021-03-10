Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861C9333E8B
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbhCJN0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:48628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233480AbhCJNZl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1C2E64FDA;
        Wed, 10 Mar 2021 13:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382741;
        bh=wLklBr5q8q6e7TbB1MwTMrvQA84qaaYu38tHb7WlGLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uUHDPCv/X36GrAuK/MOXF+vGc4n1aqj0uKXi6Zs6eh806LPh8dmmbp7OGWRqc1qwB
         yvljyxc11pu1fjO5dQ/xPw9ElKmQtPqXslMV4JNoXohtAAEJEWVgIVq9GE5N1islQm
         tucORx1v9VTQ4Q5Ucdkq+gNhatvMByJlUVzb+sXg=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 28/39] platform/x86: acer-wmi: Cleanup accelerometer device handling
Date:   Wed, 10 Mar 2021 14:24:36 +0100
Message-Id: <20210310132320.597353840@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132319.708237392@linuxfoundation.org>
References: <20210310132319.708237392@linuxfoundation.org>
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
index 8d06454f5915..b95dce2475ab 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -224,7 +224,6 @@ struct hotkey_function_type_aa {
 #define ACER_CAP_BLUETOOTH		BIT(2)
 #define ACER_CAP_BRIGHTNESS		BIT(3)
 #define ACER_CAP_THREEG			BIT(4)
-#define ACER_CAP_ACCEL			BIT(5)
 
 /*
  * Interface type flags
@@ -1526,7 +1525,7 @@ static int acer_gsensor_event(void)
 	struct acpi_buffer output;
 	union acpi_object out_obj[5];
 
-	if (!has_cap(ACER_CAP_ACCEL))
+	if (!acer_wmi_accel_dev)
 		return -1;
 
 	output.length = sizeof(out_obj);
@@ -1935,8 +1934,6 @@ static int __init acer_wmi_accel_setup(void)
 	if (err)
 		return err;
 
-	interface->capability |= ACER_CAP_ACCEL;
-
 	acer_wmi_accel_dev = input_allocate_device();
 	if (!acer_wmi_accel_dev)
 		return -ENOMEM;
@@ -1962,11 +1959,6 @@ err_free_dev:
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
@@ -2121,7 +2113,7 @@ static int acer_resume(struct device *dev)
 	if (has_cap(ACER_CAP_BRIGHTNESS))
 		set_u32(data->brightness, ACER_CAP_BRIGHTNESS);
 
-	if (has_cap(ACER_CAP_ACCEL))
+	if (acer_wmi_accel_dev)
 		acer_gsensor_init();
 
 	return 0;
@@ -2329,8 +2321,8 @@ error_device_alloc:
 error_platform_register:
 	if (wmi_has_guid(ACERWMID_EVENT_GUID))
 		acer_wmi_input_destroy();
-	if (has_cap(ACER_CAP_ACCEL))
-		acer_wmi_accel_destroy();
+	if (acer_wmi_accel_dev)
+		input_unregister_device(acer_wmi_accel_dev);
 
 	return err;
 }
@@ -2340,8 +2332,8 @@ static void __exit acer_wmi_exit(void)
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



