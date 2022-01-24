Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEF1499E6B
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351268AbiAXWdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:33:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588256AbiAXWbq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:31:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025C8C09542D;
        Mon, 24 Jan 2022 12:57:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9382B611ED;
        Mon, 24 Jan 2022 20:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3EBC340E5;
        Mon, 24 Jan 2022 20:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057844;
        bh=V42/D9J+eVOms8WP+nFToDm5/whPS2Hd3Bz6n2GX7uI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CXHMFvTHcPvsy0y/bM1ORmceXuXo9WapkfJA9XE0FApJTiWzP4kKgA+uOR+zQQX6q
         4KRzU6SkqWAzbTb/sEo4VVvq1akmEQIVdeKndljEpcdMM+/LHB610lqdonZDovHwL1
         1qBqXlONe2SKibwEJkGhc3KqkBM8v6rcfvt1LsjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Michael Stapelberg <michael@stapelberg.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0098/1039] drm/vc4: hdmi: Make sure the controller is powered in detect
Date:   Mon, 24 Jan 2022 19:31:27 +0100
Message-Id: <20220124184128.449490958@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 0f5251339eda7f7eb7bd4467607ae1d01b24e129 ]

If the HPD GPIO is not available and drm_probe_ddc fails, we end up
reading the HDMI_HOTPLUG register, but the controller might be powered
off resulting in a CPU hang. Make sure we have the power domain and the
HSM clock powered during the detect cycle to prevent the hang from
happening.

Fixes: 4f6e3d66ac52 ("drm/vc4: Add runtime PM support to the HDMI encoder driver")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Reviewed-by: Nicolas Saenz Julienne <nsaenz@kernel.org>
Tested-by: Nicolas Saenz Julienne <nsaenz@kernel.org>
Tested-by: Michael Stapelberg <michael@stapelberg.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210922125419.4125779-6-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 63b07087d37e8..f7e48bc6cb114 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -168,6 +168,8 @@ vc4_hdmi_connector_detect(struct drm_connector *connector, bool force)
 	struct vc4_hdmi *vc4_hdmi = connector_to_vc4_hdmi(connector);
 	bool connected = false;
 
+	WARN_ON(pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev));
+
 	if (vc4_hdmi->hpd_gpio &&
 	    gpiod_get_value_cansleep(vc4_hdmi->hpd_gpio)) {
 		connected = true;
@@ -188,10 +190,12 @@ vc4_hdmi_connector_detect(struct drm_connector *connector, bool force)
 			}
 		}
 
+		pm_runtime_put(&vc4_hdmi->pdev->dev);
 		return connector_status_connected;
 	}
 
 	cec_phys_addr_invalidate(vc4_hdmi->cec_adap);
+	pm_runtime_put(&vc4_hdmi->pdev->dev);
 	return connector_status_disconnected;
 }
 
-- 
2.34.1



