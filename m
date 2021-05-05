Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB277373A77
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbhEEMKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:10:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231431AbhEEMJc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:09:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF4E0613E9;
        Wed,  5 May 2021 12:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216500;
        bh=C9ke7v72V70s1IdVAQHEb0HbJn+RJXrdfqqY1sv86ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=svPwWZuggXjwNeM0u/6DWk2ivlSSSzcrs16+I6LTXq2NJes4OWsG8K9eCeUa2fai3
         URWb9Kb18Hr8WmjVGAbX/sJW+GBKcI8inUgU9N78LwTmm0j0ERWAdzI4oPaQMtqrDr
         WUrD0dowcrUrN30hUUHizW8MloRClVc4yHGQ6hrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.12 08/17] ovl: fix leaked dentry
Date:   Wed,  5 May 2021 14:06:03 +0200
Message-Id: <20210505112325.225563588@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112324.956720416@linuxfoundation.org>
References: <20210505112324.956720416@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mickaël Salaün <mic@linux.microsoft.com>

commit eaab1d45cdb4bb0c846bd23c3d666d5b90af7b41 upstream.

Since commit 6815f479ca90 ("ovl: use only uppermetacopy state in
ovl_lookup()"), overlayfs doesn't put temporary dentry when there is a
metacopy error, which leads to dentry leaks when shutting down the related
superblock:

  overlayfs: refusing to follow metacopy origin for (/file0)
  ...
  BUG: Dentry (____ptrval____){i=3f33,n=file3}  still in use (1) [unmount of overlay overlay]
  ...
  WARNING: CPU: 1 PID: 432 at umount_check.cold+0x107/0x14d
  CPU: 1 PID: 432 Comm: unmount-overlay Not tainted 5.12.0-rc5 #1
  ...
  RIP: 0010:umount_check.cold+0x107/0x14d
  ...
  Call Trace:
   d_walk+0x28c/0x950
   ? dentry_lru_isolate+0x2b0/0x2b0
   ? __kasan_slab_free+0x12/0x20
   do_one_tree+0x33/0x60
   shrink_dcache_for_umount+0x78/0x1d0
   generic_shutdown_super+0x70/0x440
   kill_anon_super+0x3e/0x70
   deactivate_locked_super+0xc4/0x160
   deactivate_super+0xfa/0x140
   cleanup_mnt+0x22e/0x370
   __cleanup_mnt+0x1a/0x30
   task_work_run+0x139/0x210
   do_exit+0xb0c/0x2820
   ? __kasan_check_read+0x1d/0x30
   ? find_held_lock+0x35/0x160
   ? lock_release+0x1b6/0x660
   ? mm_update_next_owner+0xa20/0xa20
   ? reacquire_held_locks+0x3f0/0x3f0
   ? __sanitizer_cov_trace_const_cmp4+0x22/0x30
   do_group_exit+0x135/0x380
   __do_sys_exit_group.isra.0+0x20/0x20
   __x64_sys_exit_group+0x3c/0x50
   do_syscall_64+0x45/0x70
   entry_SYSCALL_64_after_hwframe+0x44/0xae
  ...
  VFS: Busy inodes after unmount of overlay. Self-destruct in 5 seconds.  Have a nice day...

This fix has been tested with a syzkaller reproducer.

Cc: Amir Goldstein <amir73il@gmail.com>
Cc: <stable@vger.kernel.org> # v5.8+
Reported-by: syzbot <syzkaller@googlegroups.com>
Fixes: 6815f479ca90 ("ovl: use only uppermetacopy state in ovl_lookup()")
Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
Link: https://lore.kernel.org/r/20210329164907.2133175-1-mic@digikod.net
Reviewed-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/namei.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -919,6 +919,7 @@ struct dentry *ovl_lookup(struct inode *
 			continue;
 
 		if ((uppermetacopy || d.metacopy) && !ofs->config.metacopy) {
+			dput(this);
 			err = -EPERM;
 			pr_warn_ratelimited("refusing to follow metacopy origin for (%pd2)\n", dentry);
 			goto out_put;


