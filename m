Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98CA74B4B23
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344589AbiBNKCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:02:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345794AbiBNKBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:01:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C6CBC88;
        Mon, 14 Feb 2022 01:48:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 252B961287;
        Mon, 14 Feb 2022 09:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01291C340E9;
        Mon, 14 Feb 2022 09:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832091;
        bh=UImdhe0lzIBcuJU5o3NtutfAaJZJjpWz8OLIQz63P+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ixYDFJJBqz2vMl0Uu+g8HWoLfBTvGwszGeuBIC9HDBv7mOV7M3AKPw3QcLHdG+kJT
         0X3YWK2IfToRaNE6+wUB7+DWI215szig3CytCZz4tX80FibwxWQqmWiIcPKATEgbs2
         Jmbj6nahhdQLpjn/G+EjHRmHSgQsrtKf8hzpVaJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Brian Norris <briannorris@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.15 077/172] drm/rockchip: vop: Correct RK3399 VOP register fields
Date:   Mon, 14 Feb 2022 10:25:35 +0100
Message-Id: <20220214092509.064956608@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
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
@@ -902,6 +902,7 @@ static const struct vop_win_phy rk3399_w
 	.enable = VOP_REG(RK3288_WIN0_CTRL0, 0x1, 0),
 	.format = VOP_REG(RK3288_WIN0_CTRL0, 0x7, 1),
 	.rb_swap = VOP_REG(RK3288_WIN0_CTRL0, 0x1, 12),
+	.x_mir_en = VOP_REG(RK3288_WIN0_CTRL0, 0x1, 21),
 	.y_mir_en = VOP_REG(RK3288_WIN0_CTRL0, 0x1, 22),
 	.act_info = VOP_REG(RK3288_WIN0_ACT_INFO, 0x1fff1fff, 0),
 	.dsp_info = VOP_REG(RK3288_WIN0_DSP_INFO, 0x0fff0fff, 0),
@@ -912,6 +913,7 @@ static const struct vop_win_phy rk3399_w
 	.uv_vir = VOP_REG(RK3288_WIN0_VIR, 0x3fff, 16),
 	.src_alpha_ctl = VOP_REG(RK3288_WIN0_SRC_ALPHA_CTRL, 0xff, 0),
 	.dst_alpha_ctl = VOP_REG(RK3288_WIN0_DST_ALPHA_CTRL, 0xff, 0),
+	.channel = VOP_REG(RK3288_WIN0_CTRL2, 0xff, 0),
 };
 
 /*
@@ -922,11 +924,11 @@ static const struct vop_win_phy rk3399_w
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
 


