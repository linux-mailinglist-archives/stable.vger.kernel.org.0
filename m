Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0D158DE95
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345867AbiHISTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345817AbiHISPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:15:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8786A2C671;
        Tue,  9 Aug 2022 11:05:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13E6161070;
        Tue,  9 Aug 2022 18:05:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC7EC433B5;
        Tue,  9 Aug 2022 18:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068344;
        bh=tgQRxVvf3DgTp6QivUr5kqVoMh/0T6Ohp9Fs32BqAng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VOQM/TDPT+hqGDpcHPKxE19nWMI5BpiGLBSy9TYIYtCKG3tOrBH+pb8gM+uzDLgcy
         6bjI7H89uvUXL+U+1XPWlgk5s25oD3E6JJCK31qhiQnuCiYufJsWZb77c2gne0jMM2
         d0rFtKQV4qSLBHQEyrBQbXTDvsg5tZMZt9LQFjEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Werner Sembach <wse@tuxedocomputers.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 06/30] ACPI: video: Force backlight native for some TongFang devices
Date:   Tue,  9 Aug 2022 20:00:31 +0200
Message-Id: <20220809175514.514352256@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175514.276643253@linuxfoundation.org>
References: <20220809175514.276643253@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -484,7 +484,56 @@ static const struct dmi_system_id video_
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


