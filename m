Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360C01F3162
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 03:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgFHXGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:06:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727010AbgFHXGd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:06:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 542F02076C;
        Mon,  8 Jun 2020 23:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657593;
        bh=URSM4OVSd3VdBQHRpH5PXvzyY3qrWEOKrHQAtea9Itk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXHZGou2DqBTPFsVuY9HKXlHWZI4PBVsyeu6721ZO61faGWNpMRl1Z0fx4cSidQF4
         TLvkYWZsqf+59prx3C6SLFxYbS0mkU0J0q8tY80j4Uo8KCn/sgUmSrq7fFDlipHLxh
         YkjifqmuTae5/xkopQhEJ3Nv3bvpUqSOEPH2YjGE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.7 020/274] drm/bridge: panel: Return always an error pointer in drm_panel_bridge_add()
Date:   Mon,  8 Jun 2020 19:01:53 -0400
Message-Id: <20200608230607.3361041-20-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enric Balletbo i Serra <enric.balletbo@collabora.com>

[ Upstream commit 30be3031087139061de4421bf52015931eaab569 ]

Since commit 89958b7cd955 ("drm/bridge: panel: Infer connector type from
panel by default"), drm_panel_bridge_add() and their variants can return
NULL and an error pointer. This is fine but none of the actual users of
the API are checking for the NULL value. Instead of change all the
users, seems reasonable to return an error pointer instead. So change
the returned value for those functions when the connector type is unknown.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200416210654.2468805-1-enric.balletbo@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/panel.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/panel.c b/drivers/gpu/drm/bridge/panel.c
index 8461ee8304ba..7a3df0f319f3 100644
--- a/drivers/gpu/drm/bridge/panel.c
+++ b/drivers/gpu/drm/bridge/panel.c
@@ -166,7 +166,7 @@ static const struct drm_bridge_funcs panel_bridge_bridge_funcs = {
  *
  * The connector type is set to @panel->connector_type, which must be set to a
  * known type. Calling this function with a panel whose connector type is
- * DRM_MODE_CONNECTOR_Unknown will return NULL.
+ * DRM_MODE_CONNECTOR_Unknown will return ERR_PTR(-EINVAL).
  *
  * See devm_drm_panel_bridge_add() for an automatically managed version of this
  * function.
@@ -174,7 +174,7 @@ static const struct drm_bridge_funcs panel_bridge_bridge_funcs = {
 struct drm_bridge *drm_panel_bridge_add(struct drm_panel *panel)
 {
 	if (WARN_ON(panel->connector_type == DRM_MODE_CONNECTOR_Unknown))
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	return drm_panel_bridge_add_typed(panel, panel->connector_type);
 }
@@ -265,7 +265,7 @@ struct drm_bridge *devm_drm_panel_bridge_add(struct device *dev,
 					     struct drm_panel *panel)
 {
 	if (WARN_ON(panel->connector_type == DRM_MODE_CONNECTOR_Unknown))
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	return devm_drm_panel_bridge_add_typed(dev, panel,
 					       panel->connector_type);
-- 
2.25.1

