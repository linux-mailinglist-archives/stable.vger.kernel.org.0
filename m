Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4E61F2C02
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731296AbgFIATr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:19:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730589AbgFHXSL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:18:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C44A22088E;
        Mon,  8 Jun 2020 23:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658290;
        bh=VUm2zxFcPwsuvikrXnKimDFpz/sAzJXyYTib6u7UhuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cL5pp/8ZbhrQ9+Cv9XuM7s0Jl305uUBewKHM6PfM1vNIQuavnzgDN7zL8/t7hnYDg
         B3y7MIpZgZALiSpe8Di/6Pql4R4gGwzs6bSzlLRxBnIbK+p2pf/P+7woTwT1sOMg8R
         g3QdmYyixT2V6rtLTGFeZ/bgvOsq8UDgCJ7fahUM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kevin Locke <kevin@kevinlocke.name>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 294/606] Input: i8042 - add ThinkPad S230u to i8042 reset list
Date:   Mon,  8 Jun 2020 19:06:59 -0400
Message-Id: <20200608231211.3363633-294-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Locke <kevin@kevinlocke.name>

[ Upstream commit 2712c91a54a1058d55c284152b4d93c979b67be6 ]

On the Lenovo ThinkPad Twist S230u (3347-4HU) with BIOS version
"GDETC1WW (1.81 ) 06/27/2019", the keyboard, Synaptics TouchPad, and
TrackPoint either do not function or stop functioning a few minutes
after boot.  This problem has been noted before, perhaps only occurring
with BIOS 1.57 and later.[1][2][3][4][5]

Odds of a BIOS fix appear to be low: 1.57 was released over 6 years ago
and although the [BIOS changelog] notes "Fixed an issue of UEFI
touchpad/trackpoint/keyboard/touchscreen" in 1.58, it appears to be
insufficient.

Setting i8042.reset=1 or adding 33474HU to the reset list avoids the
issue on my system from either warm or cold boot.

[1]: https://bugs.launchpad.net/bugs/1210748
[2]: https://bbs.archlinux.org/viewtopic.php?pid=1360425
[3]: https://forums.linuxmint.com/viewtopic.php?f=46&t=41200
[4]: https://forums.linuxmint.com/viewtopic.php?f=49&t=157115
[5]: https://forums.lenovo.com/topic/findpost/27/1337119
[BIOS changelog]: https://download.lenovo.com/pccbbs/mobiles/gduj33uc.txt

Signed-off-by: Kevin Locke <kevin@kevinlocke.name>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/94f384b0f75f90f71425d7dce7ac82c59ddb87a8.1587702636.git.kevin@kevinlocke.name
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042-x86ia64io.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 08e919dbeb5d..7e048b557462 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -662,6 +662,13 @@ static const struct dmi_system_id __initconst i8042_dmi_reset_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "P65xRP"),
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

