Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DE530C0E8
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbhBBOKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:10:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:48892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233951AbhBBOIe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:08:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80DB66502A;
        Tue,  2 Feb 2021 13:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273817;
        bh=s03BhVqrOox6nd+uSEz+3DvdL02rQBQgyotoO2izrWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRkdFtKaQiQ0njhz0kBPgYPt68+xfls+ua6eSCpCn3H+HdqlPh2TPAa/AU1rwgJNR
         lsUBL76ZbSMnlZqkZl8Wa3y4hj4HBMwm/Afr6NVAX4WslZPfB/4OGAYY1KLEXcHUdH
         82hYZfkpX/5yzk5TMyZesWvrm6nuoYk/lXMmqe4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 04/32] y2038: futex: Move compat implementation into futex.c
Date:   Tue,  2 Feb 2021 14:38:27 +0100
Message-Id: <20210202132942.213518411@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.035179752@linuxfoundation.org>
References: <20210202132942.035179752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 04e7712f4460585e5eed5b853fd8b82a9943958f upstream.

We are going to share the compat_sys_futex() handler between 64-bit
architectures and 32-bit architectures that need to deal with both 32-bit
and 64-bit time_t, and this is easier if both entry points are in the
same file.

In fact, most other system call handlers do the same thing these days, so
let's follow the trend here and merge all of futex_compat.c into futex.c.

In the process, a few minor changes have to be done to make sure everything
still makes sense: handle_futex_death() and futex_cmpxchg_enabled() become
local symbol, and the compat version of the fetch_robust_entry() function
gets renamed to compat_fetch_robust_entry() to avoid a symbol clash.

This is intended as a purely cosmetic patch, no behavior should
change.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Lee: Back-ported to satisfy a build dependency]
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/futex.h |    8 -
 kernel/Makefile       |    3 
 kernel/futex.c        |  195 +++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/futex_compat.c |  201 --------------------------------------------------
 4 files changed, 192 insertions(+), 215 deletions(-)
 delete mode 100644 kernel/futex_compat.c

--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -11,9 +11,6 @@ union ktime;
 long do_futex(u32 __user *uaddr, int op, u32 val, union ktime *timeout,
 	      u32 __user *uaddr2, u32 val2, u32 val3);
 
-extern int
-handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi);
-
 /*
  * Futexes are matched on equal values of this key.
  * The key type depends on whether it's a shared or private mapping.
@@ -58,11 +55,6 @@ union futex_key {
 #ifdef CONFIG_FUTEX
 extern void exit_robust_list(struct task_struct *curr);
 extern void exit_pi_state_list(struct task_struct *curr);
-#ifdef CONFIG_HAVE_FUTEX_CMPXCHG
-#define futex_cmpxchg_enabled 1
-#else
-extern int futex_cmpxchg_enabled;
-#endif
 #else
 static inline void exit_robust_list(struct task_struct *curr)
 {
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -47,9 +47,6 @@ obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
 obj-$(CONFIG_FUTEX) += futex.o
-ifeq ($(CONFIG_COMPAT),y)
-obj-$(CONFIG_FUTEX) += futex_compat.o
-endif
 obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
 obj-$(CONFIG_SMP) += smp.o
 ifneq ($(CONFIG_SMP),y)
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -44,6 +44,7 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
+#include <linux/compat.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/fs.h>
@@ -171,8 +172,10 @@
  * double_lock_hb() and double_unlock_hb(), respectively.
  */
 
-#ifndef CONFIG_HAVE_FUTEX_CMPXCHG
-int __read_mostly futex_cmpxchg_enabled;
+#ifdef CONFIG_HAVE_FUTEX_CMPXCHG
+#define futex_cmpxchg_enabled 1
+#else
+static int  __read_mostly futex_cmpxchg_enabled;
 #endif
 
 /*
@@ -3123,7 +3126,7 @@ err_unlock:
  * Process a futex-list entry, check whether it's owned by the
  * dying task, and do notification if so:
  */
-int handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi)
+static int handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi)
 {
 	u32 uval, uninitialized_var(nval), mval;
 
@@ -3354,6 +3357,192 @@ SYSCALL_DEFINE6(futex, u32 __user *, uad
 	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
 }
 
+#ifdef CONFIG_COMPAT
+/*
+ * Fetch a robust-list pointer. Bit 0 signals PI futexes:
+ */
+static inline int
+compat_fetch_robust_entry(compat_uptr_t *uentry, struct robust_list __user **entry,
+		   compat_uptr_t __user *head, unsigned int *pi)
+{
+	if (get_user(*uentry, head))
+		return -EFAULT;
+
+	*entry = compat_ptr((*uentry) & ~1);
+	*pi = (unsigned int)(*uentry) & 1;
+
+	return 0;
+}
+
+static void __user *futex_uaddr(struct robust_list __user *entry,
+				compat_long_t futex_offset)
+{
+	compat_uptr_t base = ptr_to_compat(entry);
+	void __user *uaddr = compat_ptr(base + futex_offset);
+
+	return uaddr;
+}
+
+/*
+ * Walk curr->robust_list (very carefully, it's a userspace list!)
+ * and mark any locks found there dead, and notify any waiters.
+ *
+ * We silently return on any sign of list-walking problem.
+ */
+void compat_exit_robust_list(struct task_struct *curr)
+{
+	struct compat_robust_list_head __user *head = curr->compat_robust_list;
+	struct robust_list __user *entry, *next_entry, *pending;
+	unsigned int limit = ROBUST_LIST_LIMIT, pi, pip;
+	unsigned int uninitialized_var(next_pi);
+	compat_uptr_t uentry, next_uentry, upending;
+	compat_long_t futex_offset;
+	int rc;
+
+	if (!futex_cmpxchg_enabled)
+		return;
+
+	/*
+	 * Fetch the list head (which was registered earlier, via
+	 * sys_set_robust_list()):
+	 */
+	if (compat_fetch_robust_entry(&uentry, &entry, &head->list.next, &pi))
+		return;
+	/*
+	 * Fetch the relative futex offset:
+	 */
+	if (get_user(futex_offset, &head->futex_offset))
+		return;
+	/*
+	 * Fetch any possibly pending lock-add first, and handle it
+	 * if it exists:
+	 */
+	if (compat_fetch_robust_entry(&upending, &pending,
+			       &head->list_op_pending, &pip))
+		return;
+
+	next_entry = NULL;	/* avoid warning with gcc */
+	while (entry != (struct robust_list __user *) &head->list) {
+		/*
+		 * Fetch the next entry in the list before calling
+		 * handle_futex_death:
+		 */
+		rc = compat_fetch_robust_entry(&next_uentry, &next_entry,
+			(compat_uptr_t __user *)&entry->next, &next_pi);
+		/*
+		 * A pending lock might already be on the list, so
+		 * dont process it twice:
+		 */
+		if (entry != pending) {
+			void __user *uaddr = futex_uaddr(entry, futex_offset);
+
+			if (handle_futex_death(uaddr, curr, pi))
+				return;
+		}
+		if (rc)
+			return;
+		uentry = next_uentry;
+		entry = next_entry;
+		pi = next_pi;
+		/*
+		 * Avoid excessively long or circular lists:
+		 */
+		if (!--limit)
+			break;
+
+		cond_resched();
+	}
+	if (pending) {
+		void __user *uaddr = futex_uaddr(pending, futex_offset);
+
+		handle_futex_death(uaddr, curr, pip);
+	}
+}
+
+COMPAT_SYSCALL_DEFINE2(set_robust_list,
+		struct compat_robust_list_head __user *, head,
+		compat_size_t, len)
+{
+	if (!futex_cmpxchg_enabled)
+		return -ENOSYS;
+
+	if (unlikely(len != sizeof(*head)))
+		return -EINVAL;
+
+	current->compat_robust_list = head;
+
+	return 0;
+}
+
+COMPAT_SYSCALL_DEFINE3(get_robust_list, int, pid,
+			compat_uptr_t __user *, head_ptr,
+			compat_size_t __user *, len_ptr)
+{
+	struct compat_robust_list_head __user *head;
+	unsigned long ret;
+	struct task_struct *p;
+
+	if (!futex_cmpxchg_enabled)
+		return -ENOSYS;
+
+	rcu_read_lock();
+
+	ret = -ESRCH;
+	if (!pid)
+		p = current;
+	else {
+		p = find_task_by_vpid(pid);
+		if (!p)
+			goto err_unlock;
+	}
+
+	ret = -EPERM;
+	if (!ptrace_may_access(p, PTRACE_MODE_READ_REALCREDS))
+		goto err_unlock;
+
+	head = p->compat_robust_list;
+	rcu_read_unlock();
+
+	if (put_user(sizeof(*head), len_ptr))
+		return -EFAULT;
+	return put_user(ptr_to_compat(head), head_ptr);
+
+err_unlock:
+	rcu_read_unlock();
+
+	return ret;
+}
+
+COMPAT_SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
+		struct compat_timespec __user *, utime, u32 __user *, uaddr2,
+		u32, val3)
+{
+	struct timespec ts;
+	ktime_t t, *tp = NULL;
+	int val2 = 0;
+	int cmd = op & FUTEX_CMD_MASK;
+
+	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
+		      cmd == FUTEX_WAIT_BITSET ||
+		      cmd == FUTEX_WAIT_REQUEUE_PI)) {
+		if (compat_get_timespec(&ts, utime))
+			return -EFAULT;
+		if (!timespec_valid(&ts))
+			return -EINVAL;
+
+		t = timespec_to_ktime(ts);
+		if (cmd == FUTEX_WAIT)
+			t = ktime_add_safe(ktime_get(), t);
+		tp = &t;
+	}
+	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE ||
+	    cmd == FUTEX_CMP_REQUEUE_PI || cmd == FUTEX_WAKE_OP)
+		val2 = (int) (unsigned long) utime;
+
+	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
+}
+#endif /* CONFIG_COMPAT */
+
 static void __init futex_detect_cmpxchg(void)
 {
 #ifndef CONFIG_HAVE_FUTEX_CMPXCHG
--- a/kernel/futex_compat.c
+++ /dev/null
@@ -1,201 +0,0 @@
-/*
- * linux/kernel/futex_compat.c
- *
- * Futex compatibililty routines.
- *
- * Copyright 2006, Red Hat, Inc., Ingo Molnar
- */
-
-#include <linux/linkage.h>
-#include <linux/compat.h>
-#include <linux/nsproxy.h>
-#include <linux/futex.h>
-#include <linux/ptrace.h>
-#include <linux/syscalls.h>
-
-#include <asm/uaccess.h>
-
-
-/*
- * Fetch a robust-list pointer. Bit 0 signals PI futexes:
- */
-static inline int
-fetch_robust_entry(compat_uptr_t *uentry, struct robust_list __user **entry,
-		   compat_uptr_t __user *head, unsigned int *pi)
-{
-	if (get_user(*uentry, head))
-		return -EFAULT;
-
-	*entry = compat_ptr((*uentry) & ~1);
-	*pi = (unsigned int)(*uentry) & 1;
-
-	return 0;
-}
-
-static void __user *futex_uaddr(struct robust_list __user *entry,
-				compat_long_t futex_offset)
-{
-	compat_uptr_t base = ptr_to_compat(entry);
-	void __user *uaddr = compat_ptr(base + futex_offset);
-
-	return uaddr;
-}
-
-/*
- * Walk curr->robust_list (very carefully, it's a userspace list!)
- * and mark any locks found there dead, and notify any waiters.
- *
- * We silently return on any sign of list-walking problem.
- */
-void compat_exit_robust_list(struct task_struct *curr)
-{
-	struct compat_robust_list_head __user *head = curr->compat_robust_list;
-	struct robust_list __user *entry, *next_entry, *pending;
-	unsigned int limit = ROBUST_LIST_LIMIT, pi, pip;
-	unsigned int uninitialized_var(next_pi);
-	compat_uptr_t uentry, next_uentry, upending;
-	compat_long_t futex_offset;
-	int rc;
-
-	if (!futex_cmpxchg_enabled)
-		return;
-
-	/*
-	 * Fetch the list head (which was registered earlier, via
-	 * sys_set_robust_list()):
-	 */
-	if (fetch_robust_entry(&uentry, &entry, &head->list.next, &pi))
-		return;
-	/*
-	 * Fetch the relative futex offset:
-	 */
-	if (get_user(futex_offset, &head->futex_offset))
-		return;
-	/*
-	 * Fetch any possibly pending lock-add first, and handle it
-	 * if it exists:
-	 */
-	if (fetch_robust_entry(&upending, &pending,
-			       &head->list_op_pending, &pip))
-		return;
-
-	next_entry = NULL;	/* avoid warning with gcc */
-	while (entry != (struct robust_list __user *) &head->list) {
-		/*
-		 * Fetch the next entry in the list before calling
-		 * handle_futex_death:
-		 */
-		rc = fetch_robust_entry(&next_uentry, &next_entry,
-			(compat_uptr_t __user *)&entry->next, &next_pi);
-		/*
-		 * A pending lock might already be on the list, so
-		 * dont process it twice:
-		 */
-		if (entry != pending) {
-			void __user *uaddr = futex_uaddr(entry, futex_offset);
-
-			if (handle_futex_death(uaddr, curr, pi))
-				return;
-		}
-		if (rc)
-			return;
-		uentry = next_uentry;
-		entry = next_entry;
-		pi = next_pi;
-		/*
-		 * Avoid excessively long or circular lists:
-		 */
-		if (!--limit)
-			break;
-
-		cond_resched();
-	}
-	if (pending) {
-		void __user *uaddr = futex_uaddr(pending, futex_offset);
-
-		handle_futex_death(uaddr, curr, pip);
-	}
-}
-
-COMPAT_SYSCALL_DEFINE2(set_robust_list,
-		struct compat_robust_list_head __user *, head,
-		compat_size_t, len)
-{
-	if (!futex_cmpxchg_enabled)
-		return -ENOSYS;
-
-	if (unlikely(len != sizeof(*head)))
-		return -EINVAL;
-
-	current->compat_robust_list = head;
-
-	return 0;
-}
-
-COMPAT_SYSCALL_DEFINE3(get_robust_list, int, pid,
-			compat_uptr_t __user *, head_ptr,
-			compat_size_t __user *, len_ptr)
-{
-	struct compat_robust_list_head __user *head;
-	unsigned long ret;
-	struct task_struct *p;
-
-	if (!futex_cmpxchg_enabled)
-		return -ENOSYS;
-
-	rcu_read_lock();
-
-	ret = -ESRCH;
-	if (!pid)
-		p = current;
-	else {
-		p = find_task_by_vpid(pid);
-		if (!p)
-			goto err_unlock;
-	}
-
-	ret = -EPERM;
-	if (!ptrace_may_access(p, PTRACE_MODE_READ_REALCREDS))
-		goto err_unlock;
-
-	head = p->compat_robust_list;
-	rcu_read_unlock();
-
-	if (put_user(sizeof(*head), len_ptr))
-		return -EFAULT;
-	return put_user(ptr_to_compat(head), head_ptr);
-
-err_unlock:
-	rcu_read_unlock();
-
-	return ret;
-}
-
-COMPAT_SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
-		struct compat_timespec __user *, utime, u32 __user *, uaddr2,
-		u32, val3)
-{
-	struct timespec ts;
-	ktime_t t, *tp = NULL;
-	int val2 = 0;
-	int cmd = op & FUTEX_CMD_MASK;
-
-	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
-		      cmd == FUTEX_WAIT_BITSET ||
-		      cmd == FUTEX_WAIT_REQUEUE_PI)) {
-		if (compat_get_timespec(&ts, utime))
-			return -EFAULT;
-		if (!timespec_valid(&ts))
-			return -EINVAL;
-
-		t = timespec_to_ktime(ts);
-		if (cmd == FUTEX_WAIT)
-			t = ktime_add_safe(ktime_get(), t);
-		tp = &t;
-	}
-	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE ||
-	    cmd == FUTEX_CMP_REQUEUE_PI || cmd == FUTEX_WAKE_OP)
-		val2 = (int) (unsigned long) utime;
-
-	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
-}


