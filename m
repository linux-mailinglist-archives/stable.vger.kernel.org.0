Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFE74A428B
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376259AbiAaLMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377539AbiAaLKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:10:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF016C061749;
        Mon, 31 Jan 2022 03:08:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EEE160ECF;
        Mon, 31 Jan 2022 11:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289D9C340EE;
        Mon, 31 Jan 2022 11:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627280;
        bh=ntHB1EwPANzHF9BsgsFhEVLHwKVhjJU/F0L+D+K/BxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mGEWx+as8AHxLMa9dmVkkxu96qlrJz+y9RMI7n1uCx9P26J5vqml+DNRg6a6+hXwq
         +N7zyq/TkqBBY+3+5RbWIhGZQ8bsO7cihG33o7NfalEo7VlT4Ey6NWmyynb8B6ZRuV
         9Y6PMcmsAn1x5BrYjdwo8Gf8QsMiMupP/j+uU+GA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ivan Delalande <colona@arista.com>,
        Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 5.15 025/171] fsnotify: fix fsnotify hooks in pseudo filesystems
Date:   Mon, 31 Jan 2022 11:54:50 +0100
Message-Id: <20220131105230.872592417@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 29044dae2e746949ad4b9cbdbfb248994d1dcdb4 upstream.

Commit 49246466a989 ("fsnotify: move fsnotify_nameremove() hook out of
d_delete()") moved the fsnotify delete hook before d_delete() so fsnotify
will have access to a positive dentry.

This allowed a race where opening the deleted file via cached dentry
is now possible after receiving the IN_DELETE event.

To fix the regression in pseudo filesystems, convert d_delete() calls
to d_drop() (see commit 46c46f8df9aa ("devpts_pty_kill(): don't bother
with d_delete()") and move the fsnotify hook after d_drop().

Add a missing fsnotify_unlink() hook in nfsdfs that was found during
the audit of fsnotify hooks in pseudo filesystems.

Note that the fsnotify hooks in simple_recursive_removal() follow
d_invalidate(), so they require no change.

Link: https://lore.kernel.org/r/20220120215305.282577-2-amir73il@gmail.com
Reported-by: Ivan Delalande <colona@arista.com>
Link: https://lore.kernel.org/linux-fsdevel/YeNyzoDM5hP5LtGW@visor/
Fixes: 49246466a989 ("fsnotify: move fsnotify_nameremove() hook out of d_delete()")
Cc: stable@vger.kernel.org # v5.3+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/configfs/dir.c     |    6 +++---
 fs/devpts/inode.c     |    2 +-
 fs/nfsd/nfsctl.c      |    5 +++--
 net/sunrpc/rpc_pipe.c |    4 ++--
 4 files changed, 9 insertions(+), 8 deletions(-)

--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1780,8 +1780,8 @@ void configfs_unregister_group(struct co
 	configfs_detach_group(&group->cg_item);
 	d_inode(dentry)->i_flags |= S_DEAD;
 	dont_mount(dentry);
+	d_drop(dentry);
 	fsnotify_rmdir(d_inode(parent), dentry);
-	d_delete(dentry);
 	inode_unlock(d_inode(parent));
 
 	dput(dentry);
@@ -1922,10 +1922,10 @@ void configfs_unregister_subsystem(struc
 	configfs_detach_group(&group->cg_item);
 	d_inode(dentry)->i_flags |= S_DEAD;
 	dont_mount(dentry);
-	fsnotify_rmdir(d_inode(root), dentry);
 	inode_unlock(d_inode(dentry));
 
-	d_delete(dentry);
+	d_drop(dentry);
+	fsnotify_rmdir(d_inode(root), dentry);
 
 	inode_unlock(d_inode(root));
 
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -621,8 +621,8 @@ void devpts_pty_kill(struct dentry *dent
 
 	dentry->d_fsdata = NULL;
 	drop_nlink(dentry->d_inode);
-	fsnotify_unlink(d_inode(dentry->d_parent), dentry);
 	d_drop(dentry);
+	fsnotify_unlink(d_inode(dentry->d_parent), dentry);
 	dput(dentry);	/* d_alloc_name() in devpts_pty_new() */
 }
 
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1249,7 +1249,8 @@ static void nfsdfs_remove_file(struct in
 	clear_ncl(d_inode(dentry));
 	dget(dentry);
 	ret = simple_unlink(dir, dentry);
-	d_delete(dentry);
+	d_drop(dentry);
+	fsnotify_unlink(dir, dentry);
 	dput(dentry);
 	WARN_ON_ONCE(ret);
 }
@@ -1340,8 +1341,8 @@ void nfsd_client_rmdir(struct dentry *de
 	dget(dentry);
 	ret = simple_rmdir(dir, dentry);
 	WARN_ON_ONCE(ret);
+	d_drop(dentry);
 	fsnotify_rmdir(dir, dentry);
-	d_delete(dentry);
 	dput(dentry);
 	inode_unlock(dir);
 }
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -600,9 +600,9 @@ static int __rpc_rmdir(struct inode *dir
 
 	dget(dentry);
 	ret = simple_rmdir(dir, dentry);
+	d_drop(dentry);
 	if (!ret)
 		fsnotify_rmdir(dir, dentry);
-	d_delete(dentry);
 	dput(dentry);
 	return ret;
 }
@@ -613,9 +613,9 @@ static int __rpc_unlink(struct inode *di
 
 	dget(dentry);
 	ret = simple_unlink(dir, dentry);
+	d_drop(dentry);
 	if (!ret)
 		fsnotify_unlink(dir, dentry);
-	d_delete(dentry);
 	dput(dentry);
 	return ret;
 }


