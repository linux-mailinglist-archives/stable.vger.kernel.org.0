Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38BA23DA504
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 15:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238185AbhG2N5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 09:57:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238163AbhG2N5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:57:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9350660F4B;
        Thu, 29 Jul 2021 13:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567049;
        bh=AhgwLmdZGUQ8AKVUpDYugrT9gdPadWuq5u6IwB38gJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PRRLfmx4KEOfszWkHRPiitbrymbVqSw5oYuFkLe3yrYmhaha5MitDkE4RIn5EhDdy
         4zQIC5EboKWtLl92e7kg+KrTY/8F0XVSripddY5zL9+BQcz+obtQSvpM5WOLjLs5OO
         06mAj1w/koK2VgKuzKj+rj8HFOEOy7Ovorx6IPC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 5.4 06/21] cgroup1: fix leaked context root causing sporadic NULL deref in LTP
Date:   Thu, 29 Jul 2021 15:54:13 +0200
Message-Id: <20210729135143.124074914@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135142.920143237@linuxfoundation.org>
References: <20210729135142.920143237@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker@windriver.com>

commit 1e7107c5ef44431bc1ebbd4c353f1d7c22e5f2ec upstream.

Richard reported sporadic (roughly one in 10 or so) null dereferences and
other strange behaviour for a set of automated LTP tests.  Things like:

   BUG: kernel NULL pointer dereference, address: 0000000000000008
   #PF: supervisor read access in kernel mode
   #PF: error_code(0x0000) - not-present page
   PGD 0 P4D 0
   Oops: 0000 [#1] PREEMPT SMP PTI
   CPU: 0 PID: 1516 Comm: umount Not tainted 5.10.0-yocto-standard #1
   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
   RIP: 0010:kernfs_sop_show_path+0x1b/0x60

...or these others:

   RIP: 0010:do_mkdirat+0x6a/0xf0
   RIP: 0010:d_alloc_parallel+0x98/0x510
   RIP: 0010:do_readlinkat+0x86/0x120

There were other less common instances of some kind of a general scribble
but the common theme was mount and cgroup and a dubious dentry triggering
the NULL dereference.  I was only able to reproduce it under qemu by
replicating Richard's setup as closely as possible - I never did get it
to happen on bare metal, even while keeping everything else the same.

In commit 71d883c37e8d ("cgroup_do_mount(): massage calling conventions")
we see this as a part of the overall change:

   --------------
           struct cgroup_subsys *ss;
   -       struct dentry *dentry;

   [...]

   -       dentry = cgroup_do_mount(&cgroup_fs_type, fc->sb_flags, root,
   -                                CGROUP_SUPER_MAGIC, ns);

   [...]

   -       if (percpu_ref_is_dying(&root->cgrp.self.refcnt)) {
   -               struct super_block *sb = dentry->d_sb;
   -               dput(dentry);
   +       ret = cgroup_do_mount(fc, CGROUP_SUPER_MAGIC, ns);
   +       if (!ret && percpu_ref_is_dying(&root->cgrp.self.refcnt)) {
   +               struct super_block *sb = fc->root->d_sb;
   +               dput(fc->root);
                   deactivate_locked_super(sb);
                   msleep(10);
                   return restart_syscall();
           }
   --------------

In changing from the local "*dentry" variable to using fc->root, we now
export/leave that dentry pointer in the file context after doing the dput()
in the unlikely "is_dying" case.   With LTP doing a crazy amount of back to
back mount/unmount [testcases/bin/cgroup_regression_5_1.sh] the unlikely
becomes slightly likely and then bad things happen.

A fix would be to not leave the stale reference in fc->root as follows:

   --------------
                  dput(fc->root);
  +               fc->root = NULL;
                  deactivate_locked_super(sb);
   --------------

...but then we are just open-coding a duplicate of fc_drop_locked() so we
simply use that instead.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: stable@vger.kernel.org      # v5.1+
Reported-by: Richard Purdie <richard.purdie@linuxfoundation.org>
Fixes: 71d883c37e8d ("cgroup_do_mount(): massage calling conventions")
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/internal.h              |    1 -
 include/linux/fs_context.h |    1 +
 kernel/cgroup/cgroup-v1.c  |    4 +---
 3 files changed, 2 insertions(+), 4 deletions(-)

--- a/fs/internal.h
+++ b/fs/internal.h
@@ -52,7 +52,6 @@ extern void __init chrdev_init(void);
  */
 extern const struct fs_context_operations legacy_fs_context_ops;
 extern int parse_monolithic_mount_data(struct fs_context *, void *);
-extern void fc_drop_locked(struct fs_context *);
 extern void vfs_clean_context(struct fs_context *fc);
 extern int finish_clean_context(struct fs_context *fc);
 
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -134,6 +134,7 @@ extern int vfs_parse_fs_string(struct fs
 extern int generic_parse_monolithic(struct fs_context *fc, void *data);
 extern int vfs_get_tree(struct fs_context *fc);
 extern void put_fs_context(struct fs_context *fc);
+extern void fc_drop_locked(struct fs_context *fc);
 
 /*
  * sget() wrappers to be called from the ->get_tree() op.
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -1228,9 +1228,7 @@ int cgroup1_get_tree(struct fs_context *
 		ret = cgroup_do_get_tree(fc);
 
 	if (!ret && percpu_ref_is_dying(&ctx->root->cgrp.self.refcnt)) {
-		struct super_block *sb = fc->root->d_sb;
-		dput(fc->root);
-		deactivate_locked_super(sb);
+		fc_drop_locked(fc);
 		ret = 1;
 	}
 


