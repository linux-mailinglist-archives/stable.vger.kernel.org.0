Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CE93CAA14
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243760AbhGOTLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:11:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243222AbhGOTJa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:09:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E733E613F6;
        Thu, 15 Jul 2021 19:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375916;
        bh=4Fu4G4b/XGeKu5EbAcyA0kyrm0McafbQWyb4+B87B1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OkTZ29MTT4GE1Phnr5BnJ6o+JlT6mB4ZRJW1wZnBv5ewrktAoSfae3NW+HRQNfd2k
         y105RxVR8aU78tuE7THUODQt4eTVtw84is29q4ueHK4M1emiI5UAhpPRkaSbd1Xlu4
         qkV0CeyKdet9ub80cCO2yBrDloTXFbNT7xmOYfG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Bee <knaerzche@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 048/266] drm: rockchip: add missing registers for RK3188
Date:   Thu, 15 Jul 2021 20:36:43 +0200
Message-Id: <20210715182622.715196773@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Bee <knaerzche@gmail.com>

[ Upstream commit ab64b448a175b8a5a4bd323b8f74758c2574482c ]

Add dither_up, dsp_lut_en and data_blank registers to enable their
respective functionality for RK3188's VOP.
While at that also fix .dsp_blank register which is (only) set with
BIT24 (same as RK3066)

Signed-off-by: Alex Bee <knaerzche@gmail.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20210528130554.72191-3-knaerzche@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_vop_reg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_vop_reg.c b/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
index 80053d91a301..b8dcee64a1f7 100644
--- a/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
+++ b/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
@@ -505,7 +505,10 @@ static const struct vop_common rk3188_common = {
 	.dither_down_sel = VOP_REG(RK3188_DSP_CTRL0, 0x1, 27),
 	.dither_down_en = VOP_REG(RK3188_DSP_CTRL0, 0x1, 11),
 	.dither_down_mode = VOP_REG(RK3188_DSP_CTRL0, 0x1, 10),
-	.dsp_blank = VOP_REG(RK3188_DSP_CTRL1, 0x3, 24),
+	.dsp_blank = VOP_REG(RK3188_DSP_CTRL1, 0x1, 24),
+	.dither_up = VOP_REG(RK3188_DSP_CTRL0, 0x1, 9),
+	.dsp_lut_en = VOP_REG(RK3188_SYS_CTRL, 0x1, 28),
+	.data_blank = VOP_REG(RK3188_DSP_CTRL1, 0x1, 25),
 };
 
 static const struct vop_win_data rk3188_vop_win_data[] = {
-- 
2.30.2



