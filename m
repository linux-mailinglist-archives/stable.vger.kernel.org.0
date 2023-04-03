Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC796D4AE6
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbjDCOvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234161AbjDCOuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:50:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A75028EAB
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E934B81D77
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F067C433EF;
        Mon,  3 Apr 2023 14:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533414;
        bh=I+7wxY6ajxodHY5GQ91m19+hQEwXVt3H4dkv8pOr3bI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MGVNVdXfKo4hUV6uDROJwCpUQz9ZmLi+VVBMm5J37dTvyjFGpgaP6vNSPqc7Ppg2B
         57H1L3ptoPyOADypxqoNoIjmpU+/U4CWmh03aPmdkrFHtYBZ6KYUJxdJMAV52GdTYM
         8mErVaZlhU4m3gw3tal5O7ZDE4mmUwlfoTd6/fr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Manasi Navare <navaremanasi@google.com>,
        Drew Davenport <ddavenport@chromium.org>,
        Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.2 174/187] drm/i915: Split icl_color_commit_noarm() from skl_color_commit_noarm()
Date:   Mon,  3 Apr 2023 16:10:19 +0200
Message-Id: <20230403140421.978453625@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 76b767d4d1cd052e455cf18e06929e8b2b70101d upstream.

We're going to want different behavior for skl/glk vs. icl
in .color_commit_noarm(), so split the hook into two. Arguably
we already had slightly different behaviour since
csc_enable/gamma_enable are never set on icl+, so the old
code was perhaps a bit confusing as well.

Cc: <stable@vger.kernel.org> #v5.19+
Cc: Manasi Navare <navaremanasi@google.com>
Cc: Drew Davenport <ddavenport@chromium.org>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230320095438.17328-2-ville.syrjala@linux.intel.com
Reviewed-by: Imre Deak <imre.deak@intel.com>
(cherry picked from commit f161eb01f50ab31f2084975b43bce54b7b671e17)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_color.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_color.c
+++ b/drivers/gpu/drm/i915/display/intel_color.c
@@ -574,6 +574,25 @@ static void skl_color_commit_arm(const s
 			  crtc_state->csc_mode);
 }
 
+static void icl_color_commit_arm(const struct intel_crtc_state *crtc_state)
+{
+	struct intel_crtc *crtc = to_intel_crtc(crtc_state->uapi.crtc);
+	struct drm_i915_private *i915 = to_i915(crtc->base.dev);
+	enum pipe pipe = crtc->pipe;
+
+	/*
+	 * We don't (yet) allow userspace to control the pipe background color,
+	 * so force it to black.
+	 */
+	intel_de_write(i915, SKL_BOTTOM_COLOR(pipe), 0);
+
+	intel_de_write(i915, GAMMA_MODE(crtc->pipe),
+		       crtc_state->gamma_mode);
+
+	intel_de_write_fw(i915, PIPE_CSC_MODE(crtc->pipe),
+			  crtc_state->csc_mode);
+}
+
 static struct drm_property_blob *
 create_linear_lut(struct drm_i915_private *i915, int lut_size)
 {
@@ -2287,7 +2306,7 @@ static const struct intel_color_funcs i9
 static const struct intel_color_funcs icl_color_funcs = {
 	.color_check = icl_color_check,
 	.color_commit_noarm = icl_color_commit_noarm,
-	.color_commit_arm = skl_color_commit_arm,
+	.color_commit_arm = icl_color_commit_arm,
 	.load_luts = icl_load_luts,
 	.read_luts = icl_read_luts,
 };


