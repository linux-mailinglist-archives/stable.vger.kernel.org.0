Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386AD6DEF95
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbjDLIwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbjDLIwN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:52:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A30093ED
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:51:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DED076319B
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBD8C433EF;
        Wed, 12 Apr 2023 08:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289509;
        bh=lvFSa5UtYCeK0PTqjImMgwr9fydJbYwZ4FO0sAbVKHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eqcHo/H/6i0qH3Xj1YX10a+y4eDouQU5xgrzqx48FCNXz/PiwCekx7UGPmnyom4Ub
         dZ+Jmz3k7x8FhjYAMwjKGNoELWPouHsZEryhuB6d0gXKspMfzPS9oFa4vc7yQwkwpd
         CEv9KamoyMnrZRfHUUl0Ssx6D/K4U7FrVRUVWqfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.2 119/173] ACPI: video: Add acpi_backlight=video quirk for Lenovo ThinkPad W530
Date:   Wed, 12 Apr 2023 10:34:05 +0200
Message-Id: <20230412082842.907706556@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit a5b2781dcab2c77979a4b8adda781d2543580901 upstream.

The Lenovo ThinkPad W530 uses a nvidia k1000m GPU. When this gets used
together with one of the older nvidia binary driver series (the latest
series does not support it), then backlight control does not work.

This is caused by commit 3dbc80a3e4c5 ("ACPI: video: Make backlight
class device registration a separate step (v2)") combined with
commit 5aa9d943e9b6 ("ACPI: video: Don't enable fallback path for
creating ACPI backlight by default").

After these changes the acpi_video# backlight device is only registered
when requested by a GPU driver calling acpi_video_register_backlight()
which the nvidia binary driver does not do.

I realize that using the nvidia binary driver is not a supported use-case
and users can workaround this by adding acpi_backlight=video on the kernel
commandline, but the ThinkPad W530 is a popular model under Linux users,
so it seems worthwhile to add a quirk for this.

I will also email Nvidia asking them to make the driver call
acpi_video_register_backlight() when an internal LCD panel is detected.
So maybe the next maintenance release of the drivers will fix this...

Fixes: 5aa9d943e9b6 ("ACPI: video: Don't enable fallback path for creating ACPI backlight by default")
Cc: All applicable <stable@vger.kernel.org>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/video_detect.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -300,6 +300,20 @@ static const struct dmi_system_id video_
 	},
 
 	/*
+	 * Older models with nvidia GPU which need acpi_video backlight
+	 * control and where the old nvidia binary driver series does not
+	 * call acpi_video_register_backlight().
+	 */
+	{
+	 .callback = video_detect_force_video,
+	 /* ThinkPad W530 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad W530"),
+		},
+	},
+
+	/*
 	 * These models have a working acpi_video backlight control, and using
 	 * native backlight causes a regression where backlight does not work
 	 * when userspace is not handling brightness key events. Disable


