Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C7E33E04C
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 22:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbhCPVRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 17:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233075AbhCPVRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 17:17:09 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4D5C06174A;
        Tue, 16 Mar 2021 14:17:08 -0700 (PDT)
Date:   Tue, 16 Mar 2021 21:17:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615929425;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qebY6ZiWD5iPa+CvkRUaYcObSvISUruD5kXWTYuHLy0=;
        b=2PFWRNJJg5/b3zQqAKEYVXPJguSfMIJ4vtJ6TlzEVUUAjX+GzpdEGZSg37aBO/aZOGogU3
        iYVcYLDVWEBxHUIQkjLxQbxZ5gJ/JEW+U6w8A+ZS1g7no4A4m8Qc6/T7vlchmsF7PgV9a9
        6yhmwPyfjQoYFMEOmteCZsN6M+YPIea1WoPY9LcfTlOzQCzr3GbLwYgS0exGjiVUY9Bx0r
        SxSESxtnbk0k/daDPgbhDzjYTR18Y/HXnQo3OnyXw0zw1Bnzkz46uxoH782X0JkRl0Ucww
        XDxT3TaTVjflh7dUj/bpPUaX01MoBP/oV19/UXLqmW6XPyBTc1WbQOKtUW5dMQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615929425;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qebY6ZiWD5iPa+CvkRUaYcObSvISUruD5kXWTYuHLy0=;
        b=yPuCUvaUn2y/3blUHdUvIlXaHmp1IJQ91chvuJmSDaoB5BzILF3Iuw09SlaafTwjM3utam
        mEmocilSxW5eLzCg==
From:   "tip-bot2 for Oleg Nesterov" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86: Move TS_COMPAT back to asm/thread_info.h
Cc:     Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210201174649.GA17880@redhat.com>
References: <20210201174649.GA17880@redhat.com>
MIME-Version: 1.0
Message-ID: <161592942497.398.7527929638591799982.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     66c1b6d74cd7035e85c426f0af4aede19e805c8a
Gitweb:        https://git.kernel.org/tip/66c1b6d74cd7035e85c426f0af4aede19e805c8a
Author:        Oleg Nesterov <oleg@redhat.com>
AuthorDate:    Mon, 01 Feb 2021 18:46:49 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 16 Mar 2021 22:13:11 +01:00

x86: Move TS_COMPAT back to asm/thread_info.h

Move TS_COMPAT back to asm/thread_info.h, close to TS_I386_REGS_POKED.

It was moved to asm/processor.h by b9d989c7218a ("x86/asm: Move the
thread_info::status field to thread_struct"), then later 37a8f7c38339
("x86/asm: Move 'status' from thread_struct to thread_info") moved the
'status' field back but TS_COMPAT was forgotten.

Preparatory patch to fix the COMPAT case for get_nr_restart_syscall()

Fixes: 609c19a385c8 ("x86/ptrace: Stop setting TS_COMPAT in ptrace code")
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210201174649.GA17880@redhat.com
---
 arch/x86/include/asm/processor.h   |  9 ---------
 arch/x86/include/asm/thread_info.h |  9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index dc6d149..f1b9ed5 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -551,15 +551,6 @@ static inline void arch_thread_struct_whitelist(unsigned long *offset,
 	*size = fpu_kernel_xstate_size;
 }
 
-/*
- * Thread-synchronous status.
- *
- * This is different from the flags in that nobody else
- * ever touches our thread-synchronous status, so we don't
- * have to worry about atomic accesses.
- */
-#define TS_COMPAT		0x0002	/* 32bit syscall active (64BIT)*/
-
 static inline void
 native_load_sp0(unsigned long sp0)
 {
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 0d751d5..c2dc29e 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -205,6 +205,15 @@ static inline int arch_within_stack_frames(const void * const stack,
 
 #endif
 
+/*
+ * Thread-synchronous status.
+ *
+ * This is different from the flags in that nobody else
+ * ever touches our thread-synchronous status, so we don't
+ * have to worry about atomic accesses.
+ */
+#define TS_COMPAT		0x0002	/* 32bit syscall active (64BIT)*/
+
 #ifdef CONFIG_COMPAT
 #define TS_I386_REGS_POKED	0x0004	/* regs poked by 32-bit ptracer */
 #endif
