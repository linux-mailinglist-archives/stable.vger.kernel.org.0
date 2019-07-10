Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3F5C62242
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731344AbfGHPYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:24:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388276AbfGHPYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:24:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A39B216E3;
        Mon,  8 Jul 2019 15:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599440;
        bh=Dj76J/udGWUXimEaIbl4qmG+aoTNbjxnl+OZcc89+fU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jqnqRFHCm/RglGQLgaAzsXOuKZz1MTgZnxCc24wzAJdHqiCLjvOpa3S0eOoQWNBID
         xgdoHi6ZN+GR1+Tv2P3cLOviBwYlt11gMOvVPgdQmajQ5Pd1azy5XrS66WR2skL7gc
         xR6tdridiOto1tZulH6QysdQwbVi1s5p7+uW0xE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Phil Auld <pauld@redhat.com>, Joel Savitz <jsavitz@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 16/56] cpuset: restore sanity to cpuset_cpus_allowed_fallback()
Date:   Mon,  8 Jul 2019 17:13:08 +0200
Message-Id: <20190708150519.990814326@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150514.376317156@linuxfoundation.org>
References: <20190708150514.376317156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d477f8c202d1f0d4791ab1263ca7657bbe5cf79e ]

In the case that a process is constrained by taskset(1) (i.e.
sched_setaffinity(2)) to a subset of available cpus, and all of those are
subsequently offlined, the scheduler will set tsk->cpus_allowed to
the current value of task_cs(tsk)->effective_cpus.

This is done via a call to do_set_cpus_allowed() in the context of
cpuset_cpus_allowed_fallback() made by the scheduler when this case is
detected. This is the only call made to cpuset_cpus_allowed_fallback()
in the latest mainline kernel.

However, this is not sane behavior.

I will demonstrate this on a system running the latest upstream kernel
with the following initial configuration:

	# grep -i cpu /proc/$$/status
	Cpus_allowed:	ffffffff,fffffff
	Cpus_allowed_list:	0-63

(Where cpus 32-63 are provided via smt.)

If we limit our current shell process to cpu2 only and then offline it
and reonline it:

	# taskset -p 4 $$
	pid 2272's current affinity mask: ffffffffffffffff
	pid 2272's new affinity mask: 4

	# echo off > /sys/devices/system/cpu/cpu2/online
	# dmesg | tail -3
	[ 2195.866089] process 2272 (bash) no longer affine to cpu2
	[ 2195.872700] IRQ 114: no longer affine to CPU2
	[ 2195.879128] smpboot: CPU 2 is now offline

	# echo on > /sys/devices/system/cpu/cpu2/online
	# dmesg | tail -1
	[ 2617.043572] smpboot: Booting Node 0 Processor 2 APIC 0x4

We see that our current process now has an affinity mask containing
every cpu available on the system _except_ the one we originally
constrained it to:

	# grep -i cpu /proc/$$/status
	Cpus_allowed:   ffffffff,fffffffb
	Cpus_allowed_list:      0-1,3-63

This is not sane behavior, as the scheduler can now not only place the
process on previously forbidden cpus, it can't even schedule it on
the cpu it was originally constrained to!

Other cases result in even more exotic affinity masks. Take for instance
a process with an affinity mask containing only cpus provided by smt at
the moment that smt is toggled, in a configuration such as the following:

	# taskset -p f000000000 $$
	# grep -i cpu /proc/$$/status
	Cpus_allowed:	000000f0,00000000
	Cpus_allowed_list:	36-39

A double toggle of smt results in the following behavior:

	# echo off > /sys/devices/system/cpu/smt/control
	# echo on > /sys/devices/system/cpu/smt/control
	# grep -i cpus /proc/$$/status
	Cpus_allowed:	ffffff00,ffffffff
	Cpus_allowed_list:	0-31,40-63

This is even less sane than the previous case, as the new affinity mask
excludes all smt-provided cpus with ids less than those that were
previously in the affinity mask, as well as those that were actually in
the mask.

With this patch applied, both of these cases end in the following state:

	# grep -i cpu /proc/$$/status
	Cpus_allowed:	ffffffff,ffffffff
	Cpus_allowed_list:	0-63

The original policy is discarded. Though not ideal, it is the simplest way
to restore sanity to this fallback case without reinventing the cpuset
wheel that rolls down the kernel just fine in cgroup v2. A user who wishes
for the previous affinity mask to be restored in this fallback case can use
that mechanism instead.

This patch modifies scheduler behavior by instead resetting the mask to
task_cs(tsk)->cpus_allowed by default, and cpu_possible mask in legacy
mode. I tested the cases above on both modes.

Note that the scheduler uses this fallback mechanism if and only if
_every_ other valid avenue has been traveled, and it is the last resort
before calling BUG().

Suggested-by: Waiman Long <longman@redhat.com>
Suggested-by: Phil Auld <pauld@redhat.com>
Signed-off-by: Joel Savitz <jsavitz@redhat.com>
Acked-by: Phil Auld <pauld@redhat.com>
Acked-by: Waiman Long <longman@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 4657e2924ecb..0a0e1aa11f5e 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2436,10 +2436,23 @@ void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 	spin_unlock_irqrestore(&callback_lock, flags);
 }
 
+/**
+ * cpuset_cpus_allowed_fallback - final fallback before complete catastrophe.
+ * @tsk: pointer to task_struct with which the scheduler is struggling
+ *
+ * Description: In the case that the scheduler cannot find an allowed cpu in
+ * tsk->cpus_allowed, we fall back to task_cs(tsk)->cpus_allowed. In legacy
+ * mode however, this value is the same as task_cs(tsk)->effective_cpus,
+ * which will not contain a sane cpumask during cases such as cpu hotplugging.
+ * This is the absolute last resort for the scheduler and it is only used if
+ * _every_ other avenue has been traveled.
+ **/
+
 void cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 {
 	rcu_read_lock();
-	do_set_cpus_allowed(tsk, task_cs(tsk)->effective_cpus);
+	do_set_cpus_allowed(tsk, is_in_v2_mode() ?
+		task_cs(tsk)->cpus_allowed : cpu_possible_mask);
 	rcu_read_unlock();
 
 	/*
-- 
2.20.1



