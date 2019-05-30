Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43C962F48D
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbfE3Eje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:39:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729130AbfE3DMi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:38 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F385121BE2;
        Thu, 30 May 2019 03:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185958;
        bh=m/0J3wMjpMe2kFSydwghhTjlF1CyCjxPO7Itwchm/Jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mt4O9Uaefte1qTs7/M/oIoqyU+vw90Wj++HJnB9QhTcKa5QU/yi2tQE90/M4M/qU3
         lO0b0odsfgQHsd6SzlQMz7NSIzlGxB4Ia5VaFA6rtfvS+cj8D09xfUSiwtMtG64XzW
         YDAc4HqiZaLgBESnmB2dOaz82lMZQ4eOGfD9fMLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 375/405] drm/omap: Notify all devices in the pipeline of output disconnection
Date:   Wed, 29 May 2019 20:06:13 -0700
Message-Id: <20190530030559.714445475@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 27a7e3e18419869cdcc414a404f3fe66f1b4e644 ]

For HDMI pipelines, when the output gets disconnected the device
handling CEC needs to be notified. Instead of guessing which device that
would be (and sometimes getting it wrong), notify all devices in the
pipeline.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Tested-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/omapdrm/omap_connector.c | 28 ++++++++++++++----------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/omap_connector.c b/drivers/gpu/drm/omapdrm/omap_connector.c
index 9da94d10782a8..d37e3c001e24c 100644
--- a/drivers/gpu/drm/omapdrm/omap_connector.c
+++ b/drivers/gpu/drm/omapdrm/omap_connector.c
@@ -36,18 +36,22 @@ struct omap_connector {
 };
 
 static void omap_connector_hpd_notify(struct drm_connector *connector,
-				      struct omap_dss_device *src,
 				      enum drm_connector_status status)
 {
-	if (status == connector_status_disconnected) {
-		/*
-		 * If the source is an HDMI encoder, notify it of disconnection.
-		 * This is required to let the HDMI encoder reset any internal
-		 * state related to connection status, such as the CEC address.
-		 */
-		if (src && src->type == OMAP_DISPLAY_TYPE_HDMI &&
-		    src->ops->hdmi.lost_hotplug)
-			src->ops->hdmi.lost_hotplug(src);
+	struct omap_connector *omap_connector = to_omap_connector(connector);
+	struct omap_dss_device *dssdev;
+
+	if (status != connector_status_disconnected)
+		return;
+
+	/*
+	 * Notify all devics in the pipeline of disconnection. This is required
+	 * to let the HDMI encoders reset their internal state related to
+	 * connection status, such as the CEC address.
+	 */
+	for (dssdev = omap_connector->output; dssdev; dssdev = dssdev->next) {
+		if (dssdev->ops && dssdev->ops->hdmi.lost_hotplug)
+			dssdev->ops->hdmi.lost_hotplug(dssdev);
 	}
 }
 
@@ -67,7 +71,7 @@ static void omap_connector_hpd_cb(void *cb_data,
 	if (old_status == status)
 		return;
 
-	omap_connector_hpd_notify(connector, omap_connector->hpd, status);
+	omap_connector_hpd_notify(connector, status);
 
 	drm_kms_helper_hotplug_event(dev);
 }
@@ -128,7 +132,7 @@ static enum drm_connector_status omap_connector_detect(
 		       ? connector_status_connected
 		       : connector_status_disconnected;
 
-		omap_connector_hpd_notify(connector, dssdev->src, status);
+		omap_connector_hpd_notify(connector, status);
 	} else {
 		switch (omap_connector->display->type) {
 		case OMAP_DISPLAY_TYPE_DPI:
-- 
2.20.1



