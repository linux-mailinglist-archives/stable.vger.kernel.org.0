Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C9649A02A
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842202AbiAXXBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1837008AbiAXWli (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:41:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FAB0C04D634;
        Mon, 24 Jan 2022 13:04:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F3766131F;
        Mon, 24 Jan 2022 21:04:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67FEC340E5;
        Mon, 24 Jan 2022 21:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058272;
        bh=ZqBpEma6EwjEHMM+OJMZD2VLNm0DVB11FAv/b+XM+VI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZIoWWWW+QynyPW/YfLmshqn5OLP7kG7JxFC7sEtjIvOEshJAaAVQ+te4YGrKII+7I
         8jFF+B50vSanenz8HGrNvWKFctF/aJ+aMKs28Zv96PKR+KY6afUWtYr/g1M/DCk8nD
         g0z+HXdqFF6UpVEAqUr1bd4YLECuUYS31/j1mVIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0236/1039] drm: rcar-du: crtc: Support external DSI dot clock
Date:   Mon, 24 Jan 2022 19:33:45 +0100
Message-Id: <20220124184133.246171168@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

[ Upstream commit 57b290cb905bec520372ac635d9e9f0548d9d67e ]

On platforms with an external clock, both the group and crtc must be
handled accordingly to correctly pass through the external clock and
configure the DU to use the external rate.

The CRTC support was missed while adding the DSI support on the r8a779a0
which led to the output clocks being incorrectly determined.

Ensure that when a CRTC is routed through the DSI encoder, the external
clock is used without any further divider being applied.

Fixes: b291fdcf5114 ("drm: rcar-du: Add r8a779a0 device support")
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index 5672830ca184d..5236f917cc68d 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -261,12 +261,13 @@ static void rcar_du_crtc_set_display_timing(struct rcar_du_crtc *rcrtc)
 		rcar_du_group_write(rcrtc->group, DPLLCR, dpllcr);
 
 		escr = ESCR_DCLKSEL_DCLKIN | div;
-	} else if (rcdu->info->lvds_clk_mask & BIT(rcrtc->index)) {
+	} else if (rcdu->info->lvds_clk_mask & BIT(rcrtc->index) ||
+		   rcdu->info->dsi_clk_mask & BIT(rcrtc->index)) {
 		/*
-		 * Use the LVDS PLL output as the dot clock when outputting to
-		 * the LVDS encoder on an SoC that supports this clock routing
-		 * option. We use the clock directly in that case, without any
-		 * additional divider.
+		 * Use the external LVDS or DSI PLL output as the dot clock when
+		 * outputting to the LVDS or DSI encoder on an SoC that supports
+		 * this clock routing option. We use the clock directly in that
+		 * case, without any additional divider.
 		 */
 		escr = ESCR_DCLKSEL_DCLKIN;
 	} else {
-- 
2.34.1



