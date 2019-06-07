Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABC539066
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731726AbfFGPuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:50:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731604AbfFGPuM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:50:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1456A20840;
        Fri,  7 Jun 2019 15:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922612;
        bh=t87RM3dHsJgVh6f/Tad6flHb/UTjV3g+NJ3CaaMN4iw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IfVSAntxFgcpz8N+bZQSOR8ONifs0FBgM1NEhn8d+iI0ZQhchYDAfe0nFXuZSaL8t
         3zpqFLVZ9MwUe/lO/InDbfvjg/EZPZwN0PsWpEl075kjReVsjSLfaBGVo0wNkrWzj1
         SmviTCpaHshwBBfZ7Wk+6/z23ZoakSMK+dO9D0nU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 5.1 76/85] drm/sun4i: Fix sun8i HDMI PHY configuration for > 148.5 MHz
Date:   Fri,  7 Jun 2019 17:40:01 +0200
Message-Id: <20190607153857.459426362@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

commit 831adffb3b7b8df4c8e20b7b00843129fb87a166 upstream.

Vendor provided documentation says that EMP bits should be set to 3 for
pixel clocks greater than 148.5 MHz.

Fix that.

Cc: stable@vger.kernel.org # 4.17+
Fixes: 4f86e81748fe ("drm/sun4i: Add support for H3 HDMI PHY variant")
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190514204337.11068-3-jernej.skrabec@siol.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
+++ b/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
@@ -293,7 +293,8 @@ static int sun8i_hdmi_phy_config_h3(stru
 				 SUN8I_HDMI_PHY_ANA_CFG2_REG_BIGSW |
 				 SUN8I_HDMI_PHY_ANA_CFG2_REG_SLV(4);
 		ana_cfg3_init |= SUN8I_HDMI_PHY_ANA_CFG3_REG_AMPCK(9) |
-				 SUN8I_HDMI_PHY_ANA_CFG3_REG_AMP(13);
+				 SUN8I_HDMI_PHY_ANA_CFG3_REG_AMP(13) |
+				 SUN8I_HDMI_PHY_ANA_CFG3_REG_EMP(3);
 	}
 
 	regmap_update_bits(phy->regs, SUN8I_HDMI_PHY_ANA_CFG1_REG,


