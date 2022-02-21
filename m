Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E533B4BDFAE
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354294AbiBUKD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 05:03:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353514AbiBUJ5b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:57:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BB9B851;
        Mon, 21 Feb 2022 01:26:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7866BB80EB1;
        Mon, 21 Feb 2022 09:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B813DC340E9;
        Mon, 21 Feb 2022 09:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435594;
        bh=K3wtqMvTczX/YYT1K8fzaos+POq0zwUsG4xrvFbl/1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ErAc4AI/gSEPnLqXTkRNiL+aqNEckNQCheJn0s8ykhXSR7Qu6QT9vR1hskrh4O8j4
         YitkiJLnZ1DK1d2hNLO1rdg78CQ8Ca4ALHbbM9mAi5OSRCbpZexcYMnpy9cmjZvjd0
         anG8aVV7ZeXs0emBJZz+jNvRkvFZeKsE2YyHCsjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Waiman Long <longman@redhat.com>,
        Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.16 186/227] copy_process(): Move fd_install() out of sighand->siglock critical section
Date:   Mon, 21 Feb 2022 09:50:05 +0100
Message-Id: <20220221084940.999342649@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit ddc204b517e60ae64db34f9832dc41dafa77c751 upstream.

I was made aware of the following lockdep splat:

[ 2516.308763] =====================================================
[ 2516.309085] WARNING: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected
[ 2516.309433] 5.14.0-51.el9.aarch64+debug #1 Not tainted
[ 2516.309703] -----------------------------------------------------
[ 2516.310149] stress-ng/153663 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[ 2516.310512] ffff0000e422b198 (&newf->file_lock){+.+.}-{2:2}, at: fd_install+0x368/0x4f0
[ 2516.310944]
               and this task is already holding:
[ 2516.311248] ffff0000c08140d8 (&sighand->siglock){-.-.}-{2:2}, at: copy_process+0x1e2c/0x3e80
[ 2516.311804] which would create a new lock dependency:
[ 2516.312066]  (&sighand->siglock){-.-.}-{2:2} -> (&newf->file_lock){+.+.}-{2:2}
[ 2516.312446]
               but this new dependency connects a HARDIRQ-irq-safe lock:
[ 2516.312983]  (&sighand->siglock){-.-.}-{2:2}
   :
[ 2516.330700]  Possible interrupt unsafe locking scenario:

[ 2516.331075]        CPU0                    CPU1
[ 2516.331328]        ----                    ----
[ 2516.331580]   lock(&newf->file_lock);
[ 2516.331790]                                local_irq_disable();
[ 2516.332231]                                lock(&sighand->siglock);
[ 2516.332579]                                lock(&newf->file_lock);
[ 2516.332922]   <Interrupt>
[ 2516.333069]     lock(&sighand->siglock);
[ 2516.333291]
                *** DEADLOCK ***
[ 2516.389845]
               stack backtrace:
[ 2516.390101] CPU: 3 PID: 153663 Comm: stress-ng Kdump: loaded Not tainted 5.14.0-51.el9.aarch64+debug #1
[ 2516.390756] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
[ 2516.391155] Call trace:
[ 2516.391302]  dump_backtrace+0x0/0x3e0
[ 2516.391518]  show_stack+0x24/0x30
[ 2516.391717]  dump_stack_lvl+0x9c/0xd8
[ 2516.391938]  dump_stack+0x1c/0x38
[ 2516.392247]  print_bad_irq_dependency+0x620/0x710
[ 2516.392525]  check_irq_usage+0x4fc/0x86c
[ 2516.392756]  check_prev_add+0x180/0x1d90
[ 2516.392988]  validate_chain+0x8e0/0xee0
[ 2516.393215]  __lock_acquire+0x97c/0x1e40
[ 2516.393449]  lock_acquire.part.0+0x240/0x570
[ 2516.393814]  lock_acquire+0x90/0xb4
[ 2516.394021]  _raw_spin_lock+0xe8/0x154
[ 2516.394244]  fd_install+0x368/0x4f0
[ 2516.394451]  copy_process+0x1f5c/0x3e80
[ 2516.394678]  kernel_clone+0x134/0x660
[ 2516.394895]  __do_sys_clone3+0x130/0x1f4
[ 2516.395128]  __arm64_sys_clone3+0x5c/0x7c
[ 2516.395478]  invoke_syscall.constprop.0+0x78/0x1f0
[ 2516.395762]  el0_svc_common.constprop.0+0x22c/0x2c4
[ 2516.396050]  do_el0_svc+0xb0/0x10c
[ 2516.396252]  el0_svc+0x24/0x34
[ 2516.396436]  el0t_64_sync_handler+0xa4/0x12c
[ 2516.396688]  el0t_64_sync+0x198/0x19c
[ 2517.491197] NET: Registered PF_ATMPVC protocol family
[ 2517.491524] NET: Registered PF_ATMSVC protocol family
[ 2591.991877] sched: RT throttling activated

One way to solve this problem is to move the fd_install() call out of
the sighand->siglock critical section.

Before commit 6fd2fe494b17 ("copy_process(): don't use ksys_close()
on cleanups"), the pidfd installation was done without holding both
the task_list lock and the sighand->siglock. Obviously, holding these
two locks are not really needed to protect the fd_install() call.
So move the fd_install() call down to after the releases of both locks.

Link: https://lore.kernel.org/r/20220208163912.1084752-1-longman@redhat.com
Fixes: 6fd2fe494b17 ("copy_process(): don't use ksys_close() on cleanups")
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/fork.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2350,10 +2350,6 @@ static __latent_entropy struct task_stru
 		goto bad_fork_cancel_cgroup;
 	}
 
-	/* past the last point of failure */
-	if (pidfile)
-		fd_install(pidfd, pidfile);
-
 	init_task_pid_links(p);
 	if (likely(p->pid)) {
 		ptrace_init_task(p, (clone_flags & CLONE_PTRACE) || trace);
@@ -2402,6 +2398,9 @@ static __latent_entropy struct task_stru
 	syscall_tracepoint_update(p);
 	write_unlock_irq(&tasklist_lock);
 
+	if (pidfile)
+		fd_install(pidfd, pidfile);
+
 	proc_fork_connector(p);
 	sched_post_fork(p, args);
 	cgroup_post_fork(p, args);


