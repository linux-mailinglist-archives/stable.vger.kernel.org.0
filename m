Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCDFD797E0
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390660AbfG2UDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 16:03:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390301AbfG2TrU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:47:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0076F20C01;
        Mon, 29 Jul 2019 19:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429639;
        bh=9B7N36wRk/AXY+rskVB91mp5QSNljimZaU8D+Ad43rI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wKfqgznftPiDesmiLbAsy+dTpN13rs2R903WcVUPZjOZlDE1mmFKs6IxYo6FHNYxk
         UyoxJ/8vSygwEp7pUDkMSeCLLqw1ZOYAQcAG/NtboQUfzaYcDmZi886hmB02Ft7qg8
         FnHyur+AxeN8IKou24gN0HGnxN1+9EbLBSJqoyhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 048/215] drm/omap: dont check dispc timings for DSI
Date:   Mon, 29 Jul 2019 21:20:44 +0200
Message-Id: <20190729190748.832081009@linuxfoundation.org>
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

[ Upstream commit ad9df7d91b4a6e8f4b20c2bf539ac09b3b2ad6eb ]

While most display types only forward their VM to the DISPC, this
is not true for DSI. DSI calculates the VM for DISPC based on its
own, but it's not identical. Actually the DSI VM is not even a valid
DISPC VM making this check fail. Let's restore the old behaviour
and avoid checking the DISPC VM for DSI here.

Fixes: 7c27fa57ef31 ("drm/omap: Call dispc timings check operation directly")
Acked-by: Pavel Machek <pavel@ucw.cz>
Tested-by: Tony Lindgren <tony@atomide.com>
Tested-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/omapdrm/omap_crtc.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/omap_crtc.c b/drivers/gpu/drm/omapdrm/omap_crtc.c
index 8712af79a49c..4c43dd282acc 100644
--- a/drivers/gpu/drm/omapdrm/omap_crtc.c
+++ b/drivers/gpu/drm/omapdrm/omap_crtc.c
@@ -384,10 +384,20 @@ static enum drm_mode_status omap_crtc_mode_valid(struct drm_crtc *crtc,
 	int r;
 
 	drm_display_mode_to_videomode(mode, &vm);
-	r = priv->dispc_ops->mgr_check_timings(priv->dispc, omap_crtc->channel,
-					       &vm);
-	if (r)
-		return r;
+
+	/*
+	 * DSI might not call this, since the supplied mode is not a
+	 * valid DISPC mode. DSI will calculate and configure the
+	 * proper DISPC mode later.
+	 */
+	if (omap_crtc->pipe->output->next == NULL ||
+	    omap_crtc->pipe->output->next->type != OMAP_DISPLAY_TYPE_DSI) {
+		r = priv->dispc_ops->mgr_check_timings(priv->dispc,
+						       omap_crtc->channel,
+						       &vm);
+		if (r)
+			return r;
+	}
 
 	/* Check for bandwidth limit */
 	if (priv->max_bandwidth) {
-- 
2.20.1



