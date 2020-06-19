Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95816201775
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395348AbgFSQix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:38:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388920AbgFSOrK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:47:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52EFB2168B;
        Fri, 19 Jun 2020 14:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578029;
        bh=kIU1GCkQJrmZFCdDbLhvIX7ErBnoyiO8O8nd1wmRA/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p7CJYAMWrPRb9DvaKzBAAS5S44RwhRONXXpkCk34l3Hq5H6DzydnC/aBlWH60QMqr
         oZidS9685P/NdGBpXPPis4iPfyNzUOcgKmWmQd87Uklee5/cEuZW4eDcai6f1MOYtu
         HanUa/0S/202/j8Rb0V2Xew+/JFGAKNvxoRFE/CQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+7d2debdcdb3cb93c1e5e@syzkaller.appspotmail.com,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 4.14 054/190] proc: Use new_inode not new_inode_pseudo
Date:   Fri, 19 Jun 2020 16:31:39 +0200
Message-Id: <20200619141636.284305699@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit ef1548adada51a2f32ed7faef50aa465e1b4c5da upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/inode.c       |    2 +-
 fs/proc/self.c        |    2 +-
 fs/proc/thread_self.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -432,7 +432,7 @@ const struct inode_operations proc_link_
 
 struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 {
-	struct inode *inode = new_inode_pseudo(sb);
+	struct inode *inode = new_inode(sb);
 
 	if (inode) {
 		inode->i_ino = de->low_ino;
--- a/fs/proc/self.c
+++ b/fs/proc/self.c
@@ -41,7 +41,7 @@ int proc_setup_self(struct super_block *
 	inode_lock(root_inode);
 	self = d_alloc_name(s->s_root, "self");
 	if (self) {
-		struct inode *inode = new_inode_pseudo(s);
+		struct inode *inode = new_inode(s);
 		if (inode) {
 			inode->i_ino = self_inum;
 			inode->i_mtime = inode->i_atime = inode->i_ctime = current_time(inode);
--- a/fs/proc/thread_self.c
+++ b/fs/proc/thread_self.c
@@ -42,7 +42,7 @@ int proc_setup_thread_self(struct super_
 	inode_lock(root_inode);
 	thread_self = d_alloc_name(s->s_root, "thread-self");
 	if (thread_self) {
-		struct inode *inode = new_inode_pseudo(s);
+		struct inode *inode = new_inode(s);
 		if (inode) {
 			inode->i_ino = thread_self_inum;
 			inode->i_mtime = inode->i_atime = inode->i_ctime = current_time(inode);


