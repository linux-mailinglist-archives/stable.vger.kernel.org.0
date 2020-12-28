Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899622E402B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439184AbgL1OWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:22:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:57902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439186AbgL1OWP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:22:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10F79206E5;
        Mon, 28 Dec 2020 14:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165294;
        bh=bSlfWckOwMJnm/EAO2K31nscYWvG7pqH5XCo0KjMKzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yvN3dsk+3r/JZVIrtuYosldFgRJFKQW+NTJHCMiMkEhhEdyc0qff7E8IYFoKqzpSG
         5XbaMvvWVZJqJmxeKRo2SIU47X7ceEQdbcEok1TlV9dlvxB5QYuJ59K4dEMiey2usj
         OhF4N7CEL4ifv3LClpQcYjBiRA+ZCaTS86qE6zjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 441/717] drm: mxsfb: Silence -EPROBE_DEFER while waiting for bridge
Date:   Mon, 28 Dec 2020 13:47:19 +0100
Message-Id: <20201228125042.097307585@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guido Günther <agx@sigxcpu.org>

[ Upstream commit ee46d16d2e40bebc2aa790fd7b6a056466ff895c ]

It can take multiple iterations until all components for an attached DSI
bridge are up leading to several:

[    3.796425] mxsfb 30320000.lcd-controller: Cannot connect bridge: -517
[    3.816952] mxsfb 30320000.lcd-controller: [drm:mxsfb_probe [mxsfb]] *ERROR* failed to attach bridge: -517

Silence this by checking for -EPROBE_DEFER and using dev_err_probe() so
we set a deferred reason in case a dependency fails to probe (which
quickly happens on small config/DT changes due to the rather long probe
chain which can include bridges, phys, panels, backights, leds, etc.).

This also removes the only DRM_DEV_ERROR() usage, the rest of the driver
uses dev_err().

Signed-off-by: Guido Günther <agx@sigxcpu.org>
Fixes: c42001e357f7 ("drm: mxsfb: Use drm_panel_bridge")
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/d5761eb871adde5464ba112b89d966568bc2ff6c.1608020391.git.agx@sigxcpu.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mxsfb/mxsfb_drv.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/mxsfb/mxsfb_drv.c b/drivers/gpu/drm/mxsfb/mxsfb_drv.c
index 35122aef037b4..17f26052e8450 100644
--- a/drivers/gpu/drm/mxsfb/mxsfb_drv.c
+++ b/drivers/gpu/drm/mxsfb/mxsfb_drv.c
@@ -134,11 +134,8 @@ static int mxsfb_attach_bridge(struct mxsfb_drm_private *mxsfb)
 		return -ENODEV;
 
 	ret = drm_bridge_attach(&mxsfb->encoder, bridge, NULL, 0);
-	if (ret) {
-		DRM_DEV_ERROR(drm->dev,
-			      "failed to attach bridge: %d\n", ret);
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(drm->dev, ret, "Failed to attach bridge\n");
 
 	mxsfb->bridge = bridge;
 
@@ -212,7 +209,8 @@ static int mxsfb_load(struct drm_device *drm,
 
 	ret = mxsfb_attach_bridge(mxsfb);
 	if (ret) {
-		dev_err(drm->dev, "Cannot connect bridge: %d\n", ret);
+		if (ret != -EPROBE_DEFER)
+			dev_err(drm->dev, "Cannot connect bridge: %d\n", ret);
 		goto err_vblank;
 	}
 
-- 
2.27.0



