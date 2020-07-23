Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C45E22AD54
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 13:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgGWLOr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 07:14:47 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:46989 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726867AbgGWLOr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 07:14:47 -0400
X-IronPort-AV: E=Sophos;i="5.75,386,1589209200"; 
   d="scan'208";a="52889124"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 23 Jul 2020 20:14:46 +0900
Received: from be1yocto.ree.adwin.renesas.com (unknown [172.29.43.62])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 0798040062D9;
        Thu, 23 Jul 2020 20:14:42 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        dri-devel@lists.freedesktop.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] drm: of: Fix double-free bug
Date:   Thu, 23 Jul 2020 12:10:54 +0100
Message-Id: <1595502654-40595-1-git-send-email-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix double-free bug in the error path.

Fixes: 6529007522de ("drm: of: Add drm_of_lvds_get_dual_link_pixel_order")
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Cc: stable@vger.kernel.org
---
This patch is tested against drm-fixes and drm-next.
---
 drivers/gpu/drm/drm_of.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_of.c b/drivers/gpu/drm/drm_of.c
index fdb05fb..ca04c34 100644
--- a/drivers/gpu/drm/drm_of.c
+++ b/drivers/gpu/drm/drm_of.c
@@ -331,10 +331,8 @@ static int drm_of_lvds_get_remote_pixels_type(
 		 * configurations by passing the endpoints explicitly to
 		 * drm_of_lvds_get_dual_link_pixel_order().
 		 */
-		if (!current_pt || pixels_type != current_pt) {
-			of_node_put(remote_port);
+		if (!current_pt || pixels_type != current_pt)
 			return -EINVAL;
-		}
 	}
 
 	return pixels_type;
-- 
2.7.4

