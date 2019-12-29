Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7270D12C7ED
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731438AbfL2RsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:48:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:59618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731157AbfL2RsY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:48:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55829206DB;
        Sun, 29 Dec 2019 17:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641703;
        bh=SpyCjP8RX0DpkAjCNktAGaCvrCrHwq5o7oh0VsmPAok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vQaPaH4wJQ/1e3XwZxcU92/hRZNnDbE9Q6gZytUuk8xxjofnXmW85hi4Bz9J7Bo8y
         zZSCnbaELO709Jizk5xckHk7gLwfc8Ku6KamBQVYjKuXYsPAfx6/51qhb/wgytly+O
         pURSgj0SUAYR0PN49z2ELeT0/0yAURWAE00Fmf5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juston Li <juston.li@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Harry Wentland <hwentlan@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ben Skeggs <bskeggs@redhat.com>, Sean Paul <sean@poorly.run>,
        Lyude Paul <lyude@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 175/434] drm/nouveau: Dont grab runtime PM refs for HPD IRQs
Date:   Sun, 29 Dec 2019 18:23:48 +0100
Message-Id: <20191229172713.435660549@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 94dfa2e5a9ab..a442a955f98c 100644
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



