Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A01758BF4C
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242525AbiHHBhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242082AbiHHBga (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:36:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B53BC1C;
        Sun,  7 Aug 2022 18:33:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D3D860DDB;
        Mon,  8 Aug 2022 01:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6DAC43141;
        Mon,  8 Aug 2022 01:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922408;
        bh=iHZDPs2qdzAjoXp+XZNtkRFmBzqwWwQK3l4MS4ZX2Ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VlwaDPBRVwF194bTbhCfiyFv6im9busPUadSbG+3BbWNKjSQTtaco7OZaS4KziBNT
         wCvVoiDf2T1Vlbpl12d8Ze2q6TJ3M5yFlMY7vpdBd2Z3GZAOabeL1C9sPn/oP/fGVd
         llIF9OJZ3YDMDOdfplSBt7nVUQkoeJrDwN0JwiIG6425yiQK8XTu71ORckiFtfuXvr
         pmuezQF2jNL+kQkQrefEB7GhYvmtdgD72pHAL1ie9/JG0engcbFNvBFBkfMUuLrvMH
         GQpEOsM9s3mE2eCTeIon6yaeFUYgIURdj8sV+iT3A7iM596U+adklTpxJXuEdrwfRX
         CbXYO8HKExb/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Ben Greening <bgreening@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 50/58] ACPI: video: Use native backlight on Dell Inspiron N4010
Date:   Sun,  7 Aug 2022 21:31:08 -0400
Message-Id: <20220808013118.313965-50-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013118.313965-1-sashal@kernel.org>
References: <20220808013118.313965-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 03c440a26cba6cfa540d65924e9db86fcea362b2 ]

The Dell Inspiron N4010 does not have ACPI backlight control,
so acpi_video_get_backlight_type()'s heuristics return vendor as
the type to use.

But the vendor interface is broken, where as the native (intel_backlight)
works well, add a quirk to use native.

Link: https://lore.kernel.org/regressions/CALF=6jEe5G8+r1Wo0vvz4GjNQQhdkLT5p8uCHn6ZXhg4nsOWow@mail.gmail.com/
Reported-and-tested-by: Ben Greening <bgreening@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index becc198e4c22..4099140bbd5f 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -347,6 +347,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro12,1"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* Dell Inspiron N4010 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron N4010"),
+		},
+	},
 	{
 	 .callback = video_detect_force_native,
 	 /* Dell Vostro V131 */
-- 
2.35.1

