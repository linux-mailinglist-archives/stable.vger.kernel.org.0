Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36BFD604931
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 16:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbiJSO1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 10:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233349AbiJSO1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 10:27:13 -0400
X-Greylist: delayed 443 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 19 Oct 2022 07:11:55 PDT
Received: from srv6.fidu.org (srv6.fidu.org [159.69.62.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A073D13FDC1
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 07:11:55 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by srv6.fidu.org (Postfix) with ESMTP id 904BFC80098
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 16:01:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        tuxedocomputers.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from; s=
        default; t=1666188107; x=1668002508; bh=ujCMckK2CYrIVhxXqYKhxtv2
        adaE+QyZ1zIrwdoanRM=; b=qlwFWOFnRD3KPWnfpKlcWWdoHI0H2DPcuArs/M+A
        hhj10/mmgw8qa6RvwGntHPx8b4BG+RUlT/DEhjmKsAt/4zKB0gSA9zUaW3uThAuB
        q6OmYcIqtIG0pkq1807cfeIi7oAfGSekCFYxH+06DAvUdovVDkq0S7U7D+cOn8sw
        yxM=
X-Virus-Scanned: Debian amavisd-new at srv6.fidu.org
Received: from srv6.fidu.org ([127.0.0.1])
        by localhost (srv6.fidu.org [127.0.0.1]) (amavisd-new, port 10026)
        with LMTP id bPeQOpll_2Gu for <stable@vger.kernel.org>;
        Wed, 19 Oct 2022 16:01:47 +0200 (CEST)
Received: from wsembach-tuxedo.fritz.box (business-24-134-105-141.pool2.vodafone-ip.de [24.134.105.141])
        (Authenticated sender: wse@tuxedocomputers.com)
        by srv6.fidu.org (Postfix) with ESMTPA id 46FD4C80091
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 16:01:47 +0200 (CEST)
From:   Werner Sembach <wse@tuxedocomputers.com>
To:     stable@vger.kernel.org
Subject: [PATCH] ACPI: video: Force backlight native for more TongFang devices
Date:   Wed, 19 Oct 2022 16:01:42 +0200
Message-Id: <20221019140142.17558-1-wse@tuxedocomputers.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 3dbc80a3e4c55c4a5b89ef207bed7b7de36157b4 upstream.

The upstream commit "ACPI: video: Make backlight class device registration
a separate step (v2)" changes the logic in a way that these quirks are not
required anymore, but kernel <= 6.0 still need these.

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

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
---
 drivers/acpi/video_detect.c | 64 +++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 3b972ca53689..e5518b88f710 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -463,6 +463,70 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
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

