Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEA9147692
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 02:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730291AbgAXBUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 20:20:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:60196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730366AbgAXBRS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 20:17:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75AAD2071E;
        Fri, 24 Jan 2020 01:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579828637;
        bh=14siYZSO9Gnx/JKTpNTZO/Ck4Uyg4bLyMf/9qF8vPhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vpjd/i3c7gjGEnd5+FRHwZjfxBE2QmsPzN4UIC7WwEgyX+iEeLLbHgH2bbd1yZHKx
         K+4z1ePujPmNJjL08TBheC/VPvXCMtYHPehf9F+C1Bw203vkYwXxZWxjYdSwMfVopN
         RT5mKIBlWnbrjE2Zm9pAvEjj2Atji3hQEFFX1ngs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 07/33] drm: rcar_lvds: Fix color mismatches on R-Car H2 ES2.0 and later
Date:   Thu, 23 Jan 2020 20:16:42 -0500
Message-Id: <20200124011708.18232-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124011708.18232-1-sashal@kernel.org>
References: <20200124011708.18232-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 3986457110a054466bf02f9c4a85aa2bba96177b ]

Commit 5cca30ebe089be23 ("drm/rcar-du: Add LVDS_LANES quirk") states
that LVDS lanes 1 and 3 are inverted on R-Car H2 ES1 only, and that the
problem has been fixed in newer revisions.

However, the code didn't take into account the actual hardware revision,
thus applying the quirk also on newer hardware revisions, causing green
color reversals.

Fix this by applying the quirk when running on R-Car H2 ES1.x only.

Reported-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Fixes: 5cca30ebe089be23 ("drm/rcar-du: Add LVDS_LANES quirk")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Ulrich Hecht <uli+renesas@fpond.eu>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/rcar_lvds.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_lvds.c b/drivers/gpu/drm/rcar-du/rcar_lvds.c
index 3fc7e6899cab5..50c11a7f0467f 100644
--- a/drivers/gpu/drm/rcar-du/rcar_lvds.c
+++ b/drivers/gpu/drm/rcar-du/rcar_lvds.c
@@ -16,6 +16,7 @@
 #include <linux/of_graph.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/sys_soc.h>
 
 #include <drm/drm_atomic.h>
 #include <drm/drm_atomic_helper.h>
@@ -842,8 +843,23 @@ static int rcar_lvds_get_clocks(struct rcar_lvds *lvds)
 	return 0;
 }
 
+static const struct rcar_lvds_device_info rcar_lvds_r8a7790es1_info = {
+	.gen = 2,
+	.quirks = RCAR_LVDS_QUIRK_LANES,
+	.pll_setup = rcar_lvds_pll_setup_gen2,
+};
+
+static const struct soc_device_attribute lvds_quirk_matches[] = {
+	{
+		.soc_id = "r8a7790", .revision = "ES1.*",
+		.data = &rcar_lvds_r8a7790es1_info,
+	},
+	{ /* sentinel */ }
+};
+
 static int rcar_lvds_probe(struct platform_device *pdev)
 {
+	const struct soc_device_attribute *attr;
 	struct rcar_lvds *lvds;
 	struct resource *mem;
 	int ret;
@@ -857,6 +873,10 @@ static int rcar_lvds_probe(struct platform_device *pdev)
 	lvds->dev = &pdev->dev;
 	lvds->info = of_device_get_match_data(&pdev->dev);
 
+	attr = soc_device_match(lvds_quirk_matches);
+	if (attr)
+		lvds->info = attr->data;
+
 	ret = rcar_lvds_parse_dt(lvds);
 	if (ret < 0)
 		return ret;
@@ -893,12 +913,6 @@ static const struct rcar_lvds_device_info rcar_lvds_gen2_info = {
 	.pll_setup = rcar_lvds_pll_setup_gen2,
 };
 
-static const struct rcar_lvds_device_info rcar_lvds_r8a7790_info = {
-	.gen = 2,
-	.quirks = RCAR_LVDS_QUIRK_LANES,
-	.pll_setup = rcar_lvds_pll_setup_gen2,
-};
-
 static const struct rcar_lvds_device_info rcar_lvds_gen3_info = {
 	.gen = 3,
 	.quirks = RCAR_LVDS_QUIRK_PWD,
@@ -930,7 +944,7 @@ static const struct of_device_id rcar_lvds_of_table[] = {
 	{ .compatible = "renesas,r8a7744-lvds", .data = &rcar_lvds_gen2_info },
 	{ .compatible = "renesas,r8a774a1-lvds", .data = &rcar_lvds_gen3_info },
 	{ .compatible = "renesas,r8a774c0-lvds", .data = &rcar_lvds_r8a77990_info },
-	{ .compatible = "renesas,r8a7790-lvds", .data = &rcar_lvds_r8a7790_info },
+	{ .compatible = "renesas,r8a7790-lvds", .data = &rcar_lvds_gen2_info },
 	{ .compatible = "renesas,r8a7791-lvds", .data = &rcar_lvds_gen2_info },
 	{ .compatible = "renesas,r8a7793-lvds", .data = &rcar_lvds_gen2_info },
 	{ .compatible = "renesas,r8a7795-lvds", .data = &rcar_lvds_gen3_info },
-- 
2.20.1

