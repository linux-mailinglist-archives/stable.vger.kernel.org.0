Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0A0E1A56F7
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730597AbgDKXNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:13:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728797AbgDKXNw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:13:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BAD720787;
        Sat, 11 Apr 2020 23:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646832;
        bh=TzM/SWg7N0SF+1EpVQxkbMiR46P25mK/oHaGpAH0d2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZtKsjE1evxOUmTHTMz62TOp3iGeEPSQk+SHzGjh9s5kqkIUbeNbSsYh7obQGMdwx
         Tq9NZyXRYAmhqr5QcwdWfw1nJ6eDGbxR/BZGXCNo711n1gW26CQR8XzMSdlI6SiFhp
         88/v/oiPUZSMWMo1iMAL+k6B0JMX1Fv0TLe5aHRE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Yang <wen.yang99@zte.com.cn>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mukesh Ojha <mojha@codeaurora.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        dri-devel@lists.freedesktop.org,
        Markus Elfring <Markus.Elfring@web.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 21/37] drm/omap: fix possible object reference leak
Date:   Sat, 11 Apr 2020 19:13:10 -0400
Message-Id: <20200411231327.26550-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231327.26550-1-sashal@kernel.org>
References: <20200411231327.26550-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wen.yang99@zte.com.cn>

[ Upstream commit 47340e46f34a3b1d80e40b43ae3d7a8da34a3541 ]

The call to of_find_matching_node returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warnings:
drivers/gpu/drm/omapdrm/dss/omapdss-boot-init.c:212:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 209, but without a corresponding object release within this function.
drivers/gpu/drm/omapdrm/dss/omapdss-boot-init.c:237:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 209, but without a corresponding object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Cc: Markus Elfring <Markus.Elfring@web.de>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Link: https://patchwork.freedesktop.org/patch/msgid/1554692313-28882-2-git-send-email-wen.yang99@zte.com.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/omapdrm/dss/omapdss-boot-init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/omapdss-boot-init.c b/drivers/gpu/drm/omapdrm/dss/omapdss-boot-init.c
index bf626acae2712..cd8e9b799b9a5 100644
--- a/drivers/gpu/drm/omapdrm/dss/omapdss-boot-init.c
+++ b/drivers/gpu/drm/omapdrm/dss/omapdss-boot-init.c
@@ -193,7 +193,7 @@ static int __init omapdss_boot_init(void)
 	dss = of_find_matching_node(NULL, omapdss_of_match);
 
 	if (dss == NULL || !of_device_is_available(dss))
-		return 0;
+		goto put_node;
 
 	omapdss_walk_device(dss, true);
 
@@ -218,6 +218,8 @@ static int __init omapdss_boot_init(void)
 		kfree(n);
 	}
 
+put_node:
+	of_node_put(dss);
 	return 0;
 }
 
-- 
2.20.1

