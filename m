Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECAA36C18D
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 11:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235033AbhD0JVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 05:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbhD0JVM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 05:21:12 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501DCC061574
        for <stable@vger.kernel.org>; Tue, 27 Apr 2021 02:20:29 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id m5so4610692wmf.1
        for <stable@vger.kernel.org>; Tue, 27 Apr 2021 02:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m56BVCqfwfl5q0jPz4hzEYoV7UdZ/KST4hTQZTeuJdk=;
        b=Z16j2RO/tMcGi97O2Wslzw0bl7bocm0CdNceuYd7FR8sWpRYd7HG8Ip8qfiUZDTvlT
         HTaHagRZcPEwezykSoz1I9uWSEHmisn2dZaORuS6cS6VxZGe3iTz3jK4Q4TLwFAEhfb/
         jtCm3FT1ZJ50M7FTWm5j9OQPvDmXnxLTCcXaY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m56BVCqfwfl5q0jPz4hzEYoV7UdZ/KST4hTQZTeuJdk=;
        b=P67AN03RDcXNG7TKwlLbe18w93i4LnZ9rK//+y+Gv8qz4SaNJB1uH3+Zv/sk/c4nPD
         T7dpLbGAQYRM2P9PvGaaAxxWTystE2VoZw9gxtGdK01C6k7K7nWRm25dfWx6gW1TXj/Y
         1s8fDtRNOfUGqtRXj2e4VNGdt4sqo6jfZ/JyUlZh6Yh0lucxMD6nA5mKCU1/bXcXHd/K
         fEynr4aeHuvsoPJXuZBfVlGdyLF+PqjVmeFGAAdvbkY+ZJzoobs9dW8He2yFU5XcELQY
         81Pe8Ma4dg1cQV9/48vJv7VRRmOFzjhZ5sdNjrFWMkiFL5LGcQ9RVaBhlQlUj9s8tNL3
         RQHw==
X-Gm-Message-State: AOAM5332UIwYHpgPsWY+8MyMKPQHcj9GR+E2dFy5KQCSe3GnaBAQyZyK
        7ZO5fo6TLtH6+mCjFMK2bQdptg==
X-Google-Smtp-Source: ABdhPJzbPrCtq40L5ZJcK4JYJvh90uc/ZVxSStrcaxlXHngaxKYQB0bYS5ro9fj1IS+08On3AC6WBg==
X-Received: by 2002:a7b:c017:: with SMTP id c23mr3191439wmb.175.1619515228054;
        Tue, 27 Apr 2021 02:20:28 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id r24sm1939816wmh.8.2021.04.27.02.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 02:20:27 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org,
        Pekka Paalanen <pekka.paalanen@collabora.com>,
        Rob Clark <robdclark@chromium.org>,
        Jordan Crouse <jordan@cosmicpenguin.net>,
        Emil Velikov <emil.velikov@collabora.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH 5/8] drm/msm/mdp4: Fix modifier support enabling
Date:   Tue, 27 Apr 2021 11:20:15 +0200
Message-Id: <20210427092018.832258-5-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210427092018.832258-1-daniel.vetter@ffwll.ch>
References: <20210427092018.832258-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Setting the cap without the modifier list is very confusing to
userspace. Fix that by listing the ones we support explicitly.

Stable backport so that userspace can rely on this working in a
reasonable way, i.e. that the cap set implies IN_FORMATS is available.

Cc: stable@vger.kernel.org
Cc: Pekka Paalanen <pekka.paalanen@collabora.com>
Cc: Rob Clark <robdclark@chromium.org>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
Cc: Emil Velikov <emil.velikov@collabora.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
---
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c   | 2 --
 drivers/gpu/drm/msm/disp/mdp4/mdp4_plane.c | 8 +++++++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
index 3d729270bde1..4a5b518288b0 100644
--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
@@ -88,8 +88,6 @@ static int mdp4_hw_init(struct msm_kms *kms)
 	if (mdp4_kms->rev > 1)
 		mdp4_write(mdp4_kms, REG_MDP4_RESET_STATUS, 1);
 
-	dev->mode_config.allow_fb_modifiers = true;
-
 out:
 	pm_runtime_put_sync(dev->dev);
 
diff --git a/drivers/gpu/drm/msm/disp/mdp4/mdp4_plane.c b/drivers/gpu/drm/msm/disp/mdp4/mdp4_plane.c
index 9aecca919f24..49bdabea8ed5 100644
--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_plane.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_plane.c
@@ -349,6 +349,12 @@ enum mdp4_pipe mdp4_plane_pipe(struct drm_plane *plane)
 	return mdp4_plane->pipe;
 }
 
+static const uint64_t supported_format_modifiers[] = {
+	DRM_FORMAT_MOD_SAMSUNG_64_32_TILE,
+	DRM_FORMAT_MOD_LINEAR,
+	DRM_FORMAT_MOD_INVALID
+};
+
 /* initialize plane */
 struct drm_plane *mdp4_plane_init(struct drm_device *dev,
 		enum mdp4_pipe pipe_id, bool private_plane)
@@ -377,7 +383,7 @@ struct drm_plane *mdp4_plane_init(struct drm_device *dev,
 	type = private_plane ? DRM_PLANE_TYPE_PRIMARY : DRM_PLANE_TYPE_OVERLAY;
 	ret = drm_universal_plane_init(dev, plane, 0xff, &mdp4_plane_funcs,
 				 mdp4_plane->formats, mdp4_plane->nformats,
-				 NULL, type, NULL);
+				 supported_format_modifiers, type, NULL);
 	if (ret)
 		goto fail;
 
-- 
2.31.0

