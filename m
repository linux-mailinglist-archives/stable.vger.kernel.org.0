Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4183CA6C7
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238768AbhGOSuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:50:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239795AbhGOStt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:49:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF601613DC;
        Thu, 15 Jul 2021 18:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374815;
        bh=fkdniDa+xDCETYQggD9oaebwsk6k8b5LwB+FE25nR24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0TEBNrqIUldT56nKCN4IXU9pO0dMzZxz4xgDMxvxEL1Y1riZv2LUwf8oYXtvD71o0
         m/TGfnt3+ohBGIshlbZz3mJYWkszakXFZydV+pie5Ex/yOSty5YWZVcictndj0AHSr
         hoBFO/RVsWGbiRg2dNsX45/j8c5Wr7f/4QghhcxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Bee <knaerzche@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/215] drm: rockchip: add missing registers for RK3066
Date:   Thu, 15 Jul 2021 20:36:49 +0200
Message-Id: <20210715182605.892049642@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Bee <knaerzche@gmail.com>

[ Upstream commit 742203cd56d150eb7884eb45abb7d9dbc2bdbf04 ]

Add dither_up, dsp_lut_en and data_blank registers to enable their
respective functionality for RK3066's VOP.

While at that also fix .rb_swap and .format registers for all windows,
which have to be set though RK3066_SYS_CTRL1 register.
Also remove .scl from win1: Scaling is only supported on the primary
plane.

Signed-off-by: Alex Bee <knaerzche@gmail.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20210528130554.72191-4-knaerzche@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_vop_reg.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_vop_reg.c b/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
index b8dcee64a1f7..a6fe03c3748a 100644
--- a/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
+++ b/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
@@ -349,8 +349,8 @@ static const struct vop_win_phy rk3066_win0_data = {
 	.nformats = ARRAY_SIZE(formats_win_full),
 	.format_modifiers = format_modifiers_win_full,
 	.enable = VOP_REG(RK3066_SYS_CTRL1, 0x1, 0),
-	.format = VOP_REG(RK3066_SYS_CTRL0, 0x7, 4),
-	.rb_swap = VOP_REG(RK3066_SYS_CTRL0, 0x1, 19),
+	.format = VOP_REG(RK3066_SYS_CTRL1, 0x7, 4),
+	.rb_swap = VOP_REG(RK3066_SYS_CTRL1, 0x1, 19),
 	.act_info = VOP_REG(RK3066_WIN0_ACT_INFO, 0x1fff1fff, 0),
 	.dsp_info = VOP_REG(RK3066_WIN0_DSP_INFO, 0x0fff0fff, 0),
 	.dsp_st = VOP_REG(RK3066_WIN0_DSP_ST, 0x1fff1fff, 0),
@@ -361,13 +361,12 @@ static const struct vop_win_phy rk3066_win0_data = {
 };
 
 static const struct vop_win_phy rk3066_win1_data = {
-	.scl = &rk3066_win_scl,
 	.data_formats = formats_win_full,
 	.nformats = ARRAY_SIZE(formats_win_full),
 	.format_modifiers = format_modifiers_win_full,
 	.enable = VOP_REG(RK3066_SYS_CTRL1, 0x1, 1),
-	.format = VOP_REG(RK3066_SYS_CTRL0, 0x7, 7),
-	.rb_swap = VOP_REG(RK3066_SYS_CTRL0, 0x1, 23),
+	.format = VOP_REG(RK3066_SYS_CTRL1, 0x7, 7),
+	.rb_swap = VOP_REG(RK3066_SYS_CTRL1, 0x1, 23),
 	.act_info = VOP_REG(RK3066_WIN1_ACT_INFO, 0x1fff1fff, 0),
 	.dsp_info = VOP_REG(RK3066_WIN1_DSP_INFO, 0x0fff0fff, 0),
 	.dsp_st = VOP_REG(RK3066_WIN1_DSP_ST, 0x1fff1fff, 0),
@@ -382,8 +381,8 @@ static const struct vop_win_phy rk3066_win2_data = {
 	.nformats = ARRAY_SIZE(formats_win_lite),
 	.format_modifiers = format_modifiers_win_lite,
 	.enable = VOP_REG(RK3066_SYS_CTRL1, 0x1, 2),
-	.format = VOP_REG(RK3066_SYS_CTRL0, 0x7, 10),
-	.rb_swap = VOP_REG(RK3066_SYS_CTRL0, 0x1, 27),
+	.format = VOP_REG(RK3066_SYS_CTRL1, 0x7, 10),
+	.rb_swap = VOP_REG(RK3066_SYS_CTRL1, 0x1, 27),
 	.dsp_info = VOP_REG(RK3066_WIN2_DSP_INFO, 0x0fff0fff, 0),
 	.dsp_st = VOP_REG(RK3066_WIN2_DSP_ST, 0x1fff1fff, 0),
 	.yrgb_mst = VOP_REG(RK3066_WIN2_MST, 0xffffffff, 0),
@@ -408,6 +407,9 @@ static const struct vop_common rk3066_common = {
 	.dither_down_en = VOP_REG(RK3066_DSP_CTRL0, 0x1, 11),
 	.dither_down_mode = VOP_REG(RK3066_DSP_CTRL0, 0x1, 10),
 	.dsp_blank = VOP_REG(RK3066_DSP_CTRL1, 0x1, 24),
+	.dither_up = VOP_REG(RK3066_DSP_CTRL0, 0x1, 9),
+	.dsp_lut_en = VOP_REG(RK3066_SYS_CTRL1, 0x1, 31),
+	.data_blank = VOP_REG(RK3066_DSP_CTRL1, 0x1, 25),
 };
 
 static const struct vop_win_data rk3066_vop_win_data[] = {
-- 
2.30.2



