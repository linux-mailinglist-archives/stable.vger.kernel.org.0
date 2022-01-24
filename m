Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0389F498D22
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348190AbiAXT2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:28:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48994 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351152AbiAXT0E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:26:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A2A4B8121A;
        Mon, 24 Jan 2022 19:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80ED6C340E5;
        Mon, 24 Jan 2022 19:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052362;
        bh=ZYoNT/gKCF32h7AuxcVFTRr05fgo4y6nVkWi1qiO7ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cxAXBC9mUDIp13dJYDGLDL6vf1iDp4cphOJ8919jiKbm3QMFJJIvHGbzCyN6xfaQ5
         2srBJiKmt0fcfWFw3nU8+8jZ3pyorI7w3uoTWN7MhHC35zT6/PeldI1toGFSoKtOzs
         AiI3Lc3clHto8lYD2KQsdEuT2lfaPFTyqjRun1Ss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 034/320] drm/panel: kingdisplay-kd097d04: Delete panel on attach() failure
Date:   Mon, 24 Jan 2022 19:40:18 +0100
Message-Id: <20220124183954.911443634@linuxfoundation.org>
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

[ Upstream commit 5f31dbeae8a88f31c3eb4eb526ab4807c40da241 ]

If we fail to attach (e.g., because 1 of 2 dual-DSI controllers aren't
ready), we leave a dangling drm_panel reference to freed memory. Clean
that up on failure.

Fixes: 2a994cbed6b2 ("drm/panel: Add Kingdisplay KD097D04 panel driver")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210923173336.1.Icb4d9dbc1817f4e826361a4f1cea7461541668f0@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-kingdisplay-kd097d04.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-kingdisplay-kd097d04.c b/drivers/gpu/drm/panel/panel-kingdisplay-kd097d04.c
index 3ac04eb8d0fe5..1e7fecab72a9f 100644
--- a/drivers/gpu/drm/panel/panel-kingdisplay-kd097d04.c
+++ b/drivers/gpu/drm/panel/panel-kingdisplay-kd097d04.c
@@ -424,7 +424,13 @@ static int kingdisplay_panel_probe(struct mipi_dsi_device *dsi)
 	if (err < 0)
 		return err;
 
-	return mipi_dsi_attach(dsi);
+	err = mipi_dsi_attach(dsi);
+	if (err < 0) {
+		kingdisplay_panel_del(kingdisplay);
+		return err;
+	}
+
+	return 0;
 }
 
 static int kingdisplay_panel_remove(struct mipi_dsi_device *dsi)
-- 
2.34.1



