Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 351FE10B778
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbfK0UeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:34:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727519AbfK0UeM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:34:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D5CA207DD;
        Wed, 27 Nov 2019 20:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574886851;
        bh=xAvsjWTSVk+rkdZvOSr990nk1M3ME/7uTZPMbBNa94M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uC0HL7OdtChLhViMioQf91lA8P5MH1doFaHTSsXQtddGXG6UwCwHVMuSo+M6mY3IS
         rFhlSRi9cxtu7CjSNY93SHYg05cXKC3x9gLjtPeSpdSAgpzhwc9eQ4TLfSAjJKChzn
         pF2F5tNRu0av7lCYgxEVpsJaGfscDzxg5fnrDIrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@endlessm.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 018/132] platform/x86: asus-wmi: Only Tell EC the OS will handle display hotkeys from asus_nb_wmi
Date:   Wed, 27 Nov 2019 21:30:09 +0100
Message-Id: <20191127202915.451157703@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

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
index 274ccf920af50..cccf250cd1e33 100644
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
@@ -92,15 +94,18 @@ static struct quirk_entry quirk_asus_q500a = {
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
 
 static struct quirk_entry quirk_no_rfkill = {
@@ -114,13 +119,16 @@ static struct quirk_entry quirk_no_rfkill_wapf4 = {
 
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
index c06cdc5522b48..63b5b6838e8bf 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -2135,7 +2135,7 @@ static int asus_wmi_add(struct platform_device *pdev)
 		err = asus_wmi_backlight_init(asus);
 		if (err && err != -ENODEV)
 			goto fail_backlight;
-	} else
+	} else if (asus->driver->quirks->wmi_backlight_set_devstate)
 		err = asus_wmi_set_devstate(ASUS_WMI_DEVID_BACKLIGHT, 2, NULL);
 
 	status = wmi_install_notify_handler(asus->driver->event_guid,
diff --git a/drivers/platform/x86/asus-wmi.h b/drivers/platform/x86/asus-wmi.h
index 5db052d1de1e1..53bab79780e22 100644
--- a/drivers/platform/x86/asus-wmi.h
+++ b/drivers/platform/x86/asus-wmi.h
@@ -45,6 +45,7 @@ struct quirk_entry {
 	bool store_backlight_power;
 	bool wmi_backlight_power;
 	bool wmi_backlight_native;
+	bool wmi_backlight_set_devstate;
 	bool wmi_force_als_set;
 	int wapf;
 	/*
-- 
2.20.1



