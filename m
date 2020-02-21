Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46491167888
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgBUHoW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:44:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:39016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbgBUHoV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:44:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5118320801;
        Fri, 21 Feb 2020 07:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271060;
        bh=m2QY89YMDTBv5LbPtFDrXsFu6fj+7Qh5AXzAdmpTi+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d4lkq79SuWR8JOpsoiqsPQw+R+qd6H8TJoUSoP/y9ttC3LLzc38QT5cO8KRnUZ6wy
         uLp00gXiEwn05Oh65MGKGdBCpjYbeJ1kwfy4JVts+iHiUAy1Pygwse88OdFWXYmxu/
         mT+ohkBVWPoXIBYBEULxGEocIF1xrGABF9S6s4LY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 024/399] drm: rcar-du: Recognize "renesas,vsps" in addition to "vsps"
Date:   Fri, 21 Feb 2020 08:35:49 +0100
Message-Id: <20200221072404.720617938@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 7b627ce80fbd05885b27f711a5f9820f2b40749a ]

The Renesas-specific "vsps" property lacks a vendor prefix.
Add a "renesas," prefix to comply with DT best practises.
Retain backward compatibility with old DTBs by falling back to "vsps"
when needed.

Fixes: 6d62ef3ac30be756 ("drm: rcar-du: Expose the VSP1 compositor through KMS planes")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/rcar_du_kms.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_kms.c b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
index 0d59f390de19a..662d8075f4116 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_kms.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
@@ -542,6 +542,7 @@ static int rcar_du_properties_init(struct rcar_du_device *rcdu)
 static int rcar_du_vsps_init(struct rcar_du_device *rcdu)
 {
 	const struct device_node *np = rcdu->dev->of_node;
+	const char *vsps_prop_name = "renesas,vsps";
 	struct of_phandle_args args;
 	struct {
 		struct device_node *np;
@@ -557,15 +558,21 @@ static int rcar_du_vsps_init(struct rcar_du_device *rcdu)
 	 * entry contains a pointer to the VSP DT node and a bitmask of the
 	 * connected DU CRTCs.
 	 */
-	cells = of_property_count_u32_elems(np, "vsps") / rcdu->num_crtcs - 1;
+	ret = of_property_count_u32_elems(np, vsps_prop_name);
+	if (ret < 0) {
+		/* Backward compatibility with old DTBs. */
+		vsps_prop_name = "vsps";
+		ret = of_property_count_u32_elems(np, vsps_prop_name);
+	}
+	cells = ret / rcdu->num_crtcs - 1;
 	if (cells > 1)
 		return -EINVAL;
 
 	for (i = 0; i < rcdu->num_crtcs; ++i) {
 		unsigned int j;
 
-		ret = of_parse_phandle_with_fixed_args(np, "vsps", cells, i,
-						       &args);
+		ret = of_parse_phandle_with_fixed_args(np, vsps_prop_name,
+						       cells, i, &args);
 		if (ret < 0)
 			goto error;
 
@@ -587,8 +594,8 @@ static int rcar_du_vsps_init(struct rcar_du_device *rcdu)
 
 		/*
 		 * Store the VSP pointer and pipe index in the CRTC. If the
-		 * second cell of the 'vsps' specifier isn't present, default
-		 * to 0 to remain compatible with older DT bindings.
+		 * second cell of the 'renesas,vsps' specifier isn't present,
+		 * default to 0 to remain compatible with older DT bindings.
 		 */
 		rcdu->crtcs[i].vsp = &rcdu->vsps[j];
 		rcdu->crtcs[i].vsp_pipe = cells >= 1 ? args.args[0] : 0;
-- 
2.20.1



