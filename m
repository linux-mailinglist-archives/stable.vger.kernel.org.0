Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D864B1F7E3E
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 22:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgFLUvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 16:51:11 -0400
Received: from sw.superlogical.ch ([37.221.197.145]:41680 "EHLO
        sw.superlogical.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgFLUvL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jun 2020 16:51:11 -0400
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Jun 2020 16:51:09 EDT
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7FE71C22FD;
        Fri, 12 Jun 2020 22:45:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hb9fxq.ch; s=default;
        t=1591994718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qHp/m2Gy26r3yf383RnnXIgRESJmOazQYEIPxbTV9LY=;
        b=SaQIzU+YWlJ355QV5sqW3VDQa4lrRdm9Zg3RJNwdwnlwrzAVMIcRFQgzv0N30F6LO0prvm
        oRYkNmagGjKVT6kXwL/5zbhCHUZ5Ml9T/NC9M0qb+Agd39/qxsAeUW4pCbdS8T5P8TW25I
        /WWqX4bWgml8nzlShDoXzmP8wgNdNAq6HVCsbhojG2EpLpKDUt+hgiV2ARWMv+A27pSwtF
        ala++JvFaArq+RZjWyOQv4IbYJEpQ1hQmbn/fS/EkjkYj3kdneyEOwJVlQAOXB4PwiAYSk
        OE3yYuZMPniSZULXPlPd4X+Y6U4VDLYZeIy1cdzzPE5b0NTVBox/+Soqgn/EQw==
From:   Frank Werner-Krippendorf <mail@hb9fxq.ch>
To:     mail@kripp.ch
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        stable@vger.kernel.org,
        syzbot+7d2debdcdb3cb93c1e5e@syzkaller.appspotmail.com
Date:   Fri, 12 Jun 2020 22:45:21 +0200
Message-Id: <20200612204521.16722-1-mail@hb9fxq.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: =?UTF-8?B?WzdkMmRlYmRjZGIzY2I5M2MxZTVlXSBbUEFUQ0ggdjJdIHByb2M6IFVzZSBuZXdfaW5vZGUgbm90IG5ld19pbm9kZV9wc2V1ZG8=?=
X-Last-TLS-Session-Version: TLSv1.3
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Recently syzbot reported that unmounting proc when there is an ongoing
inotify watch on the root directory of proc could result in a use
after free when the watch is removed after the unmount of proc
when the watcher exits.

Commit 69879c01a0c3 ("proc: Remove the now unnecessary internal mount
of proc") made it easier to unmount proc and allowed syzbot to see the
problem, but looking at the code it has been around for a long time.

Looking at the code the fsnotify watch should have been removed by
fsnotify_sb_delete in generic_shutdown_super.  Unfortunately the inode
was allocated with new_inode_pseudo instead of new_inode so the inode
was not on the sb->s_inodes list.  Which prevented
fsnotify_unmount_inodes from finding the inode and removing the watch
as well as made it so the "VFS: Busy inodes after unmount" warning
could not find the inodes to warn about them.

Make all of the inodes in proc visible to generic_shutdown_super,
and fsnotify_sb_delete by using new_inode instead of new_inode_pseudo.
The only functional difference is that new_inode places the inodes
on the sb->s_inodes list.

I wrote a small test program and I can verify that without changes it
can trigger this issue, and by replacing new_inode_pseudo with
new_inode the issues goes away.

Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/000000000000d788c905a7dfa3f4@google.com
Reported-by: syzbot+7d2debdcdb3cb93c1e5e@syzkaller.appspotmail.com
Fixes: 0097875bd415 ("proc: Implement /proc/thread-self to point at the directory of the current thread")
Fixes: 021ada7dff22 ("procfs: switch /proc/self away from proc_dir_entry")
Fixes: 51f0885e5415 ("vfs,proc: guarantee unique inodes in /proc")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/proc/inode.c       | 2 +-
 fs/proc/self.c        | 2 +-
 fs/proc/thread_self.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index f40c2532c057..28d6105e908e 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -617,7 +617,7 @@ const struct inode_operations proc_link_inode_operations = {
 
 struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 {
-	struct inode *inode = new_inode_pseudo(sb);
+	struct inode *inode = new_inode(sb);
 
 	if (inode) {
 		inode->i_ino = de->low_ino;
diff --git a/fs/proc/self.c b/fs/proc/self.c
index ca5158fa561c..72cd69bcaf4a 100644
--- a/fs/proc/self.c
+++ b/fs/proc/self.c
@@ -43,7 +43,7 @@ int proc_setup_self(struct super_block *s)
 	inode_lock(root_inode);
 	self = d_alloc_name(s->s_root, "self");
 	if (self) {
-		struct inode *inode = new_inode_pseudo(s);
+		struct inode *inode = new_inode(s);
 		if (inode) {
 			inode->i_ino = self_inum;
 			inode->i_mtime = inode->i_atime = inode->i_ctime = current_time(inode);
diff --git a/fs/proc/thread_self.c b/fs/proc/thread_self.c
index ac284f409568..a553273fbd41 100644
--- a/fs/proc/thread_self.c
+++ b/fs/proc/thread_self.c
@@ -43,7 +43,7 @@ int proc_setup_thread_self(struct super_block *s)
 	inode_lock(root_inode);
 	thread_self = d_alloc_name(s->s_root, "thread-self");
 	if (thread_self) {
-		struct inode *inode = new_inode_pseudo(s);
+		struct inode *inode = new_inode(s);
 		if (inode) {
 			inode->i_ino = thread_self_inum;
 			inode->i_mtime = inode->i_atime = inode->i_ctime = current_time(inode);
-- 
2.20.1

