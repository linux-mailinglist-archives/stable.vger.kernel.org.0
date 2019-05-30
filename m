Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC93B2F6C4
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbfE3DJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:09:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727714AbfE3DJm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:09:42 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA9E92449D;
        Thu, 30 May 2019 03:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185781;
        bh=UsFW2WMeKH4TU8vVUZkJTsBG0FvfjkCzrrPteFtjy3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L4CQgZM6mDjEfNx3jWu3pK9Ia4HDYqlhT0pZJdqpZkyeavvcEeqehWJDb3R1obUIa
         zo6cYjc/FnVTkUMlRtb7CyNMerbgH4JH6X/QnrTOu8dizgc8mMpwVzhCVmH6jurGpL
         njEvFceFiGksj0RwycGIVDtIexDA3VEcyelNFFO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        syzbot+2a73a6ea9507b7112141@syzkaller.appspotmail.com,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.1 042/405] acct_on(): dont mess with freeze protection
Date:   Wed, 29 May 2019 20:00:40 -0700
Message-Id: <20190530030542.908792698@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 9419a3191dcb27f24478d288abaab697228d28e6 upstream.

What happens there is that we are replacing file->path.mnt of
a file we'd just opened with a clone and we need the write
count contribution to be transferred from original mount to
new one.  That's it.  We do *NOT* want any kind of freeze
protection for the duration of switchover.

IOW, we should just use __mnt_{want,drop}_write() for that
switchover; no need to bother with mnt_{want,drop}_write()
there.

Tested-by: Amir Goldstein <amir73il@gmail.com>
Reported-by: syzbot+2a73a6ea9507b7112141@syzkaller.appspotmail.com
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/internal.h         |    2 --
 include/linux/mount.h |    2 ++
 kernel/acct.c         |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/fs/internal.h
+++ b/fs/internal.h
@@ -89,9 +89,7 @@ extern int sb_prepare_remount_readonly(s
 
 extern void __init mnt_init(void);
 
-extern int __mnt_want_write(struct vfsmount *);
 extern int __mnt_want_write_file(struct file *);
-extern void __mnt_drop_write(struct vfsmount *);
 extern void __mnt_drop_write_file(struct file *);
 
 /*
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -87,6 +87,8 @@ extern bool mnt_may_suid(struct vfsmount
 
 struct path;
 extern struct vfsmount *clone_private_mount(const struct path *path);
+extern int __mnt_want_write(struct vfsmount *);
+extern void __mnt_drop_write(struct vfsmount *);
 
 struct file_system_type;
 extern struct vfsmount *fc_mount(struct fs_context *fc);
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -227,7 +227,7 @@ static int acct_on(struct filename *path
 		filp_close(file, NULL);
 		return PTR_ERR(internal);
 	}
-	err = mnt_want_write(internal);
+	err = __mnt_want_write(internal);
 	if (err) {
 		mntput(internal);
 		kfree(acct);
@@ -252,7 +252,7 @@ static int acct_on(struct filename *path
 	old = xchg(&ns->bacct, &acct->pin);
 	mutex_unlock(&acct->lock);
 	pin_kill(old);
-	mnt_drop_write(mnt);
+	__mnt_drop_write(mnt);
 	mntput(mnt);
 	return 0;
 }


