Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F3C4D8BFF
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 20:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiCNTBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 15:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242650AbiCNTBl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 15:01:41 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CF913D5C
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 12:00:30 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id u10so25558672wra.9
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 12:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=llerlk2NG0FieyJzIy3f7MVNZzJZQhS4bvuz+MMuNXk=;
        b=obYSNhYKUePQ3YysT3sgqJIdXdM9orgeTQs22WrySNxlLYiR291Je76pTgiKhi0BOK
         dLgRlEcjaNhGBpS2WR0gwtg/vuoMKtBGB+bEpsZfvwhcAvbR1RZAmKun7agoGZeaVF9q
         9zyPgf/pZxss9DYxj6mCOv0kk3o4wHvDYD+J1D5epZYQdkp8alFU3NBnNqhWWEqaIdDj
         QvIGV28LyI6AyJgvadOndzc7AZ7WRMd5oinYBS6Pr0fi1n/x344ZQawPee/HEChCHm8s
         BlUuLxDDmrAc3hRBTjV63pC9faikDxDQOxK8hBE5VHifEEqlAx1LmklnkCnFM2PWEeJ1
         Zs4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=llerlk2NG0FieyJzIy3f7MVNZzJZQhS4bvuz+MMuNXk=;
        b=NOXOnSFfEaFpBvHyuK72tLC3eAGFrFvvEbqs+pGldkCGVp1cKuUAfAwV6p2pKGfg7Y
         lyYHban38HCh1XPFXB1a2jE2q5FRD5XjquqaHATN1jL3UGRqiwmnHvBxK0/q5v0cL/is
         d30GL0TC96sm/ZbBxDNR5ggOraKNryhL0Izsgo8aUuRXtn2DtSg0zRMMfxvOrXlgxOHL
         7GHbuZMGVvmoXK+UKsUdt5UGO7LyIrcMZx0HiAhHmThvDaFgBc/4sTCn7ch86KxQaKhl
         iv1j8e8hu8xvypVXB6i4W5ohZNWqu2WWjpgBFDD3stlNDnvtGfSm5Q8CS/fa8tMRgc8m
         Dcgw==
X-Gm-Message-State: AOAM5313JWmyHitbqRMtOKfCkzcSrQ8G942SJfU7eGcfepWrQXz8zJQ1
        f3f2JB4sDympJbxW5EQNkfnUMA==
X-Google-Smtp-Source: ABdhPJzsmi59fQgBj/mMOkzCbcERD/+vtR5HmlpbsThXjp1rXFnmV6BfyBkYpe0SkIEcEJiBUSgfTg==
X-Received: by 2002:adf:ea4a:0:b0:1f0:6501:80f7 with SMTP id j10-20020adfea4a000000b001f0650180f7mr17075326wrn.306.1647284428492;
        Mon, 14 Mar 2022 12:00:28 -0700 (PDT)
Received: from localhost ([2a00:79e0:9d:200:401a:1554:bd99:b09d])
        by smtp.gmail.com with ESMTPSA id i5-20020a1c3b05000000b00382871cf734sm290755wma.25.2022.03.14.12.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 12:00:27 -0700 (PDT)
From:   Jann Horn <jannh@google.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jann Horn <jannh@google.com>, stable@vger.kernel.org
Subject: [PATCH v3] pstore: Don't use semaphores in always-atomic-context code
Date:   Mon, 14 Mar 2022 19:59:53 +0100
Message-Id: <20220314185953.2068993-1-jannh@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/firmware/efi/efi-pstore.c |  2 +-
 fs/pstore/platform.c              | 38 +++++++++++++++----------------
 include/linux/pstore.h            |  6 ++---
 3 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-p=
store.c
index 0ef086e43090..7e771c56c13c 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -266,7 +266,7 @@ static int efi_pstore_write(struct pstore_record *recor=
d)
 		efi_name[i] =3D name[i];
=20
 	ret =3D efivar_entry_set_safe(efi_name, vendor, PSTORE_EFI_ATTRIBUTES,
-			      preemptible(), record->size, record->psi->buf);
+			      false, record->size, record->psi->buf);
=20
 	if (record->reason =3D=3D KMSG_DUMP_OOPS && try_module_get(THIS_MODULE))
 		if (!schedule_work(&efivar_work))
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index f243cb5e6a4f..e26162f102ff 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -143,21 +143,22 @@ static void pstore_timer_kick(void)
 	mod_timer(&pstore_timer, jiffies + msecs_to_jiffies(pstore_update_ms));
 }
=20
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
=20
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
 	unsigned long	total =3D 0;
 	const char	*why;
 	unsigned int	part =3D 1;
+	unsigned long	flags =3D 0;
 	int		ret;
=20
 	why =3D kmsg_dump_reason_str(reason);
=20
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
=20
 	kmsg_dump_rewind(&iter);
@@ -467,8 +466,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 		total +=3D record.size;
 		part++;
 	}
-
-	up(&psinfo->buf_lock);
+	spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 }
=20
 static struct kmsg_dumper pstore_dumper =3D {
@@ -594,7 +592,7 @@ int pstore_register(struct pstore_info *psi)
 		psi->write_user =3D pstore_write_user_compat;
 	psinfo =3D psi;
 	mutex_init(&psinfo->read_mutex);
-	sema_init(&psinfo->buf_lock, 1);
+	spin_lock_init(&psinfo->buf_lock);
=20
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
=20
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
=20
-	struct semaphore buf_lock;
+	spinlock_t	buf_lock;
 	char		*buf;
 	size_t		bufsize;
=20

base-commit: 83e396641110663d3c7bb25b9bc0c6a750359ecf
--=20
2.35.1.723.g4982287a31-goog

