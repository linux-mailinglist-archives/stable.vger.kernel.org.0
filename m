Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 276476D5EA4
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 13:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234925AbjDDLHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 07:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234929AbjDDLH0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 07:07:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4461B4C04
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 04:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680606193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S6G15+Qb0LvZL3r0FsdCRRwfCNhDekze4m5/CZlC9wE=;
        b=cSDVCUxcoWCVU7Ofsg1uwY/ONlkiuHczZm0Ckz17fYHOuY08LnTNiyzDsqe6ZFLnfyR5IM
        VUBhX2/+rJCeScBbKGdCa7FtAQGfZ2ox0ZVoIBDmhyKBpMjcFTLMDYc6uGZjMt2TY2NEpB
        FSk13SO7FX/ceDzgR1VYLQgM6S7Rns8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-oo7KBZ4tMXSC8FXq-j5MiA-1; Tue, 04 Apr 2023 07:03:08 -0400
X-MC-Unique: oo7KBZ4tMXSC8FXq-j5MiA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF79D101A552;
        Tue,  4 Apr 2023 11:03:07 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.74])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DEB3F40104E;
        Tue,  4 Apr 2023 11:03:06 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     "Rafael J . Wysocki" <rafael@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Daniel Dadap <ddadap@nvidia.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2 2/6] ACPI: video: Make acpi_backlight=video work independent from GPU driver
Date:   Tue,  4 Apr 2023 13:02:47 +0200
Message-Id: <20230404110251.42449-3-hdegoede@redhat.com>
In-Reply-To: <20230404110251.42449-1-hdegoede@redhat.com>
References: <20230404110251.42449-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
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

