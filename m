Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C0B3F5471
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhHXAzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:55:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233753AbhHXAyy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:54:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE4E1613E8;
        Tue, 24 Aug 2021 00:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766451;
        bh=NloJrDL1ejwp/rlW88MAS7qGRk/Nlm6pJziuz8bSjjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKwBCBleKlxw8GbWt6RpLTPbo5zsh0y1mSg5BzGh7/VNWSyMUJcsB+7uz3JpehxWh
         Ua/5IKem/hOq/bxJz8vomS4VfbDzwD2Dhh6qlxU7O9dxrHZfB8cuw2MluUV/hkMeSN
         L6iWbD5Ana/AuyCJd0p3vJuWZIGT3LtriLqNH4kTFylUL0RZUf+7/2toK1mWjYrkKp
         zfVzvHHCH3cbG23njaawmwXv+XAv35bxselquT9X7vsvywABFAS0J9wLObfTvnEMG9
         lpZ6EPS5aU10d/vTVbnURiMjTfJufrC9ZH8xlUoHJbfG5+gwDkuaNwxD9hCEve9Cuy
         rfNJZkBksZh6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 11/26] platform/x86: asus-nb-wmi: Allow configuring SW_TABLET_MODE method with a module option
Date:   Mon, 23 Aug 2021 20:53:41 -0400
Message-Id: <20210824005356.630888-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005356.630888-1-sashal@kernel.org>
References: <20210824005356.630888-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 7f45621c14a209b986cd636447bb53b7f6f881c3 ]

Unfortunately we have been unable to find a reliable way to detect if
and how SW_TABLET_MODE reporting is supported, so we are relying on
DMI quirks for this.

Add a module-option to specify the SW_TABLET_MODE method so that this can
be easily tested without needing to rebuild the kernel.

BugLink: https://gitlab.freedesktop.org/libinput/libinput/-/issues/639
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210812145513.39117-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 0cb927f0f301..9929eedf7dd8 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -41,6 +41,10 @@ static int wapf = -1;
 module_param(wapf, uint, 0444);
 MODULE_PARM_DESC(wapf, "WAPF value");
 
+static int tablet_mode_sw = -1;
+module_param(tablet_mode_sw, uint, 0444);
+MODULE_PARM_DESC(tablet_mode_sw, "Tablet mode detect: -1:auto 0:disable 1:kbd-dock 2:lid-flip");
+
 static struct quirk_entry *quirks;
 
 static bool asus_q500a_i8042_filter(unsigned char data, unsigned char str,
@@ -477,6 +481,21 @@ static void asus_nb_wmi_quirks(struct asus_wmi_driver *driver)
 	else
 		wapf = quirks->wapf;
 
+	switch (tablet_mode_sw) {
+	case 0:
+		quirks->use_kbd_dock_devid = false;
+		quirks->use_lid_flip_devid = false;
+		break;
+	case 1:
+		quirks->use_kbd_dock_devid = true;
+		quirks->use_lid_flip_devid = false;
+		break;
+	case 2:
+		quirks->use_kbd_dock_devid = false;
+		quirks->use_lid_flip_devid = true;
+		break;
+	}
+
 	if (quirks->i8042_filter) {
 		ret = i8042_install_filter(quirks->i8042_filter);
 		if (ret) {
-- 
2.30.2

