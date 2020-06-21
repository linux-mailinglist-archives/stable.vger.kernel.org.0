Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFDD202A4F
	for <lists+stable@lfdr.de>; Sun, 21 Jun 2020 13:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbgFULbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jun 2020 07:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729878AbgFULbH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Jun 2020 07:31:07 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C29C061794;
        Sun, 21 Jun 2020 04:31:06 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id y13so8015011lfe.9;
        Sun, 21 Jun 2020 04:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=vLxHm548osrnC5LOa8tECZ+kGEmzio+NDVH5jDcBP8M=;
        b=T64gZLSlCueGpECWcPSZejupxlC0oLQYrqx/dtYViWVXfA+VWJKzT8d16CWl+fILOu
         yv3NcPpxcDGPYhQO7B4AmM0G5OlLIM5gF1JHI4sH1aBluasKb+tW1EMItsGlHp52YPJS
         S1bpreD5EWZX9QgrNokFtV1vMlbEomdHe5Twlq3Ts/QaMSTc2LSp6FFFaufsYMbEVQ0M
         dJ5cwPxYs7ujNCKlPJ0PJYqR73gDrYh/DUhU0Zvi3QKUQ8retKH81qaCNfxDMzKnObed
         7AeZzW27vyoc7F/EnleIEVwkpTHBluPeRT7nfiEMW6wtOKXMWWB2B7PJvhoGFbFdZihL
         gxEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=vLxHm548osrnC5LOa8tECZ+kGEmzio+NDVH5jDcBP8M=;
        b=BgI5dz5HRTkt+cT+GWTxqnU9w9+9mjlPzB3og3icjndAgYHMB3W7s3ZLJYTS1gOzTF
         UlNWvYjXninOxoGnBq7pELhVKG3XiPoG8Vd6EMtZN4C6fTVwJruREu4OciEzhoHHoVrm
         jEK1oP20kMOMWu8kdvFdiHvamd6iDax8whTBA8lhho4Hc0DG3njLlf/SXAxdlMCB1j4I
         eofOgxg7iTaN4ixc7IPhSCRH/WNsXo/PgZsMGMZgBYzl7SprroCMu5c1mu/IvOdyS07O
         pTK846Iq960gstXZyS932gp86ry3SmUFS1jOcMOOT/5FPG085mxtwffqDtmLhu3rMPu5
         ur1A==
X-Gm-Message-State: AOAM530E3r4MdQguunWqYKptzy1VvACkRUJw5NOQxOz8BYryswvfDW5S
        U2OsW+461caB473zn8/Z5MhEAX6hOMwm+w==
X-Google-Smtp-Source: ABdhPJyKgXcJ6elxeXLD1CIcJ5uJf4/qeXSlsKHb6g9SH8l4lYpMWjtEaK/dJlMYArxzx83mgvQVLQ==
X-Received: by 2002:a19:f208:: with SMTP id q8mr6044910lfh.172.1592739062232;
        Sun, 21 Jun 2020 04:31:02 -0700 (PDT)
Received: from localhost.localdomain (n2e4fgqko6hxp4lot-1.v6.elisa-mobile.fi. [2001:999:0:6ffe:75bb:c470:73e0:b3cd])
        by smtp.gmail.com with ESMTPSA id m15sm2674400lfk.65.2020.06.21.04.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 04:31:01 -0700 (PDT)
From:   Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
To:     mchehab@kernel.org
Cc:     laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
        stable@vger.kernel.org
Subject: [PATCH] media: media-request: Fix crash if memory allocation fails
Date:   Sun, 21 Jun 2020 14:30:40 +0300
Message-Id: <20200621113040.3540-1-tuomas.tynkkynen@iki.fi>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/media/mc/mc-request.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

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
 
-- 
2.17.1

