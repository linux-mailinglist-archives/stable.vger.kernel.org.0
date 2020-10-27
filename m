Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9045C29B89A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368879AbgJ0PmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:42:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800527AbgJ0PgS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:36:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D521722275;
        Tue, 27 Oct 2020 15:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812977;
        bh=CnuDrxPWHvpFwI9d1fFu8KYzjuRuA16BXF6FrlcRPRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rdr9BLkA+AWkmxUKJ8ldJhMAVROhIcBv33uFGYqD6Nuf0rkA+8XP0FkLJgo8Bg96b
         pWbYF5FUxbPA3ylLoZUtec8EFFd6ZAzoknJghpiWbelcu7IA63wXoNmfhw05gWm3lg
         YrCy2KRKdtGDHJI3C+Rp0tjE1jJmlz9oJ8EVD5lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 395/757] fs: fix NULL dereference due to data race in prepend_path()
Date:   Tue, 27 Oct 2020 14:50:45 +0100
Message-Id: <20201027135509.094099600@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 09cad07547445bf3a41683e4d3abcd154c123ef5 ]

Fix data race in prepend_path() with re-reading mnt->mnt_ns twice
without holding the lock.

is_mounted() does check for NULL, but is_anon_ns(mnt->mnt_ns) might
re-read the pointer again which could be NULL already, if in between
reads one of kern_unmount()/kern_unmount_array()/umount_tree() sets
mnt->mnt_ns to NULL.

This is seen in production with the following stack trace:

  BUG: kernel NULL pointer dereference, address: 0000000000000048
  ...
  RIP: 0010:prepend_path.isra.4+0x1ce/0x2e0
  Call Trace:
    d_path+0xe6/0x150
    proc_pid_readlink+0x8f/0x100
    vfs_readlink+0xf8/0x110
    do_readlinkat+0xfd/0x120
    __x64_sys_readlinkat+0x1a/0x20
    do_syscall_64+0x42/0x110
    entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: f2683bd8d5bd ("[PATCH] fix d_absolute_path() interplay with fsmount()")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/d_path.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/d_path.c b/fs/d_path.c
index 0f1fc1743302f..a69e2cd36e6e3 100644
--- a/fs/d_path.c
+++ b/fs/d_path.c
@@ -102,6 +102,8 @@ static int prepend_path(const struct path *path,
 
 		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
 			struct mount *parent = READ_ONCE(mnt->mnt_parent);
+			struct mnt_namespace *mnt_ns;
+
 			/* Escaped? */
 			if (dentry != vfsmnt->mnt_root) {
 				bptr = *buffer;
@@ -116,7 +118,9 @@ static int prepend_path(const struct path *path,
 				vfsmnt = &mnt->mnt;
 				continue;
 			}
-			if (is_mounted(vfsmnt) && !is_anon_ns(mnt->mnt_ns))
+			mnt_ns = READ_ONCE(mnt->mnt_ns);
+			/* open-coded is_mounted() to use local mnt_ns */
+			if (!IS_ERR_OR_NULL(mnt_ns) && !is_anon_ns(mnt_ns))
 				error = 1;	// absolute root
 			else
 				error = 2;	// detached or not attached yet
-- 
2.25.1



