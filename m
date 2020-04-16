Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607281AC369
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441543AbgDPNmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:42:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441524AbgDPNmf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:42:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DA0F218AC;
        Thu, 16 Apr 2020 13:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044554;
        bh=cPcVth3C/ecITib/wFDwsrdywlBZ+L1o5W0YguVVgSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MxKSL2UBtxLm59ZsnEvasOMAT+tGLoPJAblbIXi5qnErrlsqXX+jwUqzzkrBAsU0n
         xRGZmYHb0WqGpkTmmFmzIsK+bH+hZic3dD+w1TnL4lOwm+Fs/JLWH5ymr5sUbO3PIB
         C8I0WX3Q8C5U8yjWziGVN70ranijeWrE8JZEJ8eI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Torsten Duwe <duwe@lst.de>,
        Thierry Reding <treding@nvidia.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 246/257] drm/bridge: analogix-anx78xx: Fix drm_dp_link helper removal
Date:   Thu, 16 Apr 2020 15:24:57 +0200
Message-Id: <20200416131356.465132016@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Torsten Duwe <duwe@lst.de>

[ Upstream commit 3e138a63d6674a4567a018a31e467567c40b14d5 ]

drm_dp_link_rate_to_bw_code and ...bw_code_to_link_rate simply divide by
and multiply with 27000, respectively. Avoid an overflow in the u8 dpcd[0]
and the multiply+divide alltogether.

Signed-off-by: Torsten Duwe <duwe@lst.de>
Fixes: ff1e8fb68ea0 ("drm/bridge: analogix-anx78xx: Avoid drm_dp_link helpers")
Cc: Thierry Reding <treding@nvidia.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Cc: Jonas Karlman <jonas@kwiboo.se>
Cc: Jernej Skrabec <jernej.skrabec@siol.net>
Cc: <stable@vger.kernel.org> # v5.5+
Reviewed-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20200218155744.9675368BE1@verein.lst.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix-anx78xx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix-anx78xx.c b/drivers/gpu/drm/bridge/analogix-anx78xx.c
index 274989f96a916..914263a1afab4 100644
--- a/drivers/gpu/drm/bridge/analogix-anx78xx.c
+++ b/drivers/gpu/drm/bridge/analogix-anx78xx.c
@@ -866,10 +866,9 @@ static int anx78xx_dp_link_training(struct anx78xx *anx78xx)
 	if (err)
 		return err;
 
-	dpcd[0] = drm_dp_max_link_rate(anx78xx->dpcd);
-	dpcd[0] = drm_dp_link_rate_to_bw_code(dpcd[0]);
 	err = regmap_write(anx78xx->map[I2C_IDX_TX_P0],
-			   SP_DP_MAIN_LINK_BW_SET_REG, dpcd[0]);
+			   SP_DP_MAIN_LINK_BW_SET_REG,
+			   anx78xx->dpcd[DP_MAX_LINK_RATE]);
 	if (err)
 		return err;
 
-- 
2.20.1



