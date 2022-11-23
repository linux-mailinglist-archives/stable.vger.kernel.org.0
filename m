Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C556357BB
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238201AbiKWJoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238216AbiKWJoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:44:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CEF5ADC7
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:42:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C8CBB81E5E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A242AC433C1;
        Wed, 23 Nov 2022 09:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196524;
        bh=COgMoRGC2qbClDmwoUTbT34A8Y2geTBApiLwhGghjDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PnzNIUpMP63Qhc2SHCz+DVN76287Wp+dDZEAQOSBRTPk49QVQ6nRV5LRouiQo7a7A
         t99hwqSpH8Z1k2hIAKre4Z1rF4ffg3l3ucZsVFgX2MTZJpPsZ7UOUR8y6ybp6fiBT1
         feNt3ncrxVmunkDR3BTp0iK56ntA1d7H7S8Bdl1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Michael Tretter <m.tretter@pengutronix.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 038/314] drm/rockchip: vop2: fix null pointer in plane_atomic_disable
Date:   Wed, 23 Nov 2022 09:48:03 +0100
Message-Id: <20221123084627.242640238@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



