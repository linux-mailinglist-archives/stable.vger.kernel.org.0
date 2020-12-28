Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3342E3D01
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438899AbgL1OJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:09:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:44274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438892AbgL1OJy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:09:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16F0820791;
        Mon, 28 Dec 2020 14:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164553;
        bh=K0SULmlL3NUmXLIFfFQkH6VeEmYdWtXYalEIMokysxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CcviVJ1sBjMnwhhurrqyNdNhXMPv+jHCKJ8ar0HSfmVevi39+0KAGJI3L5WmVYp3e
         Xe7TD/RiyDd9xYao9KqU1PX2rXZYxmikiPJGqh+Ajt1LTaWO53xTCe5ZoigTXQeFHB
         bFkb31ECzMJz+DHuMJn57WQCCTTSD/30mXTxdv74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "kernelci.org bot" <bot@kernelci.org>,
        Marc Zyngier <maz@kernel.org>,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/717] drm/meson: dw-hdmi: Enable the iahb clock early enough
Date:   Mon, 28 Dec 2020 13:42:53 +0100
Message-Id: <20201228125029.351428889@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 2b6cb81b95d1e8abfb6d32cf194a5bd2992c315c ]

Instead of moving meson_dw_hdmi_init() around which breaks existing
platform, let's enable the clock meson_dw_hdmi_init() depends on.
This means we don't have to worry about this clock being enabled or
not, depending on the boot-loader features.

Fixes: b33340e33acd ("drm/meson: dw-hdmi: Ensure that clocks are enabled before touching the TOP registers")
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Tested-by: Guillaume Tucker <guillaume.tucker@collabora.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
[narmstrong: changed reported by to kernelci.org bot]
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201120094205.525228-3-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_dw_hdmi.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/meson/meson_dw_hdmi.c b/drivers/gpu/drm/meson/meson_dw_hdmi.c
index 29623b309cb11..aad75a22dc338 100644
--- a/drivers/gpu/drm/meson/meson_dw_hdmi.c
+++ b/drivers/gpu/drm/meson/meson_dw_hdmi.c
@@ -1051,6 +1051,10 @@ static int meson_dw_hdmi_bind(struct device *dev, struct device *master,
 	if (ret)
 		return ret;
 
+	ret = meson_enable_clk(dev, "iahb");
+	if (ret)
+		return ret;
+
 	ret = meson_enable_clk(dev, "venci");
 	if (ret)
 		return ret;
@@ -1086,6 +1090,8 @@ static int meson_dw_hdmi_bind(struct device *dev, struct device *master,
 
 	encoder->possible_crtcs = BIT(0);
 
+	meson_dw_hdmi_init(meson_dw_hdmi);
+
 	DRM_DEBUG_DRIVER("encoder initialized\n");
 
 	/* Bridge / Connector */
@@ -1110,8 +1116,6 @@ static int meson_dw_hdmi_bind(struct device *dev, struct device *master,
 	if (IS_ERR(meson_dw_hdmi->hdmi))
 		return PTR_ERR(meson_dw_hdmi->hdmi);
 
-	meson_dw_hdmi_init(meson_dw_hdmi);
-
 	next_bridge = of_drm_find_bridge(pdev->dev.of_node);
 	if (next_bridge)
 		drm_bridge_attach(encoder, next_bridge,
-- 
2.27.0



