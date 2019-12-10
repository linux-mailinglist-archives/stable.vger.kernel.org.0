Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83893119702
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfLJVJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:09:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:58754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728286AbfLJVJr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E35A6246AB;
        Tue, 10 Dec 2019 21:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012187;
        bh=kMEv874BtPuf0HyGoIPf4BP7UuEI4I7m70iZktNpjEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJUusVM15cvmCkt1Szx/OYUjeEPC1EPQ0mOEURtXmyeL5vga8kDIRnb0Ppzl0rtfy
         0nE8OOjRr64YvBft+i/RjhV8q1Aih1+zo06XWmryM2r80T0XUCXKPSnzg3SdrDqqB9
         xD0d4d3UxUfhfH+6BNqYLwZQ4bu4rTzAPwIzsn/E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lyude Paul <lyude@redhat.com>, Juston Li <juston.li@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Harry Wentland <hwentlan@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sean Paul <sean@poorly.run>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 143/350] drm/nouveau: Resume hotplug interrupts earlier
Date:   Tue, 10 Dec 2019 16:04:08 -0500
Message-Id: <20191210210735.9077-104-sashal@kernel.org>
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

[ Upstream commit ac0de16a38a9ec7026ca96132e3883c564497068 ]

Currently, we enable hotplug detection only after we re-enable the
display. However, this is too late if we're planning on sending sideband
messages during the resume process - which we'll need to do in order to
reprobe the topology on resume.

So, enable hotplug events before reinitializing the display.

Cc: Juston Li <juston.li@intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Harry Wentland <hwentlan@amd.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Sean Paul <sean@poorly.run>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191022023641.8026-11-lyude@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_display.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_display.c b/drivers/gpu/drm/nouveau/nouveau_display.c
index 6f038511a03a9..53f9bceaf17a5 100644
--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -407,6 +407,17 @@ nouveau_display_init(struct drm_device *dev, bool resume, bool runtime)
 	struct drm_connector_list_iter conn_iter;
 	int ret;
 
+	/*
+	 * Enable hotplug interrupts (done as early as possible, since we need
+	 * them for MST)
+	 */
+	drm_connector_list_iter_begin(dev, &conn_iter);
+	nouveau_for_each_non_mst_connector_iter(connector, &conn_iter) {
+		struct nouveau_connector *conn = nouveau_connector(connector);
+		nvif_notify_get(&conn->hpd);
+	}
+	drm_connector_list_iter_end(&conn_iter);
+
 	ret = disp->init(dev, resume, runtime);
 	if (ret)
 		return ret;
@@ -416,14 +427,6 @@ nouveau_display_init(struct drm_device *dev, bool resume, bool runtime)
 	 */
 	drm_kms_helper_poll_enable(dev);
 
-	/* enable hotplug interrupts */
-	drm_connector_list_iter_begin(dev, &conn_iter);
-	nouveau_for_each_non_mst_connector_iter(connector, &conn_iter) {
-		struct nouveau_connector *conn = nouveau_connector(connector);
-		nvif_notify_get(&conn->hpd);
-	}
-	drm_connector_list_iter_end(&conn_iter);
-
 	return ret;
 }
 
-- 
2.20.1

