Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E08911AEEE
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbfLKPJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:09:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:57158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729838AbfLKPJP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:09:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74E6424654;
        Wed, 11 Dec 2019 15:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576076955;
        bh=vkqTVeoP7Gmqtk/Duna3R/OH1Tk748TwIhp/xbYauV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rPjMXRNmprMHKe0F1rT84EMQYAiemUgSk2up0rB7OrwQdcvo+JLZgxAaYLm1Zu/v8
         P8GWltslGnzFO2M2gpggiK4DItC9MCiXs1uFbYWJNl6H5P+sswsqWd+NvtIVMpQaz5
         eZKMZVVAYmpVIw5mdOLLCYzzExYQY5MrL4+Qz6oE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Deepak Rawat <drawat@vmware.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Sean Paul <seanpaul@chromium.org>
Subject: [PATCH 5.4 55/92] drm: damage_helper: Fix race checking plane->state->fb
Date:   Wed, 11 Dec 2019 16:05:46 +0100
Message-Id: <20191211150246.621431176@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Paul <seanpaul@chromium.org>

commit 354c2d310082d1c384213ba76c3757dd3cd8755d upstream.

Since the dirtyfb ioctl doesn't give us any hints as to which plane is
scanning out the fb it's marking as damaged, we need to loop through
planes to find it.

Currently we just reach into plane state and check, but that can race
with another commit changing the fb out from under us. This patch locks
the plane before checking the fb and will release the lock if the plane
is not displaying the dirty fb.

Fixes: b9fc5e01d1ce ("drm: Add helper to implement legacy dirtyfb")
Cc: Rob Clark <robdclark@gmail.com>
Cc: Deepak Rawat <drawat@vmware.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Sean Paul <sean@poorly.run>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.0+
Reported-by: Daniel Vetter <daniel@ffwll.ch>
Reviewed-by: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190904202938.110207-1-sean@poorly.run
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_damage_helper.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_damage_helper.c
+++ b/drivers/gpu/drm/drm_damage_helper.c
@@ -212,8 +212,14 @@ retry:
 	drm_for_each_plane(plane, fb->dev) {
 		struct drm_plane_state *plane_state;
 
-		if (plane->state->fb != fb)
+		ret = drm_modeset_lock(&plane->mutex, state->acquire_ctx);
+		if (ret)
+			goto out;
+
+		if (plane->state->fb != fb) {
+			drm_modeset_unlock(&plane->mutex);
 			continue;
+		}
 
 		plane_state = drm_atomic_get_plane_state(state, plane);
 		if (IS_ERR(plane_state)) {


