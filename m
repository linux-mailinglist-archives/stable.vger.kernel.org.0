Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02567328D88
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241192AbhCATNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:13:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:37268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241141AbhCATI0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:08:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A29A8601FD;
        Mon,  1 Mar 2021 17:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620776;
        bh=L4FfWZTenZvMaMil7pXM9i3yvfpIPXwz4PY8NI7x1Qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fa1Mn0Zba67C7BuSfw7SM2q7GszIzSIGH+1Y4M2G/ELUP+0Ld0Su7kzASJQ7YPOsm
         Ngh8d7yfbm7actLLnFOUwfSdOouw9WZS5GWrA+8PXWWRGxIdFBnyLI4Vi8jzZ3PHL2
         8nK2/neSBa9BgcCSk62uoodtStYkYTGWHTmGdg9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dom Cobley <popcornmix@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 276/775] drm/vc4: hdmi: Restore cec physical address on reconnect
Date:   Mon,  1 Mar 2021 17:07:24 +0100
Message-Id: <20210301161215.269269929@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dom Cobley <popcornmix@gmail.com>

[ Upstream commit 4d8602b8ec16f5721a4d1339c610a81f95df1856 ]

Currently we call cec_phys_addr_invalidate on a hotplug deassert.
That may be due to a TV power cycling, or an AVR being switched
on (and switching edid).

This makes CEC unusable since our controller wouldn't have a physical
address anymore.

Set it back up again on the hotplug assert.

Fixes: 15b4511a4af6 ("drm/vc4: add HDMI CEC support")
Signed-off-by: Dom Cobley <popcornmix@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Tested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Link: https://patchwork.freedesktop.org/patch/msgid/20210111142309.193441-6-maxime@cerno.tech
(cherry picked from commit b06eecb5158e5f3eb47b9d05aea8c259985cc5f7)
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 3d473638dbe18..a9a6552bdae93 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -123,20 +123,32 @@ static enum drm_connector_status
 vc4_hdmi_connector_detect(struct drm_connector *connector, bool force)
 {
 	struct vc4_hdmi *vc4_hdmi = connector_to_vc4_hdmi(connector);
+	bool connected = false;
 
 	if (vc4_hdmi->hpd_gpio) {
 		if (gpio_get_value_cansleep(vc4_hdmi->hpd_gpio) ^
 		    vc4_hdmi->hpd_active_low)
-			return connector_status_connected;
-		cec_phys_addr_invalidate(vc4_hdmi->cec_adap);
-		return connector_status_disconnected;
+			connected = true;
+	} else if (drm_probe_ddc(vc4_hdmi->ddc)) {
+		connected = true;
+	} else if (HDMI_READ(HDMI_HOTPLUG) & VC4_HDMI_HOTPLUG_CONNECTED) {
+		connected = true;
 	}
 
-	if (drm_probe_ddc(vc4_hdmi->ddc))
-		return connector_status_connected;
+	if (connected) {
+		if (connector->status != connector_status_connected) {
+			struct edid *edid = drm_get_edid(connector, vc4_hdmi->ddc);
+
+			if (edid) {
+				cec_s_phys_addr_from_edid(vc4_hdmi->cec_adap, edid);
+				vc4_hdmi->encoder.hdmi_monitor = drm_detect_hdmi_monitor(edid);
+				kfree(edid);
+			}
+		}
 
-	if (HDMI_READ(HDMI_HOTPLUG) & VC4_HDMI_HOTPLUG_CONNECTED)
 		return connector_status_connected;
+	}
+
 	cec_phys_addr_invalidate(vc4_hdmi->cec_adap);
 	return connector_status_disconnected;
 }
-- 
2.27.0



