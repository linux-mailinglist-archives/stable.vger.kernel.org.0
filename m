Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC2C5B1EEF
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388944AbfIMNOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:14:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389493AbfIMNOT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:14:19 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A923320CC7;
        Fri, 13 Sep 2019 13:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380459;
        bh=+UNRADZumm6okOEOLOhRg+cfMCPvFN0NB1h2mPph/IU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQICCBDWZP8IGGOiCcKrywEpQfjSc5TCE31H7ndoxXy/BCy9uaaainb2Zt9nHXP3G
         5qIhnEqyUYnHifZnU3uE94/t053kNGQDF0Uf6S0Dk87CwiUa/sdlVob2P0bLwIj0xP
         ATJkgAcWatr6xHIEngNVPXLe51F+Ytw74cDCFvh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 048/190] drm/atomic_helper: Disallow new modesets on unregistered connectors
Date:   Fri, 13 Sep 2019 14:05:03 +0100
Message-Id: <20190913130603.616365987@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



