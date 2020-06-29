Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1788020E765
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbgF2V5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:57:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbgF2Sfa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 534B5247D6;
        Mon, 29 Jun 2020 15:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444143;
        bh=xNaJK2bzX/TBVBYqqlC5jqLqK9jLm6f/maT89IpZdQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bjDLdTFBHV/jwq50zlfL9uzUJrnR5fWsLqrwpHL522q2nfAw9BQNRqCEPGVWeGtht
         66BHFNaM0DHTHxAMmJv29hHG8SBrBAVMaWROBxBDjIndseW9yDtVK/QfO7YajJesjS
         pTG3WPQzT/4gnxJiBv0h2ApKniZiISBtta7+yszc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>, shlomo@fastmail.com,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel@daenzer.net>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Qiujun Huang <hqjagain@gmail.com>,
        Peter Rosin <peda@axentia.se>, linux-fbdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 248/265] drm/fb-helper: Fix vt restore
Date:   Mon, 29 Jun 2020 11:18:01 -0400
Message-Id: <20200629151818.2493727-249-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit dc5bdb68b5b369d5bc7d1de96fa64cc1737a6320 upstream.

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

v3: Fix typo Alex spotted.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
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
Link: https://patchwork.freedesktop.org/patch/msgid/20200624092910.3280448-1-daniel.vetter@ffwll.ch
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_fb_helper.c  | 63 +++++++++++++++++++++++++-------
 drivers/video/fbdev/core/fbcon.c |  3 +-
 include/uapi/linux/fb.h          |  1 +
 3 files changed, 52 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index a9771de4d17e6..c7be39a00d437 100644
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
@@ -1310,6 +1326,7 @@ int drm_fb_helper_set_par(struct fb_info *info)
 {
 	struct drm_fb_helper *fb_helper = info->par;
 	struct fb_var_screeninfo *var = &info->var;
+	bool force;
 
 	if (oops_in_progress)
 		return -EBUSY;
@@ -1319,7 +1336,25 @@ int drm_fb_helper_set_par(struct fb_info *info)
 		return -EINVAL;
 	}
 
-	drm_fb_helper_restore_fbdev_mode_unlocked(fb_helper);
+	/*
+	 * Normally we want to make sure that a kms master takes precedence over
+	 * fbdev, to avoid fbdev flickering and occasionally stealing the
+	 * display status. But Xorg first sets the vt back to text mode using
+	 * the KDSET IOCTL with KD_TEXT, and only after that drops the master
+	 * status when exiting.
+	 *
+	 * In the past this was caught by drm_fb_helper_lastclose(), but on
+	 * modern systems where logind always keeps a drm fd open to orchestrate
+	 * the vt switching, this doesn't work.
+	 *
+	 * To not break the userspace ABI we have this special case here, which
+	 * is only used for the above case. Everything else uses the normal
+	 * commit function, which ensures that we never steal the display from
+	 * an active drm master.
+	 */
+	force = var->activate & FB_ACTIVATE_KD_TEXT;
+
+	__drm_fb_helper_restore_fbdev_mode_unlocked(fb_helper, force);
 
 	return 0;
 }
diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 9d28a8e3328fb..e2a490c5ae08f 100644
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
index b6aac7ee1f670..4c14e8be72677 100644
--- a/include/uapi/linux/fb.h
+++ b/include/uapi/linux/fb.h
@@ -205,6 +205,7 @@ struct fb_bitfield {
 #define FB_ACTIVATE_ALL	       64	/* change all VCs on this fb	*/
 #define FB_ACTIVATE_FORCE     128	/* force apply even when no change*/
 #define FB_ACTIVATE_INV_MODE  256       /* invalidate videomode */
+#define FB_ACTIVATE_KD_TEXT   512       /* for KDSET vt ioctl */
 
 #define FB_ACCELF_TEXT		1	/* (OBSOLETE) see fb_info.flags and vc_mode */
 
-- 
2.25.1

