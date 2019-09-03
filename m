Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D10CA7037
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730516AbfICQZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730103AbfICQZy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:25:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75A4823717;
        Tue,  3 Sep 2019 16:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527953;
        bh=qUDXs+NRk9kq4QOIe8TO4tnvqCIQP/qICPClCjAc3Kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dmWpGoTvgLAU39UmPomTJN0cDldoLCAmFcFhgkXF/7hPqzeFCfo3PQRxaknskDlvn
         Hki1MiXQwZ3+1HJnxHqOT1rGq97dGgDqNrI/u7C8w+OyvENyYaklTy2tyfYXpKuxrv
         g9oavyA++9iG5MnftRgY0vzrVhW1kh7DmUNcHTq4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lyude Paul <lyude@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 019/167] drm/atomic_helper: Disallow new modesets on unregistered connectors
Date:   Tue,  3 Sep 2019 12:22:51 -0400
Message-Id: <20190903162519.7136-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

[ Upstream commit 4d80273976bf880c4bed9359b8f2d45663140c86 ]

With the exception of modesets which would switch the DPMS state of a
connector from on to off, we want to make sure that we disallow all
modesets which would result in enabling a new monitor or a new mode
configuration on a monitor if the connector for the display in question
is no longer registered. This allows us to stop userspace from trying to
enable new displays on connectors for an MST topology that were just
removed from the system, without preventing userspace from disabling
DPMS on those connectors.

Changes since v5:
- Fix typo in comment, nothing else

Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20181008232437.5571-2-lyude@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_atomic_helper.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index c22062cc99923..71c70a031a043 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -307,6 +307,26 @@ update_connector_routing(struct drm_atomic_state *state,
 		return 0;
 	}
 
+	crtc_state = drm_atomic_get_new_crtc_state(state,
+						   new_connector_state->crtc);
+	/*
+	 * For compatibility with legacy users, we want to make sure that
+	 * we allow DPMS On->Off modesets on unregistered connectors. Modesets
+	 * which would result in anything else must be considered invalid, to
+	 * avoid turning on new displays on dead connectors.
+	 *
+	 * Since the connector can be unregistered at any point during an
+	 * atomic check or commit, this is racy. But that's OK: all we care
+	 * about is ensuring that userspace can't do anything but shut off the
+	 * display on a connector that was destroyed after its been notified,
+	 * not before.
+	 */
+	if (!READ_ONCE(connector->registered) && crtc_state->active) {
+		DRM_DEBUG_ATOMIC("[CONNECTOR:%d:%s] is not registered\n",
+				 connector->base.id, connector->name);
+		return -EINVAL;
+	}
+
 	funcs = connector->helper_private;
 
 	if (funcs->atomic_best_encoder)
@@ -351,7 +371,6 @@ update_connector_routing(struct drm_atomic_state *state,
 
 	set_best_encoder(state, new_connector_state, new_encoder);
 
-	crtc_state = drm_atomic_get_new_crtc_state(state, new_connector_state->crtc);
 	crtc_state->connectors_changed = true;
 
 	DRM_DEBUG_ATOMIC("[CONNECTOR:%d:%s] using [ENCODER:%d:%s] on [CRTC:%d:%s]\n",
-- 
2.20.1

