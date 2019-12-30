Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2564112CCA7
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 06:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbfL3FVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 00:21:30 -0500
Received: from mout-p-202.mailbox.org ([80.241.56.172]:36768 "EHLO
        mout-p-202.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbfL3FVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 00:21:30 -0500
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 47mQlC1FMmzQlB6;
        Mon, 30 Dec 2019 06:21:27 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id MLrvg9OPl8do; Mon, 30 Dec 2019 06:21:24 +0100 (CET)
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Aleksa Sarai <cyphar@cyphar.com>, stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC 1/1] mount: universally disallow mounting over symlinks
Date:   Mon, 30 Dec 2019 16:20:36 +1100
Message-Id: <20191230052036.8765-2-cyphar@cyphar.com>
In-Reply-To: <20191230052036.8765-1-cyphar@cyphar.com>
References: <20191230052036.8765-1-cyphar@cyphar.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

An undocumented feature of the mount interface was that it was possible
to mount over a symlink (even with the old mount API) by mounting over
/proc/self/fd/$n -- where the corresponding file descrpitor was opened
with (O_PATH|O_NOFOLLOW). This didn't work with traditional "new" mounts
(for a variety of reasons), but MS_BIND worked without issue. With the
new mount API it was even easier.

From userspace's perspective, this capability is only really useful as
an attack vector. Until the introduction of openat2(RESOLVE_NO_XDEV),
there was no trivial way to detect if a bind-mount was present. In the
container runtime context (in a similar vein to CVE-2019-19921), this
could result in a privileged process being unable to detect that a
configuration resulted in magic-link usage operating on the wrong
magic-links. Additionally, the API to use this feature was incredibly
strange -- in order to umount, you would have go through
/proc/self/fd/$n again (umounting the path would result in the
*underlying* symlink being followed).

Which brings us to the issues on the kernel side. When umounting a mount
on top of a symlink, several oopses (both NULL and garbage kernel
address dereferences) and deadlocks could be triggered incredibly
trivially. Note that because this works in user namespaces, an
unprivileged user could trigger these oopses incredibly trivially. While
these bugs could be fixed separately, it seems much cleaner to disable a
"feature" which clearly was not intentional (and is not used --
otherwise we would've seen bug reports about it breaking on umount).

Note that because the linux-utils mount(1) helper will expand paths
containing symlinks in user-space, only users which used the mount(2)
syscall directly could possibly have seen this behaviour.

Cc: stable@vger.kernel.org # pre-git
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 fs/namespace.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index be601d3a8008..01a62bce105f 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2172,8 +2172,12 @@ static int graft_tree(struct mount *mnt, struct mount *p, struct mountpoint *mp)
 	if (mnt->mnt.mnt_sb->s_flags & SB_NOUSER)
 		return -EINVAL;
 
+	if (d_is_symlink(mp->m_dentry) ||
+	    d_is_symlink(mnt->mnt.mnt_root))
+		return -EINVAL;
+
 	if (d_is_dir(mp->m_dentry) !=
-	      d_is_dir(mnt->mnt.mnt_root))
+	    d_is_dir(mnt->mnt.mnt_root))
 		return -ENOTDIR;
 
 	return attach_recursive_mnt(mnt, p, mp, false);
@@ -2251,6 +2255,9 @@ static struct mount *__do_loopback(struct path *old_path, int recurse)
 	if (IS_MNT_UNBINDABLE(old))
 		return mnt;
 
+	if (d_is_symlink(old_path->dentry))
+		return mnt;
+
 	if (!check_mnt(old) && old_path->dentry->d_op != &ns_dentry_operations)
 		return mnt;
 
@@ -2635,6 +2642,10 @@ static int do_move_mount(struct path *old_path, struct path *new_path)
 	if (old_path->dentry != old_path->mnt->mnt_root)
 		goto out;
 
+	if (d_is_symlink(new_path->dentry) ||
+	    d_is_symlink(old_path->dentry))
+		goto out;
+
 	if (d_is_dir(new_path->dentry) !=
 	    d_is_dir(old_path->dentry))
 		goto out;
@@ -2726,10 +2737,6 @@ static int do_add_mount(struct mount *newmnt, struct path *path, int mnt_flags)
 	    path->mnt->mnt_root == path->dentry)
 		goto unlock;
 
-	err = -EINVAL;
-	if (d_is_symlink(newmnt->mnt.mnt_root))
-		goto unlock;
-
 	newmnt->mnt.mnt_flags = mnt_flags;
 	err = graft_tree(newmnt, parent, mp);
 
-- 
2.24.1

