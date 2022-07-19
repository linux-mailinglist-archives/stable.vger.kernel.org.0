Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57592579C50
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240866AbiGSMii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240868AbiGSMiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:38:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2527E48CB9;
        Tue, 19 Jul 2022 05:14:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 136E8B81B2C;
        Tue, 19 Jul 2022 12:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698A5C341C6;
        Tue, 19 Jul 2022 12:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232876;
        bh=56qZbx3cncrVIZ5NxaYEoRlyihlaVBC0ZdifBj4+yXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OHlrOApUD641ifBdTq/wnpwfQoShjaYVlNve5Foq7x62csQ0B5FqqIhJzLHRa11MK
         6AD6QzsF9KrJiVALWyN3Y3jLVz+qbdssVXrQrbV/nhKpmzSG4DGF9zQuksXkIUGN8B
         6a/RibTcCbH/dsTxh0vJftf5KWtnD5SM6LtnOeec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mario Kleiner <mario.kleiner.de@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/167] drm/amd/display: Only use depth 36 bpp linebuffers on DCN display engines.
Date:   Tue, 19 Jul 2022 13:53:49 +0200
Message-Id: <20220719114705.846071785@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Kleiner <mario.kleiner.de@gmail.com>

[ Upstream commit add61d3c31de6a4b5e11a2ab96aaf4c873481568 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 82f1f27baaf3..188556e41b9d 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1062,12 +1062,13 @@ bool resource_build_scaling_params(struct pipe_ctx *pipe_ctx)
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
-- 
2.35.1



