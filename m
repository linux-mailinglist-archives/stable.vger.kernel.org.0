Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 658C068959E
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbjBCKVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbjBCKVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:21:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB7D9D065
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:21:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48BE561EC7
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301EFC4339E;
        Fri,  3 Feb 2023 10:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419645;
        bh=YXwoWCdLdociTeFvSe1VLZmJCLCH7r0/im5fBWA1NcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b00nGZm0bOMlnbukbmU1XLrC5c66PrVT27TyL/dfgVTrRQVfZnXWZexH/Usa27cXm
         XwCnr5yepzdJIiCTs3TGPPg/0o/pOZtGDxK2YIGep3qBys80CF6Mj2vtefXEgQwEQk
         +sAQ47rC0qZ49jiZV0/efC46mkf9yQ//mpT9ZUzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jann Horn <jannh@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4.19 71/80] exit: Put an upper limit on how often we can oops
Date:   Fri,  3 Feb 2023 11:13:05 +0100
Message-Id: <20230203101018.267182220@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit d4ccd54d28d3c8598e2354acc13e28c060961dbb upstream.

Many Linux systems are configured to not panic on oops; but allowing an
attacker to oops the system **really** often can make even bugs that look
completely unexploitable exploitable (like NULL dereferences and such) if
each crash elevates a refcount by one or a lock is taken in read mode, and
this causes a counter to eventually overflow.

The most interesting counters for this are 32 bits wide (like open-coded
refcounts that don't use refcount_t). (The ldsem reader count on 32-bit
platforms is just 16 bits, but probably nobody cares about 32-bit platforms
that much nowadays.)

So let's panic the system if the kernel is constantly oopsing.

The speed of oopsing 2^32 times probably depends on several factors, like
how long the stack trace is and which unwinder you're using; an empirically
important one is whether your console is showing a graphical environment or
a text console that oopses will be printed to.
In a quick single-threaded benchmark, it looks like oopsing in a vfork()
child with a very short stack trace only takes ~510 microseconds per run
when a graphical console is active; but switching to a text console that
oopses are printed to slows it down around 87x, to ~45 milliseconds per
run.
(Adding more threads makes this faster, but the actual oops printing
happens under &die_lock on x86, so you can maybe speed this up by a factor
of around 2 and then any further improvement gets eaten up by lock
contention.)

It looks like it would take around 8-12 days to overflow a 32-bit counter
with repeated oopsing on a multi-core X86 system running a graphical
environment; both me (in an X86 VM) and Seth (with a distro kernel on
normal hardware in a standard configuration) got numbers in that ballpark.

12 days aren't *that* short on a desktop system, and you'd likely need much
longer on a typical server system (assuming that people don't run graphical
desktop environments on their servers), and this is a *very* noisy and
violent approach to exploiting the kernel; and it also seems to take orders
of magnitude longer on some machines, probably because stuff like EFI
pstore will slow it down a ton if that's active.

Signed-off-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/r/20221107201317.324457-1-jannh@google.com
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221117234328.594699-2-keescook@chromium.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/sysctl/kernel.txt |    9 ++++++++
 kernel/exit.c                   |   43 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -51,6 +51,7 @@ show up in /proc/sys/kernel:
 - msgmnb
 - msgmni
 - nmi_watchdog
+- oops_limit
 - osrelease
 - ostype
 - overflowgid
@@ -555,6 +556,14 @@ scanned for a given scan.
 
 ==============================================================
 
+oops_limit:
+
+Number of kernel oopses after which the kernel should panic when
+``panic_on_oops`` is not set. Setting this to 0 or 1 has the same effect
+as setting ``panic_on_oops=1``.
+
+==============================================================
+
 osrelease, ostype & version:
 
 # cat osrelease
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -68,6 +68,33 @@
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 
+/*
+ * The default value should be high enough to not crash a system that randomly
+ * crashes its kernel from time to time, but low enough to at least not permit
+ * overflowing 32-bit refcounts or the ldsem writer count.
+ */
+static unsigned int oops_limit = 10000;
+
+#ifdef CONFIG_SYSCTL
+static struct ctl_table kern_exit_table[] = {
+	{
+		.procname       = "oops_limit",
+		.data           = &oops_limit,
+		.maxlen         = sizeof(oops_limit),
+		.mode           = 0644,
+		.proc_handler   = proc_douintvec,
+	},
+	{ }
+};
+
+static __init int kernel_exit_sysctls_init(void)
+{
+	register_sysctl_init("kernel", kern_exit_table);
+	return 0;
+}
+late_initcall(kernel_exit_sysctls_init);
+#endif
+
 static void __unhash_process(struct task_struct *p, bool group_dead)
 {
 	nr_threads--;
@@ -924,10 +951,26 @@ EXPORT_SYMBOL_GPL(do_exit);
 
 void __noreturn make_task_dead(int signr)
 {
+	static atomic_t oops_count = ATOMIC_INIT(0);
+
 	/*
 	 * Take the task off the cpu after something catastrophic has
 	 * happened.
 	 */
+
+	/*
+	 * Every time the system oopses, if the oops happens while a reference
+	 * to an object was held, the reference leaks.
+	 * If the oops doesn't also leak memory, repeated oopsing can cause
+	 * reference counters to wrap around (if they're not using refcount_t).
+	 * This means that repeated oopsing can make unexploitable-looking bugs
+	 * exploitable through repeated oopsing.
+	 * To make sure this can't happen, place an upper bound on how often the
+	 * kernel may oops without panic().
+	 */
+	if (atomic_inc_return(&oops_count) >= READ_ONCE(oops_limit))
+		panic("Oopsed too often (kernel.oops_limit is %d)", oops_limit);
+
 	do_exit(signr);
 }
 


