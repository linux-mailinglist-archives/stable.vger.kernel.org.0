Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B5460FEFF
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237102AbiJ0RK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237113AbiJ0RK0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:10:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36637844D7
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:10:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6F3D623F7
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66C6C433D6;
        Thu, 27 Oct 2022 17:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890624;
        bh=H3djxYrtjU8N81Ws9gxuo3429e6bIcMPQbiWsR0LwwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kT5SuJ4tfLfeEj4BxDBLzr+sj8Y4HgX6OmbUEkzXOFZOvgHCuxs/vClz5C8WqVyD4
         U68rIS2LaOQ2x9OEV2WcCfu7gjWEapX17dNK0uDLN77DjOvg7TmjsDZOpcvrDcsnsw
         Z8aLgOEBsU417AVQ6uIInil7CumQiSdGKOz5wUMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Werner Sembach <wse@tuxedocomputers.com>
Subject: [PATCH 5.4 50/53] [PATCH v3] ACPI: video: Force backlight native for more TongFang devices
Date:   Thu, 27 Oct 2022 18:56:38 +0200
Message-Id: <20221027165051.786703166@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
References: <20221027165049.817124510@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Werner Sembach <wse@tuxedocomputers.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/video_detect.c |   64 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -464,6 +464,70 @@ static const struct dmi_system_id video_
 		},
 	},
 	/*
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
+	/*
 	 * Desktops which falsely report a backlight and which our heuristics
 	 * for this do not catch.
 	 */


