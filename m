Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA00F1A0F44
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 16:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbgDGObm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 10:31:42 -0400
Received: from nibbler.cm4all.net ([82.165.145.151]:47601 "EHLO
        nibbler.cm4all.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729154AbgDGOb2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 10:31:28 -0400
Received: from localhost (localhost [127.0.0.1])
        by nibbler.cm4all.net (Postfix) with ESMTP id E40BBC0213
        for <stable@vger.kernel.org>; Tue,  7 Apr 2020 16:23:08 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at nibbler.cm4all.net
Received: from nibbler.cm4all.net ([127.0.0.1])
        by localhost (nibbler.cm4all.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id oHWkg1WFwNzl for <stable@vger.kernel.org>;
        Tue,  7 Apr 2020 16:23:08 +0200 (CEST)
Received: from zero.intern.cm-ag (zero.intern.cm-ag [172.30.16.10])
        by nibbler.cm4all.net (Postfix) with SMTP id 9FDABC0225
        for <stable@vger.kernel.org>; Tue,  7 Apr 2020 16:23:08 +0200 (CEST)
Received: (qmail 19689 invoked from network); 7 Apr 2020 17:35:21 +0200
Received: from unknown (HELO rabbit.intern.cm-ag) (172.30.3.1)
  by zero.intern.cm-ag with SMTP; 7 Apr 2020 17:35:21 +0200
Received: by rabbit.intern.cm-ag (Postfix, from userid 1023)
        id 61F4446143D; Tue,  7 Apr 2020 16:23:08 +0200 (CEST)
From:   Max Kellermann <mk@cm4all.com>
To:     linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        trond.myklebust@hammerspace.com
Cc:     bfields@redhat.com, tytso@mit.edu, viro@zeniv.linux.org.uk,
        agruenba@redhat.com, linux-kernel@vger.kernel.org,
        Max Kellermann <mk@cm4all.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH v3 3/4] linux/fs.h: fix umask on NFS with CONFIG_FS_POSIX_ACL=n
Date:   Tue,  7 Apr 2020 16:22:42 +0200
Message-Id: <20200407142243.2032-3-mk@cm4all.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407142243.2032-1-mk@cm4all.com>
References: <20200407142243.2032-1-mk@cm4all.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make IS_POSIXACL() return false if POSIX ACL support is disabled and
ignore SB_POSIXACL/MS_POSIXACL.

Never skip applying the umask in namei.c and never bother to do any
ACL specific checks if the filesystem falsely indicates it has ACLs
enabled when the feature is completely disabled in the kernel.

This fixes a problem where the umask is always ignored in the NFS
client when compiled without CONFIG_FS_POSIX_ACL.  This is a 4 year
old regression caused by commit 013cdf1088d723 which itself was not
completely wrong, but failed to consider all the side effects by
misdesigned VFS code.

Prior to that commit, there were two places where the umask could be
applied, for example when creating a directory:

 1. in the VFS layer in SYSCALL_DEFINE3(mkdirat), but only if
    !IS_POSIXACL()

 2. again (unconditionally) in nfs3_proc_mkdir()

The first one does not apply, because even without
CONFIG_FS_POSIX_ACL, the NFS client sets MS_POSIXACL in
nfs_fill_super().

After that commit, (2.) was replaced by:

 2b. in posix_acl_create(), called by nfs3_proc_mkdir()

There's one branch in posix_acl_create() which applies the umask;
however, without CONFIG_FS_POSIX_ACL, posix_acl_create() is an empty
dummy function which does not apply the umask.

The approach chosen by this patch is to make IS_POSIXACL() always
return false when POSIX ACL support is disabled, so the umask always
gets applied by the VFS layer.  This is consistent with the (regular)
behavior of posix_acl_create(): that function returns early if
IS_POSIXACL() is false, before applying the umask.

Therefore, posix_acl_create() is responsible for applying the umask if
there is ACL support enabled in the file system (SB_POSIXACL), and the
VFS layer is responsible for all other cases (no SB_POSIXACL or no
CONFIG_FS_POSIX_ACL).

Signed-off-by: Max Kellermann <mk@cm4all.com>
Reviewed-by: J. Bruce Fields <bfields@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org
---
 include/linux/fs.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index abedbffe2c9e..5721be1146b1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2027,7 +2027,12 @@ static inline bool sb_rdonly(const struct super_block *sb) { return sb->s_flags
 #define IS_NOQUOTA(inode)	((inode)->i_flags & S_NOQUOTA)
 #define IS_APPEND(inode)	((inode)->i_flags & S_APPEND)
 #define IS_IMMUTABLE(inode)	((inode)->i_flags & S_IMMUTABLE)
+
+#ifdef CONFIG_FS_POSIX_ACL
 #define IS_POSIXACL(inode)	__IS_FLG(inode, SB_POSIXACL)
+#else
+#define IS_POSIXACL(inode)	0
+#endif
 
 #define IS_DEADDIR(inode)	((inode)->i_flags & S_DEAD)
 #define IS_NOCMTIME(inode)	((inode)->i_flags & S_NOCMTIME)
-- 
2.20.1

