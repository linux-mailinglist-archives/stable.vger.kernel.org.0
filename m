Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28FD64BBF5E
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 19:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238953AbiBRSUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 13:20:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238840AbiBRSUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 13:20:13 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582472558D
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 10:19:56 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id l67-20020a1c2546000000b00353951c3f62so7006498wml.5
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 10:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rUmKo6zDPfLzhi+qhg4n7EXRG8ALMjqvN8epa3kT43s=;
        b=o04zP7lc+XVtuQsvK/CrUC7+wRsKDCY3mqSEPxUdM+UbEN22ux9Do8Nm0iW18N9/Gl
         0h27bIkn0nAiG80FiLsmbYlUHLc6c3jSB0tmiUIK8CH1EWy4bP5pfhnRwKEiJ3rpW5Ew
         2UX7R7+7ziBSAiOnQ+5JhHNFK793Rjb1tAozpd8cPVJCwXdZcTvtnnzmP5NloYnyJVDt
         0/ZqkvWd20VuJO3JVpKLN2jDHXnbgCHIvlXMnFIzqWnkm+4B0eFEWmJZlZRzRrHiY0c/
         rHqVSppGmUKc/X/XN1hY618r1poG2g5ydxPZUyTgeX/XpA0i9LxF9rOP9RT20+fpSs7E
         REjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rUmKo6zDPfLzhi+qhg4n7EXRG8ALMjqvN8epa3kT43s=;
        b=LUOzlwZpNFDUNRjLaefxFBGvaSfcBDGG/un9/mTCD6v1GvXAoQR0Ua5JCQ4J+JUGCS
         esGLaMefjCjVCKNkroS7yIK/m0+s7WZprjVe45CqqljBlTV6+OTxkYnMwDp/c9FsL1S2
         CV88MedpyTVMiY594tQNvJ2fYqOdsIB6IEFAECuIwWPT3Qaoq9sgBNkN26kYbT5QbuTI
         POupUUROTA5wIhxMs5WzeJAnYv8Jj09bWLqXdWGPU6JPD5YU/XwHnV7K0XwgiWo7RT/r
         cjFR8DJ2PKVk3vJMQt16g7SeMJ9U5pb4DuSjbeDL0jT9J17S9QTeGhoHNoMeJ1lio2+x
         M35Q==
X-Gm-Message-State: AOAM5309BJmPiPlSOW1B93Chq+hvGFrcFDgpCDdPGyqpg8YJanHvBr1x
        zJpZ3fNXLM7PeaRQJBn7jdg/UA==
X-Google-Smtp-Source: ABdhPJyPGLZmnHvVqniU7dycUN77AhE6XUdPUdTNzAnswDqfar3hn8uxNIIF44pchqUJS0PTPZ84WA==
X-Received: by 2002:a7b:c44c:0:b0:37b:baaf:ae36 with SMTP id l12-20020a7bc44c000000b0037bbaafae36mr8174059wmi.81.1645208394686;
        Fri, 18 Feb 2022 10:19:54 -0800 (PST)
Received: from localhost ([2a02:168:96c5:1:55ed:514f:6ad7:5bcc])
        by smtp.gmail.com with ESMTPSA id c11-20020a05600c0a4b00b0037c91e085ddsm111734wmq.40.2022.02.18.10.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 10:19:54 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     Kees Cook <keescook@chromium.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jann Horn <jannh@google.com>, stable@vger.kernel.org
Subject: [PATCH v2] pstore: Don't use semaphores in always-atomic-context code
Date:   Fri, 18 Feb 2022 19:19:50 +0100
Message-Id: <20220218181950.1438236-1-jannh@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
changed in v2:
 - fix incomplete sentence in commit message (Sebastian)
 - make comment in pstore_cannot_block_path() more verbose (Sebastian)
 - add Sebastian's ack

Testing on 5.15.24 (latest stable), with CONFIG_PREEMPT=3Dy, when I trigger
a BUG() via LKDTM ("echo BUG > /sys/kernel/debug/provoke-crash/DIRECT"),
I first get the expected BUG splat, followed by this RCU warning:

Voluntary context switch within RCU read-side critical section!
WARNING: CPU: 2 PID: 1478 at kernel/rcu/tree_plugin.h:316 rcu_note_context_=
switch+0x525/0x580
Modules linked in:
CPU: 2 PID: 1478 Comm: bash Tainted: G      D           5.15.24jann #90
[...]
RIP: 0010:rcu_note_context_switch+0x525/0x580
Code: 08 4d 89 be 38 03 00 00 49 89 b6 40 03 00 00 48 89 3e e9 42 fd ff ff =
48 c7 c7 20 a4 06 92 c6 05 ce f7 a2 01 01 e8 03 fc bc 00 <0f> 0b e9 2b fb f=
f ff 48 8b 73 20 c6 43 15 00 ba 01 00 00 00 48 8b
RSP: 0018:ffffb27f01f8f910 EFLAGS: 00010082
RAX: 000000000000003f RBX: ffff9f5e8f6abd80 RCX: ffff9f5e8f69b608
RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffff9f5e8f69b600
RBP: 0000000000000000 R08: ffffffff924d5fe8 R09: 0000000000000003
R10: ffffffff92466000 R11: 3fffffffffffffff R12: ffff9f5e8f6ab0c0
R13: ffff9f5be87b3a00 R14: 0000000000000007 R15: 0000000000000400
FS:  00007f998ba3d740(0000) GS:ffff9f5e8f680000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055fa242279b8 CR3: 00000001602f6004 CR4: 00000000001706e0
Call Trace:
 <TASK>
 __schedule+0x74/0x6e0
 schedule+0x59/0xc0
 schedule_timeout+0xf7/0x140
 ? __prepare_to_swait+0x4b/0x70
 wait_for_completion+0x79/0xc0
 virt_efi_query_variable_info+0x141/0x150
 efi_query_variable_store+0x41/0x180
 efivar_entry_set_safe+0xa5/0x1f0
 efi_pstore_write+0xe6/0x130
 pstore_dump+0x177/0x290
 ? lkdtm_BUG+0x5/0x10
 kmsg_dump+0x46/0x60
 oops_end+0x47/0x90
 do_trap+0xcc/0x120
 do_error_trap+0x65/0x80
 ? lkdtm_BUG+0x5/0x10
 exc_invalid_op+0x4e/0x70
 ? lkdtm_BUG+0x5/0x10
 asm_exc_invalid_op+0xf/0x20
RIP: 0010:lkdtm_BUG+0x5/0x10
Code: ef e8 af a3 aa ff 8b 44 24 18 5a 59 48 83 c4 10 5d c3 b8 f4 ff ff ff =
eb f3 cc cc cc cc cc cc cc cc cc cc cc cc 0f 1f 44 00 00 <0f> 0b 66 0f 1f 8=
4 00 00 00 00 00 0f 1f 44 00 00 83 05 38 6b bb 01
RSP: 0018:ffffb27f01f8fe60 EFLAGS: 00010282
RAX: ffffffff91240710 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff9f5e8f6a7400 RSI: ffff9f5e8f69b600 RDI: ffffffff91d13550
RBP: ffffffff9218acab R08: ffffffff924d5fe8 R09: 0000000000000003
R10: 00000000fffff000 R11: 3fffffffffffffff R12: ffff9f5be87be000
R13: 0000000000000004 R14: ffffb27f01f8ff10 R15: 0000000000000004
 ? lkdtm_check_bool_cmdline+0x80/0x80
 direct_entry.cold+0x2c/0x37
 full_proxy_write+0x53/0x80
 vfs_write+0xc0/0x280
 ksys_write+0x4f/0xc0
 do_syscall_64+0x3b/0x90
 entry_SYSCALL_64_after_hwframe+0x44/0xae

This patch makes the RCU context warning go away.

 drivers/firmware/efi/efi-pstore.c |  2 +-
 fs/pstore/platform.c              | 39 +++++++++++++++----------------
 include/linux/pstore.h            |  7 +++---
 3 files changed, 24 insertions(+), 24 deletions(-)

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
index f243cb5e6a4f..31d5f9331210 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -143,27 +143,29 @@ static void pstore_timer_kick(void)
 	mod_timer(&pstore_timer, jiffies + msecs_to_jiffies(pstore_update_ms));
 }
=20
-/*
- * Should pstore_dump() wait for a concurrent pstore_dump()? If
- * not, the current pstore_dump() will report a failure to dump
- * and return.
- */
-static bool pstore_cannot_wait(enum kmsg_dump_reason reason)
+bool pstore_cannot_block_path(enum kmsg_dump_reason reason)
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
 		return false;
 	}
 }
+EXPORT_SYMBOL_GPL(pstore_cannot_block_path);
=20
 #if IS_ENABLED(CONFIG_PSTORE_DEFLATE_COMPRESS)
 static int zbufsize_deflate(size_t size)
@@ -389,21 +391,19 @@ static void pstore_dump(struct kmsg_dumper *dumper,
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
+			pr_err("dump skipped in %s path because of concurrent dump\n"
+				       , in_nmi() ? "NMI" : why);
 			return;
 		}
+	} else {
+		spin_lock_irqsave(&psinfo->buf_lock, flags);
 	}
=20
 	kmsg_dump_rewind(&iter);
@@ -467,8 +467,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 		total +=3D record.size;
 		part++;
 	}
-
-	up(&psinfo->buf_lock);
+	spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 }
=20
 static struct kmsg_dumper pstore_dumper =3D {
@@ -594,7 +593,7 @@ int pstore_register(struct pstore_info *psi)
 		psi->write_user =3D pstore_write_user_compat;
 	psinfo =3D psi;
 	mutex_init(&psinfo->read_mutex);
-	sema_init(&psinfo->buf_lock, 1);
+	spin_lock_init(&psinfo->buf_lock);
=20
 	if (psi->flags & PSTORE_FLAGS_DMESG)
 		allocate_buf_for_compression();
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index eb93a54cff31..e6bd205ddc63 100644
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
@@ -205,6 +205,7 @@ struct pstore_info {
=20
 extern int pstore_register(struct pstore_info *);
 extern void pstore_unregister(struct pstore_info *);
+extern bool pstore_cannot_block_path(enum kmsg_dump_reason reason);
=20
 struct pstore_ftrace_record {
 	unsigned long ip;

base-commit: 83e396641110663d3c7bb25b9bc0c6a750359ecf
--=20
2.35.1.473.g83b2b277ed-goog

