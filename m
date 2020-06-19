Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0922011F4
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404256AbgFSPrd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:47:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404243AbgFSP0A (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:26:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5658C217A0;
        Fri, 19 Jun 2020 15:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580359;
        bh=WalAKmd2wJyO633C/RRtz+BX1RofonbPiTJF5TW5uS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ERrqVbBnAaG116s2pJ5psJJfXgwajYepBP2ORRg7973TUwfLDnxu9cb4r9nm3h2w5
         FiGYXdQH9+5tHKMz+/ydB2ehC2htCE1g2yvX1HUt4Hyyp/wlt3gS9Rus16SvxG4IbI
         nPYsabfwEh9wpE6sIH3uyuYrSG2dnGgykHjcqcg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 220/376] ACPI: video: Use native backlight on Acer TravelMate 5735Z
Date:   Fri, 19 Jun 2020 16:32:18 +0200
Message-Id: <20200619141720.740932103@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



