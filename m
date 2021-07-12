Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC0C3C527C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346571AbhGLHql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:46:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349787AbhGLHoq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:44:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8848E613C8;
        Mon, 12 Jul 2021 07:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075673;
        bh=9D+4xV9JEt9v6tbd93WwvHLrr28U73iDqplSo5mrgLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RNkwJqx3F+coJDKMQvt9OeZjtNhxijsUqiDCrKazqAA4TL7mU7oZB9m1IfEg/2gu2
         NPG9vUw8EtiQOGveSvP+2oF32O6darLK+DaTqvlzS4RizDmViG9Clw/+MtG51tPgCy
         VUK1lNLrZZbI9+zcv7m9IGfwJk1zhvpkoucB2qTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+142888ffec98ab194028@syzkaller.appspotmail.com,
        Arnd Bergmann <arnd@arndb.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 315/800] media: v4l2-core: ignore native time32 ioctls on 64-bit
Date:   Mon, 12 Jul 2021 08:05:38 +0200
Message-Id: <20210712060959.190161718@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit c344f07aa1b4ba38ca8fabe407a2afe2f436323c ]

Syzbot found that passing ioctl command 0xc0505609 into a 64-bit
kernel from a 32-bit process causes uninitialized kernel memory to
get passed to drivers instead of the user space data:

BUG: KMSAN: uninit-value in check_array_args drivers/media/v4l2-core/v4l2-ioctl.c:3041 [inline]
BUG: KMSAN: uninit-value in video_usercopy+0x1631/0x3d30 drivers/media/v4l2-core/v4l2-ioctl.c:3315
CPU: 0 PID: 19595 Comm: syz-executor.4 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 check_array_args drivers/media/v4l2-core/v4l2-ioctl.c:3041 [inline]
 video_usercopy+0x1631/0x3d30 drivers/media/v4l2-core/v4l2-ioctl.c:3315
 video_ioctl2+0x9f/0xb0 drivers/media/v4l2-core/v4l2-ioctl.c:3391
 v4l2_ioctl+0x255/0x290 drivers/media/v4l2-core/v4l2-dev.c:360
 v4l2_compat_ioctl32+0x2c6/0x370 drivers/media/v4l2-core/v4l2-compat-ioctl32.c:1248
 __do_compat_sys_ioctl fs/ioctl.c:842 [inline]
 __se_compat_sys_ioctl+0x53d/0x1100 fs/ioctl.c:793
 __ia32_compat_sys_ioctl+0x4a/0x70 fs/ioctl.c:793
 do_syscall_32_irqs_on arch/x86/entry/common.c:79 [inline]
 __do_fast_syscall_32+0x102/0x160 arch/x86/entry/common.c:141
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:166
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:209
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

The time32 commands are defined but were never meant to be called on
64-bit machines, as those have always used time64 interfaces.  I missed
this in my patch that introduced the time64 handling on 32-bit platforms.

The problem in this case is the mismatch of one function checking for
the numeric value of the command and another function checking for the
type of process (native vs compat) instead, with the result being that
for this combination, nothing gets copied into the buffer at all.

Avoid this by only trying to convert the time32 commands when running
on a 32-bit kernel where these are defined in a meaningful way.

[hverkuil: fix 3 warnings: switch with no cases]

Fixes: 577c89b0ce72 ("media: v4l2-core: fix v4l2_buffer handling for time64 ABI")
Reported-by: syzbot+142888ffec98ab194028@syzkaller.appspotmail.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 2673f51aafa4..07d823656ee6 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -3072,8 +3072,8 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
 
 static unsigned int video_translate_cmd(unsigned int cmd)
 {
+#if !defined(CONFIG_64BIT) && defined(CONFIG_COMPAT_32BIT_TIME)
 	switch (cmd) {
-#ifdef CONFIG_COMPAT_32BIT_TIME
 	case VIDIOC_DQEVENT_TIME32:
 		return VIDIOC_DQEVENT;
 	case VIDIOC_QUERYBUF_TIME32:
@@ -3084,8 +3084,8 @@ static unsigned int video_translate_cmd(unsigned int cmd)
 		return VIDIOC_DQBUF;
 	case VIDIOC_PREPARE_BUF_TIME32:
 		return VIDIOC_PREPARE_BUF;
-#endif
 	}
+#endif
 	if (in_compat_syscall())
 		return v4l2_compat_translate_cmd(cmd);
 
@@ -3126,8 +3126,8 @@ static int video_get_user(void __user *arg, void *parg,
 	} else if (in_compat_syscall()) {
 		err = v4l2_compat_get_user(arg, parg, cmd);
 	} else {
+#if !defined(CONFIG_64BIT) && defined(CONFIG_COMPAT_32BIT_TIME)
 		switch (cmd) {
-#ifdef CONFIG_COMPAT_32BIT_TIME
 		case VIDIOC_QUERYBUF_TIME32:
 		case VIDIOC_QBUF_TIME32:
 		case VIDIOC_DQBUF_TIME32:
@@ -3155,8 +3155,8 @@ static int video_get_user(void __user *arg, void *parg,
 			};
 			break;
 		}
-#endif
 		}
+#endif
 	}
 
 	/* zero out anything we don't copy from userspace */
@@ -3181,8 +3181,8 @@ static int video_put_user(void __user *arg, void *parg,
 	if (in_compat_syscall())
 		return v4l2_compat_put_user(arg, parg, cmd);
 
+#if !defined(CONFIG_64BIT) && defined(CONFIG_COMPAT_32BIT_TIME)
 	switch (cmd) {
-#ifdef CONFIG_COMPAT_32BIT_TIME
 	case VIDIOC_DQEVENT_TIME32: {
 		struct v4l2_event *ev = parg;
 		struct v4l2_event_time32 ev32;
@@ -3230,8 +3230,8 @@ static int video_put_user(void __user *arg, void *parg,
 			return -EFAULT;
 		break;
 	}
-#endif
 	}
+#endif
 
 	return 0;
 }
-- 
2.30.2



