Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB8C6239A
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390326AbfGHPdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:33:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390334AbfGHPdV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:33:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48533216E3;
        Mon,  8 Jul 2019 15:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562600000;
        bh=30ZiUa57b9KbLpjZYhcteNW8B3iqs0vHt9M9lp9ue9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HLOsbQezRPLVUhYxloKA/1dsIsTv/yKyi6SF3Z8ILyvihWRJ/0WGS1FsGRkWh7XLD
         hunbw7pG8A5Z0IYxs488HTCdJNS9RhFiMT2m0LYAX+sk0bieT34jvub/1czzTM6Uw+
         T6dTpKynfThkMp0w0a51SQROkH+qA6PRNFnuIs9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@endlessm.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 44/96] platform/x86: asus-wmi: Only Tell EC the OS will handle display hotkeys from asus_nb_wmi
Date:   Mon,  8 Jul 2019 17:13:16 +0200
Message-Id: <20190708150528.914263872@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 401fee8195d401b2b94dee57383f627050724d5b ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 8 ++++++++
 drivers/platform/x86/asus-wmi.c    | 2 +-
 drivers/platform/x86/asus-wmi.h    | 1 +
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index b6f2ff95c3ed..59f3a37a44d7 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -78,10 +78,12 @@ static bool asus_q500a_i8042_filter(unsigned char data, unsigned char str,
 
 static struct quirk_entry quirk_asus_unknown = {
 	.wapf = 0,
+	.wmi_backlight_set_devstate = true,
 };
 
 static struct quirk_entry quirk_asus_q500a = {
 	.i8042_filter = asus_q500a_i8042_filter,
+	.wmi_backlight_set_devstate = true,
 };
 
 /*
@@ -92,26 +94,32 @@ static struct quirk_entry quirk_asus_q500a = {
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
 
 static struct quirk_entry quirk_asus_ux303ub = {
 	.wmi_backlight_native = true,
+	.wmi_backlight_set_devstate = true,
 };
 
 static struct quirk_entry quirk_asus_x550lb = {
+	.wmi_backlight_set_devstate = true,
 	.xusb2pr = 0x01D9,
 };
 
 static struct quirk_entry quirk_asus_forceals = {
+	.wmi_backlight_set_devstate = true,
 	.wmi_force_als_set = true,
 };
 
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index ee1fa93708ec..a66e99500c12 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -2131,7 +2131,7 @@ static int asus_wmi_add(struct platform_device *pdev)
 		err = asus_wmi_backlight_init(asus);
 		if (err && err != -ENODEV)
 			goto fail_backlight;
-	} else
+	} else if (asus->driver->quirks->wmi_backlight_set_devstate)
 		err = asus_wmi_set_devstate(ASUS_WMI_DEVID_BACKLIGHT, 2, NULL);
 
 	status = wmi_install_notify_handler(asus->driver->event_guid,
diff --git a/drivers/platform/x86/asus-wmi.h b/drivers/platform/x86/asus-wmi.h
index 6c1311f4b04d..57a79bddb286 100644
--- a/drivers/platform/x86/asus-wmi.h
+++ b/drivers/platform/x86/asus-wmi.h
@@ -44,6 +44,7 @@ struct quirk_entry {
 	bool store_backlight_power;
 	bool wmi_backlight_power;
 	bool wmi_backlight_native;
+	bool wmi_backlight_set_devstate;
 	bool wmi_force_als_set;
 	int wapf;
 	/*
-- 
2.20.1



