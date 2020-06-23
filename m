Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01EEA205663
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 17:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733061AbgFWPzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 11:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733027AbgFWPzF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 11:55:05 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3345CC061573
        for <stable@vger.kernel.org>; Tue, 23 Jun 2020 08:55:04 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id 17so3800616wmo.1
        for <stable@vger.kernel.org>; Tue, 23 Jun 2020 08:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZoyI/iMwge7M/KLt2w2TyNI2FunQuCwFzoYPdndf8Xc=;
        b=S7K2FPNI/VoZ9IPZ5IvUKWZ1Llw1Ai5zmiyVMtp6cajQ55iWcouXy3c/hYFdA6Xt8K
         sYs7ydPOXn2yDn4xiIr25KP14JN6gVGoZhcX81bOoifUqTr4p5zEt21pWcbH77FRnz+Z
         c3X4Wt66MaouB4D76U9Ck9uAy6amrrgEfCBk0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZoyI/iMwge7M/KLt2w2TyNI2FunQuCwFzoYPdndf8Xc=;
        b=BSMQBcFhdttrVPhuNZlEZEA4chkzmMxTo0sVHG4e9/yoBoW0sJh1+x/rAil4+8Y75Y
         8azGPNnqnpygvRclpcEfXFrUrJykNGK5T2h/OtoxEf+G69Lm2l/cQPqaSB72FZNZgORa
         zdhC5p3n+RiS0ApAdVBMAcEKwOyirTir7ZT7+xN43sn91VmPM2QkXDQ7aKTXQvpAbqYk
         t3698TJpMs0+5vwN3664D3/R8j5Buy3hD2bXvj1jhf2f7iGGda7PMzd+mWthiulp0h/t
         uN8/IrRzj8RHOo81P7Oy6ODOTyGofr78XB/Yi9QWeTyUbPHe5wRQtNH3czSFC5qZLOy9
         wGZA==
X-Gm-Message-State: AOAM532ld8+diiaAbgb6Wdgjqzm6bEwQC8D1L9ZA/J99vdt8IroV4DjZ
        U8Azukfaimz+P0lBIIVqMZ/Ecg==
X-Google-Smtp-Source: ABdhPJzNsflmFOr5IE2trkknEUFP0A5zaic2z/q2MR962kkjK6Z38y3TNGOhS8Nns0JpViK1+fwX+g==
X-Received: by 2002:a1c:a7ca:: with SMTP id q193mr25286732wme.69.1592927702909;
        Tue, 23 Jun 2020 08:55:02 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id f186sm4202652wmf.29.2020.06.23.08.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 08:55:02 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, shlomo@fastmail.com,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel@daenzer.net>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, stable@vger.kernel.org
Subject: [PATCH] drm/fb-helper: Fix vt restore
Date:   Tue, 23 Jun 2020 17:54:56 +0200
Message-Id: <20200623155456.3092836-1-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the past we had a pile of hacks to orchestrate access between fbdev
emulation and native kms clients. We've tried to streamline this, by
always preferring the kms side above fbdev calls when a drm master
exists, because drm master controls access to the display resources.

Unfortunately this breaks existing userspace, specifically Xorg. When
exiting Xorg first restores the console to text mode using the KDSET
ioctl on the vt. This does nothing, because a drm master is still
around. Then it drops the drm master status, which again does nothing,
because logind is keeping additional drm fd open to be able to
orchestrate vt switches. In the past this is the point where fbdev was
restored, as part of the ->lastclose hook on the drm side.

Now to fix this regression we don't want to go back to letting fbdev
restore things whenever it feels like, or to the pile of hacks we've
had before. Instead try and go with a minimal exception to make the
KDSET case work again, and nothing else.

This means that if userspace does a KDSET call when switching between
graphical compositors, there will be some flickering with fbcon
showing up for a bit. But a) that's not a regression and b) userspace
can fix it by improving the vt switching dance - logind should have
all the information it needs.

While pondering all this I'm also wondering wheter we should have a
SWITCH_MASTER ioctl to allow race-free master status handover. But
that's for another day.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=208179
Cc: shlomo@fastmail.com
Reported-and-Tested-by: shlomo@fastmail.com
Cc: Michel Dänzer <michel@daenzer.net>
Fixes: 64914da24ea9 ("drm/fbdev-helper: don't force restores")
Cc: Noralf Trønnes <noralf@tronnes.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Daniel Vetter <daniel.vetter@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.7+
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
---
 drivers/gpu/drm/drm_fb_helper.c  | 63 +++++++++++++++++++++++++-------
 drivers/video/fbdev/core/fbcon.c |  3 +-
 include/uapi/linux/fb.h          |  1 +
 3 files changed, 52 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 170aa7689110..ae69bf8e9bcc 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -227,18 +227,9 @@ int drm_fb_helper_debug_leave(struct fb_info *info)
 }
 EXPORT_SYMBOL(drm_fb_helper_debug_leave);
 
-/**
- * drm_fb_helper_restore_fbdev_mode_unlocked - restore fbdev configuration
- * @fb_helper: driver-allocated fbdev helper, can be NULL
- *
- * This should be called from driver's drm &drm_driver.lastclose callback
- * when implementing an fbcon on top of kms using this helper. This ensures that
- * the user isn't greeted with a black screen when e.g. X dies.
- *
- * RETURNS:
- * Zero if everything went ok, negative error code otherwise.
- */
-int drm_fb_helper_restore_fbdev_mode_unlocked(struct drm_fb_helper *fb_helper)
+static int
+__drm_fb_helper_restore_fbdev_mode_unlocked(struct drm_fb_helper *fb_helper,
+					    bool force)
 {
 	bool do_delayed;
 	int ret;
@@ -250,7 +241,16 @@ int drm_fb_helper_restore_fbdev_mode_unlocked(struct drm_fb_helper *fb_helper)
 		return 0;
 
 	mutex_lock(&fb_helper->lock);
-	ret = drm_client_modeset_commit(&fb_helper->client);
+	if (force) {
+		/*
+		 * Yes this is the _locked version which expects the master lock
+		 * to be held. But for forced restores we're intentionally
+		 * racing here, see drm_fb_helper_set_par().
+		 */
+		ret = drm_client_modeset_commit_locked(&fb_helper->client);
+	} else {
+		ret = drm_client_modeset_commit(&fb_helper->client);
+	}
 
 	do_delayed = fb_helper->delayed_hotplug;
 	if (do_delayed)
@@ -262,6 +262,22 @@ int drm_fb_helper_restore_fbdev_mode_unlocked(struct drm_fb_helper *fb_helper)
 
 	return ret;
 }
+
+/**
+ * drm_fb_helper_restore_fbdev_mode_unlocked - restore fbdev configuration
+ * @fb_helper: driver-allocated fbdev helper, can be NULL
+ *
+ * This should be called from driver's drm &drm_driver.lastclose callback
+ * when implementing an fbcon on top of kms using this helper. This ensures that
+ * the user isn't greeted with a black screen when e.g. X dies.
+ *
+ * RETURNS:
+ * Zero if everything went ok, negative error code otherwise.
+ */
+int drm_fb_helper_restore_fbdev_mode_unlocked(struct drm_fb_helper *fb_helper)
+{
+	return __drm_fb_helper_restore_fbdev_mode_unlocked(fb_helper, false);
+}
 EXPORT_SYMBOL(drm_fb_helper_restore_fbdev_mode_unlocked);
 
 #ifdef CONFIG_MAGIC_SYSRQ
@@ -1318,6 +1334,7 @@ int drm_fb_helper_set_par(struct fb_info *info)
 {
 	struct drm_fb_helper *fb_helper = info->par;
 	struct fb_var_screeninfo *var = &info->var;
+	bool force;
 
 	if (oops_in_progress)
 		return -EBUSY;
@@ -1327,7 +1344,25 @@ int drm_fb_helper_set_par(struct fb_info *info)
 		return -EINVAL;
 	}
 
-	drm_fb_helper_restore_fbdev_mode_unlocked(fb_helper);
+	/*
+	 * Normally we want to make sure that a kms master takes
+	 * precedence over fbdev, to avoid fbdev flickering and
+	 * occasionally stealing the display status. But Xorg first sets
+	 * the vt back to text mode using the KDSET IOCTL with KD_TEXT,
+	 * and only after that drops the master status when exiting.
+	 *
+	 * In the past this was caught by drm_fb_helper_lastclose(), but
+	 * on modern systems where logind always keeps a drm fd open to
+	 * orchestrate the vt switching, this doesn't work.
+	 *
+	 * To no break the userspace ABI we have this special case here,
+	 * which is only used for the above case. Everything else uses
+	 * the normal commit function, which ensures that we never steal
+	 * the display from an active drm master.
+	 */
+	force = var->activate & FB_ACTIVATE_KD_TEXT;
+
+	__drm_fb_helper_restore_fbdev_mode_unlocked(fb_helper, force);
 
 	return 0;
 }
diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 9d28a8e3328f..e2a490c5ae08 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2402,7 +2402,8 @@ static int fbcon_blank(struct vc_data *vc, int blank, int mode_switch)
 		ops->graphics = 1;
 
 		if (!blank) {
-			var.activate = FB_ACTIVATE_NOW | FB_ACTIVATE_FORCE;
+			var.activate = FB_ACTIVATE_NOW | FB_ACTIVATE_FORCE |
+				FB_ACTIVATE_KD_TEXT;
 			fb_set_var(info, &var);
 			ops->graphics = 0;
 			ops->var = info->var;
diff --git a/include/uapi/linux/fb.h b/include/uapi/linux/fb.h
index b6aac7ee1f67..4c14e8be7267 100644
--- a/include/uapi/linux/fb.h
+++ b/include/uapi/linux/fb.h
@@ -205,6 +205,7 @@ struct fb_bitfield {
 #define FB_ACTIVATE_ALL	       64	/* change all VCs on this fb	*/
 #define FB_ACTIVATE_FORCE     128	/* force apply even when no change*/
 #define FB_ACTIVATE_INV_MODE  256       /* invalidate videomode */
+#define FB_ACTIVATE_KD_TEXT   512       /* for KDSET vt ioctl */
 
 #define FB_ACCELF_TEXT		1	/* (OBSOLETE) see fb_info.flags and vc_mode */
 
-- 
2.27.0

