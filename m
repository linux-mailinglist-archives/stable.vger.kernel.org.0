Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B3168DECD
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 18:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjBGRVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 12:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjBGRVl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 12:21:41 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C5130C9
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 09:21:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675790497; x=1707326497;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HAM9bQDFxlH/EhH1WIAz6lDlb1Nt74UfKDXlh3LRyxA=;
  b=EoEXmBQ1jMfu7XhEVcGXorWSNIi+5klt1ChCd9Om8ULkwDPJB1Y8EDOj
   ntXoCAJqmxOEC90ce6EudGEOBq3pHci1YHYn3yO4LvTVA6zJqBb8cebEw
   uacdybIeUA5mHoXr1QS08f/vqEXgXyoU8dVzhgqCLRJmnCITPK4Ft2XAN
   scplplCBYhzs8S+zd6EKwEdGBRmvnA+FN2FXcbam9lU6ol/u9S4V4YXJf
   O3/3wWL7xyHPqVbgby1qtwOQfvbtDGQDOpvwq1CgIhZLfClt3m3+ucM4K
   j4wi0Kcnrfkhl7vz5NDz5O8IU969wP7YIZXY7pV7CHQYsKBfXtkhYya9E
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="317534430"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="317534430"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 06:33:46 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="755641535"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="755641535"
Received: from tronach-mobl.ger.corp.intel.com (HELO localhost) ([10.252.36.11])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 06:33:42 -0800
From:   Jani Nikula <jani.nikula@intel.com>
To:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc:     jani.nikula@intel.com,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Jim Cromie <jim.cromie@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, stable@vger.kernel.org
Subject: [PATCH] drm: Disable dynamic debug as broken
Date:   Tue,  7 Feb 2023 16:33:37 +0200
Message-Id: <20230207143337.2126678-1-jani.nikula@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

CONFIG_DRM_USE_DYNAMIC_DEBUG breaks debug prints for (at least modular)
drm drivers. The debug prints can be reinstated by manually frobbing
/sys/module/drm/parameters/debug after the fact, but at that point the
damage is done and all debugs from driver probe are lost. This makes
drivers totally undebuggable.

There's a more complete fix in progress [1], with further details, but
we need this fixed in stable kernels. Mark the feature as broken and
disable it by default, with hopes distros follow suit and disable it as
well.

[1] https://lore.kernel.org/r/20230125203743.564009-1-jim.cromie@gmail.com

Fixes: 84ec67288c10 ("drm_print: wrap drm_*_dbg in dyndbg descriptor factory macro")
Cc: Jim Cromie <jim.cromie@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.1+
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index f42d4c6a19f2..dc0f94f02a82 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -52,7 +52,8 @@ config DRM_DEBUG_MM
 
 config DRM_USE_DYNAMIC_DEBUG
 	bool "use dynamic debug to implement drm.debug"
-	default y
+	default n
+	depends on BROKEN
 	depends on DRM
 	depends on DYNAMIC_DEBUG || DYNAMIC_DEBUG_CORE
 	depends on JUMP_LABEL
-- 
2.34.1

