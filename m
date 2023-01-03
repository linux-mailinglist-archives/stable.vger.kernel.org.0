Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738C165C668
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 19:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbjACSjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 13:39:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbjACSjn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 13:39:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABB211156;
        Tue,  3 Jan 2023 10:39:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90228B810AB;
        Tue,  3 Jan 2023 18:39:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4857CC433F2;
        Tue,  3 Jan 2023 18:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672771180;
        bh=Nh+PE6b0zozXPBpBs8UrxaUxKujKyhLS05XtQAqHiw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pnbm9d5RhBTq5rfcX6PjvDjPAXMbKGJAxDQHmlFvrS0mqy4h4DkYKgoMdTPf+6jjt
         lQKCcm4uZCy6Heuup1kPsTt+YIofiwNG+eQZvDhNxHilaRcTkiXVaEAarssP5DAcCm
         26TrX5JT0j9771ihOKvIcUvRRm+szrHDzVrGkf2GXQb5NnlHwHyncwjGMV8Dz2u2Ck
         hSm6JL4uAXmJpGpOscZLJFycYMfB4zHXMIYPpKTzv6ur22OpC3x+6xBUmX0sar56i4
         Pm5MM7bceZbc/3Zj6y1wcfbKTa5JqmKDcia4wpNjX68KZreHO6fDfFv/GibuLYrVhr
         Nhl2d3SpFRZtw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        robert.moore@intel.com, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 6.1 03/10] ACPI: video: Allow GPU drivers to report no panels
Date:   Tue,  3 Jan 2023 13:39:27 -0500
Message-Id: <20230103183934.2022663-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230103183934.2022663-1-sashal@kernel.org>
References: <20230103183934.2022663-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 00a734104af7d878f1252d49eff9298785c6cbdc ]

The current logic for the ACPI backlight detection will create
a backlight device if no native or vendor drivers have created
8 seconds after the system has booted if the ACPI tables
included backlight control methods.

If the GPU drivers have loaded, they may be able to report whether
any LCD panels were found.  Allow using this information to factor
in whether to enable the fallback logic for making an acpi_video0
backlight device.

Suggested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_video.c | 11 +++++++++++
 include/acpi/video.h      |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
index 32953646caeb..f64fdb029090 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -2178,6 +2178,17 @@ static bool should_check_lcd_flag(void)
 	return false;
 }
 
+/*
+ * At least one graphics driver has reported that no LCD is connected
+ * via the native interface. cancel the registration for fallback acpi_video0.
+ * If another driver still deems this necessary, it can explicitly register it.
+ */
+void acpi_video_report_nolcd(void)
+{
+	cancel_delayed_work(&video_bus_register_backlight_work);
+}
+EXPORT_SYMBOL(acpi_video_report_nolcd);
+
 int acpi_video_register(void)
 {
 	int ret = 0;
diff --git a/include/acpi/video.h b/include/acpi/video.h
index a275c35e5249..8ed9bec03e53 100644
--- a/include/acpi/video.h
+++ b/include/acpi/video.h
@@ -53,6 +53,7 @@ enum acpi_backlight_type {
 };
 
 #if IS_ENABLED(CONFIG_ACPI_VIDEO)
+extern void acpi_video_report_nolcd(void);
 extern int acpi_video_register(void);
 extern void acpi_video_unregister(void);
 extern void acpi_video_register_backlight(void);
@@ -69,6 +70,7 @@ extern int acpi_video_get_levels(struct acpi_device *device,
 				 struct acpi_video_device_brightness **dev_br,
 				 int *pmax_level);
 #else
+static inline void acpi_video_report_nolcd(void) { return; };
 static inline int acpi_video_register(void) { return -ENODEV; }
 static inline void acpi_video_unregister(void) { return; }
 static inline void acpi_video_register_backlight(void) { return; }
-- 
2.35.1

