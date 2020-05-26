Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CECD1B67DF
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbgDWXKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:10:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50320 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728595AbgDWXGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:52 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvd-0004rY-Fd; Fri, 24 Apr 2020 00:06:45 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvZ-00E6zO-7J; Fri, 24 Apr 2020 00:06:41 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        "Kees Cook" <keescook@chromium.org>,
        "Salvatore Mesoraca" <s.mesoraca16@gmail.com>,
        "Solar Designer" <solar@openwall.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date:   Fri, 24 Apr 2020 00:07:15 +0100
Message-ID: <lsq.1587683028.722200761@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 208/245] namei: allow restricted O_CREAT of FIFOs and
 regular files
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

From: Salvatore Mesoraca <s.mesoraca16@gmail.com>

commit 30aba6656f61ed44cba445a3c0d38b296fa9e8f5 upstream.

Disallows open of FIFOs or regular files not owned by the user in world
writable sticky directories, unless the owner is the same as that of the
directory or the file is opened without the O_CREAT flag.  The purpose
is to make data spoofing attacks harder.  This protection can be turned
on and off separately for FIFOs and regular files via sysctl, just like
the symlinks/hardlinks protection.  This patch is based on Openwall's
"HARDEN_FIFO" feature by Solar Designer.

This is a brief list of old vulnerabilities that could have been prevented
by this feature, some of them even allow for privilege escalation:

CVE-2000-1134
CVE-2007-3852
CVE-2008-0525
CVE-2009-0416
CVE-2011-4834
CVE-2015-1838
CVE-2015-7442
CVE-2016-7489

This list is not meant to be complete.  It's difficult to track down all
vulnerabilities of this kind because they were often reported without any
mention of this particular attack vector.  In fact, before
hardlinks/symlinks restrictions, fifos/regular files weren't the favorite
vehicle to exploit them.

[s.mesoraca16@gmail.com: fix bug reported by Dan Carpenter]
  Link: https://lkml.kernel.org/r/20180426081456.GA7060@mwanda
  Link: http://lkml.kernel.org/r/1524829819-11275-1-git-send-email-s.mesoraca16@gmail.com
[keescook@chromium.org: drop pr_warn_ratelimited() in favor of audit changes in the future]
[keescook@chromium.org: adjust commit subjet]
Link: http://lkml.kernel.org/r/20180416175918.GA13494@beast
Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Solar Designer <solar@openwall.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/sysctl/fs.txt | 36 +++++++++++++++++++++++++
 fs/namei.c                  | 53 ++++++++++++++++++++++++++++++++++---
 include/linux/fs.h          |  2 ++
 kernel/sysctl.c             | 18 +++++++++++++
 4 files changed, 106 insertions(+), 3 deletions(-)

--- a/Documentation/sysctl/fs.txt
+++ b/Documentation/sysctl/fs.txt
@@ -34,7 +34,9 @@ Currently, these files are in /proc/sys/
 - overflowgid
 - pipe-user-pages-hard
 - pipe-user-pages-soft
+- protected_fifos
 - protected_hardlinks
+- protected_regular
 - protected_symlinks
 - suid_dumpable
 - super-max
@@ -182,6 +184,24 @@ applied.
 
 ==============================================================
 
+protected_fifos:
+
+The intent of this protection is to avoid unintentional writes to
+an attacker-controlled FIFO, where a program expected to create a regular
+file.
+
+When set to "0", writing to FIFOs is unrestricted.
+
+When set to "1" don't allow O_CREAT open on FIFOs that we don't own
+in world writable sticky directories, unless they are owned by the
+owner of the directory.
+
+When set to "2" it also applies to group writable sticky directories.
+
+This protection is based on the restrictions in Openwall.
+
+==============================================================
+
 protected_hardlinks:
 
 A long-standing class of security issues is the hardlink-based
@@ -202,6 +222,22 @@ This protection is based on the restrict
 
 ==============================================================
 
+protected_regular:
+
+This protection is similar to protected_fifos, but it
+avoids writes to an attacker-controlled regular file, where a program
+expected to create one.
+
+When set to "0", writing to regular files is unrestricted.
+
+When set to "1" don't allow O_CREAT open on regular files that we
+don't own in world writable sticky directories, unless they are
+owned by the owner of the directory.
+
+When set to "2" it also applies to group writable sticky directories.
+
+==============================================================
+
 protected_symlinks:
 
 A long-standing class of security issues is the symlink-based
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -723,6 +723,8 @@ static inline void put_link(struct namei
 
 int sysctl_protected_symlinks __read_mostly = 0;
 int sysctl_protected_hardlinks __read_mostly = 0;
+int sysctl_protected_fifos __read_mostly;
+int sysctl_protected_regular __read_mostly;
 
 /**
  * may_follow_link - Check symlink following for unsafe situations
@@ -837,6 +839,45 @@ static int may_linkat(struct path *link)
 	return -EPERM;
 }
 
+/**
+ * may_create_in_sticky - Check whether an O_CREAT open in a sticky directory
+ *			  should be allowed, or not, on files that already
+ *			  exist.
+ * @dir: the sticky parent directory
+ * @inode: the inode of the file to open
+ *
+ * Block an O_CREAT open of a FIFO (or a regular file) when:
+ *   - sysctl_protected_fifos (or sysctl_protected_regular) is enabled
+ *   - the file already exists
+ *   - we are in a sticky directory
+ *   - we don't own the file
+ *   - the owner of the directory doesn't own the file
+ *   - the directory is world writable
+ * If the sysctl_protected_fifos (or sysctl_protected_regular) is set to 2
+ * the directory doesn't have to be world writable: being group writable will
+ * be enough.
+ *
+ * Returns 0 if the open is allowed, -ve on error.
+ */
+static int may_create_in_sticky(struct dentry * const dir,
+				struct inode * const inode)
+{
+	if ((!sysctl_protected_fifos && S_ISFIFO(inode->i_mode)) ||
+	    (!sysctl_protected_regular && S_ISREG(inode->i_mode)) ||
+	    likely(!(dir->d_inode->i_mode & S_ISVTX)) ||
+	    uid_eq(inode->i_uid, dir->d_inode->i_uid) ||
+	    uid_eq(current_fsuid(), inode->i_uid))
+		return 0;
+
+	if (likely(dir->d_inode->i_mode & 0002) ||
+	    (dir->d_inode->i_mode & 0020 &&
+	     ((sysctl_protected_fifos >= 2 && S_ISFIFO(inode->i_mode)) ||
+	      (sysctl_protected_regular >= 2 && S_ISREG(inode->i_mode))))) {
+		return -EACCES;
+	}
+	return 0;
+}
+
 static __always_inline int
 follow_link(struct path *link, struct nameidata *nd, void **p)
 {
@@ -3057,9 +3098,15 @@ finish_open:
 		return error;
 	}
 	audit_inode(name, nd->path.dentry, 0);
-	error = -EISDIR;
-	if ((open_flag & O_CREAT) && d_is_dir(nd->path.dentry))
-		goto out;
+	if (open_flag & O_CREAT) {
+		error = -EISDIR;
+		if (d_is_dir(nd->path.dentry))
+			goto out;
+		error = may_create_in_sticky(dir,
+					     d_backing_inode(nd->path.dentry));
+		if (unlikely(error))
+			goto out;
+	}
 	error = -ENOTDIR;
 	if ((nd->flags & LOOKUP_DIRECTORY) && !d_can_lookup(nd->path.dentry))
 		goto out;
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -61,6 +61,8 @@ extern struct inodes_stat_t inodes_stat;
 extern int leases_enable, lease_break_time;
 extern int sysctl_protected_symlinks;
 extern int sysctl_protected_hardlinks;
+extern int sysctl_protected_fifos;
+extern int sysctl_protected_regular;
 
 struct buffer_head;
 typedef int (get_block_t)(struct inode *inode, sector_t iblock,
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1653,6 +1653,24 @@ static struct ctl_table fs_table[] = {
 		.extra2		= &one,
 	},
 	{
+		.procname	= "protected_fifos",
+		.data		= &sysctl_protected_fifos,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &two,
+	},
+	{
+		.procname	= "protected_regular",
+		.data		= &sysctl_protected_regular,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &two,
+	},
+	{
 		.procname	= "suid_dumpable",
 		.data		= &suid_dumpable,
 		.maxlen		= sizeof(int),

