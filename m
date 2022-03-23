Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 172494E4FF6
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 11:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243385AbiCWKGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 06:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238997AbiCWKGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 06:06:16 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B808426562
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 03:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648029886; x=1679565886;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9IX2ChMG+tQUey05sXOupe0vFV+0tsB4fpa7vGdsz4M=;
  b=TdXH+F+n/rdKZdBCnZGqbsLOBw3f4SL8ZdYWW6v4gdVCW0aeyN2eqCnc
   cRMtFi4bVFBKAiLyZkFvPNlQsaaBOcJF7TaMUcekvbXNhQ9w4TSvAACt2
   aCbTZ7/FC0D2Y+7rpONQknzIJVpovbCo7DW5FKH/G+N4X8hJivww/ZwVS
   +LwHH/Q1saBzDcaRLUNviXlyAklu4vE/dWirvmZ1zE895V5CWEvMuC5V2
   goaBV1a4AeRzOcggsSP12X7h7dXFGx555SSQ8CJBhqvi0xX1iCqALhyFs
   GF9Kj5vPfJ6lUBAXMkqQCTo/JiR1D2Jw9OZs88zV6npQJFYCtdmBFn8Fw
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="344505986"
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="344505986"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 03:04:46 -0700
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="544127102"
Received: from caliyanx-mobl.gar.corp.intel.com (HELO localhost) ([10.252.57.47])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 03:04:43 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     dri-devel@lists.freedesktop.org
Cc:     intel-gfx@lists.freedesktop.org, jani.nikula@intel.com,
        stable@vger.kernel.org, Shawn C Lee <shawn.c.lee@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>
Subject: [PATCH] drm/edid: fix CEA extension byte #3 parsing
Date:   Wed, 23 Mar 2022 12:04:38 +0200
Message-Id: <20220323100438.1757295-1-jani.nikula@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Only an EDID CEA extension has byte #3, while the CTA DisplayID Data
Block does not. Don't interpret bogus data for color formats.

For most displays it's probably an unlikely scenario you'd have a CTA
DisplayID Data Block without a CEA extension, but they do exist.

Fixes: e28ad544f462 ("drm/edid: parse CEA blocks embedded in DisplayID")
Cc: <stable@vger.kernel.org> # v4.15
Cc: Shawn C Lee <shawn.c.lee@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

---

commit e28ad544f462 was merged in v5.3, but it has Cc: stable for v4.15.

This is also fixed in my CEA data block iteration series [1], but we'll
want the simple fix for stable first.

Hum, CTA is formerly CEA, I and the code seem to use both, should we use
only one or the other?

[1] https://patchwork.freedesktop.org/series/101659/
---
 drivers/gpu/drm/drm_edid.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 561f53831e29..ccf7031a6797 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -5187,10 +5187,14 @@ static void drm_parse_cea_ext(struct drm_connector *connector,
 
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
-- 
2.30.2

