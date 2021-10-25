Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0638043A2A0
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237806AbhJYTul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:50:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238325AbhJYTsi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:48:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95B9261078;
        Mon, 25 Oct 2021 19:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190854;
        bh=Vx2ZRGg5RmOFv2OlZ/Yh8d6ij1oKPNgOh4gqM2jxo+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gWY68g+MGxBwrqVAf1wFgPJSyTMaY9ivuhOZ4lhBOOjdTS6IKKIojSVDdQGn6En08
         2g7Q3SU+SvOyDGd+Xx/UmHlA1JQWrdpAjg+iLe5hsKUUeuCeTlnFUEBmsbZs/G9ekN
         eT1vXHWpvLw1yS6maq5t7DdJX7htoFKodvXriM/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edmund Dea <edmund.j.dea@intel.com>,
        Anitha Chrisanthus <anitha.chrisanthus@intel.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 059/169] drm/kmb: Remove clearing DPHY regs
Date:   Mon, 25 Oct 2021 21:14:00 +0200
Message-Id: <20211025191025.009946082@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edmund Dea <edmund.j.dea@intel.com>

[ Upstream commit 13047a092c6d3f23b7d684b5b3fe46b2b50423b9 ]

Don't clear the shared DPHY registers common to MIPI Rx and MIPI Tx during
DSI initialization since this was causing MIPI Rx reset. Rest of the
writes are bitwise, so will not affect Mipi Rx side.

Fixes: 98521f4d4b4c ("drm/kmb: Mipi DSI part of the display driver")
Signed-off-by: Edmund Dea <edmund.j.dea@intel.com>
Signed-off-by: Anitha Chrisanthus <anitha.chrisanthus@intel.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20211013233632.471892-3-anitha.chrisanthus@intel.com
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/kmb/kmb_dsi.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/kmb/kmb_dsi.c b/drivers/gpu/drm/kmb/kmb_dsi.c
index 7e2371ffcb18..5bc6c84073a3 100644
--- a/drivers/gpu/drm/kmb/kmb_dsi.c
+++ b/drivers/gpu/drm/kmb/kmb_dsi.c
@@ -1393,11 +1393,6 @@ int kmb_dsi_mode_set(struct kmb_dsi *kmb_dsi, struct drm_display_mode *mode,
 		mipi_tx_init_cfg.lane_rate_mbps = data_rate;
 	}
 
-	kmb_write_mipi(kmb_dsi, DPHY_ENABLE, 0);
-	kmb_write_mipi(kmb_dsi, DPHY_INIT_CTRL0, 0);
-	kmb_write_mipi(kmb_dsi, DPHY_INIT_CTRL1, 0);
-	kmb_write_mipi(kmb_dsi, DPHY_INIT_CTRL2, 0);
-
 	/* Initialize mipi controller */
 	mipi_tx_init_cntrl(kmb_dsi, &mipi_tx_init_cfg);
 
-- 
2.33.0



