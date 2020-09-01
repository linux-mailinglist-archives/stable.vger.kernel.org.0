Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C16925977C
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731464AbgIAQO7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:14:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731208AbgIAPfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:35:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FA4F205F4;
        Tue,  1 Sep 2020 15:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974508;
        bh=plGUxLET0oujABFoLlyotfUbHiJsGU5G4XC+4kPwuu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ctY0z4MFJT4OtXb2YISyTISO+KiQeulO2lX3nj67ebU+1IhRPdC7BPfb+O9GZPj0
         +z5CDaTZDt8ULG18FYTYyvQ7rctYAf/4uM7dCwDq8I70uuO826OeFYnUhC6JuZdWPn
         5nLDD5rCL5tmtnfEjpQ+f+EPBUXFEhM/c7M+rLyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Sasha Levin <sashal@kernel.org>,
        syzbot <syzbot+c37a14770d51a085a520@syzkaller.appspotmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 5.4 204/214] fbmem: pull fbcon_update_vcs() out of fb_set_var()
Date:   Tue,  1 Sep 2020 17:11:24 +0200
Message-Id: <20200901151002.703499832@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

[ Upstream commit d88ca7e1a27eb2df056bbf37ddef62e1c73d37ea ]

syzbot is reporting OOB read bug in vc_do_resize() [1] caused by memcpy()
based on outdated old_{rows,row_size} values, for resize_screen() can
recurse into vc_do_resize() which changes vc->vc_{cols,rows} that outdates
old_{rows,row_size} values which were saved before calling resize_screen().

Daniel Vetter explained that resize_screen() should not recurse into
fbcon_update_vcs() path due to FBINFO_MISC_USEREVENT being still set
when calling resize_screen().

Instead of masking FBINFO_MISC_USEREVENT before calling fbcon_update_vcs(),
we can remove FBINFO_MISC_USEREVENT by calling fbcon_update_vcs() only if
fb_set_var() returned 0. This change assumes that it is harmless to call
fbcon_update_vcs() when fb_set_var() returned 0 without reaching
fb_notifier_call_chain().

[1] https://syzkaller.appspot.com/bug?id=c70c88cfd16dcf6e1d3c7f0ab8648b3144b5b25e

Reported-and-tested-by: syzbot <syzbot+c37a14770d51a085a520@syzkaller.appspotmail.com>
Suggested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: kernel test robot <lkp@intel.com> for missing #include
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/075b7e37-3278-cd7d-31ab-c5073cfa8e92@i-love.sakura.ne.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbmem.c   | 8 ++------
 drivers/video/fbdev/core/fbsysfs.c | 4 ++--
 drivers/video/fbdev/ps3fb.c        | 5 +++--
 include/linux/fb.h                 | 2 --
 4 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index e72738371ecbe..97abcd497c7e0 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -952,7 +952,6 @@ static int fb_check_caps(struct fb_info *info, struct fb_var_screeninfo *var,
 int
 fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
 {
-	int flags = info->flags;
 	int ret = 0;
 	u32 activate;
 	struct fb_var_screeninfo old_var;
@@ -1047,9 +1046,6 @@ fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
 	event.data = &mode;
 	fb_notifier_call_chain(FB_EVENT_MODE_CHANGE, &event);
 
-	if (flags & FBINFO_MISC_USEREVENT)
-		fbcon_update_vcs(info, activate & FB_ACTIVATE_ALL);
-
 	return 0;
 }
 EXPORT_SYMBOL(fb_set_var);
@@ -1100,9 +1096,9 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 			return -EFAULT;
 		console_lock();
 		lock_fb_info(info);
-		info->flags |= FBINFO_MISC_USEREVENT;
 		ret = fb_set_var(info, &var);
-		info->flags &= ~FBINFO_MISC_USEREVENT;
+		if (!ret)
+			fbcon_update_vcs(info, var.activate & FB_ACTIVATE_ALL);
 		unlock_fb_info(info);
 		console_unlock();
 		if (!ret && copy_to_user(argp, &var, sizeof(var)))
diff --git a/drivers/video/fbdev/core/fbsysfs.c b/drivers/video/fbdev/core/fbsysfs.c
index d54c88f88991d..65dae05fff8e6 100644
--- a/drivers/video/fbdev/core/fbsysfs.c
+++ b/drivers/video/fbdev/core/fbsysfs.c
@@ -91,9 +91,9 @@ static int activate(struct fb_info *fb_info, struct fb_var_screeninfo *var)
 
 	var->activate |= FB_ACTIVATE_FORCE;
 	console_lock();
-	fb_info->flags |= FBINFO_MISC_USEREVENT;
 	err = fb_set_var(fb_info, var);
-	fb_info->flags &= ~FBINFO_MISC_USEREVENT;
+	if (!err)
+		fbcon_update_vcs(fb_info, var->activate & FB_ACTIVATE_ALL);
 	console_unlock();
 	if (err)
 		return err;
diff --git a/drivers/video/fbdev/ps3fb.c b/drivers/video/fbdev/ps3fb.c
index 5ed2db39d8236..ce90483c50209 100644
--- a/drivers/video/fbdev/ps3fb.c
+++ b/drivers/video/fbdev/ps3fb.c
@@ -29,6 +29,7 @@
 #include <linux/freezer.h>
 #include <linux/uaccess.h>
 #include <linux/fb.h>
+#include <linux/fbcon.h>
 #include <linux/init.h>
 
 #include <asm/cell-regs.h>
@@ -824,12 +825,12 @@ static int ps3fb_ioctl(struct fb_info *info, unsigned int cmd,
 				var = info->var;
 				fb_videomode_to_var(&var, vmode);
 				console_lock();
-				info->flags |= FBINFO_MISC_USEREVENT;
 				/* Force, in case only special bits changed */
 				var.activate |= FB_ACTIVATE_FORCE;
 				par->new_mode_id = val;
 				retval = fb_set_var(info, &var);
-				info->flags &= ~FBINFO_MISC_USEREVENT;
+				if (!retval)
+					fbcon_update_vcs(info, var.activate & FB_ACTIVATE_ALL);
 				console_unlock();
 			}
 			break;
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 756706b666a10..8221838fefd98 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -400,8 +400,6 @@ struct fb_tile_ops {
 #define FBINFO_HWACCEL_YPAN		0x2000 /* optional */
 #define FBINFO_HWACCEL_YWRAP		0x4000 /* optional */
 
-#define FBINFO_MISC_USEREVENT          0x10000 /* event request
-						  from userspace */
 #define FBINFO_MISC_TILEBLITTING       0x20000 /* use tile blitting */
 
 /* A driver may set this flag to indicate that it does want a set_par to be
-- 
2.25.1



