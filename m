Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7D529B99A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802640AbgJ0Pug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:32986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801507AbgJ0Plb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:41:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C07B222E9;
        Tue, 27 Oct 2020 15:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813289;
        bh=NnJvSZBQlr69j2vH0W5KuBx8RQ9qe/o/fabaoCgiro4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=usrlSm355+WkuNsKVG1JMlBU1p74k31FNok4LzaQdou/BCEQnQkDOe0/a7UJQHHsx
         RcdP/K6PWc+B7nTKr5YpIbrkQY46I2meWeePM8vFnnzDJvwuZ9SQMNwNB+RyGyi86B
         LHiJMjhy6YqkQx9WRx41zpspADIqMnfgaxbpbjkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Chao Yu <chao@kernel.org>, Jamie Iles <jamie@nuviainc.com>,
        Chao Yu <yuchao0@huawei.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 501/757] f2fs: wait for sysfs kobject removal before freeing f2fs_sb_info
Date:   Tue, 27 Oct 2020 14:52:31 +0100
Message-Id: <20201027135513.949074423@linuxfoundation.org>
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

From: Jamie Iles <jamie@nuviainc.com>

[ Upstream commit ae284d87abade58c8db7760c808f311ef1ce693c ]

syzkaller found that with CONFIG_DEBUG_KOBJECT_RELEASE=y, unmounting an
f2fs filesystem could result in the following splat:

  kobject: 'loop5' ((____ptrval____)): kobject_release, parent 0000000000000000 (delayed 250)
  kobject: 'f2fs_xattr_entry-7:5' ((____ptrval____)): kobject_release, parent 0000000000000000 (delayed 750)
  ------------[ cut here ]------------
  ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x98
  WARNING: CPU: 0 PID: 699 at lib/debugobjects.c:485 debug_print_object+0x180/0x240
  Kernel panic - not syncing: panic_on_warn set ...
  CPU: 0 PID: 699 Comm: syz-executor.5 Tainted: G S                5.9.0-rc8+ #101
  Hardware name: linux,dummy-virt (DT)
  Call trace:
   dump_backtrace+0x0/0x4d8
   show_stack+0x34/0x48
   dump_stack+0x174/0x1f8
   panic+0x360/0x7a0
   __warn+0x244/0x2ec
   report_bug+0x240/0x398
   bug_handler+0x50/0xc0
   call_break_hook+0x160/0x1d8
   brk_handler+0x30/0xc0
   do_debug_exception+0x184/0x340
   el1_dbg+0x48/0xb0
   el1_sync_handler+0x170/0x1c8
   el1_sync+0x80/0x100
   debug_print_object+0x180/0x240
   debug_check_no_obj_freed+0x200/0x430
   slab_free_freelist_hook+0x190/0x210
   kfree+0x13c/0x460
   f2fs_put_super+0x624/0xa58
   generic_shutdown_super+0x120/0x300
   kill_block_super+0x94/0xf8
   kill_f2fs_super+0x244/0x308
   deactivate_locked_super+0x104/0x150
   deactivate_super+0x118/0x148
   cleanup_mnt+0x27c/0x3c0
   __cleanup_mnt+0x28/0x38
   task_work_run+0x10c/0x248
   do_notify_resume+0x9d4/0x1188
   work_pending+0x8/0x34c

Like the error handling for f2fs_register_sysfs(), we need to wait for
the kobject to be destroyed before returning to prevent a potential
use-after-free.

Fixes: bf9e697ecd42 ("f2fs: expose features to sysfs entry")
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Signed-off-by: Jamie Iles <jamie@nuviainc.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index 88ed9969cc862..5fe7d8fa93801 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -968,4 +968,5 @@ void f2fs_unregister_sysfs(struct f2fs_sb_info *sbi)
 	}
 	kobject_del(&sbi->s_kobj);
 	kobject_put(&sbi->s_kobj);
+	wait_for_completion(&sbi->s_kobj_unregister);
 }
-- 
2.25.1



