Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC622F267
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbfE3EVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:21:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730165AbfE3DPN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:13 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09FC7245AF;
        Thu, 30 May 2019 03:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186113;
        bh=euFCMq21m3y1BXTjDRjTUdYs8uNkzhAkYGQVfs6Tq60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KX788rLCxJQuk96SaGmxw9ULODbC8idAj47E+wUiQV007bfb04X4pW93na8voetzB
         zbyTcxmBaBpSWGztMGN4NMP92ot1no6JhoqBC26cgs0LKkd8BD6DIiF1dzpM5gN+Zc
         UV7Bkkl618csO1esYrFE3s/j5MGT2Lhq4IhlNJ4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 263/346] drm: rcar-du: lvds: Set LVEN and LVRES bits together on D3
Date:   Wed, 29 May 2019 20:05:36 -0700
Message-Id: <20190530030554.303614499@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 00d082cc4ea6e42ec4fed832a1020231bb1ca150 ]

On the D3 SoC the LVDS PHY must be enabled in the same register write
that enables the LVDS output. Skip writing the LVEN bit independently
on that platform, it will be set by the write that sets LVRES.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/rcar_lvds.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_lvds.c b/drivers/gpu/drm/rcar-du/rcar_lvds.c
index 534a128a869d5..ccdfc64e122a8 100644
--- a/drivers/gpu/drm/rcar-du/rcar_lvds.c
+++ b/drivers/gpu/drm/rcar-du/rcar_lvds.c
@@ -427,9 +427,13 @@ static void rcar_lvds_enable(struct drm_bridge *bridge)
 	}
 
 	if (lvds->info->quirks & RCAR_LVDS_QUIRK_GEN3_LVEN) {
-		/* Turn on the LVDS PHY. */
+		/*
+		 * Turn on the LVDS PHY. On D3, the LVEN and LVRES bit must be
+		 * set at the same time, so don't write the register yet.
+		 */
 		lvdcr0 |= LVDCR0_LVEN;
-		rcar_lvds_write(lvds, LVDCR0, lvdcr0);
+		if (!(lvds->info->quirks & RCAR_LVDS_QUIRK_PWD))
+			rcar_lvds_write(lvds, LVDCR0, lvdcr0);
 	}
 
 	if (!(lvds->info->quirks & RCAR_LVDS_QUIRK_EXT_PLL)) {
-- 
2.20.1



