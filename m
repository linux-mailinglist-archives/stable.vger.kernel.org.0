Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7951C6583FB
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbiL1Qxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235219AbiL1QxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:53:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F160E13E04
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:48:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E6496155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4D5C433D2;
        Wed, 28 Dec 2022 16:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246085;
        bh=FgkbxNBjbqEgSLmU0OPf3Y85XtaLIngNOmgqAftktAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IGeoGQCz05MK9w2BGXh3siPwPOYff6GEOMWMnO4urSPm++D9uncG+mfKh1J8L35M/
         MFTGgCltoiDViSUt6yGrR/ou/+dshGngK+LgxAC4UreMUfUv/337im/VAONw1kNZgv
         WytsgQOuOLJhQEvoNK6TR1gITyF98/lt7EKK0tFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Roman Li <roman.li@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0978/1146] drm/edid: add a quirk for two LG monitors to get them to work on 10bpc
Date:   Wed, 28 Dec 2022 15:41:57 +0100
Message-Id: <20221228144356.922576195@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

[ Upstream commit aa193f7eff8ff753577351140b8af13b76cdc7c2 ]

The LG 27GP950 and LG 27GN950 have visible display corruption when
trying to use 10bpc modes. So, to fix this, cap their maximum DSC
target bitrate to 15bpp.

Suggested-by: Roman Li <roman.li@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_edid.c  | 12 ++++++++++++
 include/drm/drm_connector.h |  6 ++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 4005dab6147d..b36abfa91581 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -87,6 +87,8 @@ static int oui(u8 first, u8 second, u8 third)
 #define EDID_QUIRK_FORCE_10BPC			(1 << 11)
 /* Non desktop display (i.e. HMD) */
 #define EDID_QUIRK_NON_DESKTOP			(1 << 12)
+/* Cap the DSC target bitrate to 15bpp */
+#define EDID_QUIRK_CAP_DSC_15BPP		(1 << 13)
 
 #define MICROSOFT_IEEE_OUI	0xca125c
 
@@ -147,6 +149,12 @@ static const struct edid_quirk {
 	EDID_QUIRK('F', 'C', 'M', 13600, EDID_QUIRK_PREFER_LARGE_75 |
 				       EDID_QUIRK_DETAILED_IN_CM),
 
+	/* LG 27GP950 */
+	EDID_QUIRK('G', 'S', 'M', 0x5bbf, EDID_QUIRK_CAP_DSC_15BPP),
+
+	/* LG 27GN950 */
+	EDID_QUIRK('G', 'S', 'M', 0x5b9a, EDID_QUIRK_CAP_DSC_15BPP),
+
 	/* LGD panel of HP zBook 17 G2, eDP 10 bpc, but reports unknown bpc */
 	EDID_QUIRK('L', 'G', 'D', 764, EDID_QUIRK_FORCE_10BPC),
 
@@ -6166,6 +6174,7 @@ static void drm_reset_display_info(struct drm_connector *connector)
 
 	info->mso_stream_count = 0;
 	info->mso_pixel_overlap = 0;
+	info->max_dsc_bpp = 0;
 }
 
 static u32 update_display_info(struct drm_connector *connector,
@@ -6252,6 +6261,9 @@ static u32 update_display_info(struct drm_connector *connector,
 		info->non_desktop = true;
 	}
 
+	if (quirks & EDID_QUIRK_CAP_DSC_15BPP)
+		info->max_dsc_bpp = 15;
+
 	return quirks;
 }
 
diff --git a/include/drm/drm_connector.h b/include/drm/drm_connector.h
index 56aee949c6fa..4d830fc55a3d 100644
--- a/include/drm/drm_connector.h
+++ b/include/drm/drm_connector.h
@@ -656,6 +656,12 @@ struct drm_display_info {
 	 * @mso_pixel_overlap: eDP MSO segment pixel overlap, 0-8 pixels.
 	 */
 	u8 mso_pixel_overlap;
+
+	/**
+	 * @max_dsc_bpp: Maximum DSC target bitrate, if it is set to 0 the
+	 * monitor's default value is used instead.
+	 */
+	u32 max_dsc_bpp;
 };
 
 int drm_display_info_set_bus_formats(struct drm_display_info *info,
-- 
2.35.1



