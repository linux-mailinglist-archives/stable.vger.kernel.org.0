Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26081B67FE
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbgDWXL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:11:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50246 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728561AbgDWXGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:52 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvd-0004rZ-G2; Fri, 24 Apr 2020 00:06:45 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvZ-00E700-RN; Fri, 24 Apr 2020 00:06:41 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        syzbot+190005201ced78a74ad6@syzkaller.appspotmail.com,
        "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date:   Fri, 24 Apr 2020 00:07:17 +0100
Message-ID: <lsq.1587683028.750035357@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 210/245] vfs: fix do_last() regression
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 6404674acd596de41fd3ad5f267b4525494a891a upstream.

Brown paperbag time: fetching ->i_uid/->i_mode really should've been
done from nd->inode.  I even suggested that, but the reason for that has
slipped through the cracks and I went for dir->d_inode instead - made
for more "obvious" patch.

Analysis:

 - at the entry into do_last() and all the way to step_into(): dir (aka
   nd->path.dentry) is known not to have been freed; so's nd->inode and
   it's equal to dir->d_inode unless we are already doomed to -ECHILD.
   inode of the file to get opened is not known.

 - after step_into(): inode of the file to get opened is known; dir
   might be pointing to freed memory/be negative/etc.

 - at the call of may_create_in_sticky(): guaranteed to be out of RCU
   mode; inode of the file to get opened is known and pinned; dir might
   be garbage.

The last was the reason for the original patch.  Except that at the
do_last() entry we can be in RCU mode and it is possible that
nd->path.dentry->d_inode has already changed under us.

In that case we are going to fail with -ECHILD, but we need to be
careful; nd->inode is pointing to valid struct inode and it's the same
as nd->path.dentry->d_inode in "won't fail with -ECHILD" case, so we
should use that.

Reported-by: "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Reported-by: syzbot+190005201ced78a74ad6@syzkaller.appspotmail.com
Wearing-brown-paperbag: Al Viro <viro@zeniv.linux.org.uk>
Fixes: d0cb50185ae9 ("do_last(): fetch directory ->i_mode and ->i_uid before it's too late")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/namei.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2945,8 +2945,8 @@ static int do_last(struct nameidata *nd,
 		   int *opened, struct filename *name)
 {
 	struct dentry *dir = nd->path.dentry;
-	kuid_t dir_uid = dir->d_inode->i_uid;
-	umode_t dir_mode = dir->d_inode->i_mode;
+	kuid_t dir_uid = nd->inode->i_uid;
+	umode_t dir_mode = nd->inode->i_mode;
 	int open_flag = op->open_flag;
 	bool will_truncate = (open_flag & O_TRUNC) != 0;
 	bool got_write = false;

