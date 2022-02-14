Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 861874B4756
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245271AbiBNJsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:48:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245318AbiBNJrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:47:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5052AE6B;
        Mon, 14 Feb 2022 01:40:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D39C86117D;
        Mon, 14 Feb 2022 09:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1532C340E9;
        Mon, 14 Feb 2022 09:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831643;
        bh=pvQvL86pNurP4n/DoHviID1KeDX0M1Jc5g2X2Aax/54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QxH2VKWtyDN+fWtqasx3WoWngoi3qB/nY6tL1GY0fD6ZzuDNpKTjImLeJBLDsIJ/+
         qq2dO6n+zTw1JQOU8/5Bj3Txekcy7O0LeBxxDXP0XpOBcO1FE01XbZEPrVdzyRn3dV
         fGWid6A1kfejxANBgbwDRJvHfHM8I9ruobSp61Rs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Brian Norris <briannorris@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.10 049/116] drm/rockchip: vop: Correct RK3399 VOP register fields
Date:   Mon, 14 Feb 2022 10:25:48 +0100
Message-Id: <20220214092500.407595604@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

commit 9da1e9ab82c92d0e89fe44cad2cd7c2d18d64070 upstream.

Commit 7707f7227f09 ("drm/rockchip: Add support for afbc") switched up
the rk3399_vop_big[] register windows, but it did so incorrectly.

The biggest problem is in rk3288_win23_data[] vs.
rk3368_win23_data[] .format field:

  RK3288's format: VOP_REG(RK3288_WIN2_CTRL0, 0x7, 1)
  RK3368's format: VOP_REG(RK3368_WIN2_CTRL0, 0x3, 5)

Bits 5:6 (i.e., shift 5, mask 0x3) are correct for RK3399, according to
the TRM.

There are a few other small differences between the 3288 and 3368
definitions that were swapped in commit 7707f7227f09. I reviewed them to
the best of my ability according to the RK3399 TRM and fixed them up.

This fixes IOMMU issues (and display errors) when testing with BG24
color formats.

Fixes: 7707f7227f09 ("drm/rockchip: Add support for afbc")
Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Tested-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220119161104.1.I1d01436bef35165a8cdfe9308789c0badb5ff46a@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/rockchip/rockchip_vop_reg.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
+++ b/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
@@ -873,6 +873,7 @@ static const struct vop_win_phy rk3399_w
 	.enable = VOP_REG(RK3288_WIN0_CTRL0, 0x1, 0),
 	.format = VOP_REG(RK3288_WIN0_CTRL0, 0x7, 1),
 	.rb_swap = VOP_REG(RK3288_WIN0_CTRL0, 0x1, 12),
+	.x_mir_en = VOP_REG(RK3288_WIN0_CTRL0, 0x1, 21),
 	.y_mir_en = VOP_REG(RK3288_WIN0_CTRL0, 0x1, 22),
 	.act_info = VOP_REG(RK3288_WIN0_ACT_INFO, 0x1fff1fff, 0),
 	.dsp_info = VOP_REG(RK3288_WIN0_DSP_INFO, 0x0fff0fff, 0),
@@ -883,6 +884,7 @@ static const struct vop_win_phy rk3399_w
 	.uv_vir = VOP_REG(RK3288_WIN0_VIR, 0x3fff, 16),
 	.src_alpha_ctl = VOP_REG(RK3288_WIN0_SRC_ALPHA_CTRL, 0xff, 0),
 	.dst_alpha_ctl = VOP_REG(RK3288_WIN0_DST_ALPHA_CTRL, 0xff, 0),
+	.channel = VOP_REG(RK3288_WIN0_CTRL2, 0xff, 0),
 };
 
 /*
@@ -893,11 +895,11 @@ static const struct vop_win_phy rk3399_w
 static const struct vop_win_data rk3399_vop_win_data[] = {
 	{ .base = 0x00, .phy = &rk3399_win01_data,
 	  .type = DRM_PLANE_TYPE_PRIMARY },
-	{ .base = 0x40, .phy = &rk3288_win01_data,
+	{ .base = 0x40, .phy = &rk3368_win01_data,
 	  .type = DRM_PLANE_TYPE_OVERLAY },
-	{ .base = 0x00, .phy = &rk3288_win23_data,
+	{ .base = 0x00, .phy = &rk3368_win23_data,
 	  .type = DRM_PLANE_TYPE_OVERLAY },
-	{ .base = 0x50, .phy = &rk3288_win23_data,
+	{ .base = 0x50, .phy = &rk3368_win23_data,
 	  .type = DRM_PLANE_TYPE_CURSOR },
 };
 


