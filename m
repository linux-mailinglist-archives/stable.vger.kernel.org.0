Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9F8F9E7A
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 00:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfKLXva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 18:51:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57356 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727020AbfKLXug (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 18:50:36 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUfvd-0008IO-WB; Tue, 12 Nov 2019 23:50:34 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUfvc-00057h-Tn; Tue, 12 Nov 2019 23:50:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Vandana BN" <bnvandana@gmail.com>,
        syzbot+66010012fd4c531a1a96@syzkaller.appspotmail.com,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        "Hans Verkuil" <hverkuil-cisco@xs4all.nl>
Date:   Tue, 12 Nov 2019 23:48:14 +0000
Message-ID: <lsq.1573602477.179773981@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 17/25] media: usb:zr364xx:Fix KASAN:null-ptr-deref
 Read in zr364xx_vidioc_querycap
In-Reply-To: <lsq.1573602477.548403712@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.77-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vandana BN <bnvandana@gmail.com>

commit 5d2e73a5f80a5b5aff3caf1ec6d39b5b3f54b26e upstream.

SyzKaller hit the null pointer deref while reading from uninitialized
udev->product in zr364xx_vidioc_querycap().

==================================================================
BUG: KASAN: null-ptr-deref in read_word_at_a_time+0xe/0x20
include/linux/compiler.h:274
Read of size 1 at addr 0000000000000000 by task v4l_id/5287

CPU: 1 PID: 5287 Comm: v4l_id Not tainted 5.1.0-rc3-319004-g43151d6 #6
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0xe8/0x16e lib/dump_stack.c:113
  kasan_report.cold+0x5/0x3c mm/kasan/report.c:321
  read_word_at_a_time+0xe/0x20 include/linux/compiler.h:274
  strscpy+0x8a/0x280 lib/string.c:207
  zr364xx_vidioc_querycap+0xb5/0x210 drivers/media/usb/zr364xx/zr364xx.c:706
  v4l_querycap+0x12b/0x340 drivers/media/v4l2-core/v4l2-ioctl.c:1062
  __video_do_ioctl+0x5bb/0xb40 drivers/media/v4l2-core/v4l2-ioctl.c:2874
  video_usercopy+0x44e/0xf00 drivers/media/v4l2-core/v4l2-ioctl.c:3056
  v4l2_ioctl+0x14e/0x1a0 drivers/media/v4l2-core/v4l2-dev.c:364
  vfs_ioctl fs/ioctl.c:46 [inline]
  file_ioctl fs/ioctl.c:509 [inline]
  do_vfs_ioctl+0xced/0x12f0 fs/ioctl.c:696
  ksys_ioctl+0xa0/0xc0 fs/ioctl.c:713
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x74/0xb0 fs/ioctl.c:718
  do_syscall_64+0xcf/0x4f0 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f3b56d8b347
Code: 90 90 90 48 8b 05 f1 fa 2a 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff
ff c3 90 90 90 90 90 90 90 90 90 90 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff
ff 73 01 c3 48 8b 0d c1 fa 2a 00 31 d2 48 29 c2 64
RSP: 002b:00007ffe005d5d68 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f3b56d8b347
RDX: 00007ffe005d5d70 RSI: 0000000080685600 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000400884
R13: 00007ffe005d5ec0 R14: 0000000000000000 R15: 0000000000000000
==================================================================

For this device udev->product is not initialized and accessing it causes a NULL pointer deref.

The fix is to check for NULL before strscpy() and copy empty string, if
product is NULL

Reported-by: syzbot+66010012fd4c531a1a96@syzkaller.appspotmail.com
Signed-off-by: Vandana BN <bnvandana@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/usb/zr364xx/zr364xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -712,7 +712,8 @@ static int zr364xx_vidioc_querycap(struc
 	struct zr364xx_camera *cam = video_drvdata(file);
 
 	strlcpy(cap->driver, DRIVER_DESC, sizeof(cap->driver));
-	strlcpy(cap->card, cam->udev->product, sizeof(cap->card));
+	if (cam->udev->product)
+		strlcpy(cap->card, cam->udev->product, sizeof(cap->card));
 	strlcpy(cap->bus_info, dev_name(&cam->udev->dev),
 		sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |

