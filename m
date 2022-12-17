Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E042A64F9FF
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiLQP3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiLQP2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:28:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410F11649D;
        Sat, 17 Dec 2022 07:27:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF703B803F5;
        Sat, 17 Dec 2022 15:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4CCC433F0;
        Sat, 17 Dec 2022 15:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671290868;
        bh=joUiXrawmAJHiaVDfPQdm0pzrZtel83AWOUVXLSsXaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wpr0SB3m/6qCwbpM32IYpkMvQf5+O6jyHMlD1mzLZZtGSMNP/WsPfVdn99xKoVaNo
         UqiLoj3c4Ha430mnzvMZgHCmAKTEiMUTVp8PRI00+ywrRU9QOWr04P5jrUl7YPd1Av
         KgR6QLJQD/O+lYPbcoeIdGr0/exyfkZETmt8qmkiNrdRQchKP4sBu0NxRuYqSPNkrm
         kr9x1FUs9hj5zH9tHpGu28KHi8FWbfBvXNicXd/bplZkan3blodvWXyCkp9FWgDyLI
         5bzFRGB6xmsLlAEv94O9RyVuEdI6j5nRy2Sa9n1Hzc6Mvr//ry4RaYIFjrQknFzMz0
         ylNM4+JdezwMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 11/22] ACPI: video: Add force_vendor quirk for Sony Vaio PCG-FRV35
Date:   Sat, 17 Dec 2022 10:27:12 -0500
Message-Id: <20221217152727.98061-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217152727.98061-1-sashal@kernel.org>
References: <20221217152727.98061-1-sashal@kernel.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 23735543eb228c604e59f99f2f5d13aa507e5db2 ]

The Sony Vaio PCG-FRV35 advertises both native and vendor backlight
control interfaces. With the upcoming changes to prefer native over
vendor acpi_video_get_backlight_type() will start returning native on
these laptops.

But the native radeon_bl0 interface does not work, where as the sony
vendor interface does work. Add a quirk to force use of the vendor
interface.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 0ab98f2e484c..8e8b435b4c8c 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -237,6 +237,19 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		},
 	},
 
+	/*
+	 * Models which should use the vendor backlight interface,
+	 * because of broken native backlight control.
+	 */
+	{
+	 .callback = video_detect_force_vendor,
+	 /* Sony Vaio PCG-FRV35 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "PCG-FRV35"),
+		},
+	},
+
 	/*
 	 * Toshiba models with Transflective display, these need to use
 	 * the toshiba_acpi vendor driver for proper Transflective handling.
-- 
2.35.1

