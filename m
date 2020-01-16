Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0015B13F3CF
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388115AbgAPSp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:45:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390046AbgAPRKj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:10:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EE1A2468A;
        Thu, 16 Jan 2020 17:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194638;
        bh=WmkmH9k1I+h9YStmDsNCig/jfY5LcZcLHbuDnJJLezs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oene3RMOt3ES08W6Ci8eYQYRVHE8kfHe1KzBqYbKq2S3H2Jc0lY0+/SIzJm2QN2rZ
         /n/2rNcgSDLGVHx/7/+LYxnqTI9J/yLIlJsDF+Ha2YCnXdRraWlsABCRcYcA4Q4pJA
         e5ed7H+wi1qptOO6oJ5hZsY7sh8ZkQFv/tpZpnXE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 496/671] drm: rcar-du: lvds: Fix bridge_to_rcar_lvds
Date:   Thu, 16 Jan 2020 12:02:14 -0500
Message-Id: <20200116170509.12787-233-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 4c39de3f4f0f..b6dc91cdff68 100644
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

