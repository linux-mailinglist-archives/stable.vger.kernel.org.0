Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 746586DE30
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731093AbfGSEHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:07:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727739AbfGSEHf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:07:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA065218A3;
        Fri, 19 Jul 2019 04:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509254;
        bh=utA8zrTd/CV5hDkCbQRS8zsKC25nhjfU6ssi7vbeuts=;
        h=From:To:Cc:Subject:Date:From;
        b=L+1T5xnsrJundiBxAL/AaUCUa2pDfRXO4zNKh4t2I9MQWuhzZYdBMiKZ1pmm1A87R
         IFY8ux7XjfDSm3/rfhAtuXqfZXTYmyNEhWb1rArva5674QArVWCIg+wyNGWFMjPHq6
         fjYqXvifnni8n//Vk1UT5c0o3GUWHLAP3QfIICEQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 001/101] drm/panel: simple: Fix panel_simple_dsi_probe
Date:   Fri, 19 Jul 2019 00:05:52 -0400
Message-Id: <20190719040732.17285-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit 7ad9db66fafb0f0ad53fd2a66217105da5ddeffe ]

In case mipi_dsi_attach() fails remove the registered panel to avoid added
panel without corresponding device.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190226081153.31334-1-peter.ujfalusi@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 97964f7f2ace..b1d41c4921dd 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2803,7 +2803,14 @@ static int panel_simple_dsi_probe(struct mipi_dsi_device *dsi)
 	dsi->format = desc->format;
 	dsi->lanes = desc->lanes;
 
-	return mipi_dsi_attach(dsi);
+	err = mipi_dsi_attach(dsi);
+	if (err) {
+		struct panel_simple *panel = dev_get_drvdata(&dsi->dev);
+
+		drm_panel_remove(&panel->base);
+	}
+
+	return err;
 }
 
 static int panel_simple_dsi_remove(struct mipi_dsi_device *dsi)
-- 
2.20.1

