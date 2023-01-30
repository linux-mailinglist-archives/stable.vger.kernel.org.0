Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20BD46810CC
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237091AbjA3OGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:06:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237095AbjA3OGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:06:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16A63B3FE
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:06:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 652A7B81151
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A481C433D2;
        Mon, 30 Jan 2023 14:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087608;
        bh=oI1QoXv9dNopkbyJTTg6+f0WrzO0tW4HFl+XeDOGJl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/1acJUsCDh9ABjS91lXf5EFWBVnDVdC2BRSMgcgNu0+oKpAOGodXrg4lMQIGp9So
         x+uHzIwITcHyIf0rXw5916IcImYhxpRR9fXaqLaPRme/2QPLuHfS37fMyVLiJqBsM3
         qne4zKZwf6lY5Aw4CbY4lE3zotolV8HVGaoTZmEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 263/313] ACPI: video: Add backlight=native DMI quirk for Asus U46E
Date:   Mon, 30 Jan 2023 14:51:38 +0100
Message-Id: <20230130134348.994273641@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit e6b3086fddc0065a5ffb947d4d29dd0e6efc327b ]

The Asus U46E backlight tables have a set of interesting problems:

1. Its ACPI tables do make _OSI ("Windows 2012") checks, so
   acpi_osi_is_win8() should return true.

   But the tables have 2 sets of _OSI calls, one from the usual global
   _INI method setting a global OSYS variable and a second set of _OSI
   calls from a MSOS method and the MSOS method is the only one calling
   _OSI ("Windows 2012").

   The MSOS method only gets called in the following cases:
   1. From some Asus specific WMI methods
   2. From _DOD, which only runs after acpi_video_get_backlight_type()
      has already been called by the i915 driver
   3. From other ACPI video bus methods which never run (see below)
   4. From some EC query callbacks

   So when i915 calls acpi_video_get_backlight_type() MSOS has never run
   and acpi_osi_is_win8() returns false, so acpi_video_get_backlight_type()
   returns acpi_video as the desired backlight type, which causes
   the intel_backlight device to not register.

2. _DOD effectively does this:

                    Return (Package (0x01)
                    {
                        0x0400
                    })

   causing acpi_video_device_in_dod() to return false, which causes
   the acpi_video backlight device to not register.

Leaving the user with no backlight device at all. Note that before 6.1.y
the i915 driver would register the intel_backlight device unconditionally
and since that then was the only backlight device userspace would use that.

Add a backlight=native DMI quirk for this special laptop to restore
the old (and working) behavior of the intel_backlight device registering.

Fixes: fb1836c91317 ("ACPI: video: Prefer native over vendor")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 4719978b8aa3..04f3b26e3a75 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -600,6 +600,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "GA503"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* Asus U46E */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "U46E"),
+		},
+	},
 	{
 	 .callback = video_detect_force_native,
 	 /* Asus UX303UB */
-- 
2.39.0



