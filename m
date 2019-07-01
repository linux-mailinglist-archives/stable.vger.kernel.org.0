Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34B223A795
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731047AbfFIQvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:51:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731867AbfFIQvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:51:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0F6A2083D;
        Sun,  9 Jun 2019 16:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099064;
        bh=LxIvHh/iYPn4Am1CEqmbscL4NNy5pXQ+zMra3YlbCvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFxGPfWKBsv2tqhDqD9HQzCIZoPhLsZLoo+5p6T0q9L+m7txg8qFM3I0UM5b6XJWO
         7SnRyjse6hRQgpgnGkJG/RnKzWvP4C/2i6n4HquKt7zNfvOf+Sy8qqs3gvyQ7zraoq
         O8UMZMGgtaVLRnRbuAtcUFRFSt+x9OxmhHWxoavw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 4.14 17/35] pstore: Convert buf_lock to semaphore
Date:   Sun,  9 Jun 2019 18:42:23 +0200
Message-Id: <20190609164126.502935305@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164125.377368385@linuxfoundation.org>
References: <20190609164125.377368385@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit ea84b580b95521644429cc6748b6c2bf27c8b0f3 upstream.

Instead of running with interrupts disabled, use a semaphore. This should
make it easier for backends that may need to sleep (e.g. EFI) when
performing a write:

|BUG: sleeping function called from invalid context at kernel/sched/completion.c:99
|in_atomic(): 1, irqs_disabled(): 1, pid: 2236, name: sig-xstate-bum
|Preemption disabled at:
|[<ffffffff99d60512>] pstore_dump+0x72/0x330
|CPU: 26 PID: 2236 Comm: sig-xstate-bum Tainted: G      D           4.20.0-rc3 #45
|Call Trace:
| dump_stack+0x4f/0x6a
| ___might_sleep.cold.91+0xd3/0xe4
| __might_sleep+0x50/0x90
| wait_for_completion+0x32/0x130
| virt_efi_query_variable_info+0x14e/0x160
| efi_query_variable_store+0x51/0x1a0
| efivar_entry_set_safe+0xa3/0x1b0
| efi_pstore_write+0x109/0x140
| pstore_dump+0x11c/0x330
| kmsg_dump+0xa4/0xd0
| oops_exit+0x22/0x30
...

Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Fixes: 21b3ddd39fee ("efi: Don't use spinlocks for efi vars")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/nvram_64.c    |    2 -
 drivers/acpi/apei/erst.c          |    1 
 drivers/firmware/efi/efi-pstore.c |    4 ---
 fs/pstore/platform.c              |   44 +++++++++++++++++++-------------------
 fs/pstore/ram.c                   |    1 
 include/linux/pstore.h            |    7 ++----
 6 files changed, 27 insertions(+), 32 deletions(-)

--- a/arch/powerpc/kernel/nvram_64.c
+++ b/arch/powerpc/kernel/nvram_64.c
@@ -566,8 +566,6 @@ static int nvram_pstore_init(void)
 	nvram_pstore_info.buf = oops_data;
 	nvram_pstore_info.bufsize = oops_data_sz;
 
-	spin_lock_init(&nvram_pstore_info.buf_lock);
-
 	rc = pstore_register(&nvram_pstore_info);
 	if (rc && (rc != -EPERM))
 		/* Print error only when pstore.backend == nvram */
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -1175,7 +1175,6 @@ static int __init erst_init(void)
 	"Error Record Serialization Table (ERST) support is initialized.\n");
 
 	buf = kmalloc(erst_erange.size, GFP_KERNEL);
-	spin_lock_init(&erst_info.buf_lock);
 	if (buf) {
 		erst_info.buf = buf + sizeof(struct cper_pstore_record);
 		erst_info.bufsize = erst_erange.size -
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -258,8 +258,7 @@ static int efi_pstore_write(struct pstor
 		efi_name[i] = name[i];
 
 	ret = efivar_entry_set_safe(efi_name, vendor, PSTORE_EFI_ATTRIBUTES,
-			      !pstore_cannot_block_path(record->reason),
-			      record->size, record->psi->buf);
+			      preemptible(), record->size, record->psi->buf);
 
 	if (record->reason == KMSG_DUMP_OOPS)
 		efivar_run_worker();
@@ -368,7 +367,6 @@ static __init int efivars_pstore_init(vo
 		return -ENOMEM;
 
 	efi_pstore_info.bufsize = 1024;
-	spin_lock_init(&efi_pstore_info.buf_lock);
 
 	if (pstore_register(&efi_pstore_info)) {
 		kfree(efi_pstore_info.buf);
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -129,26 +129,27 @@ static const char *get_reason_str(enum k
 	}
 }
 
-bool pstore_cannot_block_path(enum kmsg_dump_reason reason)
+/*
+ * Should pstore_dump() wait for a concurrent pstore_dump()? If
+ * not, the current pstore_dump() will report a failure to dump
+ * and return.
+ */
+static bool pstore_cannot_wait(enum kmsg_dump_reason reason)
 {
-	/*
-	 * In case of NMI path, pstore shouldn't be blocked
-	 * regardless of reason.
-	 */
+	/* In NMI path, pstore shouldn't block regardless of reason. */
 	if (in_nmi())
 		return true;
 
 	switch (reason) {
 	/* In panic case, other cpus are stopped by smp_send_stop(). */
 	case KMSG_DUMP_PANIC:
-	/* Emergency restart shouldn't be blocked by spin lock. */
+	/* Emergency restart shouldn't be blocked. */
 	case KMSG_DUMP_EMERG:
 		return true;
 	default:
 		return false;
 	}
 }
-EXPORT_SYMBOL_GPL(pstore_cannot_block_path);
 
 #ifdef CONFIG_PSTORE_ZLIB_COMPRESS
 /* Derived from logfs_compress() */
@@ -499,23 +500,23 @@ static void pstore_dump(struct kmsg_dump
 	unsigned long	total = 0;
 	const char	*why;
 	unsigned int	part = 1;
-	unsigned long	flags = 0;
-	int		is_locked;
 	int		ret;
 
 	why = get_reason_str(reason);
 
-	if (pstore_cannot_block_path(reason)) {
-		is_locked = spin_trylock_irqsave(&psinfo->buf_lock, flags);
-		if (!is_locked) {
-			pr_err("pstore dump routine blocked in %s path, may corrupt error record\n"
-				       , in_nmi() ? "NMI" : why);
+	if (down_trylock(&psinfo->buf_lock)) {
+		/* Failed to acquire lock: give up if we cannot wait. */
+		if (pstore_cannot_wait(reason)) {
+			pr_err("dump skipped in %s path: may corrupt error record\n",
+				in_nmi() ? "NMI" : why);
+			return;
+		}
+		if (down_interruptible(&psinfo->buf_lock)) {
+			pr_err("could not grab semaphore?!\n");
 			return;
 		}
-	} else {
-		spin_lock_irqsave(&psinfo->buf_lock, flags);
-		is_locked = 1;
 	}
+
 	oopscount++;
 	while (total < kmsg_bytes) {
 		char *dst;
@@ -532,7 +533,7 @@ static void pstore_dump(struct kmsg_dump
 		record.part = part;
 		record.buf = psinfo->buf;
 
-		if (big_oops_buf && is_locked) {
+		if (big_oops_buf) {
 			dst = big_oops_buf;
 			dst_size = big_oops_buf_sz;
 		} else {
@@ -550,7 +551,7 @@ static void pstore_dump(struct kmsg_dump
 					  dst_size, &dump_size))
 			break;
 
-		if (big_oops_buf && is_locked) {
+		if (big_oops_buf) {
 			zipped_len = pstore_compress(dst, psinfo->buf,
 						header_size + dump_size,
 						psinfo->bufsize);
@@ -573,8 +574,8 @@ static void pstore_dump(struct kmsg_dump
 		total += record.size;
 		part++;
 	}
-	if (is_locked)
-		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
+
+	up(&psinfo->buf_lock);
 }
 
 static struct kmsg_dumper pstore_dumper = {
@@ -693,6 +694,7 @@ int pstore_register(struct pstore_info *
 		psi->write_user = pstore_write_user_compat;
 	psinfo = psi;
 	mutex_init(&psinfo->read_mutex);
+	sema_init(&psinfo->buf_lock, 1);
 	spin_unlock(&pstore_lock);
 
 	if (owner && !try_module_get(owner)) {
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -812,7 +812,6 @@ static int ramoops_probe(struct platform
 		err = -ENOMEM;
 		goto fail_clear;
 	}
-	spin_lock_init(&cxt->pstore.buf_lock);
 
 	cxt->pstore.flags = PSTORE_FLAGS_DMESG;
 	if (cxt->console_size)
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -26,7 +26,7 @@
 #include <linux/errno.h>
 #include <linux/kmsg_dump.h>
 #include <linux/mutex.h>
-#include <linux/spinlock.h>
+#include <linux/semaphore.h>
 #include <linux/time.h>
 #include <linux/types.h>
 
@@ -88,7 +88,7 @@ struct pstore_record {
  * @owner:	module which is repsonsible for this backend driver
  * @name:	name of the backend driver
  *
- * @buf_lock:	spinlock to serialize access to @buf
+ * @buf_lock:	semaphore to serialize access to @buf
  * @buf:	preallocated crash dump buffer
  * @bufsize:	size of @buf available for crash dump bytes (must match
  *		smallest number of bytes available for writing to a
@@ -173,7 +173,7 @@ struct pstore_info {
 	struct module	*owner;
 	char		*name;
 
-	spinlock_t	buf_lock;
+	struct semaphore buf_lock;
 	char		*buf;
 	size_t		bufsize;
 
@@ -199,7 +199,6 @@ struct pstore_info {
 
 extern int pstore_register(struct pstore_info *);
 extern void pstore_unregister(struct pstore_info *);
-extern bool pstore_cannot_block_path(enum kmsg_dump_reason reason);
 
 struct pstore_ftrace_record {
 	unsigned long ip;


