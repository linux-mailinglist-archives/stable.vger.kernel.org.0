Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08EA54C73BB
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235594AbiB1Rih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:38:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238748AbiB1RiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:38:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7EF75E71;
        Mon, 28 Feb 2022 09:33:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 671D061359;
        Mon, 28 Feb 2022 17:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE84C340F0;
        Mon, 28 Feb 2022 17:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069619;
        bh=R5DMwCwK+whreYg186mFVdawgTW45Ryu8lb5CGcImaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v2c/x5ct0L19HTBl840Gh19hC0lfP5sBoQHyE8mRIT/kPWvCKj1X3VoVq6VnZ/cEQ
         xhD0+lrBPhtnc6VRxw2n+VKdKNWeWM+INQm6UBFXWfJc5kIooMrt1VdqeJS0xpe9BK
         xQaO8rZtfQKvRccGS+4ZZWLpEePIWqw15kc1JWoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Matthias Reichl <hias@horus.com>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.10 32/80] drm/edid: Always set RGB444
Date:   Mon, 28 Feb 2022 18:24:13 +0100
Message-Id: <20220228172315.423171903@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
References: <20220228172311.789892158@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

commit ecbd4912a693b862e25cba0a6990a8c95b00721e upstream.

In order to fill the drm_display_info structure each time an EDID is
read, the code currently will call drm_add_display_info with the parsed
EDID.

drm_add_display_info will then call drm_reset_display_info to reset all
the fields to 0, and then set them to the proper value depending on the
EDID.

In the color_formats case, we will thus report that we don't support any
color format, and then fill it back with RGB444 plus the additional
formats described in the EDID Feature Support byte.

However, since that byte only contains format-related bits since the 1.4
specification, this doesn't happen if the EDID is following an earlier
specification. In turn, it means that for one of these EDID, we end up
with color_formats set to 0.

The EDID 1.3 specification never really specifies what it means by RGB
exactly, but since both HDMI and DVI will use RGB444, it's fairly safe
to assume it's supposed to be RGB444.

Let's move the addition of RGB444 to color_formats earlier in
drm_add_display_info() so that it's always set for a digital display.

Fixes: da05a5a71ad8 ("drm: parse color format support for digital displays")
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reported-by: Matthias Reichl <hias@horus.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220203115416.1137308-1-maxime@cerno.tech
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_edid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -5132,6 +5132,7 @@ u32 drm_add_display_info(struct drm_conn
 	if (!(edid->input & DRM_EDID_INPUT_DIGITAL))
 		return quirks;
 
+	info->color_formats |= DRM_COLOR_FORMAT_RGB444;
 	drm_parse_cea_ext(connector, edid);
 
 	/*
@@ -5180,7 +5181,6 @@ u32 drm_add_display_info(struct drm_conn
 	DRM_DEBUG("%s: Assigning EDID-1.4 digital sink color depth as %d bpc.\n",
 			  connector->name, info->bpc);
 
-	info->color_formats |= DRM_COLOR_FORMAT_RGB444;
 	if (edid->features & DRM_EDID_FEATURE_RGB_YCRCB444)
 		info->color_formats |= DRM_COLOR_FORMAT_YCRCB444;
 	if (edid->features & DRM_EDID_FEATURE_RGB_YCRCB422)


