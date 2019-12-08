Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2668C116208
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfLHN5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:57:08 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60230 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726786AbfLHNyn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:43 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1C-0007eB-Tb; Sun, 08 Dec 2019 13:54:38 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1B-0002N3-Ip; Sun, 08 Dec 2019 13:54:37 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Christoph Hellwig" <hch@lst.de>,
        "Al Viro" <viro@zeniv.linux.org.uk>
Date:   Sun, 08 Dec 2019 13:53:17 +0000
Message-ID: <lsq.1575813165.869366735@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 33/72] configfs: fix a deadlock in configfs_symlink()
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 351e5d869e5ac10cb40c78b5f2d7dfc816ad4587 upstream.

Configfs abuses symlink(2).  Unlike the normal filesystems, it
wants the target resolved at symlink(2) time, like link(2) would've
done.  The problem is that ->symlink() is called with the parent
directory locked exclusive, so resolving the target inside the
->symlink() is easily deadlocked.

Short of really ugly games in sys_symlink() itself, all we can
do is to unlock the parent before resolving the target and
relock it after.  However, that invalidates the checks done
by the caller of ->symlink(), so we have to
	* check that dentry is still where it used to be
(it couldn't have been moved, but it could've been unhashed)
	* recheck that it's still negative (somebody else
might've successfully created a symlink with the same name
while we were looking the target up)
	* recheck the permissions on the parent directory.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
[bwh: Backported to 3.16: open-code inode_{,un}lock()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/configfs/symlink.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -157,11 +157,42 @@ int configfs_symlink(struct inode *dir,
 	    !type->ct_item_ops->allow_link)
 		goto out_put;
 
+	/*
+	 * This is really sick.  What they wanted was a hybrid of
+	 * link(2) and symlink(2) - they wanted the target resolved
+	 * at syscall time (as link(2) would've done), be a directory
+	 * (which link(2) would've refused to do) *AND* be a deep
+	 * fucking magic, making the target busy from rmdir POV.
+	 * symlink(2) is nothing of that sort, and the locking it
+	 * gets matches the normal symlink(2) semantics.  Without
+	 * attempts to resolve the target (which might very well
+	 * not even exist yet) done prior to locking the parent
+	 * directory.  This perversion, OTOH, needs to resolve
+	 * the target, which would lead to obvious deadlocks if
+	 * attempted with any directories locked.
+	 *
+	 * Unfortunately, that garbage is userland ABI and we should've
+	 * said "no" back in 2005.  Too late now, so we get to
+	 * play very ugly games with locking.
+	 *
+	 * Try *ANYTHING* of that sort in new code, and you will
+	 * really regret it.  Just ask yourself - what could a BOFH
+	 * do to me and do I want to find it out first-hand?
+	 *
+	 *  AV, a thoroughly annoyed bastard.
+	 */
+	mutex_unlock(&dir->i_mutex);
 	ret = get_target(symname, &path, &target_item, dentry->d_sb);
+	mutex_lock(&dir->i_mutex);
 	if (ret)
 		goto out_put;
 
-	ret = type->ct_item_ops->allow_link(parent_item, target_item);
+	if (dentry->d_inode || d_unhashed(dentry))
+		ret = -EEXIST;
+	else
+		ret = inode_permission(dir, MAY_WRITE | MAY_EXEC);
+	if (!ret)
+		ret = type->ct_item_ops->allow_link(parent_item, target_item);
 	if (!ret) {
 		mutex_lock(&configfs_symlink_mutex);
 		ret = create_link(parent_item, target_item, dentry);

