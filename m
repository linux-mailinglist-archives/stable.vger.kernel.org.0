Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7856F3ED
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 17:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfGUPYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 11:24:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40098 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726555AbfGUPYY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Jul 2019 11:24:24 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C6FC230842B5;
        Sun, 21 Jul 2019 15:24:22 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-49.ams2.redhat.com [10.36.116.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0079360C64;
        Sun, 21 Jul 2019 15:24:19 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, x86@kernel.org,
        linux-efi@vger.kernel.org, Peter Jones <pjones@redhat.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] x86/sysfb_efi: Add quirks for some devices with swapped width and height
Date:   Sun, 21 Jul 2019 17:24:18 +0200
Message-Id: <20190721152418.11644-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Sun, 21 Jul 2019 15:24:23 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some Lenovo 2-in-1s with a detachable keyboard have a portrait screen
but advertise a landscape resolution and pitch, resulting in a messed
up display if we try to show anything on the efifb (because of the wrong
pitch).

This commit fixes this by adding a new DMI match table for devices which
need to have their width and height swapped.

At first I tried to use the existing table for overriding some of the
efifb parameters, but some of the affected devices have variants with
different LCD resolutions which will not work with hardcoded override
values.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1730783
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 arch/x86/kernel/sysfb_efi.c | 45 +++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/x86/kernel/sysfb_efi.c b/arch/x86/kernel/sysfb_efi.c
index 8eb67a670b10..80d5b6720a87 100644
--- a/arch/x86/kernel/sysfb_efi.c
+++ b/arch/x86/kernel/sysfb_efi.c
@@ -230,9 +230,54 @@ static const struct dmi_system_id efifb_dmi_system_table[] __initconst = {
 	{},
 };
 
+/*
+ * Some devices have a portrait LCD but advertise a landscape resolution (and
+ * pitch). We simply swap width and height for these devices so that we can
+ * correctly deal with some of them coming with multiple resolutions.
+ */
+static const struct dmi_system_id efifb_dmi_swap_width_height[] __initconst = {
+	{
+		/*
+		 * Lenovo MIIX310-10ICR, only some batches have the troublesome
+		 * 800x1280 portrait screen. Luckily the portrait version has
+		 * its own BIOS version, so we match on that.
+		 */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "MIIX 310-10ICR"),
+			DMI_EXACT_MATCH(DMI_BIOS_VERSION, "1HCN44WW"),
+		},
+	},
+	{
+		/* Lenovo MIIX 320-10ICR with 800x1280 portrait screen */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION,
+					"Lenovo MIIX 320-10ICR"),
+		},
+	},
+	{
+		/* Lenovo D330 with 800x1280 or 1200x1920 portrait screen */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION,
+					"Lenovo ideapad D330-10IGM"),
+		},
+	},
+	{},
+};
+
 __init void sysfb_apply_efi_quirks(void)
 {
 	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI ||
 	    !(screen_info.capabilities & VIDEO_CAPABILITY_SKIP_QUIRKS))
 		dmi_check_system(efifb_dmi_system_table);
+
+	if (screen_info.orig_video_isVGA == VIDEO_TYPE_EFI &&
+	    dmi_check_system(efifb_dmi_swap_width_height)) {
+		u16 temp = screen_info.lfb_width;
+		screen_info.lfb_width = screen_info.lfb_height;
+		screen_info.lfb_height = temp;
+		screen_info.lfb_linelength = 4 * screen_info.lfb_width;
+	}
 }
-- 
2.21.0

