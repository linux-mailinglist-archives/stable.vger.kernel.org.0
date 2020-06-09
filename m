Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAA31F42AA
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731910AbgFIRqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:46:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728440AbgFIRqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:46:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3105420812;
        Tue,  9 Jun 2020 17:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591724775;
        bh=1v+8pQJ2MGHqi5djMU3ruNLkZLDmt6+87t8aQprpRs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ymmMk6r6PB2xuf/Udpad3OV3n/ISist/kYT4/SElOxLsYZHSpidfKW0VeItUBmKmR
         X+WNgWNdidpQ9jvLD2SLdg3EEREfRn8PIporvlaj4nYoTQorKnVUW3uSTPYjAnqr/8
         MV+XR/Z0TDW2zPE+oYzGOytiBh6gCxb+KY/cLoBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Sieb <samuel-kbugs@sieb.net>,
        "Lee, Chun-Yi" <jlee@suse.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 03/36] platform/x86: acer-wmi: setup accelerometer when ACPI device was found
Date:   Tue,  9 Jun 2020 19:44:03 +0200
Message-Id: <20200609173933.485128117@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609173933.288044334@linuxfoundation.org>
References: <20200609173933.288044334@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee, Chun-Yi <joeyli.kernel@gmail.com>

commit f9ac89f5ad613b462339e845aeb8494646fd9be2 upstream.

The 98d610c3739a patch was introduced since v4.11-rc1 that it causes
that the accelerometer input device will not be created on workable
machines because the HID string comparing logic is wrong.

And, the patch doesn't prevent that the accelerometer input device
be created on the machines that have no BST0001. That's because
the acpi_get_devices() returns success even it didn't find any
match device.

This patch fixed the HID string comparing logic of BST0001 device.
And, it also makes sure that the acpi_get_devices() returns
acpi_handle for BST0001.

Fixes: 98d610c3739a ("acer-wmi: setup accelerometer when machine has appropriate notify event")
Reference: https://bugzilla.kernel.org/show_bug.cgi?id=193761
Reported-by: Samuel Sieb <samuel-kbugs@sieb.net>
Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/acer-wmi.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -1826,7 +1826,7 @@ static acpi_status __init acer_wmi_get_h
 	if (!strcmp(ctx, "SENR")) {
 		if (acpi_bus_get_device(ah, &dev))
 			return AE_OK;
-		if (!strcmp(ACER_WMID_ACCEL_HID, acpi_device_hid(dev)))
+		if (strcmp(ACER_WMID_ACCEL_HID, acpi_device_hid(dev)))
 			return AE_OK;
 	} else
 		return AE_OK;
@@ -1847,8 +1847,7 @@ static int __init acer_wmi_get_handle(co
 	handle = NULL;
 	status = acpi_get_devices(prop, acer_wmi_get_handle_cb,
 					(void *)name, &handle);
-
-	if (ACPI_SUCCESS(status)) {
+	if (ACPI_SUCCESS(status) && handle) {
 		*ah = handle;
 		return 0;
 	} else {
@@ -2199,8 +2198,8 @@ static int __init acer_wmi_init(void)
 		if (err)
 			return err;
 		err = acer_wmi_accel_setup();
-		if (err)
-			return err;
+		if (err && err != -ENODEV)
+			pr_warn("Cannot enable accelerometer\n");
 	}
 
 	err = platform_driver_register(&acer_platform_driver);


