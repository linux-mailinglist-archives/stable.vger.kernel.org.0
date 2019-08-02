Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A09EE7F14B
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbfHBJhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:37:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390619AbfHBJfd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:35:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D9E4217D7;
        Fri,  2 Aug 2019 09:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738532;
        bh=4fG8yaWw5FIGbVIq1QA9djVCt5H8cR/5qPXur/6lfmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N3fdV+gZI40TeTZnQHspC8R6DuMS0FlSWQGe6O4o63PXzBvwR4exKLMBwWd0dCwdz
         bzzdrRFpROGMo8Mw8R0dPq1Pp18fWrW1EbsBoc6xpff3lNo7Gqw4OEB9MoS5ttOVO6
         7ggypVkPpihMKnddYyx5Uar2Df7tBV6B/m5nqyyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.4 141/158] x86/sysfb_efi: Add quirks for some devices with swapped width and height
Date:   Fri,  2 Aug 2019 11:29:22 +0200
Message-Id: <20190802092231.448155130@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit d02f1aa39189e0619c3525d5cd03254e61bf606a upstream.

Some Lenovo 2-in-1s with a detachable keyboard have a portrait screen but
advertise a landscape resolution and pitch, resulting in a messed up
display if the kernel tries to show anything on the efifb (because of the
wrong pitch).

Fix this by adding a new DMI match table for devices which need to have
their width and height swapped.

At first it was tried to use the existing table for overriding some of the
efifb parameters, but some of the affected devices have variants with
different LCD resolutions which will not work with hardcoded override
values.

Reference: https://bugzilla.redhat.com/show_bug.cgi?id=1730783
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20190721152418.11644-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/sysfb_efi.c |   46 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

--- a/arch/x86/kernel/sysfb_efi.c
+++ b/arch/x86/kernel/sysfb_efi.c
@@ -216,9 +216,55 @@ static const struct dmi_system_id efifb_
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
+
+		screen_info.lfb_width = screen_info.lfb_height;
+		screen_info.lfb_height = temp;
+		screen_info.lfb_linelength = 4 * screen_info.lfb_width;
+	}
 }


