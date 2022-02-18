Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8793D4BB54B
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 10:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbiBRJSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 04:18:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbiBRJSH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 04:18:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208C032EE4
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 01:17:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1A98B825B2
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 09:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE041C340E9;
        Fri, 18 Feb 2022 09:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645175851;
        bh=VZpsZiUhnulwsKj1HV/luZ+bz2pY/5zWpx8pa6zAaiU=;
        h=Subject:To:Cc:From:Date:From;
        b=eU/eic25Enjjg1dARZFgKfpl+b05qvNRQy2DsJgM7/o3hgxPKdJ7n8EhbeQG2wUp4
         M07Y2OG2p5z8Nd/yEYXGS5tJ0P3Fks/2NNz3X/0SblkdyFYK3VIZwE8ujI2veN/gLx
         NvtyXAZ6O3sZqD8omOBTuRmEJOAAqR94uW84au4s=
Subject: FAILED: patch "[PATCH] drm/i915/opregion: check port number bounds for SWSCI display" failed to apply to 4.14-stable tree
To:     jani.nikula@intel.com, lucas.demarchi@intel.com,
        stable@vger.kernel.org, tvrtko.ursulin@intel.com,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Feb 2022 10:17:28 +0100
Message-ID: <1645175848164156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ea958422291de248b9e2eaaeea36004e84b64043 Mon Sep 17 00:00:00 2001
From: Jani Nikula <jani.nikula@intel.com>
Date: Thu, 10 Feb 2022 12:36:42 +0200
Subject: [PATCH] drm/i915/opregion: check port number bounds for SWSCI display
 power state
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The mapping from enum port to whatever port numbering scheme is used by
the SWSCI Display Power State Notification is odd, and the memory of it
has faded. In any case, the parameter only has space for ports numbered
[0..4], and UBSAN reports bit shift beyond it when the platform has port
F or more.

Since the SWSCI functionality is supposed to be obsolete for new
platforms (i.e. ones that might have port F or more), just bail out
early if the mapped and mangled port number is beyond what the Display
Power State Notification can support.

Fixes: 9c4b0a683193 ("drm/i915: add opregion function to notify bios of encoder enable/disable")
Cc: <stable@vger.kernel.org> # v3.13+
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/4800
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/cc363f42d6b5a5932b6d218fefcc8bdfb15dbbe5.1644489329.git.jani.nikula@intel.com
(cherry picked from commit 24a644ebbfd3b13cda702f98907f9dd123e34bf9)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_opregion.c b/drivers/gpu/drm/i915/display/intel_opregion.c
index 0065111593a6..4a2662838cd8 100644
--- a/drivers/gpu/drm/i915/display/intel_opregion.c
+++ b/drivers/gpu/drm/i915/display/intel_opregion.c
@@ -360,6 +360,21 @@ int intel_opregion_notify_encoder(struct intel_encoder *intel_encoder,
 		port++;
 	}
 
+	/*
+	 * The port numbering and mapping here is bizarre. The now-obsolete
+	 * swsci spec supports ports numbered [0..4]. Port E is handled as a
+	 * special case, but port F and beyond are not. The functionality is
+	 * supposed to be obsolete for new platforms. Just bail out if the port
+	 * number is out of bounds after mapping.
+	 */
+	if (port > 4) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "[ENCODER:%d:%s] port %c (index %u) out of bounds for display power state notification\n",
+			    intel_encoder->base.base.id, intel_encoder->base.name,
+			    port_name(intel_encoder->port), port);
+		return -EINVAL;
+	}
+
 	if (!enable)
 		parm |= 4 << 8;
 

