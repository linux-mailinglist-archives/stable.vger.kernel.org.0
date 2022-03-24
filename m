Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197584E5E57
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 06:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346458AbiCXF7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 01:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243937AbiCXF7H (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 01:59:07 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D30893988
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 22:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648101456; x=1679637456;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=4EkRrEkFTgkOjfmRXgbne2YXQ+qZ1rLI365rc7YDlRM=;
  b=V/zuy9QxoMI9c0AJYsq1BMcu0tyVRw1l/6Sn2l9P2QUjTrgIoK54/o+v
   OdSZgTeCvQFXmWcCE+++HLNxNkeDhtJZNkhcArI4cxA6tqLvPJ/fgGJm/
   ARy9OuU2P8k3U6hNCuJ+Mll+8kGQLLoPgSXa24g5Gn+1B8n6QMfGW45Tc
   8xIhfO8KOs5V7UP3PddQxS7xJ8+RQcG+Ne2IUKtEsB4rnEMHpaklUQHhm
   OzUDs9mdZdjAdzCh7ncaQ3qNuELPrXp+pW+zrB4LfrNdoGeUNC0yXGFh9
   a8SumTUea6e4Uqp1yVFWPuTJnYK54yKkMoYDOqRQ1fWkSRBtYJD6RAyUN
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10295"; a="258481643"
X-IronPort-AV: E=Sophos;i="5.90,206,1643702400"; 
   d="scan'208";a="258481643"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 22:57:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,206,1643702400"; 
   d="scan'208";a="552750772"
Received: from shawnle1-build-machine.itwn.intel.com ([10.5.253.78])
  by fmsmga007.fm.intel.com with ESMTP; 23 Mar 2022 22:57:34 -0700
From:   Lee Shawn C <shawn.c.lee@intel.com>
To:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org
Cc:     Cooper Chiou <cooper.chiou@intel.com>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>,
        Shawn C Lee <shawn.c.lee@intel.com>
Subject: [v3] drm/edid: check basic audio support on CEA extension block
Date:   Thu, 24 Mar 2022 14:12:18 +0800
Message-Id: <20220324061218.32739-1-shawn.c.lee@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220321044330.27723-1-cooper.chiou@intel.com>
References: <20220321044330.27723-1-cooper.chiou@intel.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cooper Chiou <cooper.chiou@intel.com>

Tag code stored in bit7:5 for CTA block byte[3] is not the same as
CEA extension block definition. Only check CEA block has
basic audio support.

v3: update commit message.

Cc: stable@vger.kernel.org
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Shawn C Lee <shawn.c.lee@intel.com>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>
Signed-off-by: Cooper Chiou <cooper.chiou@intel.com>
Signed-off-by: Lee Shawn C <shawn.c.lee@intel.com>
Fixes: e28ad544f462 ("drm/edid: parse CEA blocks embedded in DisplayID")
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/drm_edid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 561f53831e29..f07af6786cec 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -4859,7 +4859,8 @@ bool drm_detect_monitor_audio(struct edid *edid)
 	if (!edid_ext)
 		goto end;
 
-	has_audio = ((edid_ext[3] & EDID_BASIC_AUDIO) != 0);
+	has_audio = (edid_ext[0] == CEA_EXT &&
+		    (edid_ext[3] & EDID_BASIC_AUDIO) != 0);
 
 	if (has_audio) {
 		DRM_DEBUG_KMS("Monitor has basic audio support\n");
-- 
2.17.1

