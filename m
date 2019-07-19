Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 695A76DEFC
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730581AbfGSEDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:03:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730558AbfGSEDi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:03:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4021D218BC;
        Fri, 19 Jul 2019 04:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509017;
        bh=7OBpNW6fw6h4L5GKaYIP4jZJ0LWGJFEfN2seOjgzGSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l6QkSgIv/6Mm+9ckalQ6eWkgFEdnffkNcSPPnW98bShLIHfCQN8v4087fTSFzMAYf
         nkQXPnKtJ0G3wqJP0cVgGP9EGzp/3mO7qVh4HlSwMK2boq3cczvKM2POkPuZ/tBhrk
         BTiJUpLnQpmYatWqfy9hB22j1dUg5dHzXz0aqwQQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.1 024/141] drm/bridge: tc358767: read display_props in get_modes()
Date:   Fri, 19 Jul 2019 00:00:49 -0400
Message-Id: <20190719040246.15945-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

[ Upstream commit 3231573065ad4f4ecc5c9147b24f29f846dc0c2f ]

We need to know the link bandwidth to filter out modes we cannot
support, so we need to have read the display props before doing the
filtering.

To ensure we have up to date display props, call tc_get_display_props()
in the beginning of tc_connector_get_modes().

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190528082747.3631-22-tomi.valkeinen@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358767.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/bridge/tc358767.c b/drivers/gpu/drm/bridge/tc358767.c
index 888980d4bc74..7e1ff2723636 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -1150,6 +1150,13 @@ static int tc_connector_get_modes(struct drm_connector *connector)
 	struct tc_data *tc = connector_to_tc(connector);
 	struct edid *edid;
 	unsigned int count;
+	int ret;
+
+	ret = tc_get_display_props(tc);
+	if (ret < 0) {
+		dev_err(tc->dev, "failed to read display props: %d\n", ret);
+		return 0;
+	}
 
 	if (tc->panel && tc->panel->funcs && tc->panel->funcs->get_modes) {
 		count = tc->panel->funcs->get_modes(tc->panel);
-- 
2.20.1

