Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 612FCA93B9
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 22:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbfIDU3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 16:29:40 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:46709 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfIDU3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 16:29:40 -0400
Received: by mail-yw1-f66.google.com with SMTP id 201so7753569ywo.13
        for <stable@vger.kernel.org>; Wed, 04 Sep 2019 13:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8GtbizlkMPrZXUURKhwXVzGIR9K6zwzCUzTAta15LT4=;
        b=LV1epChq+XeeoVIIhc5b8513dZ1Zaf5mhdGuMY6vqmzkhclsDa1eGolRtdkXM05Aor
         w27i24ss9e34HGiNmSXw9xlXVWFa7L7bS55caQXhF5SNwIW4bigdsPmUmi5ZszvwtQhp
         2DclMTptrrcpuzJPkjqnWOLwZmyQ80dlQYlImQFvFGdAol6unqCvrwteSpvTrjOS84k9
         HpVoUr+OnIUpIkpUvmMYDBTkxWCaxOirHuVTISnl26naDe9SPyYJDD7Rv1DhrdzErEQG
         pQc6wBcNy+/NokXcc6+ftNYqeoI1IKfdq6/V0nR5/l+IQHzvLx/dIPIc2rQfLl0kkppk
         6HmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8GtbizlkMPrZXUURKhwXVzGIR9K6zwzCUzTAta15LT4=;
        b=eHdfPSsDK1trOKi4ghhgb9jHccs/ey3yYMGydhOgpwXUhmBVh+AsXNg/cg53kbXWq8
         O2LBoKpBPag09p4yMXBMHZc52zinGQdaEZcvRlDlhy/qIrnACVe6eZm6c7cDVjkFfJx+
         xEBQ2OM2pLYDjCkmGBSJxbJD8FYsEEUOPPn772VyTYci5YLvcJs+g6BZXLJZZkZIwnhi
         +c2napGjI6cAhw0vqx1el+Rq9GD1Hsh5gmtgqV45cwx+xRIHpHd6rw6l7+SB+RQriQLs
         bAi1YaIzRQxxjmgVyU+hvw8O1HMdexb2njSfmDn6+3sJkTcBQYnRkpUYmt9Gpcpk5poa
         GsYw==
X-Gm-Message-State: APjAAAVDjfpQVzgt9QbmVqny8E8vCvz5DNrPA+Hy5iqQgfu7g11zAZik
        lZTIHv3f6hELyCL/yeG/kmUWaQ==
X-Google-Smtp-Source: APXvYqzVzAqe0E9A0gTrZGdq7KqWNEa/VHDLOQmWN98uN10FARcUPQTpZMY9ST8qYTYl/d2DXXAApw==
X-Received: by 2002:a81:7046:: with SMTP id l67mr7393356ywc.253.1567628979608;
        Wed, 04 Sep 2019 13:29:39 -0700 (PDT)
Received: from rosewood.cam.corp.google.com ([2620:0:1013:11:89c6:2139:5435:371d])
        by smtp.gmail.com with ESMTPSA id z137sm1944393ywd.18.2019.09.04.13.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 13:29:39 -0700 (PDT)
From:   Sean Paul <sean@poorly.run>
To:     dri-devel@lists.freedesktop.org
Cc:     Sean Paul <seanpaul@chromium.org>, Rob Clark <robdclark@gmail.com>,
        Deepak Rawat <drawat@vmware.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, stable@vger.kernel.org
Subject: [PATCH] drm: damage_helper: Fix race checking plane->state->fb
Date:   Wed,  4 Sep 2019 16:29:13 -0400
Message-Id: <20190904202938.110207-1-sean@poorly.run>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Paul <seanpaul@chromium.org>

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
Signed-off-by: Sean Paul <seanpaul@chromium.org>
---
 drivers/gpu/drm/drm_damage_helper.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_damage_helper.c b/drivers/gpu/drm/drm_damage_helper.c
index 8230dac01a89..3a4126dc2520 100644
--- a/drivers/gpu/drm/drm_damage_helper.c
+++ b/drivers/gpu/drm/drm_damage_helper.c
@@ -212,8 +212,14 @@ int drm_atomic_helper_dirtyfb(struct drm_framebuffer *fb,
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
-- 
Sean Paul, Software Engineer, Google / Chromium OS

