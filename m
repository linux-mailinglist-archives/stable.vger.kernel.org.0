Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 207684D5B0
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfFTSAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:00:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbfFTSAG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:00:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A78AC21530;
        Thu, 20 Jun 2019 18:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053605;
        bh=ouzMQJKSpXwjZpt1pdoZv050tBWH9isF/yYIty+FVM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K0WGYcSjl8wBURymEsA6vpc6YqtU574ZmVl+/rjaEEtT6EAB/uXmnFl2J3xIzL4kV
         8J7+x5qCu2KgbowkwACrhIFjQQl7cdohBOB1cZA5Jl2zRYEOpdhDHG7wT7vb3bhETK
         Az6IpWdkcc59vyel0F0q/0KUDie6JTGeNvGWlHdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4.4 48/84] cgroup: Use css_tryget() instead of css_tryget_online() in task_get_css()
Date:   Thu, 20 Jun 2019 19:56:45 +0200
Message-Id: <20190620174345.920912606@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174337.538228162@linuxfoundation.org>
References: <20190620174337.538228162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit 18fa84a2db0e15b02baa5d94bdb5bd509175d2f6 upstream.

A PF_EXITING task can stay associated with an offline css.  If such
task calls task_get_css(), it can get stuck indefinitely.  This can be
triggered by BSD process accounting which writes to a file with
PF_EXITING set when racing against memcg disable as in the backtrace
at the end.

After this change, task_get_css() may return a css which was already
offline when the function was called.  None of the existing users are
affected by this change.

  INFO: rcu_sched self-detected stall on CPU
  INFO: rcu_sched detected stalls on CPUs/tasks:
  ...
  NMI backtrace for cpu 0
  ...
  Call Trace:
   <IRQ>
   dump_stack+0x46/0x68
   nmi_cpu_backtrace.cold.2+0x13/0x57
   nmi_trigger_cpumask_backtrace+0xba/0xca
   rcu_dump_cpu_stacks+0x9e/0xce
   rcu_check_callbacks.cold.74+0x2af/0x433
   update_process_times+0x28/0x60
   tick_sched_timer+0x34/0x70
   __hrtimer_run_queues+0xee/0x250
   hrtimer_interrupt+0xf4/0x210
   smp_apic_timer_interrupt+0x56/0x110
   apic_timer_interrupt+0xf/0x20
   </IRQ>
  RIP: 0010:balance_dirty_pages_ratelimited+0x28f/0x3d0
  ...
   btrfs_file_write_iter+0x31b/0x563
   __vfs_write+0xfa/0x140
   __kernel_write+0x4f/0x100
   do_acct_process+0x495/0x580
   acct_process+0xb9/0xdb
   do_exit+0x748/0xa00
   do_group_exit+0x3a/0xa0
   get_signal+0x254/0x560
   do_signal+0x23/0x5c0
   exit_to_usermode_loop+0x5d/0xa0
   prepare_exit_to_usermode+0x53/0x80
   retint_user+0x8/0x8

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org # v4.2+
Fixes: ec438699a9ae ("cgroup, block: implement task_get_css() and use it in bio_associate_current()")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/cgroup.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -453,7 +453,7 @@ static inline struct cgroup_subsys_state
  *
  * Find the css for the (@task, @subsys_id) combination, increment a
  * reference on and return it.  This function is guaranteed to return a
- * valid css.
+ * valid css.  The returned css may already have been offlined.
  */
 static inline struct cgroup_subsys_state *
 task_get_css(struct task_struct *task, int subsys_id)
@@ -463,7 +463,13 @@ task_get_css(struct task_struct *task, i
 	rcu_read_lock();
 	while (true) {
 		css = task_css(task, subsys_id);
-		if (likely(css_tryget_online(css)))
+		/*
+		 * Can't use css_tryget_online() here.  A task which has
+		 * PF_EXITING set may stay associated with an offline css.
+		 * If such task calls this function, css_tryget_online()
+		 * will keep failing.
+		 */
+		if (likely(css_tryget(css)))
 			break;
 		cpu_relax();
 	}


