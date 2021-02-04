Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63DDD30AABF
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 16:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhBAPOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 10:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbhBAPOQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 10:14:16 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8002C0613ED
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 07:13:35 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id d16so16928605wro.11
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 07:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K5rbjOGkExgtzLhLra22CQVxtXBAO/XwKYwFCVpvkjQ=;
        b=E6l16lbFXzc3E5GVrhq8Gw1zEzI43yDD2QuHQRxlyJpBukoJxB1VL40A82i1xttjUc
         wWKSeODyfxqzO17MgmyED8TVG9YYb9cjyoVJZVUH85BjlVvjcPVxAMneDJ6ohwKNZmVw
         hLI+nRNnChA2mC874CJqqS6qS80TamSXjFBoWlAZxirXs8Uyz/m+9GdPpWZxPIrW8zjF
         glIm+VJ1fGomSxfiggsYen6RUgLSzvJBRlw6PLlFa8sZWpzW/d4jIdSTomWxPvpdDHQO
         Hkv/xz7sWO9+FAE039ccEO5vyGKgYiMo2p//infBpdrnPfTl/kIB5OGwk8+auaLswIX7
         C7zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K5rbjOGkExgtzLhLra22CQVxtXBAO/XwKYwFCVpvkjQ=;
        b=dxWe7RAPAqjqHRpA8NqFseACM3KHN0BZ2itpr9PA3sEaW7UVHiD2teAHH3G3iUkqOg
         BrL9AiDcqLqVqj0ad+kO1UMepl5+TtxsiqaH226pIiYn0b3+2Hv2y3kbD6h69ASkRP0h
         MJC2msMSCrE9mXBZna+T4wFK6Ei+ItSgTE3lcbAQ+H6g0FD+XLnfm0s4eTcLfuLRFxqV
         KMgMlDBcWYdbykTvkEVM0t90iZ1yVZPrm5/Rae+Z1aQN3xfB/01xEctqYVdVPDBRGzRA
         OAZQPh/DS3h5Sryg8sqLsXsU+qx12gbX+ub9c+SvVdGW3h27KKPLDhUCShH53pmaaprN
         j0MQ==
X-Gm-Message-State: AOAM530IwvipQGxqmfubUUhTNe1vO9bvj0ai+bdEpVDyMtzv7nDOrMxY
        3mfwKTXespKVIPJvRXLz1MasmTVC7J4HF8p1
X-Google-Smtp-Source: ABdhPJxPd3YfNCwH2c3Ut/rlAgpjNLrNzZVnpJk4J7K6LA0mtndush5DM9lfRtWe3+y4N5Vz3Idpew==
X-Received: by 2002:a5d:68cc:: with SMTP id p12mr18044054wrw.276.1612192414152;
        Mon, 01 Feb 2021 07:13:34 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id 192sm23323381wme.27.2021.02.01.07.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 07:13:33 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 01/12] y2038: futex: Move compat implementation into futex.c
Date:   Mon,  1 Feb 2021 15:12:03 +0000
Message-Id: <20210201151214.2193508-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201151214.2193508-1-lee.jones@linaro.org>
References: <20210201151214.2193508-1-lee.jones@linaro.org>
MIME-Version: 1.0
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
---
 include/linux/futex.h |   8 --
 kernel/Makefile       |   3 -
 kernel/futex.c        | 195 +++++++++++++++++++++++++++++++++++++++-
 kernel/futex_compat.c | 201 ------------------------------------------
 4 files changed, 192 insertions(+), 215 deletions(-)
 delete mode 100644 kernel/futex_compat.c

diff --git a/include/linux/futex.h b/include/linux/futex.h
index c015fa91e7cce..fb4e12cbe887e 100644
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
diff --git a/kernel/Makefile b/kernel/Makefile
index 53abf008ecb39..a672bece1f499 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -36,9 +36,6 @@ obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
 obj-$(CONFIG_FUTEX) += futex.o
-ifeq ($(CONFIG_COMPAT),y)
-obj-$(CONFIG_FUTEX) += futex_compat.o
-endif
 obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
 obj-$(CONFIG_SMP) += smp.o
 ifneq ($(CONFIG_SMP),y)
diff --git a/kernel/futex.c b/kernel/futex.c
index e50b67674ba25..2815b1801ec5a 100644
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
@@ -3088,7 +3091,7 @@ err_unlock:
  * Process a futex-list entry, check whether it's owned by the
  * dying task, and do notification if so:
  */
-int handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi)
+static int handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi)
 {
 	u32 uval, uninitialized_var(nval), mval;
 
@@ -3318,6 +3321,192 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
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
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
deleted file mode 100644
index 4ae3232e7a28a..0000000000000
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
-- 
2.25.1

