Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65AC65B0AB
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbjABL1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbjABL0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:26:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74F7655D
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:25:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6397660F37
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:25:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775ABC433EF;
        Mon,  2 Jan 2023 11:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658721;
        bh=OJxtv8Lu4/H79MRZceI+ffMKtRC/yFWX/+WKxj2GxG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BOmomBraq45X3edF+YeRvWNrCYjlgm+xVCdhfmKYOlpHURPZNbyOark5mScHqdWf8
         ootNw57mAsFedHx4/2bwey/Pgg0e5jg3JjCf3KZ7s4Etu36ipaF0N4R6W8o6rIVtxC
         60GX1fG+6fgyOPIm7LpO3msw/+vFo8keeMSRPSc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Aditya Garg <gargaditya08@live.com>
Subject: [PATCH 6.1 10/71] ACPI: video: Fix Apple GMUX backlight detection
Date:   Mon,  2 Jan 2023 12:21:35 +0100
Message-Id: <20230102110551.907189699@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
References: <20230102110551.509937186@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 3cf3b7f012f3ea8bdc56196e367cf07c10424855 ]

The apple-gmux driver only binds to old GMUX devices which have an
IORESOURCE_IO resource (using inb()/outb()) rather then memory-mapped
IO (IORESOURCE_MEM).

T2 MacBooks use the new style GMUX devices (with IORESOURCE_MEM access),
so these are not supported by the apple-gmux driver. This is not a problem
since they have working ACPI video backlight support.

But the apple_gmux_present() helper only checks if an ACPI device with
the "APP000B" HID is present, causing acpi_video_get_backlight_type()
to return acpi_backlight_apple_gmux disabling the acpi_video backlight
device.

Add a new apple_gmux_backlight_present() helper which checks that
the "APP000B" device actually is an old GMUX device with an IORESOURCE_IO
resource.

This fixes the acpi_video0 backlight no longer registering on T2 MacBooks.

Note people are working to add support for the new style GMUX to Linux:
https://github.com/kekrby/linux-t2/commits/wip/hybrid-graphics

Once this lands this patch should be reverted so that
acpi_video_get_backlight_type() also prefers the gmux on new style GMUX
MacBooks, but for now this is necessary to avoid regressing backlight
control on T2 Macs.

Fixes: 21245df307cb ("ACPI: video: Add Apple GMUX brightness control detection")
Reported-and-tested-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index ffa19d418847..13f10fbcd7f0 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -34,6 +34,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/platform_data/x86/nvidia-wmi-ec-backlight.h>
+#include <linux/pnp.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
 #include <acpi/video.h>
@@ -105,6 +106,26 @@ static bool nvidia_wmi_ec_supported(void)
 }
 #endif
 
+static bool apple_gmux_backlight_present(void)
+{
+	struct acpi_device *adev;
+	struct device *dev;
+
+	adev = acpi_dev_get_first_match_dev(GMUX_ACPI_HID, NULL, -1);
+	if (!adev)
+		return false;
+
+	dev = acpi_get_first_physical_node(adev);
+	if (!dev)
+		return false;
+
+	/*
+	 * drivers/platform/x86/apple-gmux.c only supports old style
+	 * Apple GMUX with an IO-resource.
+	 */
+	return pnp_get_resource(to_pnp_dev(dev), IORESOURCE_IO, 0) != NULL;
+}
+
 /* Force to use vendor driver when the ACPI device is known to be
  * buggy */
 static int video_detect_force_vendor(const struct dmi_system_id *d)
@@ -755,7 +776,7 @@ static enum acpi_backlight_type __acpi_video_get_backlight_type(bool native)
 	if (nvidia_wmi_ec_present)
 		return acpi_backlight_nvidia_wmi_ec;
 
-	if (apple_gmux_present())
+	if (apple_gmux_backlight_present())
 		return acpi_backlight_apple_gmux;
 
 	/* Chromebooks should always prefer native backlight control. */
-- 
2.35.1



