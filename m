Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A835E6D4D12
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 18:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbjDCQEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 12:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbjDCQEd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 12:04:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EE52684
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 09:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680537824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZFVVTffN7T4iHRpTNuctasc2/r1P7S64tl62ohoRynw=;
        b=PRsu7hb6BQYq3qljcU35vZXhRj1Gj6vrhMupeYpm5o9PJemba3UcfgFPsx/CQYHvPSmHY3
        8Xfby3DWFFz74k52H6unspKOnJVNJ2he5iaY8piBFdsl08hhrsAXuO0JKXGgGd1VtZb9cq
        INj3ydECITN/nco7qwHz9gm3BSkf5MM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-385-3sXnh4DKO4uOygpOMo5y2Q-1; Mon, 03 Apr 2023 12:03:40 -0400
X-MC-Unique: 3sXnh4DKO4uOygpOMo5y2Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD67C3C17F42;
        Mon,  3 Apr 2023 16:03:39 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E794C2166B26;
        Mon,  3 Apr 2023 16:03:38 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     "Rafael J . Wysocki" <rafael@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Daniel Dadap <ddadap@nvidia.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/6] ACPI: video: Add auto_detect arg to __acpi_video_get_backlight_type()
Date:   Mon,  3 Apr 2023 18:03:24 +0200
Message-Id: <20230403160329.707176-2-hdegoede@redhat.com>
In-Reply-To: <20230403160329.707176-1-hdegoede@redhat.com>
References: <20230403160329.707176-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Allow callers of __acpi_video_get_backlight_type() to pass a pointer
to a bool which will get set to false if the backlight-type comes from
the cmdline or a DMI quirk and set to true if auto-detection was used.

And make __acpi_video_get_backlight_type() non static so that it can
be called directly outside of video_detect.c .

While at it turn the acpi_video_get_backlight_type() and
acpi_video_backlight_use_native() wrappers into static inline functions
in include/acpi/video.h, so that we need to export one less symbol.

Fixes: 5aa9d943e9b6 ("ACPI: video: Don't enable fallback path for creating ACPI backlight by default")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/acpi/video_detect.c | 21 ++++++++-------------
 include/acpi/video.h        | 15 +++++++++++++--
 2 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index fd7cbce8076e..f7c218dd8742 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -782,7 +782,7 @@ static bool prefer_native_over_acpi_video(void)
  * Determine which type of backlight interface to use on this system,
  * First check cmdline, then dmi quirks, then do autodetect.
  */
-static enum acpi_backlight_type __acpi_video_get_backlight_type(bool native)
+enum acpi_backlight_type __acpi_video_get_backlight_type(bool native, bool *auto_detect)
 {
 	static DEFINE_MUTEX(init_mutex);
 	static bool nvidia_wmi_ec_present;
@@ -807,6 +807,9 @@ static enum acpi_backlight_type __acpi_video_get_backlight_type(bool native)
 		native_available = true;
 	mutex_unlock(&init_mutex);
 
+	if (auto_detect)
+		*auto_detect = false;
+
 	/*
 	 * The below heuristics / detection steps are in order of descending
 	 * presedence. The commandline takes presedence over anything else.
@@ -818,6 +821,9 @@ static enum acpi_backlight_type __acpi_video_get_backlight_type(bool native)
 	if (acpi_backlight_dmi != acpi_backlight_undef)
 		return acpi_backlight_dmi;
 
+	if (auto_detect)
+		*auto_detect = true;
+
 	/* Special cases such as nvidia_wmi_ec and apple gmux. */
 	if (nvidia_wmi_ec_present)
 		return acpi_backlight_nvidia_wmi_ec;
@@ -837,15 +843,4 @@ static enum acpi_backlight_type __acpi_video_get_backlight_type(bool native)
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
diff --git a/include/acpi/video.h b/include/acpi/video.h
index 8ed9bec03e53..ff5a8da5d883 100644
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
@@ -69,6 +67,19 @@ extern bool acpi_video_handles_brightness_key_presses(void);
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
-- 
2.39.1

