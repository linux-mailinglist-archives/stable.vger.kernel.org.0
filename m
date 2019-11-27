Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34BF710BFC3
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfK0UeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:34:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:34302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727471AbfK0UeG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:34:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 872402154A;
        Wed, 27 Nov 2019 20:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574886846;
        bh=OKKWQqyXkhSIYFjR8vOEa/YrOO1kajFe+zhoq3cmyFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=13VgK4AqbbU5CK2hrbbpi/qJelqTYNK9dsW9rMVvsh8q5R7y9MFoRawBCPfWusbsF
         ycQiyP9m21+FgYjY0gnIHNWm83i5luo7hrMUWcSuvxfv5DclmfWpGNbCVsg7Wjch8O
         niwmTaUPlLHN33SZdHPs0fwzV9F8Khm+RqnIIW4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <linux@rempel-privat.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 016/132] platform/x86: asus-wmi: try to set als by default
Date:   Wed, 27 Nov 2019 21:30:07 +0100
Message-Id: <20191127202912.948960780@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <linux@rempel-privat.de>

[ Upstream commit e9b615186805e2c18a0ac76aca62c1543ecfdbb8 ]

some laptops, for example ASUS UX330UAK, have brocken als_get function
but working als_set funktion. In this case, ALS will stay turned off.

             Method (WMNB, 3, Serialized)
            {
	    ...
               If (Local0 == 0x53545344)
                {
		...
                    If (IIA0 == 0x00050001)
                    {
                        If (!ALSP)
                        {
                            Return (0x02)
                        }

                        Local0 = (GALS & 0x10)    <<<---- bug,
                                                    should be: (GALS () & 0x10)
                        If (Local0)
                        {
                            Return (0x00050001)
                        }
                        Else
                        {
                            Return (0x00050000)
                        }
                    }

             .....
                If (Local0 == 0x53564544)
                {
		...
                    If (IIA0 == 0x00050001)
                    {
                        Return (ALSC (IIA1))
                    }

                  ......
                    Method (GALS, 0, NotSerialized)
                    {
                        Local0 = Zero
                        Local0 |= 0x20
                        If (ALAE)
                        {
                            Local0 |= 0x10
                        }

                        Local1 = 0x0A
                        Local1 <<= 0x08
                        Local0 |= Local1
                        Return (Local0)
                    }

Since it works without problems on Windows I assume ASUS WMI driver for Win
never trying to get ALS state, and instead it is setting it by default to ON.

This patch will do the same. Turn ALS on by default.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 13 +++++++++++++
 drivers/platform/x86/asus-wmi.c    | 12 ++++++++++++
 drivers/platform/x86/asus-wmi.h    |  1 +
 3 files changed, 26 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 7f7d6ca864771..bf9e48010b98b 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -120,6 +120,10 @@ static struct quirk_entry quirk_asus_x550lb = {
 	.xusb2pr = 0x01D9,
 };
 
+static struct quirk_entry quirk_asus_ux330uak = {
+	.wmi_force_als_set = true,
+};
+
 static int dmi_matched(const struct dmi_system_id *dmi)
 {
 	quirks = dmi->driver_data;
@@ -411,6 +415,15 @@ static const struct dmi_system_id asus_quirks[] = {
 		},
 		.driver_data = &quirk_asus_ux303ub,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUSTeK COMPUTER INC. UX330UAK",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "UX330UAK"),
+		},
+		.driver_data = &quirk_asus_ux330uak,
+	},
 	{
 		.callback = dmi_matched,
 		.ident = "ASUSTeK COMPUTER INC. X550LB",
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 2dee91537123e..c06cdc5522b48 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1109,6 +1109,15 @@ static void asus_wmi_set_xusb2pr(struct asus_wmi *asus)
 			orig_ports_available, ports_available);
 }
 
+/*
+ * Some devices dont support or have borcken get_als method
+ * but still support set method.
+ */
+static void asus_wmi_set_als(void)
+{
+	asus_wmi_set_devstate(ASUS_WMI_DEVID_ALS_ENABLE, 1, NULL);
+}
+
 /*
  * Hwmon device
  */
@@ -2104,6 +2113,9 @@ static int asus_wmi_add(struct platform_device *pdev)
 			goto fail_rfkill;
 	}
 
+	if (asus->driver->quirks->wmi_force_als_set)
+		asus_wmi_set_als();
+
 	/* Some Asus desktop boards export an acpi-video backlight interface,
 	   stop this from showing up */
 	chassis_type = dmi_get_system_info(DMI_CHASSIS_TYPE);
diff --git a/drivers/platform/x86/asus-wmi.h b/drivers/platform/x86/asus-wmi.h
index fdff626c3b51b..5db052d1de1e1 100644
--- a/drivers/platform/x86/asus-wmi.h
+++ b/drivers/platform/x86/asus-wmi.h
@@ -45,6 +45,7 @@ struct quirk_entry {
 	bool store_backlight_power;
 	bool wmi_backlight_power;
 	bool wmi_backlight_native;
+	bool wmi_force_als_set;
 	int wapf;
 	/*
 	 * For machines with AMD graphic chips, it will send out WMI event
-- 
2.20.1



