Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A9B2DA068
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 20:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502572AbgLNT1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 14:27:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:46968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502187AbgLNRgz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:36:55 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/36] platform/x86: thinkpad_acpi: Do not report SW_TABLET_MODE on Yoga 11e
Date:   Mon, 14 Dec 2020 18:28:01 +0100
Message-Id: <20201214172544.145423328@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172543.302523401@linuxfoundation.org>
References: <20201214172543.302523401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit f2eae1888cf22590c38764b8fa3c989c0283870e ]

The Yoga 11e series has 2 accelerometers described by a BOSC0200 ACPI node.
This setup relies on a Windows service which reads both accelerometers and
then calculates the angle between the 2 halves to determine laptop / tent /
tablet mode and then reports the calculated mode back to the EC by calling
special ACPI methods on the BOSC0200 node.

The bmc150 iio driver does not support this (it involves double
calculations requiring sqrt and arccos so this really needs to be done
in userspace), as a result of this on the Yoga 11e the thinkpad_acpi
code always reports SW_TABLET_MODE=0, starting with GNOME 3.38 reporting
SW_TABLET_MODE=0 causes GNOME to:

1. Not show the onscreen keyboard when a text-input field is focussed
   with the touchscreen.
2. Disable accelerometer based auto display-rotation.

This makes sense when in laptop-mode but not when in tablet-mode. But
since for the Yoga 11e the thinkpad_acpi code always reports
SW_TABLET_MODE=0, GNOME does not know when the device is in tablet-mode.

Stop reporting the broken (always 0) SW_TABLET_MODE on Yoga 11e models
to fix this.

Note there are plans for userspace to support 360 degree hinges style
2-in-1s with 2 accelerometers and figure out the mode by itself, see:
https://gitlab.freedesktop.org/hadess/iio-sensor-proxy/-/issues/216

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20201106140130.46820-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 5081048f2356e..f196a3313690f 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -3232,7 +3232,14 @@ static int hotkey_init_tablet_mode(void)
 
 		in_tablet_mode = hotkey_gmms_get_tablet_mode(res,
 							     &has_tablet_mode);
-		if (has_tablet_mode)
+		/*
+		 * The Yoga 11e series has 2 accelerometers described by a
+		 * BOSC0200 ACPI node. This setup relies on a Windows service
+		 * which calls special ACPI methods on this node to report
+		 * the laptop/tent/tablet mode to the EC. The bmc150 iio driver
+		 * does not support this, so skip the hotkey on these models.
+		 */
+		if (has_tablet_mode && !acpi_dev_present("BOSC0200", "1", -1))
 			tp_features.hotkey_tablet = TP_HOTKEY_TABLET_USES_GMMS;
 		type = "GMMS";
 	} else if (acpi_evalf(hkey_handle, &res, "MHKG", "qd")) {
-- 
2.27.0



