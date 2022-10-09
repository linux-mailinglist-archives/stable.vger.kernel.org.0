Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B0F5F95E0
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbiJJAZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbiJJAWg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:22:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009A4DEAD;
        Sun,  9 Oct 2022 16:56:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87C1960CF5;
        Sun,  9 Oct 2022 23:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C417EC4347C;
        Sun,  9 Oct 2022 23:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359791;
        bh=rDGR6WxWcKz0GLoKdiF+LPWjqv10NnK1ij4BucIKLCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hiCBlY7CjKHxmOZO32doE9288uAX+CRRXDM1vE79uG761GMKwZd0pRoIMj5CG+pRE
         BefhuEB1dEijMztgm7qTKTwE5K+hWtG4D8SN4G5l137bbfQfqZHbZUtVSOLeno+83A
         G73DMRn9PgQ7yxx7SFBuJ/s8uMYe52dDaty83oeg7YAZw6E4FFHO6CYBZUBgCpHFDT
         TFGBUNlxR1H/guluWrWN/GB5uC+/Y1W7/uZ/QmfySmKdLi/C+rtcWeOE04+CDAjSul
         E1SsZYWALpBScSs+NI61bQYs6Vnt/BuXsYKiLfZIQxoUD2KrXQxDr6XVz7JnN2n5HJ
         bjLuEnQQ+dFlQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>, emma@anholt.net,
        mripard@kernel.org, airlied@gmail.com, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 10/22] drm/vc4: vec: Fix timings for VEC modes
Date:   Sun,  9 Oct 2022 19:55:28 -0400
Message-Id: <20221009235540.1231640-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009235540.1231640-1-sashal@kernel.org>
References: <20221009235540.1231640-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>

[ Upstream commit 30d7565be96b3946c18a1ce3fd538f7946839092 ]

This commit fixes vertical timings of the VEC (composite output) modes
to accurately represent the 525-line ("NTSC") and 625-line ("PAL") ITU-R
standards.

Previous timings were actually defined as 502 and 601 lines, resulting
in non-standard 62.69 Hz and 52 Hz signals being generated,
respectively.

Signed-off-by: Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>
Acked-by: Noralf Trønnes <noralf@tronnes.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20220728-rpi-analog-tv-properties-v2-28-459522d653a7@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_vec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_vec.c b/drivers/gpu/drm/vc4/vc4_vec.c
index bd5b8eb58b18..c6bd168a5898 100644
--- a/drivers/gpu/drm/vc4/vc4_vec.c
+++ b/drivers/gpu/drm/vc4/vc4_vec.c
@@ -257,7 +257,7 @@ static void vc4_vec_ntsc_j_mode_set(struct vc4_vec *vec)
 static const struct drm_display_mode ntsc_mode = {
 	DRM_MODE("720x480", DRM_MODE_TYPE_DRIVER, 13500,
 		 720, 720 + 14, 720 + 14 + 64, 720 + 14 + 64 + 60, 0,
-		 480, 480 + 3, 480 + 3 + 3, 480 + 3 + 3 + 16, 0,
+		 480, 480 + 7, 480 + 7 + 6, 525, 0,
 		 DRM_MODE_FLAG_INTERLACE)
 };
 
@@ -279,7 +279,7 @@ static void vc4_vec_pal_m_mode_set(struct vc4_vec *vec)
 static const struct drm_display_mode pal_mode = {
 	DRM_MODE("720x576", DRM_MODE_TYPE_DRIVER, 13500,
 		 720, 720 + 20, 720 + 20 + 64, 720 + 20 + 64 + 60, 0,
-		 576, 576 + 2, 576 + 2 + 3, 576 + 2 + 3 + 20, 0,
+		 576, 576 + 4, 576 + 4 + 6, 625, 0,
 		 DRM_MODE_FLAG_INTERLACE)
 };
 
-- 
2.35.1

