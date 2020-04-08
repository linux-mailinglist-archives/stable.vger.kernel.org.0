Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22DD61A2717
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 18:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730275AbgDHQYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 12:24:13 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38908 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728473AbgDHQYN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 12:24:13 -0400
Received: by mail-wm1-f67.google.com with SMTP id f20so57522wmh.3
        for <stable@vger.kernel.org>; Wed, 08 Apr 2020 09:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o1wXXAbri86QChEa50j3H0JwCub+mO1ccJpn2usVHv0=;
        b=HYp5Bq75xxTmKkQ+MwniWHFEFiXu9DoFPzIjKWs0sTP35Z4+14iO0Ez2Itb5g6Yzf4
         gGIW60ImXzKzNMVCeZNeLLmoYyzc/2bSB490taxtJsRyvN1rr5hsDcDs/Kxz6UI/Zg/g
         PLn57TkhnsaZH3nq26pN7Agbq8A8eE+yjcgoU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o1wXXAbri86QChEa50j3H0JwCub+mO1ccJpn2usVHv0=;
        b=TbqY8hL+LmvvfUeJW1sE/ICnTr2TRO+shZVXFudCow+FIOJxt7f51jLAf9hM/Vw7Ev
         SBDoJUjpjG2lzdw8fEyxX9KBwzM6QRz6QiCeCev27L27KjFKFh8bbXueQEw9NKTtET5t
         gWA8kjN+I8VJPSXQBl4iC12VACupIkw+tsXMrxwr/dycNZLDp/F7mw47eI51X4QAGoTK
         UsfG0Hd35cy3RwXxJpDuhEQnqtqqOujRKLXwBu9mJ9nhI0jlWD2BJltMeImQByrv6QqQ
         +NZs2VEV8owwljQmEXgJ724tH+V69De81Q27aCtvxJecedJKywQXvRAGv8cMCUPslw1T
         k1+A==
X-Gm-Message-State: AGi0PuaJpiJlOivkEQ5K/cEFfXSxvp+H/E7bbY9MItmFjjnj86vvIvc8
        HiGCqf5cdjf9j6PyPCtNQsoSGA==
X-Google-Smtp-Source: APiQypKz8wOvsiwaQ6yZhKkaOvbAB1KfIjZ7OheWj1K9qwQtTAOpdj5ga9Ksu7zXCCdYCbGmsA9ZIg==
X-Received: by 2002:a1c:7ed0:: with SMTP id z199mr5427573wmc.60.1586363049729;
        Wed, 08 Apr 2020 09:24:09 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id m15sm47369wmc.35.2020.04.08.09.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 09:24:08 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Stone <daniel@fooishbar.org>,
        Pekka Paalanen <pekka.paalanen@collabora.co.uk>,
        stable@vger.kernel.org, Daniel Stone <daniels@collabora.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH] drm: avoid spurious EBUSY due to nonblocking atomic modesets
Date:   Wed,  8 Apr 2020 18:24:03 +0200
Message-Id: <20200408162403.3616785-1-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
has any idea what exactly the new uapi should look like. As a stop-gap
plug this problem by demoting nonblocking commits which might cause
issues by including CRTCs not in the original request to blocking
commits.

v2: Add comments and a WARN_ON to enforce this only when allowed - we
don't want to silently convert page flips into blocking plane updates
just because the driver is buggy.

v3: Fix inverted WARN_ON (Pekka).

References: https://lists.freedesktop.org/archives/dri-devel/2018-July/182281.html
Bugzilla: https://gitlab.freedesktop.org/wayland/weston/issues/24#note_9568
Cc: Daniel Stone <daniel@fooishbar.org>
Cc: Pekka Paalanen <pekka.paalanen@collabora.co.uk>
Cc: stable@vger.kernel.org
Reviewed-by: Daniel Stone <daniels@collabora.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
--
Resending because last attempt failed CI and meanwhile the results are
lost :-/
-Daniel
---
 drivers/gpu/drm/drm_atomic.c | 34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
index 965173fd0ac2..4f140ff6fb98 100644
--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -1362,15 +1362,43 @@ EXPORT_SYMBOL(drm_atomic_commit);
 int drm_atomic_nonblocking_commit(struct drm_atomic_state *state)
 {
 	struct drm_mode_config *config = &state->dev->mode_config;
-	int ret;
+	unsigned requested_crtc = 0;
+	unsigned affected_crtc = 0;
+	struct drm_crtc *crtc;
+	struct drm_crtc_state *crtc_state;
+	bool nonblocking = true;
+	int ret, i;
+
+	/*
+	 * For commits that allow modesets drivers can add other CRTCs to the
+	 * atomic commit, e.g. when they need to reallocate global resources.
+	 *
+	 * But when userspace also requests a nonblocking commit then userspace
+	 * cannot know that the commit affects other CRTCs, which can result in
+	 * spurious EBUSY failures. Until we have better uapi plug this by
+	 * demoting such commits to blocking mode.
+	 */
+	for_each_new_crtc_in_state(state, crtc, crtc_state, i)
+		requested_crtc |= drm_crtc_mask(crtc);
 
 	ret = drm_atomic_check_only(state);
 	if (ret)
 		return ret;
 
-	DRM_DEBUG_ATOMIC("committing %p nonblocking\n", state);
+	for_each_new_crtc_in_state(state, crtc, crtc_state, i)
+		affected_crtc |= drm_crtc_mask(crtc);
+
+	if (affected_crtc != requested_crtc) {
+		/* adding other CRTC is only allowed for modeset commits */
+		WARN_ON(!state->allow_modeset);
+
+		DRM_DEBUG_ATOMIC("demoting %p to blocking mode to avoid EBUSY\n", state);
+		nonblocking = false;
+	} else {
+		DRM_DEBUG_ATOMIC("committing %p nonblocking\n", state);
+	}
 
-	return config->funcs->atomic_commit(state->dev, state, true);
+	return config->funcs->atomic_commit(state->dev, state, nonblocking);
 }
 EXPORT_SYMBOL(drm_atomic_nonblocking_commit);
 
-- 
2.25.1

