Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01A06D2D9A
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 04:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233777AbjDACJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 22:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbjDACJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 22:09:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A171CEC45;
        Fri, 31 Mar 2023 19:09:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39A76B83320;
        Sat,  1 Apr 2023 01:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED918C4339B;
        Sat,  1 Apr 2023 01:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313442;
        bh=Aq8vcejyKWuvLtlAKkoLOGG9pzuV4Z9p3791cnIrGFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6j2WcyQQo/Pnp5oExNLABaJSxdrap6TUBzmjLr46VGEzeO2YWnPUp6nibeu/40s9
         HZLoreY1OBq1ncfXjtmXTUcpi8LavbyIV1RvQQQ5q82um3i+i8IKH5kApmFDIoOYoD
         y0HCSxsY9ilKb5HyYS3uCYI64pIEWFmjogzC7/8ZYgyeReuZyoN7QwMHSrQC57cjQZ
         y8suUr5IGpqTzBSfUF2OJnNXeBgXb02XP1+pokcxRGQdlRnVONHfOg2UZUupOYvDH0
         LpG5FgLxDpT7xLAIjotpCHaOLBC967inugb/OEU9ajVAqeBF6lfkQMLJkJdUYvi3pz
         oal5WbGs90D7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@gmail.com, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 07/11] drm: panel-orientation-quirks: Add quirk for Lenovo Yoga Book X90F
Date:   Fri, 31 Mar 2023 21:43:45 -0400
Message-Id: <20230401014350.3357107-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014350.3357107-1-sashal@kernel.org>
References: <20230401014350.3357107-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 03aecb1acbcd7a660f97d645ca6c09d9de27ff9d ]

Like the Windows Lenovo Yoga Book X91F/L the Android Lenovo Yoga Book
X90F/L has a portrait 1200x1920 screen used in landscape mode,
add a quirk for this.

When the quirk for the X91F/L was initially added it was written to
also apply to the X90F/L but this does not work because the Android
version of the Yoga Book uses completely different DMI strings.
Also adjust the X91F/L quirk to reflect that it only applies to
the X91F/L models.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230301095218.28457-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 8768073794fbf..6106fa7c43028 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -284,10 +284,17 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "IdeaPad Duet 3 10IGL5"),
 		},
 		.driver_data = (void *)&lcd1200x1920_rightside_up,
-	}, {	/* Lenovo Yoga Book X90F / X91F / X91L */
+	}, {	/* Lenovo Yoga Book X90F / X90L */
 		.matches = {
-		  /* Non exact match to match all versions */
-		  DMI_MATCH(DMI_PRODUCT_NAME, "Lenovo YB1-X9"),
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "CHERRYVIEW D1 PLATFORM"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "YETI-11"),
+		},
+		.driver_data = (void *)&lcd1200x1920_rightside_up,
+	}, {	/* Lenovo Yoga Book X91F / X91L */
+		.matches = {
+		  /* Non exact match to match F + L versions */
+		  DMI_MATCH(DMI_PRODUCT_NAME, "Lenovo YB1-X91"),
 		},
 		.driver_data = (void *)&lcd1200x1920_rightside_up,
 	}, {	/* OneGX1 Pro */
-- 
2.39.2

