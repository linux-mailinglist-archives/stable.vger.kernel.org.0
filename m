Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848F64F34A3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238162AbiDEJEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243884AbiDEIvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:51:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BF4CFBAF;
        Tue,  5 Apr 2022 01:40:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF983B81C6F;
        Tue,  5 Apr 2022 08:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4061DC385A1;
        Tue,  5 Apr 2022 08:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147988;
        bh=oIga0He4yI5LBX1UhvwIvH0cnuahKV9lNiCEteLrRxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGFX7Uad6j/l8ols4QdJI/Wed0CkSRLwGG/N5cqk6w4I55hMD++g8+dW51CO2MOCa
         bXwbBFe8a9CayPXpndUVVdVkBKHBxnP54Xa1VqjxJUUnzz+ik/akimdbsCvDZKt+5d
         a9JasQtBE1RHmBXtqdSKkZdSQSaClg2DryfxwxCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.16 0195/1017] drm/i915/opregion: check port number bounds for SWSCI display power state
Date:   Tue,  5 Apr 2022 09:18:28 +0200
Message-Id: <20220405070400.033338683@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jani Nikula <jani.nikula@intel.com>

commit 24a644ebbfd3b13cda702f98907f9dd123e34bf9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_opregion.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_opregion.c
+++ b/drivers/gpu/drm/i915/display/intel_opregion.c
@@ -375,6 +375,21 @@ int intel_opregion_notify_encoder(struct
 		return -EINVAL;
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
 


