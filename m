Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80ACC217090
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgGGPSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:18:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729216AbgGGPSr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:18:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7E1D20738;
        Tue,  7 Jul 2020 15:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135127;
        bh=D4YRO9MFSrZLokgGMY3kWA+jrpa9nXrTLSjB8vCGRQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wVMSd4xIlaAluwIB5zOXowyB4ZsmgKHTsZK3+Sn4T52ogzMZwXM4dcqtiohTRHSuz
         vSBJYL7KG+BEFUDZUvm3F02ZBEZibPmfT8ykFTf/HRYkomo44BDbA76htU/8HJdCW0
         okDwO5UCDJHH6JO/NYLeF6+dgus4Dl/n+uqHPzYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 21/36] drm: sun4i: hdmi: Remove extra HPD polling
Date:   Tue,  7 Jul 2020 17:17:13 +0200
Message-Id: <20200707145750.140298346@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145749.130272978@linuxfoundation.org>
References: <20200707145749.130272978@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit bda8eaa6dee7525f4dac950810a85a88bf6c2ba0 ]

The HPD sense mechanism in Allwinner's old HDMI encoder hardware is more
or less an input-only GPIO. Other GPIO-based HPD implementations
directly return the current state, instead of polling for a specific
state and returning the other if that times out.

Remove the I/O polling from sun4i_hdmi_connector_detect() and directly
return a known state based on the current reading. This also gets rid
of excessive CPU usage by kworker as reported on Stack Exchange [1] and
Armbian forums [2].

 [1] https://superuser.com/questions/1515001/debian-10-buster-on-cubietruck-with-bug-in-sun4i-drm-hdmi
 [2] https://forum.armbian.com/topic/14282-headless-systems-and-sun4i_drm_hdmi-a10a20/

Fixes: 9c5681011a0c ("drm/sun4i: Add HDMI support")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20200629060032.24134-1-wens@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c b/drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c
index 8ad36f574df8c..7e7fa8cef2ade 100644
--- a/drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c
+++ b/drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c
@@ -242,9 +242,8 @@ sun4i_hdmi_connector_detect(struct drm_connector *connector, bool force)
 	struct sun4i_hdmi *hdmi = drm_connector_to_sun4i_hdmi(connector);
 	unsigned long reg;
 
-	if (readl_poll_timeout(hdmi->base + SUN4I_HDMI_HPD_REG, reg,
-			       reg & SUN4I_HDMI_HPD_HIGH,
-			       0, 500000)) {
+	reg = readl(hdmi->base + SUN4I_HDMI_HPD_REG);
+	if (reg & SUN4I_HDMI_HPD_HIGH) {
 		cec_phys_addr_invalidate(hdmi->cec_adap);
 		return connector_status_disconnected;
 	}
-- 
2.25.1



