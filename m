Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA88625040
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbiKKCeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbiKKCeG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:34:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7C411155;
        Thu, 10 Nov 2022 18:33:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A10FF61E87;
        Fri, 11 Nov 2022 02:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EABC433D6;
        Fri, 11 Nov 2022 02:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134036;
        bh=COgMoRGC2qbClDmwoUTbT34A8Y2geTBApiLwhGghjDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eoLLaHiTxEU1n5m7Ma4nfWStmnyO1VsQ4A/gNbVa9gFcPtfbtUTljcb2jXDjaRtNb
         hPn5Ahr1Fu1n532v79Yu2UNNxxlMVJ6PgEQqj6z01ZlO8jg/mWPCBcQILSYs5GtDaN
         AC8J9wY7LladMxx8+DWTWjndA9EgtR3YepMm1T9dAHPaHPM/6UB8nPS2zv6zRMqjka
         kC6aBkyWcuV5tzo92gkOsn7zQao/DdkP7NaVrDiBoPtTtLLqJNPCGxzAAtQyJ5Uy96
         asznr3A/yXFNzSPPQZxuV1ulPcy4IZMRqciNfjd6bVwlddnge7Qf8l61geRDjD55gb
         CW13hdN1N0iqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Tretter <m.tretter@pengutronix.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, hjc@rock-chips.com,
        airlied@gmail.com, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 07/30] drm/rockchip: vop2: fix null pointer in plane_atomic_disable
Date:   Thu, 10 Nov 2022 21:33:15 -0500
Message-Id: <20221111023340.227279-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023340.227279-1-sashal@kernel.org>
References: <20221111023340.227279-1-sashal@kernel.org>
MIME-Version: 1.0
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

From: Michael Tretter <m.tretter@pengutronix.de>

[ Upstream commit 471bf2406c043491b1a8288e5f04bc278f7d7ca1 ]

If the vop2_plane_atomic_disable function is called with NULL as a
state, accessing the old_pstate runs into a null pointer exception.
However, the drm_atomic_helper_disable_planes_on_crtc function calls the
atomic_disable callback with state NULL.

Allow to disable a plane without passing a plane state by checking the
old_pstate only if a state is passed.

Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20221028095206.2136601-2-m.tretter@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index f9aa8b96c695..bf9c3e92e1cd 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -997,13 +997,15 @@ static int vop2_plane_atomic_check(struct drm_plane *plane,
 static void vop2_plane_atomic_disable(struct drm_plane *plane,
 				      struct drm_atomic_state *state)
 {
-	struct drm_plane_state *old_pstate = drm_atomic_get_old_plane_state(state, plane);
+	struct drm_plane_state *old_pstate = NULL;
 	struct vop2_win *win = to_vop2_win(plane);
 	struct vop2 *vop2 = win->vop2;
 
 	drm_dbg(vop2->drm, "%s disable\n", win->data->name);
 
-	if (!old_pstate->crtc)
+	if (state)
+		old_pstate = drm_atomic_get_old_plane_state(state, plane);
+	if (old_pstate && !old_pstate->crtc)
 		return;
 
 	vop2_win_disable(win);
-- 
2.35.1

