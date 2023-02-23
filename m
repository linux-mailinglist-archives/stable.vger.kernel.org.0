Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4726A0977
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbjBWNGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233657AbjBWNGN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:06:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A9955C0C
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:06:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DDDA5CE2014
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0445FC433EF;
        Thu, 23 Feb 2023 13:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157569;
        bh=wWuF2RiU/Jx4joPyaylmuwmJNQqnww36DoAq1HiYwck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x1B9eTA6sVSlbSkXc9AevL2DW80/GoijLitupimIHoXsr+LI3vtsN2ugFQBsSxhFd
         AVpl1IFFWzXJmfN0WAuSbwib1LZbM7AFWx2TcWCRtfNvhCn8WQTARO5uaOU8y+ZXSq
         mNWqmjuBOu9JeeIYjtN/8rRe6Lm7wThqIDpcw2j8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Daniel Dadap <ddadap@nvidia.com>
Subject: [PATCH 6.2 09/11] platform/x86: nvidia-wmi-ec-backlight: Add force module parameter
Date:   Thu, 23 Feb 2023 14:05:03 +0100
Message-Id: <20230223130426.552183775@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130426.170746546@linuxfoundation.org>
References: <20230223130426.170746546@linuxfoundation.org>
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

commit 0d9bdd8a550170306c2021b8d6766c5343b870c2 upstream.

On some Lenovo Legion models, the backlight might be driven by either
one of nvidia_wmi_ec_backlight or amdgpu_bl0 at different times.

When the Nvidia WMI EC backlight interface reports the backlight is
controlled by the EC, the current backlight handling only registers
nvidia_wmi_ec_backlight (and registers no other backlight interfaces).

This hides (never registers) the amdgpu_bl0 interface, where as prior
to 6.1.4 users would have both nvidia_wmi_ec_backlight and amdgpu_bl0
and could work around things in userspace.

Add a force module parameter which can be used with acpi_backlight=native
to restore the old behavior as a workound (for now) by passing:

"acpi_backlight=native nvidia-wmi-ec-backlight.force=1"

Fixes: 8d0ca287fd8c ("platform/x86: nvidia-wmi-ec-backlight: Use acpi_video_get_backlight_type()")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217026
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Daniel Dadap <ddadap@nvidia.com>
Link: https://lore.kernel.org/r/20230217144208.5721-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/nvidia-wmi-ec-backlight.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/nvidia-wmi-ec-backlight.c
+++ b/drivers/platform/x86/nvidia-wmi-ec-backlight.c
@@ -12,6 +12,10 @@
 #include <linux/wmi.h>
 #include <acpi/video.h>
 
+static bool force;
+module_param(force, bool, 0444);
+MODULE_PARM_DESC(force, "Force loading (disable acpi_backlight=xxx checks");
+
 /**
  * wmi_brightness_notify() - helper function for calling WMI-wrapped ACPI method
  * @w:    Pointer to the struct wmi_device identified by %WMI_BRIGHTNESS_GUID
@@ -91,7 +95,7 @@ static int nvidia_wmi_ec_backlight_probe
 	int ret;
 
 	/* drivers/acpi/video_detect.c also checks that SOURCE == EC */
-	if (acpi_video_get_backlight_type() != acpi_backlight_nvidia_wmi_ec)
+	if (!force && acpi_video_get_backlight_type() != acpi_backlight_nvidia_wmi_ec)
 		return -ENODEV;
 
 	/*


