Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC2E79610
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729747AbfG2TsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:48:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729729AbfG2TsQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:48:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0516820C01;
        Mon, 29 Jul 2019 19:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429696;
        bh=kTu5OqvrgpLJAICy736VvCxhpsfGdUpXfh8eyIoGUHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LpAGVNcs7BQMZ3hNG54Bjaq6D58AQ2gBwMwJc6kQAlByTgAaButqHbnLSx0YDDdF9
         rJCn10hYjX24AY71bgkbpVI0ekfSuTF19u6AEyzY5b0DD6/m8253XU0xoylZY34q20
         IEAjN2ZUrGyvPX9/xgsJ9LPUpEUUAQIZ5kjegzog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Sean Paul <seanpaul@chromium.org>,
        Yakir Yang <ykk@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 064/215] drm/rockchip: Properly adjust to a true clock in adjusted_mode
Date:   Mon, 29 Jul 2019 21:21:00 +0200
Message-Id: <20190729190751.575791553@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 12ed5265a90b..09046135e720 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -1011,7 +1011,8 @@ static bool vop_crtc_mode_fixup(struct drm_crtc *crtc,
 	struct vop *vop = to_vop(crtc);
 
 	adjusted_mode->clock =
-		clk_round_rate(vop->dclk, mode->clock * 1000) / 1000;
+		DIV_ROUND_UP(clk_round_rate(vop->dclk, mode->clock * 1000),
+			     1000);
 
 	return true;
 }
-- 
2.20.1



