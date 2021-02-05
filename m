Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848B23110D4
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 20:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbhBERav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:30:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233467AbhBEP7p (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:59:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F2786502E;
        Fri,  5 Feb 2021 14:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534290;
        bh=g9hHEd9p4S2lFSq1V/Bux5mX5+DYlhSY7IJqI+gmCvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bbsy4N5YnMO6G6dDnYjqxvu9gHzut2DyZkm/ouhcONUmV6EWmjpMiNNL/sMn8T2Mx
         29SEF0QPMs4lbxYwnjrKF14945j0br2BWzGBVx2AveO7WyizsMrLbl+GlM3ON4aPPK
         bGPuhQNGEdYuNiG4Gjnk+KIMpVr3b1RMaKTmOviI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 56/57] kthread: Extract KTHREAD_IS_PER_CPU
Date:   Fri,  5 Feb 2021 15:07:22 +0100
Message-Id: <20210205140658.388157614@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit ac687e6e8c26181a33270efd1a2e2241377924b0 ]

There is a need to distinguish geniune per-cpu kthreads from kthreads
that happen to have a single CPU affinity.

Geniune per-cpu kthreads are kthreads that are CPU affine for
correctness, these will obviously have PF_KTHREAD set, but must also
have PF_NO_SETAFFINITY set, lest userspace modify their affinity and
ruins things.

However, these two things are not sufficient, PF_NO_SETAFFINITY is
also set on other tasks that have their affinities controlled through
other means, like for instance workqueues.

Therefore another bit is needed; it turns out kthread_create_per_cpu()
already has such a bit: KTHREAD_IS_PER_CPU, which is used to make
kthread_park()/kthread_unpark() work correctly.

Expose this flag and remove the implicit setting of it from
kthread_create_on_cpu(); the io_uring usage of it seems dubious at
best.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Tested-by: Valentin Schneider <valentin.schneider@arm.com>
Link: https://lkml.kernel.org/r/20210121103506.557620262@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kthread.h |  3 +++
 kernel/kthread.c        | 27 ++++++++++++++++++++++++++-
 kernel/smpboot.c        |  1 +
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 65b81e0c494d2..2484ed97e72f5 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -33,6 +33,9 @@ struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
 					  unsigned int cpu,
 					  const char *namefmt);
 
+void kthread_set_per_cpu(struct task_struct *k, int cpu);
+bool kthread_is_per_cpu(struct task_struct *k);
+
 /**
  * kthread_run - create and wake a thread.
  * @threadfn: the function to run until signal_pending(current).
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 933a625621b8d..5edf7e19ab262 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -493,11 +493,36 @@ struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
 		return p;
 	kthread_bind(p, cpu);
 	/* CPU hotplug need to bind once again when unparking the thread. */
-	set_bit(KTHREAD_IS_PER_CPU, &to_kthread(p)->flags);
 	to_kthread(p)->cpu = cpu;
 	return p;
 }
 
+void kthread_set_per_cpu(struct task_struct *k, int cpu)
+{
+	struct kthread *kthread = to_kthread(k);
+	if (!kthread)
+		return;
+
+	WARN_ON_ONCE(!(k->flags & PF_NO_SETAFFINITY));
+
+	if (cpu < 0) {
+		clear_bit(KTHREAD_IS_PER_CPU, &kthread->flags);
+		return;
+	}
+
+	kthread->cpu = cpu;
+	set_bit(KTHREAD_IS_PER_CPU, &kthread->flags);
+}
+
+bool kthread_is_per_cpu(struct task_struct *k)
+{
+	struct kthread *kthread = to_kthread(k);
+	if (!kthread)
+		return false;
+
+	return test_bit(KTHREAD_IS_PER_CPU, &kthread->flags);
+}
+
 /**
  * kthread_unpark - unpark a thread created by kthread_create().
  * @k:		thread created by kthread_create().
diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index 2efe1e206167c..f25208e8df836 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -188,6 +188,7 @@ __smpboot_create_thread(struct smp_hotplug_thread *ht, unsigned int cpu)
 		kfree(td);
 		return PTR_ERR(tsk);
 	}
+	kthread_set_per_cpu(tsk, cpu);
 	/*
 	 * Park the thread so that it could start right on the CPU
 	 * when it is available.
-- 
2.27.0



