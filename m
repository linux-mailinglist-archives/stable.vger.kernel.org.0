Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C120B48041C
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbhL0THU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:07:20 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41702 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbhL0TGY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:06:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27D4661178;
        Mon, 27 Dec 2021 19:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B00C36AED;
        Mon, 27 Dec 2021 19:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631983;
        bh=6YGgRH6ThzbzsmiBnkn8aHEm9OO34efPccdNlOv5AlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sdvUICBZtFD+/FoHcVq4a6hjW+DCrmAVbBGiNcZ4K1UN6a/BXN0RLqVqXdTKHYKcR
         /ON4kwF961ACj5gn9Qry+E1b43XJ6avMelHWZwTsHBir1qazkhzhbqPiOlfAYqePvv
         Uu610E7LhdEhWDrWnzMStMxu/65Hx9vhkdfbplj6A7FfMuKT3408b2rTZUBv5gpFkO
         ic6e5u0NXTK81RAcPdB0tFZRwu5zjmijy9i1nanE2k2lt80Yt4xGku28fgAdrbZEB4
         aQz5LaU9xymUvsjcK4RmjNer+BaEJz6JrdCyKs6h+rUMlZDpFmWmU3UC61Vj1QqczF
         UUYClaxbuVBcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Samuel=20=C4=8Cavoj?= <samuel@cavoj.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, mpdesouza@suse.com,
        tiwai@suse.de, adobriyan@gmail.com, po-hsu.lin@canonical.com,
        arnd@arndb.de, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 2/6] Input: i8042 - enable deferred probe quirk for ASUS UM325UA
Date:   Mon, 27 Dec 2021 14:06:06 -0500
Message-Id: <20211227190615.1043350-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190615.1043350-1-sashal@kernel.org>
References: <20211227190615.1043350-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Čavoj <samuel@cavoj.net>

[ Upstream commit 44ee250aeeabb28b52a10397ac17ffb8bfe94839 ]

The ASUS UM325UA suffers from the same issue as the ASUS UX425UA, which
is a very similar laptop. The i8042 device is not usable immediately
after boot and fails to initialize, requiring a deferred retry.

Enable the deferred probe quirk for the UM325UA.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1190256
Signed-off-by: Samuel Čavoj <samuel@cavoj.net>
Link: https://lore.kernel.org/r/20211204015615.232948-1-samuel@cavoj.net
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042-x86ia64io.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 29179d42b467a..ee0b0a7237ad8 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -1007,6 +1007,13 @@ static const struct dmi_system_id i8042_dmi_probe_defer_table[] __initconst = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX425UA"),
 		},
 	},
+	{
+		/* ASUS ZenBook UM325UA */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX325UA_UM325UA"),
+		},
+	},
 	{ }
 };
 
-- 
2.34.1

