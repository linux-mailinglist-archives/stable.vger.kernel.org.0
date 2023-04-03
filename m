Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA87D6D4D1B
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 18:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbjDCQEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 12:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbjDCQEn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 12:04:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE327FB
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 09:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680537825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QFnDNILODHR5me6InULDE/PUm3Vc5LEdBrYsm2u34sI=;
        b=X3xB7iN4RLxwXEwwFbCMHIhIwyRSbK4+2fSi+Jr40FszyNlqZAeTLx5IvqmOdXgkR2QNi0
        D0b6jVQmaQGnYcc3kGxDjldtqHOD5CV3Q2lj9xxbae9DfnPBdb8lx7gf+gGb5IszB08r3h
        1RyM6OC0pU7hsTf7Lj8G7k6RLBgnyU8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-PbXa3y9eOjGTBdraZkoPNQ-1; Mon, 03 Apr 2023 12:03:41 -0400
X-MC-Unique: PbXa3y9eOjGTBdraZkoPNQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 105E5101A553;
        Mon,  3 Apr 2023 16:03:41 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1BF992166B26;
        Mon,  3 Apr 2023 16:03:40 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     "Rafael J . Wysocki" <rafael@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Daniel Dadap <ddadap@nvidia.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 2/6] ACPI: video: Make acpi_backlight=video work independent from GPU driver
Date:   Mon,  3 Apr 2023 18:03:25 +0200
Message-Id: <20230403160329.707176-3-hdegoede@redhat.com>
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
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/acpi/acpi_video.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
index 97b711e57bff..c7a6d0b69dab 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -1984,6 +1984,7 @@ static int instance;
 static int acpi_video_bus_add(struct acpi_device *device)
 {
 	struct acpi_video_bus *video;
+	bool auto_detect;
 	int error;
 	acpi_status status;
 
@@ -2045,10 +2046,20 @@ static int acpi_video_bus_add(struct acpi_device *device)
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
-- 
2.39.1

