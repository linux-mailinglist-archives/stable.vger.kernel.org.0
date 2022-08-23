Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E7359D43B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241961AbiHWINU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242511AbiHWIL1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:11:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A19641F;
        Tue, 23 Aug 2022 01:08:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1D49B81C28;
        Tue, 23 Aug 2022 08:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30A2C433C1;
        Tue, 23 Aug 2022 08:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242115;
        bh=VgfD82FDMnVQPgul32TgZhr3cf/IS1Hgbc5o8I1YtSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MKxneXVxAvj+1BSHH1/Fd6I+ZXGGE9q89uIfVMSwj4q+kI6lxw4sM/qYOGXTUC1S9
         HOgYUuN+8eW+9q8gF0Wg/YHOIEtJKeIgCKdkmQx8z1qJkXVCLI+8c9FvUgPLBvSlPR
         YqXUzE8Ja/Yvk7nqtKXO3zVLCVXZyNknxvRnJ4VY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Werner Sembach <wse@tuxedocomputers.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.9 021/101] ACPI: video: Force backlight native for some TongFang devices
Date:   Tue, 23 Aug 2022 10:02:54 +0200
Message-Id: <20220823080035.367723380@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
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
@@ -210,7 +210,56 @@ static const struct dmi_system_id video_
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
 	 * These models have a working acpi_video backlight control, and using
 	 * native backlight causes a regression where backlight does not work


