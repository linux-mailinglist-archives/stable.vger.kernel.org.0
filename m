Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3EB359FC39
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 15:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238709AbiHXNwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 09:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237446AbiHXNwT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 09:52:19 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6547198CA0
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 06:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661348899; x=1692884899;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GXdPhCs+OiXL6atbTQKesx51GVza2ZRqHVt6nYJiM6g=;
  b=NdKUNoPMdB9IjL6yCL0dbhnzrMwk2xnXgDMDATRF3UktinG+vfWtGjz4
   AhMpDdknhDqnzNO3HU0x6TKcCIbQFGiwj3S5xck5JEu8MBqKAfNVzoQUv
   TZkE+pIR2ZHP4uMyWlWIwIw561OlpN5y7ffQJ0obBDhiuWqAnjdjAl4V7
   gj8EY8QzYylIeX9BJQRXqNLzOwnSn/T5Of5uMlNrwkW3sXeQgszIv38Vf
   jgdo/G8SppEd3w57Rcde+g+9HJp3rESRu7KcxxpmW6LAGpc14VgLLvzjh
   cnf556Hs21t0fyeX3pUMHPBu4qRleoI94iRAOgvzflQNw76QNon4lactc
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="320031012"
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="320031012"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 06:46:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="609764547"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.59])
  by orsmga002.jf.intel.com with SMTP; 24 Aug 2022 06:46:40 -0700
Received: by stinkbox (sSMTP sendmail emulation); Wed, 24 Aug 2022 16:46:39 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     dri-devel@lists.freedesktop.org
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH v2] drm/edid: Handle EDID 1.4 range descriptor h/vfreq offsets
Date:   Wed, 24 Aug 2022 16:46:39 +0300
Message-Id: <20220824134639.8454-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220819092728.14753-1-ville.syrjala@linux.intel.com>
References: <20220819092728.14753-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

EDID 1.4 introduced some extra flags in the range
descriptor to support min/max h/vfreq >= 255. Consult them
to correctly parse the vfreq limits.

Note that some combinations of the flags are documented
as "reserved" (as are some other values in the descriptor)
but explicitly checking for those doesn't seem particularly
worthwile since we end up with bogus results whether we
decode them or not.

v2: Increase the storage to u16 to make it work (Jani)
    Note the "reserved" values situation (Jani)

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6519
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/drm_edid.c  | 24 ++++++++++++++++++------
 include/drm/drm_connector.h |  4 ++--
 include/drm/drm_edid.h      |  5 +++++
 3 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 90a5e26eafa8..4005dab6147d 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -6020,12 +6020,14 @@ static void drm_parse_cea_ext(struct drm_connector *connector,
 }
 
 static
-void get_monitor_range(const struct detailed_timing *timing,
-		       void *info_monitor_range)
+void get_monitor_range(const struct detailed_timing *timing, void *c)
 {
-	struct drm_monitor_range_info *monitor_range = info_monitor_range;
+	struct detailed_mode_closure *closure = c;
+	struct drm_display_info *info = &closure->connector->display_info;
+	struct drm_monitor_range_info *monitor_range = &info->monitor_range;
 	const struct detailed_non_pixel *data = &timing->data.other_data;
 	const struct detailed_data_monitor_range *range = &data->data.range;
+	const struct edid *edid = closure->drm_edid->edid;
 
 	if (!is_display_descriptor(timing, EDID_DETAIL_MONITOR_RANGE))
 		return;
@@ -6041,18 +6043,28 @@ void get_monitor_range(const struct detailed_timing *timing,
 
 	monitor_range->min_vfreq = range->min_vfreq;
 	monitor_range->max_vfreq = range->max_vfreq;
+
+	if (edid->revision >= 4) {
+		if (data->pad2 & DRM_EDID_RANGE_OFFSET_MIN_VFREQ)
+			monitor_range->min_vfreq += 255;
+		if (data->pad2 & DRM_EDID_RANGE_OFFSET_MAX_VFREQ)
+			monitor_range->max_vfreq += 255;
+	}
 }
 
 static void drm_get_monitor_range(struct drm_connector *connector,
 				  const struct drm_edid *drm_edid)
 {
-	struct drm_display_info *info = &connector->display_info;
+	const struct drm_display_info *info = &connector->display_info;
+	struct detailed_mode_closure closure = {
+		.connector = connector,
+		.drm_edid = drm_edid,
+	};
 
 	if (!version_greater(drm_edid, 1, 1))
 		return;
 
-	drm_for_each_detailed_block(drm_edid, get_monitor_range,
-				    &info->monitor_range);
+	drm_for_each_detailed_block(drm_edid, get_monitor_range, &closure);
 
 	DRM_DEBUG_KMS("Supported Monitor Refresh rate range is %d Hz - %d Hz\n",
 		      info->monitor_range.min_vfreq,
diff --git a/include/drm/drm_connector.h b/include/drm/drm_connector.h
index 248206bbd975..56aee949c6fa 100644
--- a/include/drm/drm_connector.h
+++ b/include/drm/drm_connector.h
@@ -319,8 +319,8 @@ enum drm_panel_orientation {
  *             EDID's detailed monitor range
  */
 struct drm_monitor_range_info {
-	u8 min_vfreq;
-	u8 max_vfreq;
+	u16 min_vfreq;
+	u16 max_vfreq;
 };
 
 /**
diff --git a/include/drm/drm_edid.h b/include/drm/drm_edid.h
index 2181977ae683..d81da97cad6e 100644
--- a/include/drm/drm_edid.h
+++ b/include/drm/drm_edid.h
@@ -92,6 +92,11 @@ struct detailed_data_string {
 	u8 str[13];
 } __attribute__((packed));
 
+#define DRM_EDID_RANGE_OFFSET_MIN_VFREQ (1 << 0)
+#define DRM_EDID_RANGE_OFFSET_MAX_VFREQ (1 << 1)
+#define DRM_EDID_RANGE_OFFSET_MIN_HFREQ (1 << 2)
+#define DRM_EDID_RANGE_OFFSET_MAX_HFREQ (1 << 3)
+
 #define DRM_EDID_DEFAULT_GTF_SUPPORT_FLAG   0x00
 #define DRM_EDID_RANGE_LIMITS_ONLY_FLAG     0x01
 #define DRM_EDID_SECONDARY_GTF_SUPPORT_FLAG 0x02
-- 
2.35.1

