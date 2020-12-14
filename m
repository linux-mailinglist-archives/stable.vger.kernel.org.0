Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD052D9FB0
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502092AbgLNS4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:56:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:47838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502255AbgLNRhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:37 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 022/105] drm/rockchip: Avoid uninitialized use of endpoint id in LVDS
Date:   Mon, 14 Dec 2020 18:27:56 +0100
Message-Id: <20201214172556.341254481@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

[ Upstream commit aec9fe892812ed10d0bffcf309d2a8fc380d8ce6 ]

In the Rockchip DRM LVDS component driver, the endpoint id provided to
drm_of_find_panel_or_bridge is grabbed from the endpoint's reg property.

However, the property may be missing in the case of a single endpoint.
Initialize the endpoint_id variable to 0 to avoid using an
uninitialized variable in that case.

Fixes: 34cc0aa25456 ("drm/rockchip: Add support for Rockchip Soc LVDS")
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20201110200430.1713467-1-paul.kocialkowski@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_lvds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_lvds.c b/drivers/gpu/drm/rockchip/rockchip_lvds.c
index 63f967902c2d8..a29912f3b997e 100644
--- a/drivers/gpu/drm/rockchip/rockchip_lvds.c
+++ b/drivers/gpu/drm/rockchip/rockchip_lvds.c
@@ -544,7 +544,7 @@ static int rockchip_lvds_bind(struct device *dev, struct device *master,
 	struct device_node  *port, *endpoint;
 	int ret = 0, child_count = 0;
 	const char *name;
-	u32 endpoint_id;
+	u32 endpoint_id = 0;
 
 	lvds->drm_dev = drm_dev;
 	port = of_graph_get_port_by_id(dev->of_node, 1);
-- 
2.27.0



