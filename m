Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0621B11E1
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 18:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgDTQkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 12:40:51 -0400
Received: from vulcan.kevinlocke.name ([107.191.43.88]:43896 "EHLO
        vulcan.kevinlocke.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgDTQkq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 12:40:46 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Apr 2020 12:40:45 EDT
Received: from kevinolos (host-69-145-60-23.bln-mt.client.bresnan.net [69.145.60.23])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id 0453E1849C55;
        Mon, 20 Apr 2020 16:35:39 +0000 (UTC)
Received: by kevinolos (Postfix, from userid 1000)
        id B29D11303663; Mon, 20 Apr 2020 10:35:35 -0600 (MDT)
From:   Kevin Locke <kevin@kevinlocke.name>
To:     kevin@kevinlocke.name
Cc:     stable@vger.kernel.org
Subject: [PATCH] Input: i8042 - add ThinkPad S230u to i8042 nomux list
Date:   Mon, 20 Apr 2020 10:35:35 -0600
Message-Id: <feb8a8339a67025dab3850e6377eb6f3a0e782ba.1587400535.git.kevin@kevinlocke.name>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On the Lenovo ThinkPad Twist S230u (3347-4HU) with BIOS version
"GDETC1WW (1.81 ) 06/27/2019", whether booted in UEFI or Legacy/CSM mode
the keyboard, Synaptics TouchPad, and TrackPoint either do not function
or stop functioning a few minutes after boot.  This problem has been
noted before, perhaps only occurring on BIOS 1.57 and
later.[1][2][3][4][5]

This model does not have an external PS/2 port, so mux does not appear
to be useful.

Odds of a BIOS fix appear to be low: 1.57 was released over 6 years ago
and although the [BIOS changelog] notes "Fixed an issue of UEFI
touchpad/trackpoint/keyboard/touchscreen" in 1.58, it appears to be
insufficient.

Adding 33474HU to the nomux list avoids the issue on my system.

[1]: https://bugs.launchpad.net/bugs/1210748
[2]: https://bbs.archlinux.org/viewtopic.php?pid=1360425
[3]: https://forums.linuxmint.com/viewtopic.php?f=46&t=41200
[4]: https://forums.linuxmint.com/viewtopic.php?f=49&t=157115
[5]: https://forums.lenovo.com/topic/findpost/27/1337119
[BIOS changelog]: https://download.lenovo.com/pccbbs/mobiles/gduj33uc.txt

Signed-off-by: Kevin Locke <kevin@kevinlocke.name>
Cc: stable@vger.kernel.org
---
 drivers/input/serio/i8042-x86ia64io.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 08e919dbeb5d..5bbc9152731d 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -541,6 +541,13 @@ static const struct dmi_system_id __initconst i8042_dmi_nomux_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5738"),
 		},
 	},
+	{
+		/* Lenovo ThinkPad Twist S230u */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "33474HU"),
+		},
+	},
 	{ }
 };
 
-- 
2.26.1

