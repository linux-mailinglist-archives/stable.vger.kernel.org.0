Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D47625042
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbiKKCeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbiKKCeG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:34:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C180B11161;
        Thu, 10 Nov 2022 18:33:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4042961E88;
        Fri, 11 Nov 2022 02:33:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91820C433B5;
        Fri, 11 Nov 2022 02:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134037;
        bh=L9LEH3BsZlnsIKqkJQyyudYrCpgnyFcbsQzEgaFeCIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZSccu8H8vHOOl1VWUTvc4fJcwnLKsY0YZZX/9qBRPd1Q57prLHyGqKdJxbvST0slc
         RxoqBEQZX1Ov7qrSfvJwfVw9xWnCY5rK3FtEIs0iVM9CsfhCb49Y97JWumKvjIlldk
         Gz1PXGQFWxU7UziqmzwAgr03L1unDR+hN10dtP1lCklnWn2ZOMRqooKsFIbqLrGQKm
         nL5sBwhjCmp6QWf5eVE5IRJkPJxnQQaHHYWXTk2p9YCDG7a8f46O9HMJzkTVnLoQ6p
         yP5Z+fkGeVgXUBrwYKTeGUDri9vFqV9pNN5ey8FM1iPc0k03WY39Fn+KZxtVr2F2yy
         4Y87GlWmLLIhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Tretter <m.tretter@pengutronix.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, hjc@rock-chips.com,
        airlied@gmail.com, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 08/30] drm/rockchip: vop2: disable planes when disabling the crtc
Date:   Thu, 10 Nov 2022 21:33:16 -0500
Message-Id: <20221111023340.227279-8-sashal@kernel.org>
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

[ Upstream commit 447fb14bf07905b880c9ed1ea92c53d6dd0649d7 ]

The vop2 driver needs to explicitly disable the planes if the crtc is
disabled. Unless the planes are explicitly disabled, the address of the
last framebuffer is kept in the registers of the VOP2. When re-enabling
the encoder after it has been disabled by the driver, the VOP2 will
start and read the framebuffer that has been freed but is still pointed
to by the register. The iommu will catch these read accesses and print
errors.

Explicitly disable the planes when the crtc is disabled to reset the
registers.

Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20221028095206.2136601-3-m.tretter@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index bf9c3e92e1cd..1fc04019dfd8 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -878,10 +878,14 @@ static void vop2_crtc_atomic_disable(struct drm_crtc *crtc,
 {
 	struct vop2_video_port *vp = to_vop2_video_port(crtc);
 	struct vop2 *vop2 = vp->vop2;
+	struct drm_crtc_state *old_crtc_state;
 	int ret;
 
 	vop2_lock(vop2);
 
+	old_crtc_state = drm_atomic_get_old_crtc_state(state, crtc);
+	drm_atomic_helper_disable_planes_on_crtc(old_crtc_state, false);
+
 	drm_crtc_vblank_off(crtc);
 
 	/*
-- 
2.35.1

