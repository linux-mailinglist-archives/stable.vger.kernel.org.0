Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DED354E0EF
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 14:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232743AbiFPMly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 08:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbiFPMly (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 08:41:54 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28426517D3
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 05:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655383313; x=1686919313;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+Wo21Vemf8CrXxLRiwYw2qTyCSIcv/Kcjr2rGQeCvrU=;
  b=MIwrXh5fMMJaVXMXBMCLQm57UX+kbbVYvd/WMTjz4xoSfv6rhQaVSmnd
   cSLwVGf8jgG/0U9KF7Wkzo7Cve8cZLCFxloEQN2xCGyb+u3MU4hAE1caD
   xy179ttnJ9YKjbOWtZTVpiwVImP5vYdxAx2takbF+VCT9sg5VMzpn/k3j
   7NNF2DuHC1TKudsDFtz8ZRRy/mpC0MnWNJYmO+MANzuOIRbsAg4A/J3vN
   pUWOacwXHzvvmtvUZ8I6X+Tgayx4O1rF37zC3c6XXXp5W3rma1yQ+Q1gt
   Lo8UAEzJTBl/hKoJbfM3Ktxf9XHj103A3ZG5H5MrrG5aEhqYRboHCokcD
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="262258174"
X-IronPort-AV: E=Sophos;i="5.91,305,1647327600"; 
   d="scan'208";a="262258174"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 05:41:44 -0700
X-IronPort-AV: E=Sophos;i="5.91,305,1647327600"; 
   d="scan'208";a="831544143"
Received: from malashi-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.57.133])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 05:41:42 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     jani.nikula@intel.com,
        Diego Santa Cruz <Diego.SantaCruz@spinetix.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/glk: ECS Liva Q2 needs GLK HDMI port timing quirk
Date:   Thu, 16 Jun 2022 15:41:37 +0300
Message-Id: <20220616124137.3184371-1-jani.nikula@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Diego Santa Cruz <Diego.SantaCruz@spinetix.com>

The quirk added in upstream commit 90c3e2198777 ("drm/i915/glk: Add
Quirk for GLK NUC HDMI port issues.") is also required on the ECS Liva
Q2.

Note: Would be nicer to figure out the extra delay required for the
retimer without quirks, however don't know how to check for that.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1326
Signed-off-by: Diego Santa Cruz <Diego.SantaCruz@spinetix.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/i915/display/intel_quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_quirks.c b/drivers/gpu/drm/i915/display/intel_quirks.c
index c8488f5ebd04..e415cd7c0b84 100644
--- a/drivers/gpu/drm/i915/display/intel_quirks.c
+++ b/drivers/gpu/drm/i915/display/intel_quirks.c
@@ -191,6 +191,9 @@ static struct intel_quirk intel_quirks[] = {
 	/* ASRock ITX*/
 	{ 0x3185, 0x1849, 0x2212, quirk_increase_ddi_disabled_time },
 	{ 0x3184, 0x1849, 0x2212, quirk_increase_ddi_disabled_time },
+	/* ECS Liva Q2 */
+	{ 0x3185, 0x1019, 0xa94d, quirk_increase_ddi_disabled_time },
+	{ 0x3184, 0x1019, 0xa94d, quirk_increase_ddi_disabled_time },
 };
 
 void intel_init_quirks(struct drm_i915_private *i915)
-- 
2.30.2

