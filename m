Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F4145274804
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 20:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgIVSSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 14:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgIVSSm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 14:18:42 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46034C061755
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 11:18:42 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id c18so18142968wrm.9
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 11:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xvy3alJ96Ui0nxtR1bQ3lwH1mzmrGuy6LWS2STQmjbE=;
        b=JgHD4xhBv3w2KS1wlmGq725myi4zw1aoz3Xkk8ZtD3TfxN6Fo1h0htK5Xt6QKfaGh8
         vm8drfKlFES9YM0uVmqZ/MtHm9L/FpqjtIS45T3otInnC/T5vHvy9x+4SmcE28vwlpxX
         ACt3lq3/LUKeNrwnxx8IhTSbYpgX89yhQJ2XA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xvy3alJ96Ui0nxtR1bQ3lwH1mzmrGuy6LWS2STQmjbE=;
        b=aqUqGvXlo6syCe1h4Yk+lImDqHk/Fj5fPnyrbu6jxiz+xiI9LwYN4bkA40seHSWdVp
         ivYFMNlb9N3ipLW3g/JpU98jOPazoj+MIP+h0TPOJvsVm12wDB774wZEN9zKdI2oOxzU
         XkMJgZhmE/u2AVqkJ9LhjKbUOdoiTBxLqKwFnglD5F7UOJkiVW71TpD4c5flg+I9kMKC
         +FIdroE8rwwPOEl2Aw+eHxO/M1KH0mkONl3fh/o/W7gChNxw1WZO4CfvVM5drIZCxivO
         YtLflExkncI3m2VicfME0HzlO9gYivrtPhnbPvP7dRv53WRpx3X8GT2hbV8726WmTRW+
         zblA==
X-Gm-Message-State: AOAM532HRRKechA3FKHBji/sdEUHGI2mil6e7SmmqJhnOh4rTuKjfdxJ
        M90vru2/dqRrOP/8iB3QdO+S3Q==
X-Google-Smtp-Source: ABdhPJzeAXe6S7OGQg1DJ3blsd6I3onm90rmkmafgoVnXXvNrg4QBzqceh4SbOMb0JA0vgSjU3TVjg==
X-Received: by 2002:a5d:4949:: with SMTP id r9mr6994316wrs.27.1600798720794;
        Tue, 22 Sep 2020 11:18:40 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id n4sm27203520wrp.61.2020.09.22.11.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 11:18:40 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Stone <daniel@fooishbar.org>,
        Pekka Paalanen <pekka.paalanen@collabora.co.uk>,
        Simon Ser <contact@emersion.fr>, stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH] drm: document and enforce rules around "spurious" EBUSY from atomic_commit
Date:   Tue, 22 Sep 2020 20:18:34 +0200
Message-Id: <20200922181834.2913552-1-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When doing an atomic modeset with ALLOW_MODESET drivers are allowed to
pull in arbitrary other resources, including CRTCs (e.g. when
reconfiguring global resources).

But in nonblocking mode userspace has then no idea this happened,
which can lead to spurious EBUSY calls, both:
- when that other CRTC is currently busy doing a page_flip the
  ALLOW_MODESET commit can fail with an EBUSY
- on the other CRTC a normal atomic flip can fail with EBUSY because
  of the additional commit inserted by the kernel without userspace's
  knowledge

For blocking commits this isn't a problem, because everyone else will
just block until all the CRTC are reconfigured. Only thing userspace
can notice is the dropped frames without any reason for why frames got
dropped.

Consensus is that we need new uapi to handle this properly, but no one
has any idea what exactly the new uapi should look like. Since this
has been shipping for years already compositors need to deal no matter
what, so as a first step just try to enforce this across drivers
better with some checks.

v2: Add comments and a WARN_ON to enforce this only when allowed - we
don't want to silently convert page flips into blocking plane updates
just because the driver is buggy.

v3: Fix inverted WARN_ON (Pekka).

v4: Drop the uapi changes, only add a WARN_ON for now to enforce some
rules for drivers.

References: https://lists.freedesktop.org/archives/dri-devel/2018-July/182281.html
Bugzilla: https://gitlab.freedesktop.org/wayland/weston/issues/24#note_9568
Cc: Daniel Stone <daniel@fooishbar.org>
Cc: Pekka Paalanen <pekka.paalanen@collabora.co.uk>
Cc: Simon Ser <contact@emersion.fr>
Cc: stable@vger.kernel.org
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
---
 drivers/gpu/drm/drm_atomic.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
index 58527f151984..ef106e7153a6 100644
--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -281,6 +281,10 @@ EXPORT_SYMBOL(__drm_atomic_state_free);
  * needed. It will also grab the relevant CRTC lock to make sure that the state
  * is consistent.
  *
+ * WARNING: Drivers may only add new CRTC states to a @state if
+ * drm_atomic_state.allow_modeset is set, or if it's a driver-internal commit
+ * not created by userspace through an IOCTL call.
+ *
  * Returns:
  *
  * Either the allocated state or the error code encoded into the pointer. When
@@ -1262,10 +1266,15 @@ int drm_atomic_check_only(struct drm_atomic_state *state)
 	struct drm_crtc_state *new_crtc_state;
 	struct drm_connector *conn;
 	struct drm_connector_state *conn_state;
+	unsigned requested_crtc = 0;
+	unsigned affected_crtc = 0;
 	int i, ret = 0;
 
 	DRM_DEBUG_ATOMIC("checking %p\n", state);
 
+	for_each_new_crtc_in_state(state, crtc, old_crtc_state, i)
+		requested_crtc |= drm_crtc_mask(crtc);
+
 	for_each_oldnew_plane_in_state(state, plane, old_plane_state, new_plane_state, i) {
 		ret = drm_atomic_plane_check(old_plane_state, new_plane_state);
 		if (ret) {
@@ -1313,6 +1322,24 @@ int drm_atomic_check_only(struct drm_atomic_state *state)
 		}
 	}
 
+	for_each_new_crtc_in_state(state, crtc, old_crtc_state, i)
+		affected_crtc |= drm_crtc_mask(crtc);
+
+	/*
+	 * For commits that allow modesets drivers can add other CRTCs to the
+	 * atomic commit, e.g. when they need to reallocate global resources.
+	 * This can cause spurious EBUSY, which robs compositors of a very
+	 * effective sanity check for their drawing loop. Therefor only allow
+	 * this for modeset commits.
+	 *
+	 * FIXME: Should add affected_crtc mask to the ATOMIC IOCTL as an output
+	 * so compositors know what's going on.
+	 */
+	if (affected_crtc != requested_crtc) {
+		/* adding other CRTC is only allowed for modeset commits */
+		WARN_ON(!state->allow_modeset);
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(drm_atomic_check_only);
-- 
2.28.0

