Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EECF6DEFEC
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbjDLI4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbjDLI4s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:56:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D6F7AA8
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:56:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 248796317D
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E9EC4339B;
        Wed, 12 Apr 2023 08:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289488;
        bh=/Q3UN315pK5M8c06heD37MxopiZUoKNSvu6wWmkTs/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wIUMb9W8obKBTeLmWAkElMqJERnDj+mShCJvp1c/sbVp1bCZPOkjUvKMwXxLMrfE5
         +FCpIZ/ZFRRsFHEgA5mPNvXXN9qg0vMmxYNXRbGrVsYcEeONcgbwOV97WeC2UWAfcW
         uLKTPM1dP3Cp9zk5seRous77sDN6qkp7nBMhs6ms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.2 117/173] ACPI: video: Make acpi_backlight=video work independent from GPU driver
Date:   Wed, 12 Apr 2023 10:34:03 +0200
Message-Id: <20230412082842.826157314@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
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

commit e506731c8f35699d746c615164ed620cd53c00ca upstream.

Commit 3dbc80a3e4c5 ("ACPI: video: Make backlight class device
registration a separate step (v2)") combined with
commit 5aa9d943e9b6 ("ACPI: video: Don't enable fallback path for
creating ACPI backlight by default")

Means that the video.ko code now fully depends on the GPU driver calling
acpi_video_register_backlight() for the acpi_video# backlight class
devices to get registered.

This means that if the GPU driver does not do this, acpi_backlight=video
on the cmdline, or DMI quirks for selecting acpi_video# will not work.

This is a problem on for example Apple iMac14,1 all-in-ones where
the monitor's LCD panel shows up as a regular DP connection instead of
eDP so the GPU driver will not call acpi_video_register_backlight() [1].

Fix this by making video.ko directly register the acpi_video# devices
when these have been explicitly requested either on the cmdline or
through DMI quirks (rather then auto-detection being used).

[1] GPU drivers only call acpi_video_register_backlight() when an internal
panel is detected, to avoid non working acpi_video# devices getting
registered on desktops which unfortunately is a real issue.

Fixes: 5aa9d943e9b6 ("ACPI: video: Don't enable fallback path for creating ACPI backlight by default")
Cc: All applicable <stable@vger.kernel.org>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_video.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -1984,6 +1984,7 @@ static int instance;
 static int acpi_video_bus_add(struct acpi_device *device)
 {
 	struct acpi_video_bus *video;
+	bool auto_detect;
 	int error;
 	acpi_status status;
 
@@ -2045,10 +2046,20 @@ static int acpi_video_bus_add(struct acp
 	mutex_unlock(&video_list_lock);
 
 	/*
-	 * The userspace visible backlight_device gets registered separately
-	 * from acpi_video_register_backlight().
+	 * If backlight-type auto-detection is used then a native backlight may
+	 * show up later and this may change the result from video to native.
+	 * Therefor normally the userspace visible /sys/class/backlight device
+	 * gets registered separately by the GPU driver calling
+	 * acpi_video_register_backlight() when an internal panel is detected.
+	 * Register the backlight now when not using auto-detection, so that
+	 * when the kernel cmdline or DMI-quirks are used the backlight will
+	 * get registered even if acpi_video_register_backlight() is not called.
 	 */
 	acpi_video_run_bcl_for_osi(video);
+	if (__acpi_video_get_backlight_type(false, &auto_detect) == acpi_backlight_video &&
+	    !auto_detect)
+		acpi_video_bus_register_backlight(video);
+
 	acpi_video_bus_add_notify_handler(video);
 
 	return 0;


