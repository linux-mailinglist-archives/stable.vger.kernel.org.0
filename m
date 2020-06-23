Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC4E20534B
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 15:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732608AbgFWNUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 09:20:08 -0400
Received: from www.linuxtv.org ([130.149.80.248]:58200 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732580AbgFWNUI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 09:20:08 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1jnimF-0068J1-3O; Tue, 23 Jun 2020 13:15:51 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Tue, 23 Jun 2020 13:19:37 +0000
Subject: [git:media_tree/master] media: media-request: Fix crash if memory allocation fails
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1jnimF-0068J1-3O@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: media-request: Fix crash if memory allocation fails
Author:  Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
Date:    Sun Jun 21 13:30:40 2020 +0200

Syzbot reports a NULL-ptr deref in the kref_put() call:

BUG: KASAN: null-ptr-deref in media_request_put drivers/media/mc/mc-request.c:81 [inline]
 kref_put include/linux/kref.h:64 [inline]
 media_request_put drivers/media/mc/mc-request.c:81 [inline]
 media_request_close+0x4d/0x170 drivers/media/mc/mc-request.c:89
 __fput+0x2ed/0x750 fs/file_table.c:281
 task_work_run+0x147/0x1d0 kernel/task_work.c:123
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop arch/x86/entry/common.c:165 [inline]
 prepare_exit_to_usermode+0x48e/0x600 arch/x86/entry/common.c:196

What led to this crash was an injected memory allocation failure in
media_request_alloc():

FAULT_INJECTION: forcing a failure.
name failslab, interval 1, probability 0, space 0, times 0
 should_failslab+0x5/0x20
 kmem_cache_alloc_trace+0x57/0x300
 ? anon_inode_getfile+0xe5/0x170
 media_request_alloc+0x339/0x440
 media_device_request_alloc+0x94/0xc0
 media_device_ioctl+0x1fb/0x330
 ? do_vfs_ioctl+0x6ea/0x1a00
 ? media_ioctl+0x101/0x120
 ? __media_device_usb_init+0x430/0x430
 ? media_poll+0x110/0x110
 __se_sys_ioctl+0xf9/0x160
 do_syscall_64+0xf3/0x1b0

When that allocation fails, filp->private_data is left uninitialized
which media_request_close() does not expect and crashes.

To avoid this, reorder media_request_alloc() such that
allocating the struct file happens as the last step thus
media_request_close() will no longer get called for a partially created
media request.

Reported-by: syzbot+6bed2d543cf7e48b822b@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
Fixes: 10905d70d788 ("media: media-request: implement media requests")
Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/mc/mc-request.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

---

diff --git a/drivers/media/mc/mc-request.c b/drivers/media/mc/mc-request.c
index e3fca436c75b..c0782fd96c59 100644
--- a/drivers/media/mc/mc-request.c
+++ b/drivers/media/mc/mc-request.c
@@ -296,9 +296,18 @@ int media_request_alloc(struct media_device *mdev, int *alloc_fd)
 	if (WARN_ON(!mdev->ops->req_alloc ^ !mdev->ops->req_free))
 		return -ENOMEM;
 
+	if (mdev->ops->req_alloc)
+		req = mdev->ops->req_alloc(mdev);
+	else
+		req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
 	fd = get_unused_fd_flags(O_CLOEXEC);
-	if (fd < 0)
-		return fd;
+	if (fd < 0) {
+		ret = fd;
+		goto err_free_req;
+	}
 
 	filp = anon_inode_getfile("request", &request_fops, NULL, O_CLOEXEC);
 	if (IS_ERR(filp)) {
@@ -306,15 +315,6 @@ int media_request_alloc(struct media_device *mdev, int *alloc_fd)
 		goto err_put_fd;
 	}
 
-	if (mdev->ops->req_alloc)
-		req = mdev->ops->req_alloc(mdev);
-	else
-		req = kzalloc(sizeof(*req), GFP_KERNEL);
-	if (!req) {
-		ret = -ENOMEM;
-		goto err_fput;
-	}
-
 	filp->private_data = req;
 	req->mdev = mdev;
 	req->state = MEDIA_REQUEST_STATE_IDLE;
@@ -336,12 +336,15 @@ int media_request_alloc(struct media_device *mdev, int *alloc_fd)
 
 	return 0;
 
-err_fput:
-	fput(filp);
-
 err_put_fd:
 	put_unused_fd(fd);
 
+err_free_req:
+	if (mdev->ops->req_free)
+		mdev->ops->req_free(req);
+	else
+		kfree(req);
+
 	return ret;
 }
 
