Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A66E66DEECD
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjDLIpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbjDLIov (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:44:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4FF86B5
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:44:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57809630A1
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F59CC433D2;
        Wed, 12 Apr 2023 08:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289058;
        bh=hw3GM1MrphKYN1jjXC3YijJ126DywjLtlxb4sLXRnko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k45V0vtiD4tP1vL3MQTGIkBVBwCrzQZ3/okY+jxPCnRR/DDBn/FIE2dEnWNk0CHJ/
         HrEzmSc17FEvIdzOMJLPXES0ZfYCx1rn2ttWDzWVLKGcBLncaeeyAFbuOTYhRZqG9g
         14a010LwlpTvYQ7Mef42Q++sZD3ChgrEf0sl3+HI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 121/164] ACPI: video: Add acpi_backlight=video quirk for Lenovo ThinkPad W530
Date:   Wed, 12 Apr 2023 10:34:03 +0200
Message-Id: <20230412082841.730190059@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
@@ -298,6 +298,20 @@ static const struct dmi_system_id video_
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


