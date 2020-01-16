Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECFD013E713
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390708AbgAPRNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:13:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:57992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390705AbgAPRNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:13:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 706A72468C;
        Thu, 16 Jan 2020 17:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194798;
        bh=aOKjMlhukutgw1+Sk4z/1CeV3kR3/79/Q7lf4BLEXwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xMR7tLW6iucsEmLBaXDiaBt9tcqj0Fo0yCpJTK7aSM7ZGuw7DwT0iHfk33KW4q6hu
         rVYJTR6w3JjTt4zzo2Ma6kYAoQpp5H8T0g5AZb4JQtQUHJAE4pTEoCEgqk1uAU4kHZ
         VDF9mbbkpYqTOYk7/7YM5Cir9HCh/oyiP5lgkclo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 610/671] drm: panel-lvds: Potential Oops in probe error handling
Date:   Thu, 16 Jan 2020 12:04:08 -0500
Message-Id: <20200116170509.12787-347-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit fb2ee9bf084bcaeff1e5be100decc0eacb4af2d5 ]

The "lvds->backlight" pointer could be NULL in situations where
of_parse_phandle() returns NULL.  This code is cleaner if we use the
managed devm_of_find_backlight() so the clean up is automatic.

Fixes: 7c9dff5bd643 ("drm: panels: Add LVDS panel driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190911104928.GA15930@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-lvds.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-lvds.c b/drivers/gpu/drm/panel/panel-lvds.c
index 8a1687887ae9..bd704a36c5d0 100644
--- a/drivers/gpu/drm/panel/panel-lvds.c
+++ b/drivers/gpu/drm/panel/panel-lvds.c
@@ -199,7 +199,6 @@ static int panel_lvds_parse_dt(struct panel_lvds *lvds)
 static int panel_lvds_probe(struct platform_device *pdev)
 {
 	struct panel_lvds *lvds;
-	struct device_node *np;
 	int ret;
 
 	lvds = devm_kzalloc(&pdev->dev, sizeof(*lvds), GFP_KERNEL);
@@ -245,14 +244,9 @@ static int panel_lvds_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	np = of_parse_phandle(lvds->dev->of_node, "backlight", 0);
-	if (np) {
-		lvds->backlight = of_find_backlight_by_node(np);
-		of_node_put(np);
-
-		if (!lvds->backlight)
-			return -EPROBE_DEFER;
-	}
+	lvds->backlight = devm_of_find_backlight(lvds->dev);
+	if (IS_ERR(lvds->backlight))
+		return PTR_ERR(lvds->backlight);
 
 	/*
 	 * TODO: Handle all power supplies specified in the DT node in a generic
@@ -268,14 +262,10 @@ static int panel_lvds_probe(struct platform_device *pdev)
 
 	ret = drm_panel_add(&lvds->panel);
 	if (ret < 0)
-		goto error;
+		return ret;
 
 	dev_set_drvdata(lvds->dev, lvds);
 	return 0;
-
-error:
-	put_device(&lvds->backlight->dev);
-	return ret;
 }
 
 static int panel_lvds_remove(struct platform_device *pdev)
@@ -286,9 +276,6 @@ static int panel_lvds_remove(struct platform_device *pdev)
 
 	panel_lvds_disable(&lvds->panel);
 
-	if (lvds->backlight)
-		put_device(&lvds->backlight->dev);
-
 	return 0;
 }
 
-- 
2.20.1

