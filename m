Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529A0498D23
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348198AbiAXT2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:28:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49014 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351180AbiAXT0I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:26:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72EDFB81232;
        Mon, 24 Jan 2022 19:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F1BC340E5;
        Mon, 24 Jan 2022 19:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052365;
        bh=MAqNBqkJY10xt9ZfgsqlIb9d8Hthqug4RgrqoOKK6xU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eB3TJV5YOEZ1WmC3e1RfIUszW70UqzgaMm+/3Ak8ksMy8O5EPZitmyic+isvWJ9Ic
         OJ4XR2Q4V5ix4aKLQ6Dt2jzNWvFmi39zOSjWo6ZfIB1sGPxyqBJA5NSES+PnyDAv28
         3hYbzvEWeHIkSrN/ZK5FytwRnk1srqSrwcpRRAMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/320] drm/panel: innolux-p079zca: Delete panel on attach() failure
Date:   Mon, 24 Jan 2022 19:40:19 +0100
Message-Id: <20220124183954.942378834@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit 32a267e9c057e1636e7afdd20599aa5741a73079 ]

If we fail to attach (e.g., because 1 of 2 dual-DSI controllers aren't
ready), we leave a dangling drm_panel reference to freed memory. Clean
that up on failure.

This problem exists since the driver's introduction, but is especially
relevant after refactored for dual-DSI variants.

Fixes: 14c8f2e9f8ea ("drm/panel: add Innolux P079ZCA panel driver")
Fixes: 7ad4e4636c54 ("drm/panel: p079zca: Refactor panel driver to support multiple panels")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210923173336.2.I9023cf8811a3abf4964ed84eb681721d8bb489d6@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-innolux-p079zca.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-innolux-p079zca.c b/drivers/gpu/drm/panel/panel-innolux-p079zca.c
index d92d1c98878c1..df90b66079816 100644
--- a/drivers/gpu/drm/panel/panel-innolux-p079zca.c
+++ b/drivers/gpu/drm/panel/panel-innolux-p079zca.c
@@ -509,6 +509,7 @@ static void innolux_panel_del(struct innolux_panel *innolux)
 static int innolux_panel_probe(struct mipi_dsi_device *dsi)
 {
 	const struct panel_desc *desc;
+	struct innolux_panel *innolux;
 	int err;
 
 	desc = of_device_get_match_data(&dsi->dev);
@@ -520,7 +521,14 @@ static int innolux_panel_probe(struct mipi_dsi_device *dsi)
 	if (err < 0)
 		return err;
 
-	return mipi_dsi_attach(dsi);
+	err = mipi_dsi_attach(dsi);
+	if (err < 0) {
+		innolux = mipi_dsi_get_drvdata(dsi);
+		innolux_panel_del(innolux);
+		return err;
+	}
+
+	return 0;
 }
 
 static int innolux_panel_remove(struct mipi_dsi_device *dsi)
-- 
2.34.1



