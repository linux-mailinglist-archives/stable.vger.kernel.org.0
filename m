Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC7915F4A8
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404870AbgBNSXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:23:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:52348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgBNPt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:49:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5095B2086A;
        Fri, 14 Feb 2020 15:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695366;
        bh=m2QY89YMDTBv5LbPtFDrXsFu6fj+7Qh5AXzAdmpTi+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rgCznXuN1StiYGEH71duvRbOls02tbU4tiOvcaLG6MfBKcF09BXtnJx+D8h+IpNJp
         MVF+8PTvHRXdmwbM33PXK4nklE17cX76V1ALssT5K0XzKL0IGElXpiLgd821slkhH/
         Twn6YXg5HtG/V6s9KouuPGcDK5fytlO66m58JSWk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 024/542] drm: rcar-du: Recognize "renesas,vsps" in addition to "vsps"
Date:   Fri, 14 Feb 2020 10:40:16 -0500
Message-Id: <20200214154854.6746-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

