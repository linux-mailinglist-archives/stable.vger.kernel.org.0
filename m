Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDDBD60DEA4
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 12:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbiJZKLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 06:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233111AbiJZKLr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 06:11:47 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C785B8E792
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 03:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666779106; x=1698315106;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OdxGfXAWeQWB7d4z4d16YQro4plB+ZqSdzTYXSm6u70=;
  b=aKd5rc8XDVqaUG6S+1YS4oyQyC/oKJVHI8hiZpR4MOHzEZ6pmjuvqOp+
   Dp9PVv+2Iw90Nu6pZiOVi7MYptu12d+WgkZZfFV/pup/iN28PoQrE873r
   1UltZWoQKeXHZ2p2icmr/NGnrNKwlU+skx56og/moaSQUVCjEQDm4lVmn
   iEXBG7g7nc8Sdu/mn5PKkGNuBsIR74tu5na6tW6i/qjDER+c9k789vKaJ
   XMFcbCQV8pYl4G9o9rr8ifJPKGfn3bvKfVNLcOni6VOtDVlipqjoVYzIr
   8Tb65fbzM0kOuQvZDEf5WbVtBTgVy1v5nIkPc9dVxnOspSKZtxRgy0Vfo
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="291213366"
X-IronPort-AV: E=Sophos;i="5.95,214,1661842800"; 
   d="scan'208";a="291213366"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 03:11:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="695305849"
X-IronPort-AV: E=Sophos;i="5.95,214,1661842800"; 
   d="scan'208";a="695305849"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.191])
  by fmsmga008.fm.intel.com with SMTP; 26 Oct 2022 03:11:38 -0700
Received: by stinkbox (sSMTP sendmail emulation); Wed, 26 Oct 2022 13:11:37 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/8] drm/i915/sdvo: Filter out invalid outputs more sensibly
Date:   Wed, 26 Oct 2022 13:11:27 +0300
Message-Id: <20221026101134.20865-2-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221026101134.20865-1-ville.syrjala@linux.intel.com>
References: <20221026101134.20865-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

We try to filter out the corresponding xxx1 output
if the xxx0 output is not present. But the way that is
being done is pretty awkward. Make it less so.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_sdvo.c | 29 ++++++++++++++++++-----
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_sdvo.c b/drivers/gpu/drm/i915/display/intel_sdvo.c
index cf8e80936d8e..c6200a91a777 100644
--- a/drivers/gpu/drm/i915/display/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/display/intel_sdvo.c
@@ -2925,16 +2925,33 @@ intel_sdvo_lvds_init(struct intel_sdvo *intel_sdvo, int device)
 	return false;
 }
 
-static bool
-intel_sdvo_output_setup(struct intel_sdvo *intel_sdvo, u16 flags)
+static u16 intel_sdvo_filter_output_flags(u16 flags)
 {
+	flags &= SDVO_OUTPUT_MASK;
+
 	/* SDVO requires XXX1 function may not exist unless it has XXX0 function.*/
+	if (!(flags & SDVO_OUTPUT_TMDS0))
+		flags &= ~SDVO_OUTPUT_TMDS1;
+
+	if (!(flags & SDVO_OUTPUT_RGB0))
+		flags &= ~SDVO_OUTPUT_RGB1;
+
+	if (!(flags & SDVO_OUTPUT_LVDS0))
+		flags &= ~SDVO_OUTPUT_LVDS1;
+
+	return flags;
+}
+
+static bool
+intel_sdvo_output_setup(struct intel_sdvo *intel_sdvo, u16 flags)
+{
+	flags = intel_sdvo_filter_output_flags(flags);
 
 	if (flags & SDVO_OUTPUT_TMDS0)
 		if (!intel_sdvo_dvi_init(intel_sdvo, 0))
 			return false;
 
-	if ((flags & SDVO_TMDS_MASK) == SDVO_TMDS_MASK)
+	if (flags & SDVO_OUTPUT_TMDS1)
 		if (!intel_sdvo_dvi_init(intel_sdvo, 1))
 			return false;
 
@@ -2955,7 +2972,7 @@ intel_sdvo_output_setup(struct intel_sdvo *intel_sdvo, u16 flags)
 		if (!intel_sdvo_analog_init(intel_sdvo, 0))
 			return false;
 
-	if ((flags & SDVO_RGB_MASK) == SDVO_RGB_MASK)
+	if (flags & SDVO_OUTPUT_RGB1)
 		if (!intel_sdvo_analog_init(intel_sdvo, 1))
 			return false;
 
@@ -2963,11 +2980,11 @@ intel_sdvo_output_setup(struct intel_sdvo *intel_sdvo, u16 flags)
 		if (!intel_sdvo_lvds_init(intel_sdvo, 0))
 			return false;
 
-	if ((flags & SDVO_LVDS_MASK) == SDVO_LVDS_MASK)
+	if (flags & SDVO_OUTPUT_LVDS1)
 		if (!intel_sdvo_lvds_init(intel_sdvo, 1))
 			return false;
 
-	if ((flags & SDVO_OUTPUT_MASK) == 0) {
+	if (flags == 0) {
 		unsigned char bytes[2];
 
 		intel_sdvo->controlled_output = 0;
-- 
2.37.4

