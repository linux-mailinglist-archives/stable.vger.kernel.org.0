Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD2A148374
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404551AbgAXLgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:36:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:56508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404918AbgAXLgT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:36:19 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 980EC2075D;
        Fri, 24 Jan 2020 11:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865778;
        bh=F15riyX+Q22QSaT4wO+h8MfdHoCJJgCmX9tkNCmbnVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rVnDG92wvX2d6/g8aa64bOBpOYbHGuwVFPqBuKa90TBqNZ5c8df27kQhMLijfbtUK
         tfWcx9f6Pd0cbriIuYYw5XaTg5/UtKTbi1EZ7FSnAOwr0bXZfnWIT7mvHlfILDP38e
         n1dwEWiPZUQepKD+xzesv3AesNsPP1hDjdG+kS5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 618/639] drm: panel-lvds: Potential Oops in probe error handling
Date:   Fri, 24 Jan 2020 10:33:08 +0100
Message-Id: <20200124093207.013052486@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8a1687887ae91..bd704a36c5d0e 100644
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



