Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34C8207001
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 11:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388615AbgFXJ3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 05:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388336AbgFXJ3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 05:29:18 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD27C061755
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 02:29:17 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id h15so1556303wrq.8
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 02:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W0wVhEMhWH3hYon0OeouApnRcgkILMJ/Xt7oWX7gLsg=;
        b=OarMyjw89XIpDvY/QrTzsO6Ols2ILfTaOBq04SQiR+FuIsZe012LrnZ7cB4zo7Vdxw
         mQrHMwiF33CoS+wnoev+YLG6RDjnn2k2B+S00boaApeE/hk1EY3pTXyPCTpC4VkZJi9h
         JHGgzLTawQgb5CcaWIZu3lOSxK1uE6W8rGlRo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W0wVhEMhWH3hYon0OeouApnRcgkILMJ/Xt7oWX7gLsg=;
        b=NvN+c1NsY0PS3IuZa9kwVs0ohKMntr99IhtFrkbq9Gz/q4EIhBadSrlpZI/x7zo6o1
         bCaWAIH4/77S1UEe+1AVQbPF4dVdWZrJXS2MNBTetIwz2k7HjRNrWWU+lhzggUnW3UJl
         JKHy0oyWnWogBdRMe4IIfEb7P6GJ6fhG3rDY5s6La00B+f1JA2iyVxqOPUVqWSEGKIF3
         dPs+CSeNSjasBnHxN5UCZf54iAq8AMnxR6FmiZRY1Hka7fMxLqs5ABXltavDBudsoyEB
         0RX8xv+8llqMyoseliV/Op/4Wq196ciOALiAFyGBwmBANOeBb1l+P3iN98ZvJ/xLM7iO
         lruA==
X-Gm-Message-State: AOAM5307UDI3YcfKHEmzyXMugYboOJ559lgZpJ69Dh4ICnslJl+wB8mF
        jvGUB7KifDIzrQ6w8aTkl8ImxA==
X-Google-Smtp-Source: ABdhPJzW8mAFVy2khktm0xHnYGgLgpNPmVkDKLcdGO6ITsJNOwZiUyPwYV1adoRJGMo/aW8PBK8RYQ==
X-Received: by 2002:adf:a34d:: with SMTP id d13mr28876302wrb.270.1592990956247;
        Wed, 24 Jun 2020 02:29:16 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id l190sm7212565wml.12.2020.06.24.02.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 02:29:15 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>, shlomo@fastmail.com,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel@daenzer.net>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, stable@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Qiujun Huang <hqjagain@gmail.com>,
        Peter Rosin <peda@axentia.se>, linux-fbdev@vger.kernel.org
Subject: [PATCH] drm/fb-helper: Fix vt restore
Date:   Wed, 24 Jun 2020 11:29:10 +0200
Message-Id: <20200624092910.3280448-1-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623155456.3092836-1-daniel.vetter@ffwll.ch>
References: <20200623155456.3092836-1-daniel.vetter@ffwll.ch>
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

v2: Somehow forgot to cc all the fbdev people.

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
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Qiujun Huang <hqjagain@gmail.com>
Cc: Peter Rosin <peda@axentia.se>
Cc: linux-fbdev@vger.kernel.org
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

