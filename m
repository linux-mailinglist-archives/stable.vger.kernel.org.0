Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0903B6DC0F
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389234AbfGSEN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:13:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388001AbfGSEN3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:13:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B59121872;
        Fri, 19 Jul 2019 04:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509608;
        bh=NDrTMJck9PjoSa91ieKCleeY7HzyP5UQQ+2j9bL/8QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PWcsjEEz/WQK2GGyiAaSbFsVhTOYzWEKnWio8rbk6xngdE1svgc2t1COimLUoYhWK
         Fvzj2f5RWzAyOzGjjSovhaY6mzcPHmpRhZtqsUdILc7+Hhajyt2JKvNyUqucvDKnKR
         p2RPdmHRkLc2gb8pw8C/OJ9e3xT2A/gWR1hmAcv8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Anderson <dianders@chromium.org>,
        Sean Paul <seanpaul@chromium.org>,
        Yakir Yang <ykk@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 15/45] drm/rockchip: Properly adjust to a true clock in adjusted_mode
Date:   Fri, 19 Jul 2019 00:12:34 -0400
Message-Id: <20190719041304.18849-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719041304.18849-1-sashal@kernel.org>
References: <20190719041304.18849-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 99b9683f2142b20bad78e61f7f829e8714e45685 ]

When fixing up the clock in vop_crtc_mode_fixup() we're not doing it
quite correctly.  Specifically if we've got the true clock 266666667 Hz,
we'll perform this calculation:
   266666667 / 1000 => 266666

Later when we try to set the clock we'll do clk_set_rate(266666 *
1000).  The common clock framework won't actually pick the proper clock
in this case since it always wants clocks <= the specified one.

Let's solve this by using DIV_ROUND_UP.

Fixes: b59b8de31497 ("drm/rockchip: return a true clock rate to adjusted_mode")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Reviewed-by: Yakir Yang <ykk@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20190614224730.98622-1-dianders@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
index 32d87c6035c9..5bed63eee5f0 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -865,7 +865,8 @@ static bool vop_crtc_mode_fixup(struct drm_crtc *crtc,
 	struct vop *vop = to_vop(crtc);
 
 	adjusted_mode->clock =
-		clk_round_rate(vop->dclk, mode->clock * 1000) / 1000;
+		DIV_ROUND_UP(clk_round_rate(vop->dclk, mode->clock * 1000),
+			     1000);
 
 	return true;
 }
-- 
2.20.1

