Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36406D4D18
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 18:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbjDCQEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 12:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233158AbjDCQEl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 12:04:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57082D5A
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 09:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680537827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qz47ygUTtJFsbQSSqll5q7aL5tEKMt97oq3yTwrvfdU=;
        b=YTphF4iRFyj3UWiAJ0QxTpIkBVYTdAUWk5GKEdcGHZnHlKJvWd2vPeGghjgcUp5o81yGEP
        kUlcwl7ikZN9ESRIxoZjfi153J4QPMKYAqjYG0n4F36XFjDinGSku85q5EMqAhryPN48tF
        6urjq3Ib0PlxOi/B1p5TL/Q4F75bLfs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-UlKovdj-NbaUXgmqCwIgog-1; Mon, 03 Apr 2023 12:03:43 -0400
X-MC-Unique: UlKovdj-NbaUXgmqCwIgog-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C67E101A531;
        Mon,  3 Apr 2023 16:03:43 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 68D2A2166B26;
        Mon,  3 Apr 2023 16:03:42 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     "Rafael J . Wysocki" <rafael@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Daniel Dadap <ddadap@nvidia.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 4/6] ACPI: video: Add acpi_backlight=video quirk for Lenovo ThinkPad W530
Date:   Mon,  3 Apr 2023 18:03:27 +0200
Message-Id: <20230403160329.707176-5-hdegoede@redhat.com>
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
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/acpi/video_detect.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 295744fe7c92..e85729fc481f 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -299,6 +299,20 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		},
 	},
 
+	/*
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
 	/*
 	 * These models have a working acpi_video backlight control, and using
 	 * native backlight causes a regression where backlight does not work
-- 
2.39.1

