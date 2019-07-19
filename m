Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07C0B6E013
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbfGSEjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:39:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728096AbfGSD63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:58:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE8BD21883;
        Fri, 19 Jul 2019 03:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508708;
        bh=8VpvaTC8NGBlITD/Wn03BWKljQg/sjAOb1QSXenJhhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IfK1L2aRPJe+SmVnxRY49Xs2fzSDSxdvqCpQkZFwgRXW+K/RZWjVId929XL0kBDFH
         kbAiib1D+ZsPOJkucTqsZzXaSiaLGNPDfm/YHdtGOoepdsv6jPHh/I0ZzZ7wUdTOKG
         1rEfanwEktf19MQ0NZp+2/ggmPIKyAE5lphUcXmk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Reichel <sebastian.reichel@collabora.com>,
        Pavel Machek <pavel@ucw.cz>, Tony Lindgren <tony@atomide.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 046/171] drm/omap: don't check dispc timings for DSI
Date:   Thu, 18 Jul 2019 23:54:37 -0400
Message-Id: <20190719035643.14300-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Reichel <sebastian.reichel@collabora.com>

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

