Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6700591A69
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 14:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbiHMMyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 08:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiHMMyD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 08:54:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A1B14D39
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 05:54:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13BB360CA4
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 12:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D574C433C1;
        Sat, 13 Aug 2022 12:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660395241;
        bh=rzRkDTc67ERHH3Wj16u4PuWsp+UDUlY7VdVrqb60uT0=;
        h=Subject:To:Cc:From:Date:From;
        b=0AnJ46uwWolrym01Sv5ThCzpb28QXIAd7f9w6bbKvtFcuSDJzWkpITD1WT33pUcY+
         lwyOY51qXMm2QQvgUo12zOdmj0/QVIKaO7h6HtSH0m894VzT/fxqTU+3aWmM3EaikV
         BCOnk3dMfeuY+v8dWiAPOH42lUIfn7eWwEypG+dI=
Subject: FAILED: patch "[PATCH] drm/amd/display: Only use depth 36 bpp linebuffers on DCN" failed to apply to 5.18-stable tree
To:     mario.kleiner.de@gmail.com, alexander.deucher@amd.com,
        harry.wentland@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 14:53:51 +0200
Message-ID: <1660395231213125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cb50813998b5aed924323b1b46471e8c60b26692 Mon Sep 17 00:00:00 2001
From: Mario Kleiner <mario.kleiner.de@gmail.com>
Date: Mon, 11 Jul 2022 19:39:28 +0200
Subject: [PATCH] drm/amd/display: Only use depth 36 bpp linebuffers on DCN
 display engines.

Various DCE versions had trouble with 36 bpp lb depth, requiring fixes,
last time in commit 353ca0fa5630 ("drm/amd/display: Fix 10bit 4K display
on CIK GPUs") for DCE-8. So far >= DCE-11.2 was considered ok, but now I
found out that on DCE-11.2 it causes dithering when there shouldn't be
any, so identity pixel passthrough with identity gamma LUTs doesn't work
when it should. This breaks various important neuroscience applications,
as reported to me by scientific users of Polaris cards under Ubuntu 22.04
with Linux 5.15, and confirmed by testing it myself on DCE-11.2.

Lets only use depth 36 for DCN engines, where my testing showed that it
is both necessary for high color precision output, e.g., RGBA16 fb's,
and not harmful, as far as more than one year in real-world use showed.

DCE engines seem to work fine for high precision output at 30 bpp, so
this ("famous last words") depth 30 should hopefully fix all known problems
without introducing new ones.

Successfully retested on DCE-11.2 Polaris and DCN-1.0 Raven Ridge on
top of Linux 5.19.0-rc2 + drm-next.

Fixes: 353ca0fa5630 ("drm/amd/display: Fix 10bit 4K display on CIK GPUs")
Signed-off-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Tested-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Cc: stable@vger.kernel.org # 5.14.0
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 2a701c583332..e33df231e9d2 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1156,12 +1156,13 @@ bool resource_build_scaling_params(struct pipe_ctx *pipe_ctx)
 	 * on certain displays, such as the Sharp 4k. 36bpp is needed
 	 * to support SURFACE_PIXEL_FORMAT_GRPH_ARGB16161616 and
 	 * SURFACE_PIXEL_FORMAT_GRPH_ABGR16161616 with actual > 10 bpc
-	 * precision on at least DCN display engines. However, at least
-	 * Carrizo with DCE_VERSION_11_0 does not like 36 bpp lb depth,
-	 * so use only 30 bpp on DCE_VERSION_11_0. Testing with DCE 11.2 and 8.3
-	 * did not show such problems, so this seems to be the exception.
+	 * precision on DCN display engines, but apparently not for DCE, as
+	 * far as testing on DCE-11.2 and DCE-8 showed. Various DCE parts have
+	 * problems: Carrizo with DCE_VERSION_11_0 does not like 36 bpp lb depth,
+	 * neither do DCE-8 at 4k resolution, or DCE-11.2 (broken identify pixel
+	 * passthrough). Therefore only use 36 bpp on DCN where it is actually needed.
 	 */
-	if (plane_state->ctx->dce_version > DCE_VERSION_11_0)
+	if (plane_state->ctx->dce_version > DCE_VERSION_MAX)
 		pipe_ctx->plane_res.scl_data.lb_params.depth = LB_PIXEL_DEPTH_36BPP;
 	else
 		pipe_ctx->plane_res.scl_data.lb_params.depth = LB_PIXEL_DEPTH_30BPP;

