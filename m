Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767C25708FC
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 19:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbiGKRjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 13:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbiGKRjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 13:39:46 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B82C6B258
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 10:39:45 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id oy13so5172509ejb.1
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 10:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QbNkUB3NzvVhPi0S7gR2mDTXIn3a0+mT5FVjS17tpYM=;
        b=cci/HmO67hkCe1aQerLGkZvutwCpmz2jr/zobqmZv++apYU0U6z5MkEp4cjONeq/5y
         /xAtoZWzS96LJyvj9DQ9Qs9FWCwCkvmBeN0QtkoZpiUCVQcqrgNNIlI01bwLG0pHJxx2
         aZESWp97X9+6GdfJHJX+MswfoadOWxFdfAxC21N+Z5rjZjZbKnK1V//8PD0QhKB7aIze
         gOAlvjRbPPt+Zl9HtqapBs6XrxcxBhn99//s2IrLldJdrwgFVVKgykcyA+nH9CJDDGSL
         MNG2sU2LTXYLw45+V+W3jlnDLj1ihwWv12lwNhPozYBuDaH0zKsXka5oyoGu5faV/OEg
         8y8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QbNkUB3NzvVhPi0S7gR2mDTXIn3a0+mT5FVjS17tpYM=;
        b=gJIFfwzbUJjeNZiXjhtPPmbxA3LL1Y1G2bWM0sMG3CdjCCMbX5Xy9KivY9BBbYvry2
         hWkApLXgyGWTcgI2t0QJNBF9/A7EOSTRtI4Dx8Nt9swTHTLk+jLtpWinaHNE5ft0jJEA
         YI0D4PQTRNgY3IrAz5lZ/A+U5HfiCQT9QlDBUGanbKz0hvFK4eGhpsQfIvaoXmWNRSx3
         FpFEPYZND/j5Omz8W7iqgLy65SQE973IQASNgyLcc6eEc+EzlneE01Kp46h8H1im9Wu4
         tfYYIkx6SGPPqRb+F9dFdMY5GGUqOxjU07UOaPF24TvC7UdyUyQNezsbzqyZsJ5f+kcQ
         q/4Q==
X-Gm-Message-State: AJIora9pZv0a19NdVEcapw9rduqMBSxeSF2RXUteDj+5A45RBFeP/pfc
        bQOh0jlGMMT4YuDdg5A0+HU=
X-Google-Smtp-Source: AGRyM1s4hO2Swgzw0fZ9nSMxPCGQ3AdrDmS9cvtEGO40YWt6tCytlnI1vvMlL4zVCk71aTC+cVzEfw==
X-Received: by 2002:a17:907:a07c:b0:72a:b390:ee8a with SMTP id ia28-20020a170907a07c00b0072ab390ee8amr19212665ejc.96.1657561183659;
        Mon, 11 Jul 2022 10:39:43 -0700 (PDT)
Received: from groovy.localdomain (dynamic-2a01-0c22-d05f-bf00-3e61-137e-625f-8d33.c22.pool.telefonica.de. [2a01:c22:d05f:bf00:3e61:137e:625f:8d33])
        by smtp.gmail.com with ESMTPSA id g9-20020a50ec09000000b0043a735add09sm4630553edr.21.2022.07.11.10.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 10:39:43 -0700 (PDT)
From:   Mario Kleiner <mario.kleiner.de@gmail.com>
To:     amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc:     mario.kleiner.de@gmail.com, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <harry.wentland@amd.com>
Subject: [PATCH] drm/amd/display: Only use depth 36 bpp linebuffers on DCN display engines.
Date:   Mon, 11 Jul 2022 19:39:28 +0200
Message-Id: <20220711173928.3858-1-mario.kleiner.de@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 6774dd8bb53e..3fe3fbac1e63 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1117,12 +1117,13 @@ bool resource_build_scaling_params(struct pipe_ctx *pipe_ctx)
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
2.34.1

