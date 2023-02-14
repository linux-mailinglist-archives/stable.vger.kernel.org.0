Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6EC0696749
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 15:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbjBNOrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 09:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233481AbjBNOrQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 09:47:16 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2D2252B7;
        Tue, 14 Feb 2023 06:47:02 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D9AFF22307;
        Tue, 14 Feb 2023 14:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1676386020; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EK9CiP6A9TI1KmO+gBKuo7Y6VjfBhIiJDZ2Z+Ukkaws=;
        b=NrIWWvTt0AsCqPqzqyXPhbWtDHVu3yg7/B7gRjZo4/ZIqJcTmIk0ZmY7igSVXpVblGLw2K
        Krs05g+nLykoGD41GvOwYwaBr/Xm34illEaLt7DrkQNk2v2Mp6TA9HgcWB4EKsSShXuTph
        bwHDb1ySHIcOn6zUtOGTTTC2nEybqdE=
Received: from suse.cz (pmladek.udp.ovpn2.prg.suse.de [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 36FFF2C141;
        Tue, 14 Feb 2023 14:47:00 +0000 (UTC)
Date:   Tue, 14 Feb 2023 15:46:56 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     akpm@linux-foundation.org, bhe@redhat.com,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        dyoung@redhat.com, d.hatayama@jp.fujitsu.com, feng.tang@intel.com,
        hidehiro.kawai.ez@hitachi.com, keescook@chromium.org,
        mikelley@microsoft.com, vgoyal@redhat.com, kernel-dev@igalia.com,
        kernel@gpiccoli.net, stable@vger.kernel.org
Subject: Re: [PATCH v4] panic: Fixes the panic_print NMI backtrace setting
Message-ID: <Y+ue4OsyrGSx5ujB@alley>
References: <20230210203510.1734835-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210203510.1734835-1-gpiccoli@igalia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 2023-02-10 17:35:10, Guilherme G. Piccoli wrote:
> Commit 8d470a45d1a6 ("panic: add option to dump all CPUs backtraces in panic_print")
> introduced a setting for the "panic_print" kernel parameter to allow
> users to request a NMI backtrace on panic. Problem is that the panic_print
> handling happens after the secondary CPUs are already disabled, hence
> this option ended-up being kind of a no-op - kernel skips the NMI trace
> in idling CPUs, which is the case of offline CPUs.

Great catch!

> Hi folks, thanks in advance for reviews/comments.
> 
> Notice that while at it, I got rid of the "crash_kexec_post_notifiers"
> local copy in panic(). This was introduced by commit b26e27ddfd2a
> ("kexec: use core_param for crash_kexec_post_notifiers boot option"),
> but it is not clear from comments or commit message why this local copy
> is required.
> 
> My understanding is that it's a mechanism to prevent some concurrency,
> in case some other CPU modify this variable while panic() is running.
> I find it very unlikely, hence I removed it - but if people consider
> this copy needed, I can respin this patch and keep it, even providing a
> comment about that, in order to be explict about its need.

Yes, I think that it makes the behavior consistent even when the
global variable manipulated in parallel.

I would personally prefer to keep the local copy. Better safe
than sorry.

> Let me know your thoughts!
> Cheers,
> 
> Guilherme
> 
> 
>  kernel/panic.c | 47 +++++++++++++++++++++++++++--------------------
>  1 file changed, 27 insertions(+), 20 deletions(-)
> 
> diff --git a/kernel/panic.c b/kernel/panic.c
> index 463c9295bc28..f45ee88be8a2 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -211,9 +211,6 @@ static void panic_print_sys_info(bool console_flush)
>  		return;
>  	}
>  
> -	if (panic_print & PANIC_PRINT_ALL_CPU_BT)
> -		trigger_all_cpu_backtrace();
> -

Sigh, this is yet another PANIC_PRINT_ action that need special
timing. We should handle both the same way.

What about the following? The parameter @mask says what
actions are allowed at the given time.

--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -72,6 +72,9 @@ EXPORT_SYMBOL_GPL(panic_timeout);
 #define PANIC_PRINT_FTRACE_INFO		0x00000010
 #define PANIC_PRINT_ALL_PRINTK_MSG	0x00000020
 #define PANIC_PRINT_ALL_CPU_BT		0x00000040
+/* Filter out actions that need special timing. */
+#define PANIC_PRINT_COMMON_INFO_MASK	~(PANIC_PRINT_ALL_PRINTK_MSG |	 \
+					  PANIC_PRINT_ALL_CPU_BT)
 unsigned long panic_print;
 
 ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
@@ -203,30 +206,29 @@ void nmi_panic(struct pt_regs *regs, const char *msg)
 }
 EXPORT_SYMBOL(nmi_panic);
 
-static void panic_print_sys_info(bool console_flush)
+static void panic_print_sys_info(unsigned long mask)
 {
-	if (console_flush) {
-		if (panic_print & PANIC_PRINT_ALL_PRINTK_MSG)
-			console_flush_on_panic(CONSOLE_REPLAY_ALL);
-		return;
-	}
+	unsigned long panic_print_now = panic_print & mask;
+
+	if (panic_print_now & PANIC_PRINT_ALL_PRINTK_MSG)
+		console_flush_on_panic(CONSOLE_REPLAY_ALL);
 
-	if (panic_print & PANIC_PRINT_ALL_CPU_BT)
+	if (panic_print_now & PANIC_PRINT_ALL_CPU_BT)
 		trigger_all_cpu_backtrace();
 
-	if (panic_print & PANIC_PRINT_TASK_INFO)
+	if (panic_print_now & PANIC_PRINT_TASK_INFO)
 		show_state();
 
-	if (panic_print & PANIC_PRINT_MEM_INFO)
+	if (panic_print_now & PANIC_PRINT_MEM_INFO)
 		show_mem(0, NULL);
 
-	if (panic_print & PANIC_PRINT_TIMER_INFO)
+	if (panic_print_now & PANIC_PRINT_TIMER_INFO)
 		sysrq_timer_list_show();
 
-	if (panic_print & PANIC_PRINT_LOCK_INFO)
+	if (panic_print_now & PANIC_PRINT_LOCK_INFO)
 		debug_show_all_locks();
 
-	if (panic_print & PANIC_PRINT_FTRACE_INFO)
+	if (panic_print_now & PANIC_PRINT_FTRACE_INFO)
 		ftrace_dump(DUMP_ALL);
 }
 
@@ -333,9 +335,12 @@ void panic(const char *fmt, ...)
 	 *
 	 * Bypass the panic_cpu check and call __crash_kexec directly.
 	 */
-	if (!_crash_kexec_post_notifiers) {
+	if (!_crash_kexec_post_notifiers)
 		__crash_kexec(NULL);
 
+	panic_print_sys_info(PANIC_PRINT_ALL_CPU_BT);
+
+	if (!_crash_kexec_post_notifiers) {
 		/*
 		 * Note smp_send_stop is the usual smp shutdown function, which
 		 * unfortunately means it may not be hardened to work in a
@@ -357,7 +362,7 @@ void panic(const char *fmt, ...)
 	 */
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
-	panic_print_sys_info(false);
+	panic_print_sys_info(PANIC_PRINT_COMMON_INFO_MASK);
 
 	kmsg_dump(KMSG_DUMP_PANIC);
 
@@ -386,7 +391,7 @@ void panic(const char *fmt, ...)
 	debug_locks_off();
 	console_flush_on_panic(CONSOLE_FLUSH_PENDING);
 
-	panic_print_sys_info(true);
+	panic_print_sys_info(PANIC_PRINT_ALL_PRINTK_MSG);
 
 	if (!panic_blink)
 		panic_blink = no_blink;


Best Regards,
Petr
