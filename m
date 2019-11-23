Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A06EB107D49
	for <lists+stable@lfdr.de>; Sat, 23 Nov 2019 07:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbfKWGUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Nov 2019 01:20:52 -0500
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:24412 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbfKWGUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 Nov 2019 01:20:52 -0500
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id xAN6KltE015343;
        Sat, 23 Nov 2019 07:20:47 +0100
Date:   Sat, 23 Nov 2019 07:20:47 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Bob Funk <bobfunk11@gmail.com>
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: Re: Bug Report - Kernel Branch 4.4.y - asus-wmi.c
Message-ID: <20191123062047.GB14713@1wt.eu>
References: <33bfa93a-3853-85f5-47f9-8a69ed9c656e@gmail.com>
 <20191123061446.GA14713@1wt.eu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191123061446.GA14713@1wt.eu>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 23, 2019 at 07:14:46AM +0100, Willy Tarreau wrote:
> I suspect that this is caused by missing commit 401fee81, which fixes
> 78f3ac76d9e5, was backported to 4.19 but not to 4.4. However you will
> have to backport it by hand as it doesn't apply due to context
> differences, but it trivial to do.

Please try the attached patch. I haven't even tried to compile it but
I think it's OK.

Willy


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="0001-platform-x86-asus-wmi-Only-Tell-EC-the-OS-will-handl.patch"
Content-Transfer-Encoding: 8bit

From cfc80c044499f17e82c3ede448a4e1462572ae39 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Wed, 12 Jun 2019 09:02:02 +0200
Subject: platform/x86: asus-wmi: Only Tell EC the OS will handle display
 hotkeys from asus_nb_wmi
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

commit 401fee8195d401b2b94dee57383f627050724d5b upstream.

Commit 78f3ac76d9e5 ("platform/x86: asus-wmi: Tell the EC the OS will
handle the display off hotkey") causes the backlight to be permanently off
on various EeePC laptop models using the eeepc-wmi driver (Asus EeePC
1015BX, Asus EeePC 1025C).

The asus_wmi_set_devstate(ASUS_WMI_DEVID_BACKLIGHT, 2, NULL) call added
by that commit is made conditional in this commit and only enabled in
the quirk_entry structs in the asus-nb-wmi driver fixing the broken
display / backlight on various EeePC laptop models.

Cc: João Paulo Rechi Vita <jprvita@endlessm.com>
Fixes: 78f3ac76d9e5 ("platform/x86: asus-wmi: Tell the EC the OS will handle the display off hotkey")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
[wt: dropped changes for missing quirks]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/platform/x86/asus-nb-wmi.c | 4 ++++
 drivers/platform/x86/asus-wmi.c    | 2 +-
 drivers/platform/x86/asus-wmi.h    | 1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index a284a2b..bbea208 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -57,6 +57,7 @@ static struct quirk_entry *quirks;
 
 static struct quirk_entry quirk_asus_unknown = {
 	.wapf = 0,
+	.wmi_backlight_set_devstate = true,
 };
 
 /*
@@ -67,15 +68,18 @@ static struct quirk_entry quirk_asus_unknown = {
 static struct quirk_entry quirk_asus_x55u = {
 	.wapf = 4,
 	.wmi_backlight_power = true,
+	.wmi_backlight_set_devstate = true,
 	.no_display_toggle = true,
 };
 
 static struct quirk_entry quirk_asus_wapf4 = {
 	.wapf = 4,
+	.wmi_backlight_set_devstate = true,
 };
 
 static struct quirk_entry quirk_asus_x200ca = {
 	.wapf = 2,
+	.wmi_backlight_set_devstate = true,
 };
 
 static int dmi_matched(const struct dmi_system_id *dmi)
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 7c1defa..c4386ae 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -2084,7 +2084,7 @@ static int asus_wmi_add(struct platform_device *pdev)
 		err = asus_wmi_backlight_init(asus);
 		if (err && err != -ENODEV)
 			goto fail_backlight;
-	} else
+	} else if (asus->driver->quirks->wmi_backlight_set_devstate)
 		err = asus_wmi_set_devstate(ASUS_WMI_DEVID_BACKLIGHT, 2, NULL);
 
 	status = wmi_install_notify_handler(asus->driver->event_guid,
diff --git a/drivers/platform/x86/asus-wmi.h b/drivers/platform/x86/asus-wmi.h
index 4da4c8b..0f565cc 100644
--- a/drivers/platform/x86/asus-wmi.h
+++ b/drivers/platform/x86/asus-wmi.h
@@ -42,6 +42,7 @@ struct quirk_entry {
 	bool scalar_panel_brightness;
 	bool store_backlight_power;
 	bool wmi_backlight_power;
+	bool wmi_backlight_set_devstate;
 	int wapf;
 	/*
 	 * For machines with AMD graphic chips, it will send out WMI event
-- 
2.9.0


--LZvS9be/3tNcYl/X--
