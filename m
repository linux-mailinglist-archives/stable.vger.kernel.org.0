Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 532FD1D0DD
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 22:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfENUxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 16:53:06 -0400
Received: from mailoutvs44.siol.net ([185.57.226.235]:33484 "EHLO
        mail.siol.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726143AbfENUxG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 16:53:06 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.siol.net (Postfix) with ESMTP id 6A9F2521EE8;
        Tue, 14 May 2019 22:43:50 +0200 (CEST)
X-Virus-Scanned: amavisd-new at psrvmta09.zcs-production.pri
Received: from mail.siol.net ([127.0.0.1])
        by localhost (psrvmta09.zcs-production.pri [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id an7GL3Abu5SR; Tue, 14 May 2019 22:43:50 +0200 (CEST)
Received: from mail.siol.net (localhost [127.0.0.1])
        by mail.siol.net (Postfix) with ESMTPS id 1CCDB521E08;
        Tue, 14 May 2019 22:43:50 +0200 (CEST)
Received: from localhost.localdomain (cpe-86-58-52-202.static.triera.net [86.58.52.202])
        (Authenticated sender: 031275009)
        by mail.siol.net (Postfix) with ESMTPSA id 8202D521EE8;
        Tue, 14 May 2019 22:43:47 +0200 (CEST)
From:   Jernej Skrabec <jernej.skrabec@siol.net>
To:     maxime.ripard@bootlin.com, wens@csie.org
Cc:     airlied@linux.ie, daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, stable@vger.kernel.org
Subject: [PATCH 2/2] drm/sun4i: Fix sun8i HDMI PHY configuration for > 148.5 MHz
Date:   Tue, 14 May 2019 22:43:37 +0200
Message-Id: <20190514204337.11068-3-jernej.skrabec@siol.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190514204337.11068-1-jernej.skrabec@siol.net>
References: <20190514204337.11068-1-jernej.skrabec@siol.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Vendor provided documentation says that EMP bits should be set to 3 for
pixel clocks greater than 148.5 MHz.

Fix that.

Cc: stable@vger.kernel.org # 4.17+
Fixes: 4f86e81748fe ("drm/sun4i: Add support for H3 HDMI PHY variant")
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
---
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c b/drivers/gpu/drm/sun=
4i/sun8i_hdmi_phy.c
index afc6d4a9c20b..43643ad31730 100644
--- a/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
+++ b/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
@@ -293,7 +293,8 @@ static int sun8i_hdmi_phy_config_h3(struct dw_hdmi *h=
dmi,
 				 SUN8I_HDMI_PHY_ANA_CFG2_REG_BIGSW |
 				 SUN8I_HDMI_PHY_ANA_CFG2_REG_SLV(4);
 		ana_cfg3_init |=3D SUN8I_HDMI_PHY_ANA_CFG3_REG_AMPCK(9) |
-				 SUN8I_HDMI_PHY_ANA_CFG3_REG_AMP(13);
+				 SUN8I_HDMI_PHY_ANA_CFG3_REG_AMP(13) |
+				 SUN8I_HDMI_PHY_ANA_CFG3_REG_EMP(3);
 	}
=20
 	regmap_update_bits(phy->regs, SUN8I_HDMI_PHY_ANA_CFG1_REG,
--=20
2.21.0

