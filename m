Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A798873B3B
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392162AbfGXT6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:58:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392151AbfGXT57 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:57:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B0E122ADC;
        Wed, 24 Jul 2019 19:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998278;
        bh=AILK7DP9X50hhJTzq8VqHW7fZk/yuQgyTU9wiXDKOBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PWFNIlClTfxLYIfVHiWlMDj/X90V64fI+w0s7DQBkPQ06szAXdYIg7CvYBQwlIt4u
         fvNK+P1mEFhYo4HqzDwk8Z8X5x1n+YuRvKtvKJ+VM9Pm3IbrFgcwFpUx868Y326mPu
         USRmyr4P3/v7YlhPN5xaTpy1umhqchhXWszsTTw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Radoslaw Burny <rburny@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        John Sperbeck <jsperbeck@google.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.1 310/371] fs/proc/proc_sysctl.c: fix the default values of i_uid/i_gid on /proc/sys inodes.
Date:   Wed, 24 Jul 2019 21:21:02 +0200
Message-Id: <20190724191747.441574900@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Radoslaw Burny <rburny@google.com>

commit 5ec27ec735ba0477d48c80561cc5e856f0c5dfaf upstream.

Normally, the inode's i_uid/i_gid are translated relative to s_user_ns,
but this is not a correct behavior for proc.  Since sysctl permission
check in test_perm is done against GLOBAL_ROOT_[UG]ID, it makes more
sense to use these values in u_[ug]id of proc inodes.  In other words:
although uid/gid in the inode is not read during test_perm, the inode
logically belongs to the root of the namespace.  I have confirmed this
with Eric Biederman at LPC and in this thread:
  https://lore.kernel.org/lkml/87k1kzjdff.fsf@xmission.com

Consequences
============

Since the i_[ug]id values of proc nodes are not used for permissions
checks, this change usually makes no functional difference.  However, it
causes an issue in a setup where:

 * a namespace container is created without root user in container -
   hence the i_[ug]id of proc nodes are set to INVALID_[UG]ID

 * container creator tries to configure it by writing /proc/sys files,
   e.g. writing /proc/sys/kernel/shmmax to configure shared memory limit

Kernel does not allow to open an inode for writing if its i_[ug]id are
invalid, making it impossible to write shmmax and thus - configure the
container.

Using a container with no root mapping is apparently rare, but we do use
this configuration at Google.  Also, we use a generic tool to configure
the container limits, and the inability to write any of them causes a
failure.

History
=======

The invalid uids/gids in inodes first appeared due to 81754357770e (fs:
Update i_[ug]id_(read|write) to translate relative to s_user_ns).
However, AFAIK, this did not immediately cause any issues.  The
inability to write to these "invalid" inodes was only caused by a later
commit 0bd23d09b874 (vfs: Don't modify inodes with a uid or gid unknown
to the vfs).

Tested: Used a repro program that creates a user namespace without any
mapping and stat'ed /proc/$PID/root/proc/sys/kernel/shmmax from outside.
Before the change, it shows the overflow uid, with the change it's 0.
The overflow uid indicates that the uid in the inode is not correct and
thus it is not possible to open the file for writing.

Link: http://lkml.kernel.org/r/20190708115130.250149-1-rburny@google.com
Fixes: 0bd23d09b874 ("vfs: Don't modify inodes with a uid or gid unknown to the vfs")
Signed-off-by: Radoslaw Burny <rburny@google.com>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: John Sperbeck <jsperbeck@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: <stable@vger.kernel.org>	[4.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/proc_sysctl.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -498,6 +498,10 @@ static struct inode *proc_sys_make_inode
 
 	if (root->set_ownership)
 		root->set_ownership(head, table, &inode->i_uid, &inode->i_gid);
+	else {
+		inode->i_uid = GLOBAL_ROOT_UID;
+		inode->i_gid = GLOBAL_ROOT_GID;
+	}
 
 	return inode;
 }


