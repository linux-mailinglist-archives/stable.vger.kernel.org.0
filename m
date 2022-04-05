Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5004F3720
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242361AbiDELKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348828AbiDEJsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CAEB0A7B;
        Tue,  5 Apr 2022 02:36:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 780BB61368;
        Tue,  5 Apr 2022 09:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E32C385A0;
        Tue,  5 Apr 2022 09:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151382;
        bh=KbOJmrCYI/tPWvMS0mNsAb+2B9qS9w9YvfcfjYDuH/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=THNra1VeHIPHiwJI+5L9FRaqLVNgNBEGwt7bYr2eDnzA/S6dbdnhpS9tsBUdtxYsS
         5DLS9lJm6NRTGLh2E83qLrNDyywYJp3LQTlFRe3Jc5D6u5e+JhjtNBKpLqnfSYKvK6
         UJ+v6NiAWM8FF3xKVa5E/ImgKt2NqiA8cOhN6sdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 395/913] drm/edid: Dont clear formats if using deep color
Date:   Tue,  5 Apr 2022 09:24:17 +0200
Message-Id: <20220405070351.688043605@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
@@ -5033,16 +5033,8 @@ static void drm_parse_hdmi_deep_color_in
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


