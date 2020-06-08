Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE4C1F312B
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 03:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgFIBGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 21:06:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727797AbgFHXHH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:07:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71BB520E65;
        Mon,  8 Jun 2020 23:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657626;
        bh=vqpwzmqgPum7xJcl5MJ2NPLpxEZEaPhP2tB5CEtYRks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mbx6w96Z4cmh5Gfw70rt7gu75XExqtWtB0QTHvxWBs1rvA6ksDQxik/AP2k6sSNu3
         do57LiRDahAAf3fddaY94Bak3241hftJmkNomEJVhjzn6rHgUTLJ9CBRblTfGBDJrc
         4I13GiUevcIR/tmSytux5JOpjYDJz0D6FIFJRXDw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomohito Esaki <etom@igel.co.jp>,
        Yoshihito Ogawa <yoshihito.ogawa.kc@renesas.com>,
        Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Daniel Stone <daniels@collabora.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 046/274] drm: rcar-du: Set primary plane zpos immutably at initializing
Date:   Mon,  8 Jun 2020 19:02:19 -0400
Message-Id: <20200608230607.3361041-46-sashal@kernel.org>
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

From: Tomohito Esaki <etom@igel.co.jp>

[ Upstream commit 7982471d01aac33994276bf567c8f1f3a137648a ]

According to drm_plane_create_zpos_property() function documentation,
all planes zpos range should be set if zpos property is supported.
However, the rcar-du driver didn't set primary plane zpos range. Since
the primary plane's zpos is fixed, set it immutably.

Reported-by: Yoshihito Ogawa <yoshihito.ogawa.kc@renesas.com>
Reported-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Tomohito Esaki <etom@igel.co.jp>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Daniel Stone <daniels@collabora.com>
[Turn continue into if ... else ...]
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/rcar_du_plane.c | 16 +++++++++-------
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c   | 14 ++++++++------
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_plane.c b/drivers/gpu/drm/rcar-du/rcar_du_plane.c
index c6430027169f..a0021fc25b27 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_plane.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_plane.c
@@ -785,13 +785,15 @@ int rcar_du_planes_init(struct rcar_du_group *rgrp)
 
 		drm_plane_create_alpha_property(&plane->plane);
 
-		if (type == DRM_PLANE_TYPE_PRIMARY)
-			continue;
-
-		drm_object_attach_property(&plane->plane.base,
-					   rcdu->props.colorkey,
-					   RCAR_DU_COLORKEY_NONE);
-		drm_plane_create_zpos_property(&plane->plane, 1, 1, 7);
+		if (type == DRM_PLANE_TYPE_PRIMARY) {
+			drm_plane_create_zpos_immutable_property(&plane->plane,
+								 0);
+		} else {
+			drm_object_attach_property(&plane->plane.base,
+						   rcdu->props.colorkey,
+						   RCAR_DU_COLORKEY_NONE);
+			drm_plane_create_zpos_property(&plane->plane, 1, 1, 7);
+		}
 	}
 
 	return 0;
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index 5e4faf258c31..f1a81c9b184d 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -392,12 +392,14 @@ int rcar_du_vsp_init(struct rcar_du_vsp *vsp, struct device_node *np,
 		drm_plane_helper_add(&plane->plane,
 				     &rcar_du_vsp_plane_helper_funcs);
 
-		if (type == DRM_PLANE_TYPE_PRIMARY)
-			continue;
-
-		drm_plane_create_alpha_property(&plane->plane);
-		drm_plane_create_zpos_property(&plane->plane, 1, 1,
-					       vsp->num_planes - 1);
+		if (type == DRM_PLANE_TYPE_PRIMARY) {
+			drm_plane_create_zpos_immutable_property(&plane->plane,
+								 0);
+		} else {
+			drm_plane_create_alpha_property(&plane->plane);
+			drm_plane_create_zpos_property(&plane->plane, 1, 1,
+						       vsp->num_planes - 1);
+		}
 	}
 
 	return 0;
-- 
2.25.1

