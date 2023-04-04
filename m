Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038746D5EB8
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 13:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234527AbjDDLKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 07:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234516AbjDDLKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 07:10:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78062133
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 04:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680606570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EzDn6/dNG6W9bpF33/A9akZ0Fh/d2exOdQEiIaEENDw=;
        b=JfIFQaRdpAoqSOeW0J/Q9E3lkF00QccO76lLh+6GOHse0c4sLGrSEnV15uvdAg85I8xa+0
        maJt968MdKLt0uPJ2nJYPUWWfS5ujW8dWbA/WJJJH89cKj/FUzvWFv1xzNM7jrdHxW1iy1
        RSUSrwn7U/AVf7elhi4nCQ5oYi2jwIw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-BCG8yJebOG2X3wdA7GNOnQ-1; Tue, 04 Apr 2023 07:03:09 -0400
X-MC-Unique: BCG8yJebOG2X3wdA7GNOnQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 252403C16E84;
        Tue,  4 Apr 2023 11:03:09 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.74])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2067C483EC1;
        Tue,  4 Apr 2023 11:03:08 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     "Rafael J . Wysocki" <rafael@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Daniel Dadap <ddadap@nvidia.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2 3/6] ACPI: video: Add acpi_backlight=video quirk for Apple iMac14,1 and iMac14,2
Date:   Tue,  4 Apr 2023 13:02:48 +0200
Message-Id: <20230404110251.42449-4-hdegoede@redhat.com>
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

On the Apple iMac14,1 and iMac14,2 all-in-ones (monitors with builtin "PC")
the connection between the GPU and the panel is seen by the GPU driver as
regular DP instead of eDP, causing the GPU driver to never call
acpi_video_register_backlight().

(GPU drivers only call acpi_video_register_backlight() when an internal
 panel is detected, to avoid non working acpi_video# devices getting
 registered on desktops which unfortunately is a real issue.)

Fix the missing acpi_video# backlight device on these all-in-ones by
adding a acpi_backlight=video DMI quirk, so that video.ko will
immediately register the backlight device instead of waiting for
an acpi_video_register_backlight() call.

Fixes: 5aa9d943e9b6 ("ACPI: video: Don't enable fallback path for creating ACPI backlight by default")
Cc: stable@vger.kernel.org
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/acpi/video_detect.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index f7c218dd8742..295744fe7c92 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -276,6 +276,29 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		},
 	},
 
+	/*
+	 * Models which need acpi_video backlight control where the GPU drivers
+	 * do not call acpi_video_register_backlight() because no internal panel
+	 * is detected. Typically these are all-in-ones (monitors with builtin
+	 * PC) where the panel connection shows up as regular DP instead of eDP.
+	 */
+	{
+	 .callback = video_detect_force_video,
+	 /* Apple iMac14,1 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "iMac14,1"),
+		},
+	},
+	{
+	 .callback = video_detect_force_video,
+	 /* Apple iMac14,2 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "iMac14,2"),
+		},
+	},
+
 	/*
 	 * These models have a working acpi_video backlight control, and using
 	 * native backlight causes a regression where backlight does not work
-- 
2.39.1

