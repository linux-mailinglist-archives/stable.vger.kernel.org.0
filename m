Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0E01F22F1
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbgFHXLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:11:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727920AbgFHXLR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:11:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DF86212CC;
        Mon,  8 Jun 2020 23:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657877;
        bh=WalAKmd2wJyO633C/RRtz+BX1RofonbPiTJF5TW5uS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cm0AFNWnARbden/cCzJHjYhiAHojxkFzVL3SSQ4YgraW+FAC1pDDOyjrbteTIZlG5
         hW+OLl7V0QzKuHt5UZokqLqR8bfRAAxpqmwCevnhQtreCKAK9eBHPoX3Zgh0modg5A
         B3tBtg/1WbdWZrV4DnTStEcn7mj1rs+vGXUNUc7A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 234/274] ACPI: video: Use native backlight on Acer TravelMate 5735Z
Date:   Mon,  8 Jun 2020 19:05:27 -0400
Message-Id: <20200608230607.3361041-234-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Menzel <pmenzel@molgen.mpg.de>

[ Upstream commit c41c36e900a337b4132b12ccabc97f5578248b44 ]

Currently, changing the brightness of the internal display of the Acer
TravelMate 5735Z does not work. Pressing the function keys or changing the
slider, GNOME Shell 3.36.2 displays the OSD (five steps), but the
brightness does not change.

The Acer TravelMate 5735Z shipped with Windows 7 and as such does not
trigger our "win8 ready" heuristic for preferring the native backlight
interface.

Still ACPI backlight control doesn't work on this model, where as the
native (intel_video) backlight interface does work by adding
`acpi_backlight=native` or `acpi_backlight=none` to Linux’ command line.

So, add a quirk to force using native backlight control on this model.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=207835
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index b4994e50608d..2499d7e3c710 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -361,6 +361,16 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_BOARD_NAME, "JV50"),
 		},
 	},
+	{
+	 /* https://bugzilla.kernel.org/show_bug.cgi?id=207835 */
+	 .callback = video_detect_force_native,
+	 .ident = "Acer TravelMate 5735Z",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 5735Z"),
+		DMI_MATCH(DMI_BOARD_NAME, "BA51_MV"),
+		},
+	},
 
 	/*
 	 * Desktops which falsely report a backlight and which our heuristics
-- 
2.25.1

