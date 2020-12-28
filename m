Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871672E41BD
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438030AbgL1OHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:07:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:41468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438133AbgL1OHE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:07:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65B17206D4;
        Mon, 28 Dec 2020 14:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164384;
        bh=9RvLSejUFGb1DnP4EcE3NpQQHY4tAHzLTQcLQGwqT/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vvqqy1Y2UnPMMCPaOKzjWHatvq1DDRivMeW5+9ZouIxKNcT5RksnEfe+wN3pinHAi
         Vcvra3k6bpYW+Q+Q+CzcK2HpxKLVd0tS9pfxdzRqa2/X3Bg3mUeidfhVklxD98zk2L
         SV14oGYK/sZIKIjlT1U6YUJSYzYyktxN/2pYgN80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 144/717] drm/meson: dw-hdmi: Ensure that clocks are enabled before touching the TOP registers
Date:   Mon, 28 Dec 2020 13:42:22 +0100
Message-Id: <20201228125027.861595356@linuxfoundation.org>
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

[ Upstream commit b33340e33acdfe5ca6a5aa1244709575ae1e0432 ]

Removing the meson-dw-hdmi module and re-inserting it results in a hang
as the driver writes to HDMITX_TOP_SW_RESET. Similar effects can be seen
when booting with mainline u-boot and using the u-boot provided DT (which
is highly desirable).

The reason for the hang seem to be that the clocks are not always
enabled by the time we enter meson_dw_hdmi_init(). Moving this call
*after* dw_hdmi_probe() ensures that the clocks are enabled.

Fixes: 1374b8375c2e ("drm/meson: dw_hdmi: add resume/suspend hooks")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201116200744.495826-5-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_dw_hdmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/meson/meson_dw_hdmi.c b/drivers/gpu/drm/meson/meson_dw_hdmi.c
index 68826cf9993fc..7f8eea4941472 100644
--- a/drivers/gpu/drm/meson/meson_dw_hdmi.c
+++ b/drivers/gpu/drm/meson/meson_dw_hdmi.c
@@ -1073,8 +1073,6 @@ static int meson_dw_hdmi_bind(struct device *dev, struct device *master,
 
 	DRM_DEBUG_DRIVER("encoder initialized\n");
 
-	meson_dw_hdmi_init(meson_dw_hdmi);
-
 	/* Bridge / Connector */
 
 	dw_plat_data->priv_data = meson_dw_hdmi;
@@ -1097,6 +1095,8 @@ static int meson_dw_hdmi_bind(struct device *dev, struct device *master,
 	if (IS_ERR(meson_dw_hdmi->hdmi))
 		return PTR_ERR(meson_dw_hdmi->hdmi);
 
+	meson_dw_hdmi_init(meson_dw_hdmi);
+
 	next_bridge = of_drm_find_bridge(pdev->dev.of_node);
 	if (next_bridge)
 		drm_bridge_attach(encoder, next_bridge,
-- 
2.27.0



