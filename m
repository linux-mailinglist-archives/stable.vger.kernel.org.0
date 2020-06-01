Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C60C1EAE84
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgFASyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:54:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729843AbgFASBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:01:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1EEB2065C;
        Mon,  1 Jun 2020 18:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034512;
        bh=UF3nzlyOfmDMR7p9mVsviExlSwnPBfkq9XMpJS5aL04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJ6lWFPEsYu817CAsLtOs54wcGohiexHVd9I0WGqAg2uDBu4LTlpn29NuuX7OLD+B
         nSROmLWUsbCqL7IW1faa3e5xG6sIHUuiRrdNgNqnVou058/b0ui5+JjMg7aoU2SL/9
         nAhut/BlAaqAqPzum+i+HWrRDz6ectJC8J3npjVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Locke <kevin@kevinlocke.name>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 25/77] Input: i8042 - add ThinkPad S230u to i8042 nomux list
Date:   Mon,  1 Jun 2020 19:53:30 +0200
Message-Id: <20200601174020.903952113@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174016.396817032@linuxfoundation.org>
References: <20200601174016.396817032@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Locke <kevin@kevinlocke.name>

[ Upstream commit 18931506465a762ffd3f4803d36a18d336a67da9 ]

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
Link: https://lore.kernel.org/r/feb8a8339a67025dab3850e6377eb6f3a0e782ba.1587400635.git.kevin@kevinlocke.name
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042-x86ia64io.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 0d0f977a2f39..8bf38eded1ef 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -545,6 +545,13 @@ static const struct dmi_system_id __initconst i8042_dmi_nomux_table[] = {
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
2.25.1



