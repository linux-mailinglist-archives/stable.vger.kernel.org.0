Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA8C6D49E4
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbjDCOmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233830AbjDCOmG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:42:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC9B17AF6
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:42:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7F90B81D05
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19ED3C433EF;
        Mon,  3 Apr 2023 14:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532920;
        bh=6SnvLvhDmMe+ljU9lj8VIya8wlZXztZgAtVXyz4R2RA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=shXVM+Rzt6pg0KZhOTF7CZDEzGxXP+1G9mTs1LAn7iTXjx3S3gboVG35f1Zkf90qA
         P9HNV0EcqcUkjPo+ZjEDRoGn8Kl8ycEgURLXEXFvh8ylDBlaRtE4KHSzHvLFvP0Wd6
         hhoR3q5zwsjRwdOVh+UsWppNXz1vre/sp3j1V6ys=
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
Subject: [PATCH 6.1 168/181] drm/i915: Move CSC load back into .color_commit_arm() when PSR is enabled on skl/glk
Date:   Mon,  3 Apr 2023 16:10:03 +0200
Message-Id: <20230403140420.579896686@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit a8e03e00b62073b494886dbff32f8b5338066c8b upstream.

SKL/GLK CSC unit suffers from a nasty issue where a CSC
coeff/offset register read or write between DC5 exit and
PSR exit will undo the CSC arming performed by DMC, and
then during PSR exit the hardware will latch zeroes into
the active CSC registers. This causes any plane going
through the CSC to output all black.

We can sidestep the issue by making sure the PSR exit has
already actually happened before we touch the CSC coeff/offset
registers. Easiest way to guarantee that is to just move the
CSC programming back into the .color_commir_arm() as we force
a PSR exit (and crucially wait for it to actually happen)
prior to touching the arming registers.

When PSR (and thus also DC states) are disabled we don't
have anything to worry about, so we can keep using the
more optional _noarm() hook for writing the CSC registers.

Cc: <stable@vger.kernel.org> #v5.19+
Cc: Manasi Navare <navaremanasi@google.com>
Cc: Drew Davenport <ddavenport@chromium.org>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Jouni Högander <jouni.hogander@intel.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8283
Fixes: d13dde449580 ("drm/i915: Split pipe+output CSC programming to noarm+arm pair")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230320095438.17328-3-ville.syrjala@linux.intel.com
Reviewed-by: Imre Deak <imre.deak@intel.com>
(cherry picked from commit 80a892a4c2428b65366721599fc5fe50eaed35fd)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_color.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_color.c
+++ b/drivers/gpu/drm/i915/display/intel_color.c
@@ -499,6 +499,22 @@ static void icl_color_commit_noarm(const
 	icl_load_csc_matrix(crtc_state);
 }
 
+static void skl_color_commit_noarm(const struct intel_crtc_state *crtc_state)
+{
+	/*
+	 * Possibly related to display WA #1184, SKL CSC loses the latched
+	 * CSC coeff/offset register values if the CSC registers are disarmed
+	 * between DC5 exit and PSR exit. This will cause the plane(s) to
+	 * output all black (until CSC_MODE is rearmed and properly latched).
+	 * Once PSR exit (and proper register latching) has occurred the
+	 * danger is over. Thus when PSR is enabled the CSC coeff/offset
+	 * register programming will be peformed from skl_color_commit_arm()
+	 * which is called after PSR exit.
+	 */
+	if (!crtc_state->has_psr)
+		ilk_load_csc_matrix(crtc_state);
+}
+
 static void ilk_color_commit_noarm(const struct intel_crtc_state *crtc_state)
 {
 	ilk_load_csc_matrix(crtc_state);
@@ -541,6 +557,9 @@ static void skl_color_commit_arm(const s
 	enum pipe pipe = crtc->pipe;
 	u32 val = 0;
 
+	if (crtc_state->has_psr)
+		ilk_load_csc_matrix(crtc_state);
+
 	/*
 	 * We don't (yet) allow userspace to control the pipe background color,
 	 * so force it to black, but apply pipe gamma and CSC appropriately
@@ -2171,7 +2190,7 @@ static const struct intel_color_funcs ic
 
 static const struct intel_color_funcs glk_color_funcs = {
 	.color_check = glk_color_check,
-	.color_commit_noarm = ilk_color_commit_noarm,
+	.color_commit_noarm = skl_color_commit_noarm,
 	.color_commit_arm = skl_color_commit_arm,
 	.load_luts = glk_load_luts,
 	.read_luts = glk_read_luts,
@@ -2179,7 +2198,7 @@ static const struct intel_color_funcs gl
 
 static const struct intel_color_funcs skl_color_funcs = {
 	.color_check = ivb_color_check,
-	.color_commit_noarm = ilk_color_commit_noarm,
+	.color_commit_noarm = skl_color_commit_noarm,
 	.color_commit_arm = skl_color_commit_arm,
 	.load_luts = bdw_load_luts,
 	.read_luts = NULL,


