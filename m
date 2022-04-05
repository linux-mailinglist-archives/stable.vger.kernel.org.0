Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D632B4F2D7B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237390AbiDEJKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243979AbiDEIvX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:51:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EB5D0A83;
        Tue,  5 Apr 2022 01:40:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6137160FFB;
        Tue,  5 Apr 2022 08:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76900C385A1;
        Tue,  5 Apr 2022 08:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147971;
        bh=toUIKSG7Y9lYiTObnBI3exiCjRwsy9pdblqnPZcepWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s9XDr8qUxH19qQTVwgakgpMdjI+iiBkQSP+RjCD3e+0+jovdo+fAYBU8E0R8uoHWj
         u0gdkctyGnA3dBi8F5smSobbub4Ia+9yqqmbgSfX+tc7YBsEmKJpY7htdk4AtkX/VL
         ELR/Di2HGcvDCW24bEcIFav0s7UbL+uuZpN9xOFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.16 0161/1017] pstore: Dont use semaphores in always-atomic-context code
Date:   Tue,  5 Apr 2022 09:17:54 +0200
Message-Id: <20220405070358.998841592@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

commit 8126b1c73108bc691f5643df19071a59a69d0bc6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/efi-pstore.c |    2 +-
 fs/pstore/platform.c              |   38 ++++++++++++++++++--------------------
 include/linux/pstore.h            |    6 +++---
 3 files changed, 22 insertions(+), 24 deletions(-)

--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -266,7 +266,7 @@ static int efi_pstore_write(struct pstor
 		efi_name[i] = name[i];
 
 	ret = efivar_entry_set_safe(efi_name, vendor, PSTORE_EFI_ATTRIBUTES,
-			      preemptible(), record->size, record->psi->buf);
+			      false, record->size, record->psi->buf);
 
 	if (record->reason == KMSG_DUMP_OOPS && try_module_get(THIS_MODULE))
 		if (!schedule_work(&efivar_work))
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
@@ -389,21 +390,19 @@ static void pstore_dump(struct kmsg_dump
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
@@ -467,8 +466,7 @@ static void pstore_dump(struct kmsg_dump
 		total += record.size;
 		part++;
 	}
-
-	up(&psinfo->buf_lock);
+	spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 }
 
 static struct kmsg_dumper pstore_dumper = {
@@ -594,7 +592,7 @@ int pstore_register(struct pstore_info *
 		psi->write_user = pstore_write_user_compat;
 	psinfo = psi;
 	mutex_init(&psinfo->read_mutex);
-	sema_init(&psinfo->buf_lock, 1);
+	spin_lock_init(&psinfo->buf_lock);
 
 	if (psi->flags & PSTORE_FLAGS_DMESG)
 		allocate_buf_for_compression();
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
 


