Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3EF5C0205
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiIUPrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiIUPqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:46:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6820B77574;
        Wed, 21 Sep 2022 08:46:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07122630B2;
        Wed, 21 Sep 2022 15:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A35C433D6;
        Wed, 21 Sep 2022 15:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775205;
        bh=MOWdypYyqnky78kZC6msHskSNBx7xgN9K0cfvYK41j0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t3M4hZWYZUvWwxzY47KrSCgtyzqPMWQAfjEEsUX09+fW/LXdlK54vhmVtGdjL4ila
         zyOIMXtNbRJ0trlXWlYcjE9VnBIwZZbd3VpKAf/p/LeJcH6St7TDkyBd9+E4Rdkfue
         13XxBH2uvTv+Cey62NZYeA1HmRKtWsZImwBV3MRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Riesch <michael.riesch@wolfvision.net>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 14/38] drm/rockchip: vop2: Fix eDP/HDMI sync polarities
Date:   Wed, 21 Sep 2022 17:45:58 +0200
Message-Id: <20220921153646.739629402@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.298361220@linuxfoundation.org>
References: <20220921153646.298361220@linuxfoundation.org>
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

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 35b513a74eabf09bd718e04fd9e62b09c022807f ]

The hsync/vsync polarities were not honoured for the eDP and HDMI ports.
Add the register settings to configure the polarities as requested by the
DRM_MODE_FLAG_PHSYNC/DRM_MODE_FLAG_PVSYNC flags.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Fixes: 604be85547ce ("drm/rockchip: Add VOP2 driver")
Tested-by: Michael Riesch <michael.riesch@wolfvision.net>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220815133942.4051532-1-s.hauer@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index d6e831576cd2..88271f04615b 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -1436,11 +1436,15 @@ static void rk3568_set_intf_mux(struct vop2_video_port *vp, int id,
 		die &= ~RK3568_SYS_DSP_INFACE_EN_HDMI_MUX;
 		die |= RK3568_SYS_DSP_INFACE_EN_HDMI |
 			   FIELD_PREP(RK3568_SYS_DSP_INFACE_EN_HDMI_MUX, vp->id);
+		dip &= ~RK3568_DSP_IF_POL__HDMI_PIN_POL;
+		dip |= FIELD_PREP(RK3568_DSP_IF_POL__HDMI_PIN_POL, polflags);
 		break;
 	case ROCKCHIP_VOP2_EP_EDP0:
 		die &= ~RK3568_SYS_DSP_INFACE_EN_EDP_MUX;
 		die |= RK3568_SYS_DSP_INFACE_EN_EDP |
 			   FIELD_PREP(RK3568_SYS_DSP_INFACE_EN_EDP_MUX, vp->id);
+		dip &= ~RK3568_DSP_IF_POL__EDP_PIN_POL;
+		dip |= FIELD_PREP(RK3568_DSP_IF_POL__EDP_PIN_POL, polflags);
 		break;
 	case ROCKCHIP_VOP2_EP_MIPI0:
 		die &= ~RK3568_SYS_DSP_INFACE_EN_MIPI0_MUX;
-- 
2.35.1



