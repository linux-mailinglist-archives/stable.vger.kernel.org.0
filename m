Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10FEB5014AE
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343903AbiDNNtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344164AbiDNNkF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:40:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A90DCCB;
        Thu, 14 Apr 2022 06:37:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06AAC61BA7;
        Thu, 14 Apr 2022 13:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CA2C385A1;
        Thu, 14 Apr 2022 13:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943459;
        bh=+KSWGZLsyCxV17kI15AtxAUl4b0L3AxImXHMggeHEKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tSxE+TUeRhdfPZKpFJqu2hl5olEkjXf80bt4v24ulrDnBSvPP1GeZLyGiQmxYkV4z
         URHkGdEq689C6G2D2L2L5jMTR8ohA0+QI0bWG0Y/qQLPfdHBRbegBwN6ppFXUXb9K8
         yGkPHVcKztraCcMFMKr1F0/Cbf35HvGlzhQdtEG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 162/475] drm/edid: Dont clear formats if using deep color
Date:   Thu, 14 Apr 2022 15:09:07 +0200
Message-Id: <20220414110859.672777855@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 75478b3b393bcbdca4e6da76fe3a9f1a4133ec5d ]

The current code, when parsing the EDID Deep Color depths, that the
YUV422 cannot be used, referring to the HDMI 1.3 Specification.

This specification, in its section 6.2.4, indeed states:

  For each supported Deep Color mode, RGB 4:4:4 shall be supported and
  optionally YCBCR 4:4:4 may be supported.

  YCBCR 4:2:2 is not permitted for any Deep Color mode.

This indeed can be interpreted like the code does, but the HDMI 1.4
specification further clarifies that statement in its section 6.2.4:

  For each supported Deep Color mode, RGB 4:4:4 shall be supported and
  optionally YCBCR 4:4:4 may be supported.

  YCBCR 4:2:2 is also 36-bit mode but does not require the further use
  of the Deep Color modes described in section 6.5.2 and 6.5.3.

This means that, even though YUV422 can be used with 12 bit per color,
it shouldn't be treated as a deep color mode.

This is also broken with YUV444 if it's supported by the display, but
DRM_EDID_HDMI_DC_Y444 isn't set. In such a case, the code will clear
color_formats of the YUV444 support set previously in
drm_parse_cea_ext(), but will not set it back.

Since the formats supported are already setup properly in
drm_parse_cea_ext(), let's just remove the code modifying the formats in
drm_parse_hdmi_deep_color_info()

Fixes: d0c94692e0a3 ("drm/edid: Parse and handle HDMI deep color modes.")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220120151625.594595-3-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_edid.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -4534,16 +4534,8 @@ static void drm_parse_hdmi_deep_color_in
 		  connector->name, dc_bpc);
 	info->bpc = dc_bpc;
 
-	/*
-	 * Deep color support mandates RGB444 support for all video
-	 * modes and forbids YCRCB422 support for all video modes per
-	 * HDMI 1.3 spec.
-	 */
-	info->color_formats = DRM_COLOR_FORMAT_RGB444;
-
 	/* YCRCB444 is optional according to spec. */
 	if (hdmi[6] & DRM_EDID_HDMI_DC_Y444) {
-		info->color_formats |= DRM_COLOR_FORMAT_YCRCB444;
 		DRM_DEBUG("%s: HDMI sink does YCRCB444 in deep color.\n",
 			  connector->name);
 	}


