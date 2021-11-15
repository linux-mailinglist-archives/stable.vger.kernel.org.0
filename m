Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE30451E20
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243152AbhKPAfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344589AbhKOTZD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 662EE63311;
        Mon, 15 Nov 2021 19:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002825;
        bh=dRgJMLgw4yxIYt+TNNTuOnUOyCrSll/E6JD65vMoENs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OuFFjchq1fOzL94sWNVVs2sGxBSoJjht4uOKQtFL0ddeNaD02fdEbxEW5IsqATokU
         1MpbjFek2Ge+6DkT3MonPN6/J/b+HmX6CBMplc/GX0cux7peHy9NmF2c4L5uF5lZBE
         UmIotXGZnNVX/+1KRnVRPkFvJxabt/A7ayeO8VlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 711/917] drm/bridge/lontium-lt9611uxc: fix provided connector suport
Date:   Mon, 15 Nov 2021 18:03:26 +0100
Message-Id: <20211115165453.008438357@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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



