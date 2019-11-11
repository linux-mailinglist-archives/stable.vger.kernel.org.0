Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBA31F7CF9
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbfKKSvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:51:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729976AbfKKSvk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:51:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EF14222BD;
        Mon, 11 Nov 2019 18:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498298;
        bh=AC7j0hTvdLJC4KtmliyQnPkC2qsF+C31855uvSXbV0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cb6CxVbNbRE1cie9Q7NWp6147GMEBZBdYodcIYOgfVqOcjMjQ1kaIT9xlkyD6H0VF
         mpuaHmNxgJakuRipkgdCbmnmWXuroKL6NP48DRaj5dxf+bWfcrRhO3z8eEuQPRJwaP
         HyDXmUhkjiz/fci/TOnNoqrCs5O0WXslVtzEavbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.3 081/193] configfs: fix a deadlock in configfs_symlink()
Date:   Mon, 11 Nov 2019 19:27:43 +0100
Message-Id: <20191111181507.118324581@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/configfs/symlink.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -143,11 +143,42 @@ int configfs_symlink(struct inode *dir,
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
+	inode_unlock(dir);
 	ret = get_target(symname, &path, &target_item, dentry->d_sb);
+	inode_lock(dir);
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


