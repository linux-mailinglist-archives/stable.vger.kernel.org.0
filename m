Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48C0451287
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346803AbhKOTgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:36:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:44626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244714AbhKOTRS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:17:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BA6B61A7D;
        Mon, 15 Nov 2021 18:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000579;
        bh=dRgJMLgw4yxIYt+TNNTuOnUOyCrSll/E6JD65vMoENs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I6IukBOieLoTSoD6+ttd0JIWk7fCGgKyAoI6NY7MKlE/CGXvHj0ljYlZ5Lrs5tXMc
         eNljQpFbpBPbh1PxRpGaewx2gTVsDrr8E8A/y7VFsHrsNyc+Zh+x+mW6eO6bIhqq0U
         cN2OHTpmyLxGjWApw41PJA1gwttPD/LwxScyDvxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 680/849] drm/bridge/lontium-lt9611uxc: fix provided connector suport
Date:   Mon, 15 Nov 2021 18:02:43 +0100
Message-Id: <20211115165443.274740084@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 15184965783aab3ca7ee4f939e2598943b3f40f9 ]

- set DRM_CONNECTOR_POLL_HPD as the connector will generate hotplug
  events on its own

- do not call drm_kms_helper_hotplug_event() unless mode_config.funcs
  pointer is not NULL to remove possible kernel oops.

Fixes: bc6fa8676ebb ("drm/bridge/lontium-lt9611uxc: move HPD notification out of IRQ handler")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210708230329.395976-1-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt9611uxc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt9611uxc.c b/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
index 3cac16db970f0..010657ea7af78 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
@@ -167,9 +167,10 @@ static void lt9611uxc_hpd_work(struct work_struct *work)
 	struct lt9611uxc *lt9611uxc = container_of(work, struct lt9611uxc, work);
 	bool connected;
 
-	if (lt9611uxc->connector.dev)
-		drm_kms_helper_hotplug_event(lt9611uxc->connector.dev);
-	else {
+	if (lt9611uxc->connector.dev) {
+		if (lt9611uxc->connector.dev->mode_config.funcs)
+			drm_kms_helper_hotplug_event(lt9611uxc->connector.dev);
+	} else {
 
 		mutex_lock(&lt9611uxc->ocm_lock);
 		connected = lt9611uxc->hdmi_connected;
@@ -339,6 +340,8 @@ static int lt9611uxc_connector_init(struct drm_bridge *bridge, struct lt9611uxc
 		return -ENODEV;
 	}
 
+	lt9611uxc->connector.polled = DRM_CONNECTOR_POLL_HPD;
+
 	drm_connector_helper_add(&lt9611uxc->connector,
 				 &lt9611uxc_bridge_connector_helper_funcs);
 	ret = drm_connector_init(bridge->dev, &lt9611uxc->connector,
-- 
2.33.0



