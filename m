Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9141B6820
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbgDWXMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:12:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50180 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728532AbgDWXGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:51 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvd-0004ms-5S; Fri, 24 Apr 2020 00:06:45 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvZ-00E6zj-E7; Fri, 24 Apr 2020 00:06:41 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Al Viro" <viro@zeniv.linux.org.uk>
Date:   Fri, 24 Apr 2020 00:07:16 +0100
Message-ID: <lsq.1587683028.691828482@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 209/245] do_last(): fetch directory ->i_mode and
 ->i_uid before it's too late
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

commit d0cb50185ae942b03c4327be322055d622dc79f6 upstream.

may_create_in_sticky() call is done when we already have dropped the
reference to dir.

Fixes: 30aba6656f61e (namei: allow restricted O_CREAT of FIFOs and regular files)
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/namei.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -843,7 +843,8 @@ static int may_linkat(struct path *link)
  * may_create_in_sticky - Check whether an O_CREAT open in a sticky directory
  *			  should be allowed, or not, on files that already
  *			  exist.
- * @dir: the sticky parent directory
+ * @dir_mode: mode bits of directory
+ * @dir_uid: owner of directory
  * @inode: the inode of the file to open
  *
  * Block an O_CREAT open of a FIFO (or a regular file) when:
@@ -859,18 +860,18 @@ static int may_linkat(struct path *link)
  *
  * Returns 0 if the open is allowed, -ve on error.
  */
-static int may_create_in_sticky(struct dentry * const dir,
+static int may_create_in_sticky(umode_t dir_mode, kuid_t dir_uid,
 				struct inode * const inode)
 {
 	if ((!sysctl_protected_fifos && S_ISFIFO(inode->i_mode)) ||
 	    (!sysctl_protected_regular && S_ISREG(inode->i_mode)) ||
-	    likely(!(dir->d_inode->i_mode & S_ISVTX)) ||
-	    uid_eq(inode->i_uid, dir->d_inode->i_uid) ||
+	    likely(!(dir_mode & S_ISVTX)) ||
+	    uid_eq(inode->i_uid, dir_uid) ||
 	    uid_eq(current_fsuid(), inode->i_uid))
 		return 0;
 
-	if (likely(dir->d_inode->i_mode & 0002) ||
-	    (dir->d_inode->i_mode & 0020 &&
+	if (likely(dir_mode & 0002) ||
+	    (dir_mode & 0020 &&
 	     ((sysctl_protected_fifos >= 2 && S_ISFIFO(inode->i_mode)) ||
 	      (sysctl_protected_regular >= 2 && S_ISREG(inode->i_mode))))) {
 		return -EACCES;
@@ -2944,6 +2945,8 @@ static int do_last(struct nameidata *nd,
 		   int *opened, struct filename *name)
 {
 	struct dentry *dir = nd->path.dentry;
+	kuid_t dir_uid = dir->d_inode->i_uid;
+	umode_t dir_mode = dir->d_inode->i_mode;
 	int open_flag = op->open_flag;
 	bool will_truncate = (open_flag & O_TRUNC) != 0;
 	bool got_write = false;
@@ -3102,7 +3105,7 @@ finish_open:
 		error = -EISDIR;
 		if (d_is_dir(nd->path.dentry))
 			goto out;
-		error = may_create_in_sticky(dir,
+		error = may_create_in_sticky(dir_mode, dir_uid,
 					     d_backing_inode(nd->path.dentry));
 		if (unlikely(error))
 			goto out;

