Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2431196FC
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfLJVaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:30:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:58918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728286AbfLJVJw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39661246A7;
        Tue, 10 Dec 2019 21:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012191;
        bh=vKrGV+U6ZIYLfVQT/UY7pRLhv6t2/3JYD+SUqMl5pp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0YOxCbqNYbhfJnJUZ9NGh/p/B2uTi+BQce4EYQRuM4tau3f7zjHuuvabtdgK4UtRh
         SvGyKFqvyul1qPbXa8CxW6UkE1i1Ok6nTt1H8Ay5niUadZZbLqN1Up/ySAokVEN6Am
         O4FkzyXfvrs9bomE699ax5nZhXbQnm0XnF58OQfU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lyude Paul <lyude@redhat.com>, Juston Li <juston.li@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Harry Wentland <hwentlan@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ben Skeggs <bskeggs@redhat.com>, Sean Paul <sean@poorly.run>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 146/350] drm/nouveau: Don't grab runtime PM refs for HPD IRQs
Date:   Tue, 10 Dec 2019 16:04:11 -0500
Message-Id: <20191210210735.9077-107-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

[ Upstream commit 09e530657e1c982d3dbc5e4302bf9207950c3d0a ]

In order for suspend/resume reprobing to work, we need to be able to
perform sideband communications during suspend/resume, along with
runtime PM suspend/resume. In order to do so, we also need to make sure
that nouveau doesn't bother grabbing a runtime PM reference to do so,
since otherwise we'll start deadlocking runtime PM again.

Note that we weren't able to do this before, because of the DP MST
helpers processing UP requests from topologies in the same context as
drm_dp_mst_hpd_irq() which would have caused us to open ourselves up to
receiving hotplug events and deadlocking with runtime suspend/resume.
Now that those requests are handled asynchronously, this change should
be completely safe.

Cc: Juston Li <juston.li@intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Harry Wentland <hwentlan@amd.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Ben Skeggs <bskeggs@redhat.com>
Reviewed-by: Sean Paul <sean@poorly.run>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191022023641.8026-10-lyude@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c | 33 +++++++++++----------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index 94dfa2e5a9abe..a442a955f98cb 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -1131,6 +1131,16 @@ nouveau_connector_hotplug(struct nvif_notify *notify)
 	const char *name = connector->name;
 	struct nouveau_encoder *nv_encoder;
 	int ret;
+	bool plugged = (rep->mask != NVIF_NOTIFY_CONN_V0_UNPLUG);
+
+	if (rep->mask & NVIF_NOTIFY_CONN_V0_IRQ) {
+		NV_DEBUG(drm, "service %s\n", name);
+		drm_dp_cec_irq(&nv_connector->aux);
+		if ((nv_encoder = find_encoder(connector, DCB_OUTPUT_DP)))
+			nv50_mstm_service(nv_encoder->dp.mstm);
+
+		return NVIF_NOTIFY_KEEP;
+	}
 
 	ret = pm_runtime_get(drm->dev->dev);
 	if (ret == 0) {
@@ -1151,25 +1161,16 @@ nouveau_connector_hotplug(struct nvif_notify *notify)
 		return NVIF_NOTIFY_DROP;
 	}
 
-	if (rep->mask & NVIF_NOTIFY_CONN_V0_IRQ) {
-		NV_DEBUG(drm, "service %s\n", name);
-		drm_dp_cec_irq(&nv_connector->aux);
-		if ((nv_encoder = find_encoder(connector, DCB_OUTPUT_DP)))
-			nv50_mstm_service(nv_encoder->dp.mstm);
-	} else {
-		bool plugged = (rep->mask != NVIF_NOTIFY_CONN_V0_UNPLUG);
-
+	if (!plugged)
+		drm_dp_cec_unset_edid(&nv_connector->aux);
+	NV_DEBUG(drm, "%splugged %s\n", plugged ? "" : "un", name);
+	if ((nv_encoder = find_encoder(connector, DCB_OUTPUT_DP))) {
 		if (!plugged)
-			drm_dp_cec_unset_edid(&nv_connector->aux);
-		NV_DEBUG(drm, "%splugged %s\n", plugged ? "" : "un", name);
-		if ((nv_encoder = find_encoder(connector, DCB_OUTPUT_DP))) {
-			if (!plugged)
-				nv50_mstm_remove(nv_encoder->dp.mstm);
-		}
-
-		drm_helper_hpd_irq_event(connector->dev);
+			nv50_mstm_remove(nv_encoder->dp.mstm);
 	}
 
+	drm_helper_hpd_irq_event(connector->dev);
+
 	pm_runtime_mark_last_busy(drm->dev->dev);
 	pm_runtime_put_autosuspend(drm->dev->dev);
 	return NVIF_NOTIFY_KEEP;
-- 
2.20.1

