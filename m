Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17126630A7B
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235159AbiKSC13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235718AbiKSCZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:25:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29EB80997;
        Fri, 18 Nov 2022 18:15:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E7E9B82676;
        Sat, 19 Nov 2022 02:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85749C433D7;
        Sat, 19 Nov 2022 02:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824153;
        bh=/UNhONuEPMfoFhB7C+3F3s8jtVtjM7CFczWkPwqlbr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GRGhOh+IeNemx2yvsOT/LAfM1m6RsP4bI5oU3PC+KOff7LBAqiKlc0spIa5E17nZ+
         ggzXr/L64PcsI6Y2PCbg5KFsjLoMJJo+7PDw0MTE2t8qqTvKw2PRhsBW63iYWmtZ6F
         VqTgCrnbjRuXXo4Hff09l4Z+AEPbSXR4sw+rQGMmBeN4z5WVHKXnnJsUdAS2Xl2yEI
         UyoFATpOG3fOq8iG5cw9uXFdwdT2yIoACK95l/DPlkE8h95VqLy/CdM1tugBJq/Xxh
         mrgo/UKep4NQ8Kju9vmcPpRkLUtOcMRcE6pwA1tvHTUxQN6z11lbzRiJYLHRKlKxJm
         oa4s5YqY0qZmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Iris <pawel.js@protonmail.com>, Daniel Dadap <ddadap@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/11] ACPI: video: Add backlight=native DMI quirk for Dell G15 5515
Date:   Fri, 18 Nov 2022 21:15:38 -0500
Message-Id: <20221119021543.1775315-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021543.1775315-1-sashal@kernel.org>
References: <20221119021543.1775315-1-sashal@kernel.org>
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
index e5518b88f710..f514b16a5c23 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -527,6 +527,20 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
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

