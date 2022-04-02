Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 511B24F017A
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 14:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241811AbiDBMbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 08:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiDBMbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 08:31:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8017137A2C
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 05:29:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B062613F1
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 12:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E41DC340EC;
        Sat,  2 Apr 2022 12:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648902579;
        bh=fr2lvHIwN1e1bpErNc2ODARvXk/S8WgHC5nxKpoT81Q=;
        h=Subject:To:Cc:From:Date:From;
        b=GzCFkQP8wlCPvjC1E70eZ3yiy9eyvuxKuVyUr/EEqCczjKzPMhv5FIV6qHbDr0+od
         cCPGuWHAwFI2MhgHRpgAQ2EKeNTFrt2odaNokmZT//31RNU7kfM6aGdcWn3pxpov1g
         uS5G1mMusAuUvhprysA0/7HltzHFDAbWZddz6va4=
Subject: FAILED: patch "[PATCH] drm/edid: fix CEA extension byte #3 parsing" failed to apply to 4.19-stable tree
To:     jani.nikula@intel.com, shawn.c.lee@intel.com,
        stable@vger.kernel.org, ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 14:29:37 +0200
Message-ID: <164890257744242@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7344bad7fb6daa4877a1c064b52c7d5f9182c41b Mon Sep 17 00:00:00 2001
From: Jani Nikula <jani.nikula@intel.com>
Date: Wed, 23 Mar 2022 12:04:38 +0200
Subject: [PATCH] drm/edid: fix CEA extension byte #3 parsing
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Only an EDID CEA extension has byte #3, while the CTA DisplayID Data
Block does not. Don't interpret bogus data for color formats.

For most displays it's probably an unlikely scenario you'd have a CTA
DisplayID Data Block without a CEA extension, but they do exist.

Fixes: e28ad544f462 ("drm/edid: parse CEA blocks embedded in DisplayID")
Cc: <stable@vger.kernel.org>
Cc: Shawn C Lee <shawn.c.lee@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220323100438.1757295-1-jani.nikula@intel.com

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index f07af6786cec..cc7bd58369df 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -5188,10 +5188,14 @@ static void drm_parse_cea_ext(struct drm_connector *connector,
 
 	/* The existence of a CEA block should imply RGB support */
 	info->color_formats = DRM_COLOR_FORMAT_RGB444;
-	if (edid_ext[3] & EDID_CEA_YCRCB444)
-		info->color_formats |= DRM_COLOR_FORMAT_YCBCR444;
-	if (edid_ext[3] & EDID_CEA_YCRCB422)
-		info->color_formats |= DRM_COLOR_FORMAT_YCBCR422;
+
+	/* CTA DisplayID Data Block does not have byte #3 */
+	if (edid_ext[0] == CEA_EXT) {
+		if (edid_ext[3] & EDID_CEA_YCRCB444)
+			info->color_formats |= DRM_COLOR_FORMAT_YCBCR444;
+		if (edid_ext[3] & EDID_CEA_YCRCB422)
+			info->color_formats |= DRM_COLOR_FORMAT_YCBCR422;
+	}
 
 	if (cea_db_offsets(edid_ext, &start, &end))
 		return;

