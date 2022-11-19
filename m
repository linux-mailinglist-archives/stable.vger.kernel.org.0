Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3323630A8F
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiKSC1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236054AbiKSC0q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:26:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EA0C75BC;
        Fri, 18 Nov 2022 18:16:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6EEBB82675;
        Sat, 19 Nov 2022 02:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F8EC433D6;
        Sat, 19 Nov 2022 02:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824178;
        bh=bCH7MYI1GijblJTXTLzY7Hpp6MFxcSy81VjOAhyox6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LThOVI/J2e6GUSmVhmm1G1PBLiO9Zww3zrkbIwtUT2YTfzJWa9Ouo6f5cnCkXR9Ex
         39pEUBL94X+H2/QwxS3Lh4CbRzA4m6rdfdP30An/cn8mbyGBYJjLYm6G090YSaff+O
         eicMpx7wemZ+uZwrJ9j9fJIQRc78RRNu/aWuTiWwgaHByUxUiINFlLCHQ4aPoVE1pY
         O84NlSKdI4MV0kfZDXdZO6SV+YYD2zNvMzi/zAfNUtqmZAXMkYQOmB27q8AcNAEE2L
         QgvGgeFWGYx22bK6gnW2xxZuTkt9J5yXM9IoHH6omMgQYZngZtb8k9Vc1hSFErdEso
         YBMK+bITWkh9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Iris <pawel.js@protonmail.com>, Daniel Dadap <ddadap@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 5/8] ACPI: video: Add backlight=native DMI quirk for Dell G15 5515
Date:   Fri, 18 Nov 2022 21:16:06 -0500
Message-Id: <20221119021610.1775469-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021610.1775469-1-sashal@kernel.org>
References: <20221119021610.1775469-1-sashal@kernel.org>
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

[ Upstream commit f46acc1efd4b5846de9fa05f966e504f328f34a6 ]

The Dell G15 5515 has the WMI interface (and WMI call returns) expected
by the nvidia-wmi-ec-backlight interface. But the backlight class device
registered by the nvidia-wmi-ec-backlight driver does not actually work.

The amdgpu_bl0 native GPU backlight class device does actually work,
add a backlight=native DMI quirk for this.

Reported-by: Iris <pawel.js@protonmail.com>
Reviewed-by: Daniel Dadap <ddadap@nvidia.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
- Add a comment that this needs to be revisited when dynamic-mux
  support gets added (suggested by: Daniel Dadap)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 0ec74ab2a399..2008bba48b06 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -511,6 +511,20 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_BOARD_NAME, "GMxRGxx"),
 		},
 	},
+	/*
+	 * Models which have nvidia-ec-wmi support, but should not use it.
+	 * Note this indicates a likely firmware bug on these models and should
+	 * be revisited if/when Linux gets support for dynamic mux mode.
+	 */
+	{
+	 .callback = video_detect_force_native,
+	 /* Dell G15 5515 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Dell G15 5515"),
+		},
+	},
+
 	/*
 	 * Desktops which falsely report a backlight and which our heuristics
 	 * for this do not catch.
-- 
2.35.1

