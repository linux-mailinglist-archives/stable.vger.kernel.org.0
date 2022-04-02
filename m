Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2A14F01EE
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 15:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238194AbiDBNG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 09:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354355AbiDBNGY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 09:06:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E481F5F8E1
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 06:04:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 827DC6149F
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 13:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A55C340EE;
        Sat,  2 Apr 2022 13:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648904671;
        bh=/q7EhkhE2499A6lVsYq0NggP1o/U/cswRy87D3eOwgU=;
        h=Subject:To:Cc:From:Date:From;
        b=To9wZxRvfbDagxSXLAXags8Z6Dr7Vf1mFeC+3wA3tCvisbcGlSfAOKeZrFKqkvpDi
         TWQTFEj1mST+9RmNS4X20Gbl0yZlUhEmTjeNuTvcBxTV1wWphzQhEyZ2Vq+dyo5jbt
         5aEoEZTlpJf1qyK7hO5UFAGrIZcQaevYGFEE/EMs=
Subject: FAILED: patch "[PATCH] drm/i915/opregion: check port number bounds for SWSCI display" failed to apply to 4.14-stable tree
To:     jani.nikula@intel.com, lucas.demarchi@intel.com,
        stable@vger.kernel.org, ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 15:04:21 +0200
Message-ID: <164890466122221@kroah.com>
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 24a644ebbfd3b13cda702f98907f9dd123e34bf9 Mon Sep 17 00:00:00 2001
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

diff --git a/drivers/gpu/drm/i915/display/intel_opregion.c b/drivers/gpu/drm/i915/display/intel_opregion.c
index af9d30f56cc1..ad1afe9df6c3 100644
--- a/drivers/gpu/drm/i915/display/intel_opregion.c
+++ b/drivers/gpu/drm/i915/display/intel_opregion.c
@@ -363,6 +363,21 @@ int intel_opregion_notify_encoder(struct intel_encoder *intel_encoder,
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
 

