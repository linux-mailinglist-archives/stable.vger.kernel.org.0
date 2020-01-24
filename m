Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21DD8148293
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391668AbgAXL3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:29:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391770AbgAXL3P (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:29:15 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0E4A20704;
        Fri, 24 Jan 2020 11:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865354;
        bh=LvvvrNfztF4oOA7lDebFemPPvgBxqR12VB3hnK3IRC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hpi7cfO6LcBBDOpayEmkBCTyExgqmkvshH0gGTw6m1+rUuXbXMWdzsAOvQWQ/JeyX
         dVffMGDykvN9BZDOxnvc0lkPNpcNQNe63a+fQE5gVeqlFZv5sOdzS+CnUiF47qsDTh
         W3LfXTJJRr1B/IeYGR2O6kaEwR3FTDnwucYXKpzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 510/639] drm: rcar-du: lvds: Fix bridge_to_rcar_lvds
Date:   Fri, 24 Jan 2020 10:31:20 +0100
Message-Id: <20200124093152.697520138@linuxfoundation.org>
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

From: Fabrizio Castro <fabrizio.castro@bp.renesas.com>

[ Upstream commit 0b936e6122738f4cf474d1f3ff636cba0edc8b94 ]

Using name "bridge" for macro bridge_to_rcar_lvds argument doesn't
work when the pointer name used by the caller is not "bridge".
Rename the argument to "b" to allow for any pointer name.

While at it, fix the connector_to_rcar_lvds macro similarly.

Fixes: c6a27fa41fab ("drm: rcar-du: Convert LVDS encoder code to bridge driver")
Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
[Fix connector_to_rcar_lvds]
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/rcar_lvds.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_lvds.c b/drivers/gpu/drm/rcar-du/rcar_lvds.c
index 4c39de3f4f0f3..b6dc91cdff68e 100644
--- a/drivers/gpu/drm/rcar-du/rcar_lvds.c
+++ b/drivers/gpu/drm/rcar-du/rcar_lvds.c
@@ -59,11 +59,11 @@ struct rcar_lvds {
 	enum rcar_lvds_mode mode;
 };
 
-#define bridge_to_rcar_lvds(bridge) \
-	container_of(bridge, struct rcar_lvds, bridge)
+#define bridge_to_rcar_lvds(b) \
+	container_of(b, struct rcar_lvds, bridge)
 
-#define connector_to_rcar_lvds(connector) \
-	container_of(connector, struct rcar_lvds, connector)
+#define connector_to_rcar_lvds(c) \
+	container_of(c, struct rcar_lvds, connector)
 
 static void rcar_lvds_write(struct rcar_lvds *lvds, u32 reg, u32 data)
 {
-- 
2.20.1



