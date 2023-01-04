Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFADC65D81F
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239734AbjADQLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239872AbjADQKj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:10:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0B81705F
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:10:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2924B8171C
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CB0C433F0;
        Wed,  4 Jan 2023 16:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848635;
        bh=59SvUcSmaASt14zvlSbB04zfzDQcW3y2jq00V/IEwJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QF7ELPGGGpoYe1KY15oP65RaBta0Asop0yBt4xWO4MNvJoSo2xujqwRamKUzGVh9C
         rru+Mire0s/5CgnoWEBIQf4qclXoDUb80QswAgBE/cNrxg9UOJiiUR4UUYy8lHwsrQ
         v/t0HlWZtCtidsfENzQgWG16tqdnNuuV0BzQ2Flw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/207] ACPI: video: Simplify __acpi_video_get_backlight_type()
Date:   Wed,  4 Jan 2023 17:05:04 +0100
Message-Id: <20230104160513.373492984@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

[ Upstream commit a5df42521f328b45c9d89c13740e747be08ac66e ]

Simplify __acpi_video_get_backlight_type() removing a nested if which
makes the flow harder to follow.

This also results in having only 1 exit point with
return acpi_backlight_native instead of 2.

Note this drops the (video_caps & ACPI_VIDEO_BACKLIGHT) check from
the if (acpi_osi_is_win8() && native_available) return native path.
Windows 8's hardware certification requirements include that there must
be ACPI video bus backlight control, so the ACPI_VIDEO_BACKLIGHT check
is redundant.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 13f10fbcd7f0..0c17ee93f861 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -734,6 +734,16 @@ static bool google_cros_ec_present(void)
 	return acpi_dev_found("GOOG0004") || acpi_dev_found("GOOG000C");
 }
 
+/*
+ * Windows 8 and newer no longer use the ACPI video interface, so it often
+ * does not work. So on win8+ systems prefer native brightness control.
+ * Chromebooks should always prefer native backlight control.
+ */
+static bool prefer_native_over_acpi_video(void)
+{
+	return acpi_osi_is_win8() || google_cros_ec_present();
+}
+
 /*
  * Determine which type of backlight interface to use on this system,
  * First check cmdline, then dmi quirks, then do autodetect.
@@ -779,26 +789,14 @@ static enum acpi_backlight_type __acpi_video_get_backlight_type(bool native)
 	if (apple_gmux_backlight_present())
 		return acpi_backlight_apple_gmux;
 
-	/* Chromebooks should always prefer native backlight control. */
-	if (google_cros_ec_present() && native_available)
-		return acpi_backlight_native;
+	/* Use ACPI video if available, except when native should be preferred. */
+	if ((video_caps & ACPI_VIDEO_BACKLIGHT) &&
+	     !(native_available && prefer_native_over_acpi_video()))
+		return acpi_backlight_video;
 
-	/* On systems with ACPI video use either native or ACPI video. */
-	if (video_caps & ACPI_VIDEO_BACKLIGHT) {
-		/*
-		 * Windows 8 and newer no longer use the ACPI video interface,
-		 * so it often does not work. If the ACPI tables are written
-		 * for win8 and native brightness ctl is available, use that.
-		 *
-		 * The native check deliberately is inside the if acpi-video
-		 * block on older devices without acpi-video support native
-		 * is usually not the best choice.
-		 */
-		if (acpi_osi_is_win8() && native_available)
-			return acpi_backlight_native;
-		else
-			return acpi_backlight_video;
-	}
+	/* Use native if available */
+	if (native_available && prefer_native_over_acpi_video())
+		return acpi_backlight_native;
 
 	/* No ACPI video (old hw), use vendor specific fw methods. */
 	return acpi_backlight_vendor;
-- 
2.35.1



