Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1102E64A1A3
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbiLLNnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232920AbiLLNnX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:43:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D3E14D12
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:42:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 448CCB80D2C
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E419EC433EF;
        Mon, 12 Dec 2022 13:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852536;
        bh=oU+PJRKSBQUdS/wKZ89u66xf5ISHpbx8whdnRh1eKBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BuDSXMez12IIKF9NRO5+u3XfiRZWw4NANbsIjVWRO3aIjBlgXSX8opiVgMWiWy9o/
         N9c5UKhF9j+jqxcMyYCS+yRqH38g+Th56kOENH/bn8x/r1YDWWbFIkO8V6uU0uI4Wy
         y2m52dv9FR59ka2Ccma9hogqTcML1MNONlt2Y8Kc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guillaume BRUN <the.cheaterman@gmail.com>,
        Christian Hewitt <christianshewitt@gmail.com>,
        Robert Foss <robert.foss@linaro.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 101/157] drm: bridge: dw_hdmi: fix preference of RGB modes over YUV420
Date:   Mon, 12 Dec 2022 14:17:29 +0100
Message-Id: <20221212130938.891548947@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

From: Guillaume BRUN <the.cheaterman@gmail.com>

[ Upstream commit d3d6b1bf85aefe0ebc0624574b3bb62f0693914c ]

Cheap monitors sometimes advertise YUV modes they don't really have
(HDMI specification mandates YUV support so even monitors without actual
support will often wrongfully advertise it) which results in YUV matches
and user forum complaints of a red tint to light colour display areas in
common desktop environments.

Moving the default RGB fall-back before YUV selection results in RGB
mode matching in most cases, reducing complaints.

Fixes: 6c3c719936da ("drm/bridge: synopsys: dw-hdmi: add bus format negociation")
Signed-off-by: Guillaume BRUN <the.cheaterman@gmail.com>
Tested-by: Christian Hewitt <christianshewitt@gmail.com>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221116143523.2126-1-the.cheaterman@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
index 40d8ca37f5bc..aa51c61a78c7 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -2720,6 +2720,9 @@ static u32 *dw_hdmi_bridge_atomic_get_output_bus_fmts(struct drm_bridge *bridge,
 	 * if supported. In any case the default RGB888 format is added
 	 */
 
+	/* Default 8bit RGB fallback */
+	output_fmts[i++] = MEDIA_BUS_FMT_RGB888_1X24;
+
 	if (max_bpc >= 16 && info->bpc == 16) {
 		if (info->color_formats & DRM_COLOR_FORMAT_YCBCR444)
 			output_fmts[i++] = MEDIA_BUS_FMT_YUV16_1X48;
@@ -2753,9 +2756,6 @@ static u32 *dw_hdmi_bridge_atomic_get_output_bus_fmts(struct drm_bridge *bridge,
 	if (info->color_formats & DRM_COLOR_FORMAT_YCBCR444)
 		output_fmts[i++] = MEDIA_BUS_FMT_YUV8_1X24;
 
-	/* Default 8bit RGB fallback */
-	output_fmts[i++] = MEDIA_BUS_FMT_RGB888_1X24;
-
 	*num_output_fmts = i;
 
 	return output_fmts;
-- 
2.35.1



