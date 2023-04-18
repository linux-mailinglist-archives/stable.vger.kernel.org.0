Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 899FA6E641F
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbjDRMq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbjDRMqZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:46:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA5614F65
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:46:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67ED463398
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772A2C433D2;
        Tue, 18 Apr 2023 12:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821982;
        bh=xdNacUZzDO8QPZ3U3zjunvBA8AJo5K39CPFIpA+F4cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mtNi4dxBk/SlOkMCWXS47Rt/XBc9357lvkpbsvHfryVECTLQvmM4bZliwm0/qWskn
         mCVVJe98ffr1lOL3s3xtQnrDzWoWIOsGtYmuH9JVjjX6HOXlBQp2t/E4/z+hnev/ic
         QaqpU5P8vjXLLwQpCc2He5nOMnm6oJgKoJlsJGKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/134] drm: panel-orientation-quirks: Add quirk for Lenovo Yoga Book X90F
Date:   Tue, 18 Apr 2023 14:22:18 +0200
Message-Id: <20230418120315.942941410@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
index 5522d610c5cfd..b1a38e6ce2f8f 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -328,10 +328,17 @@ static const struct dmi_system_id orientation_data[] = {
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
 	}, {	/* Lenovo Yoga Tablet 2 830F / 830L */
-- 
2.39.2



