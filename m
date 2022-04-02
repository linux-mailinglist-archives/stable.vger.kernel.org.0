Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCFCA4F0181
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 14:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238375AbiDBMhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 08:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237010AbiDBMhC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 08:37:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3534716D8F9
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 05:35:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCDD6B8076E
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 12:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135B1C340EC;
        Sat,  2 Apr 2022 12:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648902907;
        bh=tKppHKAlIFxjCG1UmYrhjLXjtGMvDdGRK5XHkhjHb38=;
        h=Subject:To:Cc:From:Date:From;
        b=WZvoHdSd2anJ8VM6cYQz1LgTIL3b0OS9s8lq4g8f5SR36odjK8E5talrTLYAz59Nn
         Ryezqvgf/lbHIW5Iot3vogvXsf4gNGJYsGKJ8iky/jLqo/SAwpEJ4lcB7Y5sDYW86i
         5s2iTAnOIgljIDLI89WYXpsBF2cSbiL6RoTtL3Q0=
Subject: FAILED: patch "[PATCH] pstore: Don't use semaphores in always-atomic-context code" failed to apply to 5.4-stable tree
To:     jannh@google.com, bigeasy@linutronix.de, keescook@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 14:35:04 +0200
Message-ID: <1648902904225187@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8126b1c73108bc691f5643df19071a59a69d0bc6 Mon Sep 17 00:00:00 2001
From: Jann Horn <jannh@google.com>
Date: Mon, 14 Mar 2022 19:59:53 +0100
Subject: [PATCH] pstore: Don't use semaphores in always-atomic-context code

pstore_dump() is *always* invoked in atomic context (nowadays in an RCU
read-side critical section, before that under a spinlock).
It doesn't make sense to try to use semaphores here.

This is mostly a revert of commit ea84b580b955 ("pstore: Convert buf_lock
to semaphore"), except that two parts aren't restored back exactly as they
were:

 - keep the lock initialization in pstore_register
 - in efi_pstore_write(), always set the "block" flag to false
 - omit "is_locked", that was unnecessary since
   commit 959217c84c27 ("pstore: Actually give up during locking failure")
 - fix the bailout message

The actual problem that the buggy commit was trying to address may have
been that the use of preemptible() in efi_pstore_write() was wrong - it
only looks at preempt_count() and the state of IRQs, but __rcu_read_lock()
doesn't touch either of those under CONFIG_PREEMPT_RCU.
(Sidenote: CONFIG_PREEMPT_RCU means that the scheduler can preempt tasks in
RCU read-side critical sections, but you're not allowed to actively
block/reschedule.)

Lockdep probably never caught the problem because it's very rare that you
actually hit the contended case, so lockdep always just sees the
down_trylock(), not the down_interruptible(), and so it can't tell that
there's a problem.

Fixes: ea84b580b955 ("pstore: Convert buf_lock to semaphore")
Cc: stable@vger.kernel.org
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220314185953.2068993-1-jannh@google.com

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index 0ef086e43090..7e771c56c13c 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -266,7 +266,7 @@ static int efi_pstore_write(struct pstore_record *record)
 		efi_name[i] = name[i];
 
 	ret = efivar_entry_set_safe(efi_name, vendor, PSTORE_EFI_ATTRIBUTES,
-			      preemptible(), record->size, record->psi->buf);
+			      false, record->size, record->psi->buf);
 
 	if (record->reason == KMSG_DUMP_OOPS && try_module_get(THIS_MODULE))
 		if (!schedule_work(&efivar_work))
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index f243cb5e6a4f..e26162f102ff 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -143,21 +143,22 @@ static void pstore_timer_kick(void)
 	mod_timer(&pstore_timer, jiffies + msecs_to_jiffies(pstore_update_ms));
 }
 
-/*
- * Should pstore_dump() wait for a concurrent pstore_dump()? If
- * not, the current pstore_dump() will report a failure to dump
- * and return.
- */
-static bool pstore_cannot_wait(enum kmsg_dump_reason reason)
+static bool pstore_cannot_block_path(enum kmsg_dump_reason reason)
 {
-	/* In NMI path, pstore shouldn't block regardless of reason. */
+	/*
+	 * In case of NMI path, pstore shouldn't be blocked
+	 * regardless of reason.
+	 */
 	if (in_nmi())
 		return true;
 
 	switch (reason) {
 	/* In panic case, other cpus are stopped by smp_send_stop(). */
 	case KMSG_DUMP_PANIC:
-	/* Emergency restart shouldn't be blocked. */
+	/*
+	 * Emergency restart shouldn't be blocked by spinning on
+	 * pstore_info::buf_lock.
+	 */
 	case KMSG_DUMP_EMERG:
 		return true;
 	default:
@@ -389,21 +390,19 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 	unsigned long	total = 0;
 	const char	*why;
 	unsigned int	part = 1;
+	unsigned long	flags = 0;
 	int		ret;
 
 	why = kmsg_dump_reason_str(reason);
 
-	if (down_trylock(&psinfo->buf_lock)) {
-		/* Failed to acquire lock: give up if we cannot wait. */
-		if (pstore_cannot_wait(reason)) {
-			pr_err("dump skipped in %s path: may corrupt error record\n",
-				in_nmi() ? "NMI" : why);
-			return;
-		}
-		if (down_interruptible(&psinfo->buf_lock)) {
-			pr_err("could not grab semaphore?!\n");
+	if (pstore_cannot_block_path(reason)) {
+		if (!spin_trylock_irqsave(&psinfo->buf_lock, flags)) {
+			pr_err("dump skipped in %s path because of concurrent dump\n",
+					in_nmi() ? "NMI" : why);
 			return;
 		}
+	} else {
+		spin_lock_irqsave(&psinfo->buf_lock, flags);
 	}
 
 	kmsg_dump_rewind(&iter);
@@ -467,8 +466,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 		total += record.size;
 		part++;
 	}
-
-	up(&psinfo->buf_lock);
+	spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 }
 
 static struct kmsg_dumper pstore_dumper = {
@@ -594,7 +592,7 @@ int pstore_register(struct pstore_info *psi)
 		psi->write_user = pstore_write_user_compat;
 	psinfo = psi;
 	mutex_init(&psinfo->read_mutex);
-	sema_init(&psinfo->buf_lock, 1);
+	spin_lock_init(&psinfo->buf_lock);
 
 	if (psi->flags & PSTORE_FLAGS_DMESG)
 		allocate_buf_for_compression();
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index eb93a54cff31..e97a8188f0fd 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -14,7 +14,7 @@
 #include <linux/errno.h>
 #include <linux/kmsg_dump.h>
 #include <linux/mutex.h>
-#include <linux/semaphore.h>
+#include <linux/spinlock.h>
 #include <linux/time.h>
 #include <linux/types.h>
 
@@ -87,7 +87,7 @@ struct pstore_record {
  * @owner:	module which is responsible for this backend driver
  * @name:	name of the backend driver
  *
- * @buf_lock:	semaphore to serialize access to @buf
+ * @buf_lock:	spinlock to serialize access to @buf
  * @buf:	preallocated crash dump buffer
  * @bufsize:	size of @buf available for crash dump bytes (must match
  *		smallest number of bytes available for writing to a
@@ -178,7 +178,7 @@ struct pstore_info {
 	struct module	*owner;
 	const char	*name;
 
-	struct semaphore buf_lock;
+	spinlock_t	buf_lock;
 	char		*buf;
 	size_t		bufsize;
 

