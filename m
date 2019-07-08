Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64BB261DF4
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 13:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730603AbfGHLvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 07:51:36 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:47153 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727286AbfGHLvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 07:51:36 -0400
Received: by mail-pg1-f202.google.com with SMTP id o19so10340096pgl.14
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 04:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=RUO0cgtogOledx1PUbIVwBv1WP5SbTQS/eUbtx6ca1A=;
        b=B0OFmaHSy+LoXPkMA2Ul+miuzJXjvdo9LY8EJgk2lFUHwSUSB4ZmtFqaWavAsdj4od
         snl/VTXx4lCoKMHUKCW4oO5innRUxx+6QMFHQHWdZV2KLezn4+jOtVMpJlLJd8OXJpno
         J2bSSy8JyaZrLnQvfe9GOQm1/PRFnQ7QeIgWKOUPn72NqRKyO9M5wgG+YfYcF/AMnASr
         VuuZb+NvgEQpvoUdHvQ/2N2MZ8IiQ2nSYCrSHYvDQ8RfD/1DbPl7gHQGaYM/weFidX+5
         wVgeuPwmOQCZaeIfiPaH6FY2Q69hwYyORxDxBiM7C0EzotWxKYRGMr9y7prf4uIkXGsc
         m2Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=RUO0cgtogOledx1PUbIVwBv1WP5SbTQS/eUbtx6ca1A=;
        b=ISFhGOlBOpyKVtEfCrVvjLGo5Axxtmy4aYcJ1HbWW7UYZaAqiQCqlZik9qdnYfGQ6a
         /RlfqX6XXqOyiciAUzEPcO4EmK3BoD/djO5BZiJ3oLn4EHOqEytkSsSxO+M5c6YYU//u
         xL8Yladj5Ah4VPTvyz7SMsb0jY3cICWeachZoDbkQozGUVJGLJd2OzAuzXgoeAiDthxd
         ttjz78X6QduainPh+RjmY94CvI6w2s6WMQxs26uabDZfe6muV1bo75EhEJ4iYjRCPDv/
         az14PgalBnUiBGoTCX+myuldPtY0u4quk4H7ogdRrhxyH55FTKbSDKzvdack6CpmLxwI
         CicA==
X-Gm-Message-State: APjAAAXQ2OWBpB7lVNh97SQz6CrCXdjP8qSq1eJoBodB7hdnNkgavdhq
        C8QvFGsdSZD5iEDEKOfCRHLN1sorC5Y=
X-Google-Smtp-Source: APXvYqyy3wqolz5H6URclfrxPsjBk3fSL9runmXFQbRxI7E/LFW05znauTpADCA+6Xq5+MqfLTdxro38OnM=
X-Received: by 2002:a65:49cc:: with SMTP id t12mr6413038pgs.83.1562586695288;
 Mon, 08 Jul 2019 04:51:35 -0700 (PDT)
Date:   Mon,  8 Jul 2019 13:51:30 +0200
Message-Id: <20190708115130.250149-1-rburny@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH v3] fs: Fix the default values of i_uid/i_gid on /proc/sys inodes.
From:   Radoslaw Burny <rburny@google.com>
To:     "Luis R . Rodriguez" <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Seth Forshee <seth.forshee@canonical.com>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jsperbeck@google.com, Andrew Morton <akpm@linux-foundation.org>,
        Radoslaw Burny <rburny@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

fs: Fix the default values of i_uid/i_gid on /proc/sys inodes.
Normally, the inode's i_uid/i_gid are translated relative to s_user_ns,
but this is not a correct behavior for proc. Since sysctl permission
check in test_perm is done against GLOBAL_ROOT_[UG]ID, it makes more
sense to use these values in u_[ug]id of proc inodes.
In other words: although uid/gid in the inode is not read during
test_perm, the inode logically belongs to the root of the namespace.
I have confirmed this with Eric Biederman at LPC and in this thread:
https://lore.kernel.org/lkml/87k1kzjdff.fsf@xmission.com

Consequences
============
Since the i_[ug]id values of proc nodes are not used for permissions
checks, this change usually makes no functional difference. However, it
causes an issue in a setup where:
* a namespace container is created without root user in container -
  hence the i_[ug]id of proc nodes are set to INVALID_[UG]ID
* container creator tries to configure it by writing /proc/sys files,
  e.g. writing /proc/sys/kernel/shmmax to configure shared memory limit
Kernel does not allow to open an inode for writing if its i_[ug]id are
invalid, making it impossible to write shmmax and thus - configure the
container.
Using a container with no root mapping is apparently rare, but we do use
this configuration at Google. Also, we use a generic tool to configure
the container limits, and the inability to write any of them causes a
failure.

History
=======
The invalid uids/gids in inodes first appeared due to 81754357770e (fs:
Update i_[ug]id_(read|write) to translate relative to s_user_ns).
However, AFAIK, this did not immediately cause any issues.
The inability to write to these "invalid" inodes was only caused by a
later commit 0bd23d09b874 (vfs: Don't modify inodes with a uid or gid
unknown to the vfs).

Tested: Used a repro program that creates a user namespace without any
mapping and stat'ed /proc/$PID/root/proc/sys/kernel/shmmax from outside.
Before the change, it shows the overflow uid, with the change it's 0.
The overflow uid indicates that the uid in the inode is not correct and
thus it is not possible to open the file for writing.

Fixes: 0bd23d09b874 ("vfs: Don't modify inodes with a uid or gid unknown to the vfs")
Cc: stable@vger.kernel.org # v4.8+
Signed-off-by: Radoslaw Burny <rburny@google.com>
---
Changelog since v1:
  - Updated the commit title and description.

 fs/proc/proc_sysctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index c74570736b24..36ad1b0d6259 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -499,6 +499,10 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
 
 	if (root->set_ownership)
 		root->set_ownership(head, table, &inode->i_uid, &inode->i_gid);
+	else {
+		inode->i_uid = GLOBAL_ROOT_UID;
+		inode->i_gid = GLOBAL_ROOT_GID;
+	}
 
 	return inode;
 }
-- 
2.22.0.410.gd8fdbe21b5-goog

