Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5713E60E45C
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 17:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbiJZPXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 11:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233159AbiJZPXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 11:23:13 -0400
Received: from srv6.fidu.org (srv6.fidu.org [IPv6:2a01:4f8:231:de0::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D23900E6
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 08:23:11 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by srv6.fidu.org (Postfix) with ESMTP id CD56FC8008E;
        Wed, 26 Oct 2022 17:23:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        tuxedocomputers.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from; s=
        default; t=1666797789; x=1668612190; bh=axlMX9RG0/r2hNYbpEc9CRpB
        qJ5xa/RwTu/mIHj0Wpc=; b=WGZI423grJRG8Uve+F/LjWFx7JgdvpsNZ1wS00Oz
        UavMDfti20eWCU4CPUh0tcGl7oQwpjwRffVv2wwPPUeUtJKV8rUAP6p7Xufe5DNS
        6l4zdZjsPUMqIUjcw3wIL2K/PWpYVZZ0brHQw4c6Z5nYF7+GPK9DxcKLB0pAKM+7
        6I8=
X-Virus-Scanned: Debian amavisd-new at srv6.fidu.org
Received: from srv6.fidu.org ([127.0.0.1])
        by localhost (srv6.fidu.org [127.0.0.1]) (amavisd-new, port 10026)
        with LMTP id RsRPzRF976C0; Wed, 26 Oct 2022 17:23:09 +0200 (CEST)
Received: from wsembach-tuxedo.fritz.box (unknown [24.134.105.141])
        (Authenticated sender: wse@tuxedocomputers.com)
        by srv6.fidu.org (Postfix) with ESMTPA id 53B29C8008D;
        Wed, 26 Oct 2022 17:23:09 +0200 (CEST)
From:   Werner Sembach <wse@tuxedocomputers.com>
To:     stable@vger.kernel.org
Cc:     hdegoede@redhat.com, daniel@ffwll.ch, airlied@redhat.com,
        lenb@kernel.org, rafael.j.wysocki@intel.com
Subject: [PATCH v3] ACPI: video: Force backlight native for more TongFang devices
Date:   Wed, 26 Oct 2022 17:22:46 +0200
Message-Id: <20221026152246.24990-1-wse@tuxedocomputers.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 3dbc80a3e4c55c4a5b89ef207bed7b7de36157b4 upstream.

This commit is very different from the upstream commit! It fixes the same
issue by adding more quirks, rather then the general fix from the 6.1
kernel, because the general fix from the 6.1 kernel is part of a larger
refactoring of the backlight code which is not suitable for the stable
series.

As described in "ACPI: video: Drop NL5x?U, PF4NU1F and PF5?U??
acpi_backlight=native quirks" (10212754a0d2) the upstream commit "ACPI:
video: Make backlight class device registration a separate step (v2)"
(3dbc80a3e4c5) makes these quirks unnecessary. However as mentioned in this
bugtracker ticket https://bugzilla.kernel.org/show_bug.cgi?id=215683#c17
the upstream fix is part of a larger patchset that is overall too complex
for stable.

The TongFang GKxNRxx, GMxNGxx, GMxZGxx, and GMxRGxx / TUXEDO
Stellaris/Polaris Gen 1-4, have the same problem as the Clevo NL5xRU and
NL5xNU / TUXEDO Aura 15 Gen1 and Gen2:
They have a working native and video interface for screen backlight.
However the default detection mechanism first registers the video interface
before unregistering it again and switching to the native interface during
boot. This results in a dangling SBIOS request for backlight change for
some reason, causing the backlight to switch to ~2% once per boot on the
first power cord connect or disconnect event. Setting the native interface
explicitly circumvents this buggy behaviour by avoiding the unregistering
process.

Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
---
 drivers/acpi/video_detect.c | 64 +++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index e39d59ad64964..b13713199ad94 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -500,6 +500,70 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_BOARD_NAME, "PF5LUXG"),
 		},
 	},
+	/*
+	 * More Tongfang devices with the same issue as the Clevo NL5xRU and
+	 * NL5xNU/TUXEDO Aura 15 Gen1 and Gen2. See the description above.
+	 */
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GKxNRxx",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_NAME, "GKxNRxx"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GKxNRxx",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "POLARIS1501A1650TI"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GKxNRxx",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "POLARIS1501A2060"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GKxNRxx",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "POLARIS1701A1650TI"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GKxNRxx",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "POLARIS1701A2060"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GMxNGxx",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_NAME, "GMxNGxx"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GMxZGxx",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_NAME, "GMxZGxx"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GMxRGxx",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_NAME, "GMxRGxx"),
+		},
+	},
 	/*
 	 * Desktops which falsely report a backlight and which our heuristics
 	 * for this do not catch.
-- 
2.34.1

