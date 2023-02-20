Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F50C69CD97
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbjBTNus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:50:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbjBTNur (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:50:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06C31D91F
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:50:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0A23B80D4B
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D29C433D2;
        Mon, 20 Feb 2023 13:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901043;
        bh=7zR3S+52r/rJ7m94EdcCBjMxB3gViC7q5PlGD6IHKc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L9+wse1oYYTsVJuFdQiUtAhVt06D/VwxJzu90FGPdrkSvr9Wcru6DsIreTfgKc740
         ESttzYBJwLjEOvdOQKlrICr/Jw1uAQIBisRuJ/ji4HaHpThlipLG2pSalTMS5ocxkm
         49PGz+dEQrRDusfBhFn7TBo0fCu1PClhyg6eCXxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Munehisa Kamata <kamatam@amazon.com>,
        Mengchi Cheng <mengcc@amazon.com>,
        Ingo Molnar <mingo@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5.4 133/156] sched/psi: Fix use-after-free in ep_remove_wait_queue()
Date:   Mon, 20 Feb 2023 14:36:17 +0100
Message-Id: <20230220133608.150844415@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Munehisa Kamata <kamatam@amazon.com>

commit c2dbe32d5db5c4ead121cf86dabd5ab691fb47fe upstream.

If a non-root cgroup gets removed when there is a thread that registered
trigger and is polling on a pressure file within the cgroup, the polling
waitqueue gets freed in the following path:

 do_rmdir
   cgroup_rmdir
     kernfs_drain_open_files
       cgroup_file_release
         cgroup_pressure_release
           psi_trigger_destroy

However, the polling thread still has a reference to the pressure file and
will access the freed waitqueue when the file is closed or upon exit:

 fput
   ep_eventpoll_release
     ep_free
       ep_remove_wait_queue
         remove_wait_queue

This results in use-after-free as pasted below.

The fundamental problem here is that cgroup_file_release() (and
consequently waitqueue's lifetime) is not tied to the file's real lifetime.
Using wake_up_pollfree() here might be less than ideal, but it is in line
with the comment at commit 42288cb44c4b ("wait: add wake_up_pollfree()")
since the waitqueue's lifetime is not tied to file's one and can be
considered as another special case. While this would be fixable by somehow
making cgroup_file_release() be tied to the fput(), it would require
sizable refactoring at cgroups or higher layer which might be more
justifiable if we identify more cases like this.

  BUG: KASAN: use-after-free in _raw_spin_lock_irqsave+0x60/0xc0
  Write of size 4 at addr ffff88810e625328 by task a.out/4404

	CPU: 19 PID: 4404 Comm: a.out Not tainted 6.2.0-rc6 #38
	Hardware name: Amazon EC2 c5a.8xlarge/, BIOS 1.0 10/16/2017
	Call Trace:
	<TASK>
	dump_stack_lvl+0x73/0xa0
	print_report+0x16c/0x4e0
	kasan_report+0xc3/0xf0
	kasan_check_range+0x2d2/0x310
	_raw_spin_lock_irqsave+0x60/0xc0
	remove_wait_queue+0x1a/0xa0
	ep_free+0x12c/0x170
	ep_eventpoll_release+0x26/0x30
	__fput+0x202/0x400
	task_work_run+0x11d/0x170
	do_exit+0x495/0x1130
	do_group_exit+0x100/0x100
	get_signal+0xd67/0xde0
	arch_do_signal_or_restart+0x2a/0x2b0
	exit_to_user_mode_prepare+0x94/0x100
	syscall_exit_to_user_mode+0x20/0x40
	do_syscall_64+0x52/0x90
	entry_SYSCALL_64_after_hwframe+0x63/0xcd
	</TASK>

 Allocated by task 4404:

	kasan_set_track+0x3d/0x60
	__kasan_kmalloc+0x85/0x90
	psi_trigger_create+0x113/0x3e0
	pressure_write+0x146/0x2e0
	cgroup_file_write+0x11c/0x250
	kernfs_fop_write_iter+0x186/0x220
	vfs_write+0x3d8/0x5c0
	ksys_write+0x90/0x110
	do_syscall_64+0x43/0x90
	entry_SYSCALL_64_after_hwframe+0x63/0xcd

 Freed by task 4407:

	kasan_set_track+0x3d/0x60
	kasan_save_free_info+0x27/0x40
	____kasan_slab_free+0x11d/0x170
	slab_free_freelist_hook+0x87/0x150
	__kmem_cache_free+0xcb/0x180
	psi_trigger_destroy+0x2e8/0x310
	cgroup_file_release+0x4f/0xb0
	kernfs_drain_open_files+0x165/0x1f0
	kernfs_drain+0x162/0x1a0
	__kernfs_remove+0x1fb/0x310
	kernfs_remove_by_name_ns+0x95/0xe0
	cgroup_addrm_files+0x67f/0x700
	cgroup_destroy_locked+0x283/0x3c0
	cgroup_rmdir+0x29/0x100
	kernfs_iop_rmdir+0xd1/0x140
	vfs_rmdir+0xfe/0x240
	do_rmdir+0x13d/0x280
	__x64_sys_rmdir+0x2c/0x30
	do_syscall_64+0x43/0x90
	entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 0e94682b73bf ("psi: introduce psi monitor")
Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
Signed-off-by: Mengchi Cheng <mengcc@amazon.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/20230106224859.4123476-1-kamatam@amazon.com/
Link: https://lore.kernel.org/r/20230214212705.4058045-1-kamatam@amazon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/psi.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1092,10 +1092,11 @@ void psi_trigger_destroy(struct psi_trig
 
 	group = t->group;
 	/*
-	 * Wakeup waiters to stop polling. Can happen if cgroup is deleted
-	 * from under a polling process.
+	 * Wakeup waiters to stop polling and clear the queue to prevent it from
+	 * being accessed later. Can happen if cgroup is deleted from under a
+	 * polling process.
 	 */
-	wake_up_interruptible(&t->event_wait);
+	wake_up_pollfree(&t->event_wait);
 
 	mutex_lock(&group->trigger_lock);
 


