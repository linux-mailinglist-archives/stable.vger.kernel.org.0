Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A642474CF
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387459AbgHQTPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:15:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387456AbgHQPjo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:39:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4ACCC23123;
        Mon, 17 Aug 2020 15:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678783;
        bh=fW0PLUaemraPxR56ZlLLDoiTZLlCiLqb4+qpdqoPWUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eChT69/B5mNbtmnDhFCzUyCa8xLzZJ4XN+fztJLrsGgSugKwA6Q1mJ2jYwPlfTy65
         Zkez+nBXN0q0aRxiE5LkWjpo7GZgWviedipK079RsXeqF7LULC5cyURZXRY2/iWPjK
         r+5ckWW7KZqBWZMw8XzTRQ4PR0i9rvG/uYpjS/fU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6bed2d543cf7e48b822b@syzkaller.appspotmail.com,
        Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.8 422/464] media: media-request: Fix crash if memory allocation fails
Date:   Mon, 17 Aug 2020 17:16:15 +0200
Message-Id: <20200817143853.988809228@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>

commit e30cc79cc80fd919b697a15c5000d9f57487de8e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/mc/mc-request.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

--- a/drivers/media/mc/mc-request.c
+++ b/drivers/media/mc/mc-request.c
@@ -296,9 +296,18 @@ int media_request_alloc(struct media_dev
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
@@ -306,15 +315,6 @@ int media_request_alloc(struct media_dev
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
@@ -336,12 +336,15 @@ int media_request_alloc(struct media_dev
 
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
 


