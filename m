Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF4BF1A5441
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbgDKXEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:04:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727474AbgDKXEs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:04:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DB6920CC7;
        Sat, 11 Apr 2020 23:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646288;
        bh=AkaNifXui+usapZRPzwxcFjxfd8TaQuZOKjCKUXSmrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pHy+wqkjWmAVs+Ncu+/uK0ev4atFs9Qd45Gam9y0YGYRcQPtQ2PopSyagY+m6+w6s
         EVwQm0H3OaPbrnVGIBEEDGT0fErdR0TtbFd2r38hud8AVlYLIsg76GYQMjZgk8HODn
         2PIJ7x2K9rFKVBZNGg3RBiFX/hCoVfnzZwuaiyg4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.6 049/149] drm/panel: simple: fix osd070t1718_19ts sync drive edge
Date:   Sat, 11 Apr 2020 19:02:06 -0400
Message-Id: <20200411230347.22371-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

[ Upstream commit fb0629eeeedb6622c16da1aa76a4520daf9a46e2 ]

The panel datasheet says that the panel samples at falling edge, but
does not say anything about h/v sync signals. Testing shows that if the
sync signals are driven on falling edge, the picture on the panel will
be slightly shifted right.

Setting sync drive edge to the same as data drive edge fixes this issue.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20191114093950.4101-4-tomi.valkeinen@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index e14c14ac62b53..417bbe9984606 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2464,7 +2464,8 @@ static const struct panel_desc osddisplays_osd070t1718_19ts = {
 		.height = 91,
 	},
 	.bus_format = MEDIA_BUS_FMT_RGB888_1X24,
-	.bus_flags = DRM_BUS_FLAG_DE_HIGH | DRM_BUS_FLAG_PIXDATA_DRIVE_POSEDGE,
+	.bus_flags = DRM_BUS_FLAG_DE_HIGH | DRM_BUS_FLAG_PIXDATA_DRIVE_POSEDGE |
+		DRM_BUS_FLAG_SYNC_DRIVE_POSEDGE,
 	.connector_type = DRM_MODE_CONNECTOR_DPI,
 };
 
-- 
2.20.1

