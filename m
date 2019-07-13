Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B05276782B
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 06:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfGMEMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 00:12:50 -0400
Received: from nibbler.cm4all.net ([82.165.145.151]:37139 "EHLO
        nibbler.cm4all.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfGMEMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 00:12:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by nibbler.cm4all.net (Postfix) with ESMTP id B8C46C01AA
        for <stable@vger.kernel.org>; Sat, 13 Jul 2019 06:12:23 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at nibbler.cm4all.net
Received: from nibbler.cm4all.net ([127.0.0.1])
        by localhost (nibbler.cm4all.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id m2xiZW05Lseq for <stable@vger.kernel.org>;
        Sat, 13 Jul 2019 06:12:23 +0200 (CEST)
Received: from zero.intern.cm-ag (zero.intern.cm-ag [172.30.16.10])
        by nibbler.cm4all.net (Postfix) with SMTP id 93C65C01DD
        for <stable@vger.kernel.org>; Sat, 13 Jul 2019 06:12:23 +0200 (CEST)
Received: (qmail 30933 invoked from network); 13 Jul 2019 06:44:01 +0200
Received: from unknown (HELO rabbit.intern.cm-ag) (172.30.3.1)
  by zero.intern.cm-ag with SMTP; 13 Jul 2019 06:44:01 +0200
Received: by rabbit.intern.cm-ag (Postfix, from userid 1023)
        id 543DC460C4C; Sat, 13 Jul 2019 06:12:18 +0200 (CEST)
From:   Max Kellermann <mk@cm4all.com>
To:     linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        trond.myklebust@hammerspace.com, bfields@redhat.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, hughd@google.com,
        anna.schumaker@netapp.com
Cc:     linux-kernel@vger.kernel.org, Max Kellermann <mk@cm4all.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 3/4] linux/fs.h: fix umask on NFS with CONFIG_FS_POSIX_ACL=n
Date:   Sat, 13 Jul 2019 06:11:59 +0200
Message-Id: <20190713041200.18566-3-mk@cm4all.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190713041200.18566-1-mk@cm4all.com>
References: <20190713041200.18566-1-mk@cm4all.com>
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
Cc: stable@vger.kernel.org
---
 include/linux/fs.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index f7fdfe93e25d..5e9f3aa7ba26 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1993,7 +1993,12 @@ static inline bool sb_rdonly(const struct super_block *sb) { return sb->s_flags
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

