Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0814996B1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445973AbiAXVF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:05:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53780 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351712AbiAXU6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:58:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE176B80FA3;
        Mon, 24 Jan 2022 20:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B7EC340E5;
        Mon, 24 Jan 2022 20:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057917;
        bh=H/tPH33St1gFh5Gacd8JGf5OOGlFWqNnI4EL4xPm4mc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y6IpuxcqUKo+tbME8rB3FYVLQiNP4zQg4smodf5haiY0iF73X4MjgOK6sDn0YgiIX
         RJ06sGW91aN/q5jPiu138DMLVCZekNtlDqWXqHYoOJKW/iLtSP6Ey9VfQ/pIHu1Wl6
         X6HRSE68t1s2hv9ugt4NWWlmZ586GSwVkLU04M6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0088/1039] drm/panel: kingdisplay-kd097d04: Delete panel on attach() failure
Date:   Mon, 24 Jan 2022 19:31:17 +0100
Message-Id: <20220124184128.118355347@linuxfoundation.org>
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
index 86e4213e8bb13..daccb1fd5fdad 100644
--- a/drivers/gpu/drm/panel/panel-kingdisplay-kd097d04.c
+++ b/drivers/gpu/drm/panel/panel-kingdisplay-kd097d04.c
@@ -406,7 +406,13 @@ static int kingdisplay_panel_probe(struct mipi_dsi_device *dsi)
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



