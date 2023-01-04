Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D4B65D040
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 11:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjADKGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 05:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238646AbjADKFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 05:05:55 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22FF9167C8
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 02:05:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672826754; x=1704362754;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ryzcVYOaRAa95oTg4borpUxLnzJUfxejTdGtDiKVR8Q=;
  b=BNSaPwHQoWV2NKDaQOFIT+MzIoVq/DegGzzb9fIvwYHM+GUyrEjAFAEo
   e1OqBsuA1C+5siUscoTPZdcEVcSTljHHCCpNb/85X8d/p7AjhMNldSS3l
   TvpwDBHTm8MQflANt8Tmjp1OFTVw/9P21CzYGEvoIASI2VWScL5xgDBSL
   KYYdHdV3QmdA6DZE46tVlaLBmLuj/H2Bl4EnpfMLTb4E5vN2NY+mlJ0fI
   ehmvl9ZkLwP6JRToYvY12EHxhoClNH54gGuvfvaZJ8VXnuWYPgVuGidkX
   Gi4g+Vm89R8kG/a1T+8HtnwMvg8qJgDo4WiSRwGl2gOK5w9ZzY+fjIe9D
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="386333695"
X-IronPort-AV: E=Sophos;i="5.96,299,1665471600"; 
   d="scan'208";a="386333695"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 02:05:53 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="983877010"
X-IronPort-AV: E=Sophos;i="5.96,299,1665471600"; 
   d="scan'208";a="983877010"
Received: from mkabdel-mobl.ger.corp.intel.com (HELO localhost) ([10.252.25.63])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 02:05:52 -0800
From:   Jani Nikula <jani.nikula@intel.com>
To:     dri-devel@lists.freedesktop.org
Cc:     intel-gfx@lists.freedesktop.org, ville.syrjala@linux.intel.com,
        jani.nikula@intel.com, stable@vger.kernel.org
Subject: [PATCH v7 02/22] drm/edid: fix parsing of 3D modes from HDMI VSDB
Date:   Wed,  4 Jan 2023 12:05:17 +0200
Message-Id: <cf159b8816191ed595a3cb954acaf189c4528cc7.1672826282.git.jani.nikula@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1672826282.git.jani.nikula@intel.com>
References: <cover.1672826282.git.jani.nikula@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 537d9ed2f6c1 ("drm/edid: convert add_cea_modes() to use cea db
iter") inadvertently moved the do_hdmi_vsdb_modes() call within the db
iteration loop, always passing NULL as the CTA VDB to
do_hdmi_vsdb_modes(), skipping a lot of stereo modes.

Move the call back outside of the loop.

This does mean only one CTA VDB and HDMI VSDB combination will be
handled, but it's an unlikely scenario to have more than one of either
block, and it was not accounted for before the regression either.

Fixes: 537d9ed2f6c1 ("drm/edid: convert add_cea_modes() to use cea db iter")
Cc: <stable@vger.kernel.org> # v6.0+
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/drm_edid.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 23f7146e6a9b..b94adb9bbefb 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -5249,13 +5249,12 @@ static int add_cea_modes(struct drm_connector *connector,
 {
 	const struct cea_db *db;
 	struct cea_db_iter iter;
+	const u8 *hdmi = NULL, *video = NULL;
+	u8 hdmi_len = 0, video_len = 0;
 	int modes = 0;
 
 	cea_db_iter_edid_begin(drm_edid, &iter);
 	cea_db_iter_for_each(db, &iter) {
-		const u8 *hdmi = NULL, *video = NULL;
-		u8 hdmi_len = 0, video_len = 0;
-
 		if (cea_db_tag(db) == CTA_DB_VIDEO) {
 			video = cea_db_data(db);
 			video_len = cea_db_payload_len(db);
@@ -5271,18 +5270,17 @@ static int add_cea_modes(struct drm_connector *connector,
 			modes += do_y420vdb_modes(connector, vdb420,
 						  cea_db_payload_len(db) - 1);
 		}
-
-		/*
-		 * We parse the HDMI VSDB after having added the cea modes as we
-		 * will be patching their flags when the sink supports stereo
-		 * 3D.
-		 */
-		if (hdmi)
-			modes += do_hdmi_vsdb_modes(connector, hdmi, hdmi_len,
-						    video, video_len);
 	}
 	cea_db_iter_end(&iter);
 
+	/*
+	 * We parse the HDMI VSDB after having added the cea modes as we will be
+	 * patching their flags when the sink supports stereo 3D.
+	 */
+	if (hdmi)
+		modes += do_hdmi_vsdb_modes(connector, hdmi, hdmi_len,
+					    video, video_len);
+
 	return modes;
 }
 
-- 
2.34.1

