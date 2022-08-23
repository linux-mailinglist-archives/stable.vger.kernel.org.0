Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D100D59D7B4
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238680AbiHWJbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350940AbiHWJbD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:31:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57DE77562;
        Tue, 23 Aug 2022 01:38:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A41CD61541;
        Tue, 23 Aug 2022 08:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA383C433D6;
        Tue, 23 Aug 2022 08:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243838;
        bh=kAAceLf1VywHIek44vBXTfsB0yb0I7oJ0SqPKKlSA08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RWwB4xcbtC1S/Yj+gjW+9s+5voP1G8LgzaYUC5VESlgjxINngAXaB6toxf0VaVeHF
         gWHPezaxsLMGJEwEMzDN/UQr25cc2we582JCrJuy6L6Kw4ydAYLdIDAm5sVFj+ieiK
         c8gtPkEPEI8vs100TYLoz57YuP4bh5dza3noePeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Werner Sembach <wse@tuxedocomputers.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.14 010/229] ACPI: video: Force backlight native for some TongFang devices
Date:   Tue, 23 Aug 2022 10:22:51 +0200
Message-Id: <20220823080053.733076151@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Werner Sembach <wse@tuxedocomputers.com>

commit c752089f7cf5b5800c6ace4cdd1a8351ee78a598 upstream.

The TongFang PF5PU1G, PF4NU1F, PF5NU1G, and PF5LUXG/TUXEDO BA15 Gen10,
Pulse 14/15 Gen1, and Pulse 15 Gen2 have the same problem as the Clevo
NL5xRU and NL5xNU/TUXEDO Aura 15 Gen1 and Gen2:
They have a working native and video interface. However the default
detection mechanism first registers the video interface before
unregistering it again and switching to the native interface during boot.
This results in a dangling SBIOS request for backlight change for some
reason, causing the backlight to switch to ~2% once per boot on the first
power cord connect or disconnect event. Setting the native interface
explicitly circumvents this buggy behaviour by avoiding the unregistering
process.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: All applicable <stable@vger.kernel.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/video_detect.c |   51 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -431,7 +431,56 @@ static const struct dmi_system_id video_
 		DMI_MATCH(DMI_BOARD_NAME, "NL5xNU"),
 		},
 	},
-
+	/*
+	 * The TongFang PF5PU1G, PF4NU1F, PF5NU1G, and PF5LUXG/TUXEDO BA15 Gen10,
+	 * Pulse 14/15 Gen1, and Pulse 15 Gen2 have the same problem as the Clevo
+	 * NL5xRU and NL5xNU/TUXEDO Aura 15 Gen1 and Gen2. See the description
+	 * above.
+	 */
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang PF5PU1G",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_NAME, "PF5PU1G"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang PF4NU1F",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_NAME, "PF4NU1F"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang PF4NU1F",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "PULSE1401"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang PF5NU1G",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_NAME, "PF5NU1G"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang PF5NU1G",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "PULSE1501"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang PF5LUXG",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_NAME, "PF5LUXG"),
+		},
+	},
 	/*
 	 * Desktops which falsely report a backlight and which our heuristics
 	 * for this do not catch.


