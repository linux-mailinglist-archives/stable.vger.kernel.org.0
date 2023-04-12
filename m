Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00FDE6DEEF6
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbjDLIqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbjDLIqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:46:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35A183EE
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:46:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D392E630EC
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:45:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F8EC433EF;
        Wed, 12 Apr 2023 08:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289130;
        bh=dxP/zdCgUu4U78LfQNvK3j0COt/fbv592/boMGmKGr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RZJDO9F7ViQajwyOHNn8xUkOk5qZU/Mz1Eug17aK8M1Q2p+1sGMrbiecg/45bLBoR
         cG13ogiLVw5uJ7yW1PZvwwukE/pdI/GXcl22xLaALXHoc22cVtd1EccFCFJl9UTUi6
         IFcLvTAguCpLFXB3cSFYdK7Vby4Nk+kteRe1OH4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 118/164] ACPI: video: Add auto_detect arg to __acpi_video_get_backlight_type()
Date:   Wed, 12 Apr 2023 10:34:00 +0200
Message-Id: <20230412082841.620532513@linuxfoundation.org>
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

commit 78dfc9d1d1abb9e400386fa9c5724a8f7d75e3b9 upstream.

Allow callers of __acpi_video_get_backlight_type() to pass a pointer
to a bool which will get set to false if the backlight-type comes from
the cmdline or a DMI quirk and set to true if auto-detection was used.

And make __acpi_video_get_backlight_type() non static so that it can
be called directly outside of video_detect.c .

While at it turn the acpi_video_get_backlight_type() and
acpi_video_backlight_use_native() wrappers into static inline functions
in include/acpi/video.h, so that we need to export one less symbol.

Fixes: 5aa9d943e9b6 ("ACPI: video: Don't enable fallback path for creating ACPI backlight by default")
Cc: All applicable <stable@vger.kernel.org>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/video_detect.c |   21 ++++++++-------------
 include/acpi/video.h        |   15 +++++++++++++--
 2 files changed, 21 insertions(+), 15 deletions(-)

--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -772,7 +772,7 @@ static bool prefer_native_over_acpi_vide
  * Determine which type of backlight interface to use on this system,
  * First check cmdline, then dmi quirks, then do autodetect.
  */
-static enum acpi_backlight_type __acpi_video_get_backlight_type(bool native)
+enum acpi_backlight_type __acpi_video_get_backlight_type(bool native, bool *auto_detect)
 {
 	static DEFINE_MUTEX(init_mutex);
 	static bool nvidia_wmi_ec_present;
@@ -797,6 +797,9 @@ static enum acpi_backlight_type __acpi_v
 		native_available = true;
 	mutex_unlock(&init_mutex);
 
+	if (auto_detect)
+		*auto_detect = false;
+
 	/*
 	 * The below heuristics / detection steps are in order of descending
 	 * presedence. The commandline takes presedence over anything else.
@@ -808,6 +811,9 @@ static enum acpi_backlight_type __acpi_v
 	if (acpi_backlight_dmi != acpi_backlight_undef)
 		return acpi_backlight_dmi;
 
+	if (auto_detect)
+		*auto_detect = true;
+
 	/* Special cases such as nvidia_wmi_ec and apple gmux. */
 	if (nvidia_wmi_ec_present)
 		return acpi_backlight_nvidia_wmi_ec;
@@ -827,15 +833,4 @@ static enum acpi_backlight_type __acpi_v
 	/* No ACPI video/native (old hw), use vendor specific fw methods. */
 	return acpi_backlight_vendor;
 }
-
-enum acpi_backlight_type acpi_video_get_backlight_type(void)
-{
-	return __acpi_video_get_backlight_type(false);
-}
-EXPORT_SYMBOL(acpi_video_get_backlight_type);
-
-bool acpi_video_backlight_use_native(void)
-{
-	return __acpi_video_get_backlight_type(true) == acpi_backlight_native;
-}
-EXPORT_SYMBOL(acpi_video_backlight_use_native);
+EXPORT_SYMBOL(__acpi_video_get_backlight_type);
--- a/include/acpi/video.h
+++ b/include/acpi/video.h
@@ -59,8 +59,6 @@ extern void acpi_video_unregister(void);
 extern void acpi_video_register_backlight(void);
 extern int acpi_video_get_edid(struct acpi_device *device, int type,
 			       int device_id, void **edid);
-extern enum acpi_backlight_type acpi_video_get_backlight_type(void);
-extern bool acpi_video_backlight_use_native(void);
 /*
  * Note: The value returned by acpi_video_handles_brightness_key_presses()
  * may change over time and should not be cached.
@@ -69,6 +67,19 @@ extern bool acpi_video_handles_brightnes
 extern int acpi_video_get_levels(struct acpi_device *device,
 				 struct acpi_video_device_brightness **dev_br,
 				 int *pmax_level);
+
+extern enum acpi_backlight_type __acpi_video_get_backlight_type(bool native,
+								bool *auto_detect);
+
+static inline enum acpi_backlight_type acpi_video_get_backlight_type(void)
+{
+	return __acpi_video_get_backlight_type(false, NULL);
+}
+
+static inline bool acpi_video_backlight_use_native(void)
+{
+	return __acpi_video_get_backlight_type(true, NULL) == acpi_backlight_native;
+}
 #else
 static inline void acpi_video_report_nolcd(void) { return; };
 static inline int acpi_video_register(void) { return -ENODEV; }


