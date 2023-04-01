Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9186F6D2D19
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233766AbjDABpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbjDABok (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:44:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF2820C38;
        Fri, 31 Mar 2023 18:43:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DB1DACE2F69;
        Sat,  1 Apr 2023 01:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15830C433A0;
        Sat,  1 Apr 2023 01:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313383;
        bh=xdNacUZzDO8QPZ3U3zjunvBA8AJo5K39CPFIpA+F4cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eb41pUW14nhwWi5lmHd4tIjYYyiMjEnF3BRV/Wyns5F0/9NmJ4hHdjSZrjxKpNSRt
         1TsdZcflv5fEDtflVwAZrUjJaZCRVZrPjRo0c05DkseIkMJwgxTcT5B2Ie3uYd5pqo
         jfDwgSfYCySrD1l+7ks3QBQUVXCUKdOYGkbCyeEHxtysHZhJowataTvjoSjfmY7cHu
         T/jTBkMdcDcnXDWUEE0lbhpbZdJraqFgGWDXqj9C1kyhJ85VR+27UAqRG2wjHBfk32
         eYRZTaFcyy9mAaaayDBehiqcNpbrvKzem22/t+5lGNNZJMlLLf4zoh1b36SeD51oXo
         ebGqAoPMRkzog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@gmail.com, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 13/24] drm: panel-orientation-quirks: Add quirk for Lenovo Yoga Book X90F
Date:   Fri, 31 Mar 2023 21:42:29 -0400
Message-Id: <20230401014242.3356780-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014242.3356780-1-sashal@kernel.org>
References: <20230401014242.3356780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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

