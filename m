Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70E3110BFCA
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfK0Ueh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:34:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:35086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727645AbfK0Ueg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:34:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7336E20866;
        Wed, 27 Nov 2019 20:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574886875;
        bh=+jTHa6RfLG3FB+eqyQHja/Mz7Yn6YwCwk6IA2kcztlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HJK/27QSC2JmwcI6iUA2Ea9dCOi4AkXj2Bf30r/NFb2czrkdILmjlOvHkIhdrtNcs
         DlZpBGDJMsXeNrrHpSDg5jzZQo3q+e4Be7c5o6ZGoHm4x+VkWtyh0vWbafjgR9Uh9+
         DR/K4uUgOCpRaAt64BLAxKfds0fJGFaRf8EJcCOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@endlessm.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 007/132] asus-wmi: Create quirk for airplane_mode LED
Date:   Wed, 27 Nov 2019 21:29:58 +0100
Message-Id: <20191127202904.567920052@linuxfoundation.org>
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

From: João Paulo Rechi Vita <jprvita@gmail.com>

[ Upstream commit a977e59c0c67c9d492bb16677ce66d67cae0ebd8 ]

Some Asus laptops that have an airplane-mode indicator LED, also have
the WMI WLAN user bit set, and the following bits in their DSDT:

Scope (_SB)
{
  (...)
  Device (ATKD)
  {
    (...)
    Method (WMNB, 3, Serialized)
    {
      (...)
      If (LEqual (IIA0, 0x00010002))
      {
        OWGD (IIA1)
        Return (One)
      }
    }
  }
}

So when asus-wmi uses ASUS_WMI_DEVID_WLAN_LED (0x00010002) to store the
wlan state, it drives the airplane-mode indicator LED (through the call
to OWGD) in an inverted fashion: the LED is ON when airplane mode is OFF
(since wlan is ON), and vice-versa.

This commit creates a quirk to not register a RFKill switch at all for
these laptops, to allow the asus-wireless driver to drive the airplane
mode LED correctly through the ASHS ACPI device. It also adds a match to
that quirk for the Asus X555UB, which is affected by this problem.

Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
Reviewed-by: Corentin Chary <corentin.chary@gmail.com>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 13 +++++++++++++
 drivers/platform/x86/asus-wmi.c    |  8 +++++---
 drivers/platform/x86/asus-wmi.h    |  1 +
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index a284a2b42bcd5..5390846fa1e64 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -78,6 +78,10 @@ static struct quirk_entry quirk_asus_x200ca = {
 	.wapf = 2,
 };
 
+static struct quirk_entry quirk_no_rfkill = {
+	.no_rfkill = true,
+};
+
 static int dmi_matched(const struct dmi_system_id *dmi)
 {
 	quirks = dmi->driver_data;
@@ -315,6 +319,15 @@ static const struct dmi_system_id asus_quirks[] = {
 		},
 		.driver_data = &quirk_asus_x200ca,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUSTeK COMPUTER INC. X555UB",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "X555UB"),
+		},
+		.driver_data = &quirk_no_rfkill,
+	},
 	{},
 };
 
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 7c1defaef3f58..823f85b1b4dc6 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -2067,9 +2067,11 @@ static int asus_wmi_add(struct platform_device *pdev)
 	if (err)
 		goto fail_leds;
 
-	err = asus_wmi_rfkill_init(asus);
-	if (err)
-		goto fail_rfkill;
+	if (!asus->driver->quirks->no_rfkill) {
+		err = asus_wmi_rfkill_init(asus);
+		if (err)
+			goto fail_rfkill;
+	}
 
 	/* Some Asus desktop boards export an acpi-video backlight interface,
 	   stop this from showing up */
diff --git a/drivers/platform/x86/asus-wmi.h b/drivers/platform/x86/asus-wmi.h
index 4da4c8bafe70e..5de1df510ebd8 100644
--- a/drivers/platform/x86/asus-wmi.h
+++ b/drivers/platform/x86/asus-wmi.h
@@ -38,6 +38,7 @@ struct key_entry;
 struct asus_wmi;
 
 struct quirk_entry {
+	bool no_rfkill;
 	bool hotplug_wireless;
 	bool scalar_panel_brightness;
 	bool store_backlight_power;
-- 
2.20.1



