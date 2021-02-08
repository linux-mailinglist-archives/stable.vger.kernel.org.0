Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B22313AAC
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 18:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhBHRSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 12:18:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:33784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233919AbhBHRRp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 12:17:45 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76EB864E60;
        Mon,  8 Feb 2021 17:17:04 +0000 (UTC)
Date:   Mon, 8 Feb 2021 12:17:02 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     mhiramat@kernel.org, Jianlin.Lv@arm.com, <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracing/kprobe: Fix to support kretprobe
 events on unloaded" failed to apply to 5.4-stable tree
Message-ID: <20210208121702.31699807@gandalf.local.home>
In-Reply-To: <161277915958242@kroah.com>
References: <161277915958242@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 08 Feb 2021 11:12:39 +0100
<gregkh@linuxfoundation.org> wrote:

> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
>

This seems to work for 5.4.

Masami, can you review this, and the backport to 4.19 is a bit more messy.
Can you look at applying this patch to 4.19 if necessary?

Thanks,

-- Steve


------------------ original commit in Linus's tree ------------------

>From 97c753e62e6c31a404183898d950d8c08d752dbd Mon Sep 17 00:00:00 2001
From: Masami Hiramatsu <mhiramat@kernel.org>
Date: Thu, 28 Jan 2021 00:37:51 +0900
Subject: [PATCH] tracing/kprobe: Fix to support kretprobe events on unloaded
 modules

Fix kprobe_on_func_entry() returns error code instead of false so that
register_kretprobe() can return an appropriate error code.

append_trace_kprobe() expects the kprobe registration returns -ENOENT
when the target symbol is not found, and it checks whether the target
module is unloaded or not. If the target module doesn't exist, it
defers to probe the target symbol until the module is loaded.

However, since register_kretprobe() returns -EINVAL instead of -ENOENT
in that case, it always fail on putting the kretprobe event on unloaded
modules. e.g.

Kprobe event:
/sys/kernel/debug/tracing # echo p xfs:xfs_end_io >> kprobe_events
[   16.515574] trace_kprobe: This probe might be able to register after target module is loaded. Continue.

Kretprobe event: (p -> r)
/sys/kernel/debug/tracing # echo r xfs:xfs_end_io >> kprobe_events
sh: write error: Invalid argument
/sys/kernel/debug/tracing # cat error_log
[   41.122514] trace_kprobe: error: Failed to register probe event
  Command: r xfs:xfs_end_io
             ^

To fix this bug, change kprobe_on_func_entry() to detect symbol lookup
failure and return -ENOENT in that case. Otherwise it returns -EINVAL
or 0 (succeeded, given address is on the entry).

Link: https://lkml.kernel.org/r/161176187132.1067016.8118042342894378981.stgit@devnote2

Cc: stable@vger.kernel.org
Fixes: 59158ec4aef7 ("tracing/kprobes: Check the probe on unloaded module correctly")
Reported-by: Jianlin Lv <Jianlin.Lv@arm.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Index: linux-test.git/include/linux/kprobes.h
===================================================================
--- linux-test.git.orig/include/linux/kprobes.h
+++ linux-test.git/include/linux/kprobes.h
@@ -232,7 +232,7 @@ extern void kprobes_inc_nmissed_count(st
 extern bool arch_within_kprobe_blacklist(unsigned long addr);
 extern int arch_populate_kprobe_blacklist(void);
 extern bool arch_kprobe_on_func_entry(unsigned long offset);
-extern bool kprobe_on_func_entry(kprobe_opcode_t *addr, const char *sym, unsigned long offset);
+extern int kprobe_on_func_entry(kprobe_opcode_t *addr, const char *sym, unsigned long offset);
 
 extern bool within_kprobe_blacklist(unsigned long addr);
 extern int kprobe_add_ksym_blacklist(unsigned long entry);
Index: linux-test.git/kernel/kprobes.c
===================================================================
--- linux-test.git.orig/kernel/kprobes.c
+++ linux-test.git/kernel/kprobes.c
@@ -1948,29 +1948,45 @@ bool __weak arch_kprobe_on_func_entry(un
 	return !offset;
 }
 
-bool kprobe_on_func_entry(kprobe_opcode_t *addr, const char *sym, unsigned long offset)
+/**
+ * kprobe_on_func_entry() -- check whether given address is function entry
+ * @addr: Target address
+ * @sym:  Target symbol name
+ * @offset: The offset from the symbol or the address
+ *
+ * This checks whether the given @addr+@offset or @sym+@offset is on the
+ * function entry address or not.
+ * This returns 0 if it is the function entry, or -EINVAL if it is not.
+ * And also it returns -ENOENT if it fails the symbol or address lookup.
+ * Caller must pass @addr or @sym (either one must be NULL), or this
+ * returns -EINVAL.
+ */
+int kprobe_on_func_entry(kprobe_opcode_t *addr, const char *sym, unsigned long offset)
 {
 	kprobe_opcode_t *kp_addr = _kprobe_addr(addr, sym, offset);
 
 	if (IS_ERR(kp_addr))
-		return false;
+		return PTR_ERR(kp_addr);
 
-	if (!kallsyms_lookup_size_offset((unsigned long)kp_addr, NULL, &offset) ||
-						!arch_kprobe_on_func_entry(offset))
-		return false;
+	if (!kallsyms_lookup_size_offset((unsigned long)kp_addr, NULL, &offset))
+		return -ENOENT;
 
-	return true;
+	if (!arch_kprobe_on_func_entry(offset))
+		return -EINVAL;
+
+	return 0;
 }
 
 int register_kretprobe(struct kretprobe *rp)
 {
-	int ret = 0;
+	int ret;
 	struct kretprobe_instance *inst;
 	int i;
 	void *addr;
 
-	if (!kprobe_on_func_entry(rp->kp.addr, rp->kp.symbol_name, rp->kp.offset))
-		return -EINVAL;
+	ret = kprobe_on_func_entry(rp->kp.addr, rp->kp.symbol_name, rp->kp.offset);
+	if (ret)
+		return ret;
 
 	if (kretprobe_blacklist_size) {
 		addr = kprobe_addr(&rp->kp);
Index: linux-test.git/kernel/trace/trace_kprobe.c
===================================================================
--- linux-test.git.orig/kernel/trace/trace_kprobe.c
+++ linux-test.git/kernel/trace/trace_kprobe.c
@@ -220,9 +220,9 @@ bool trace_kprobe_on_func_entry(struct t
 {
 	struct trace_kprobe *tk = trace_kprobe_primary_from_call(call);
 
-	return tk ? kprobe_on_func_entry(tk->rp.kp.addr,
+	return tk ? (kprobe_on_func_entry(tk->rp.kp.addr,
 			tk->rp.kp.addr ? NULL : tk->rp.kp.symbol_name,
-			tk->rp.kp.addr ? 0 : tk->rp.kp.offset) : false;
+			tk->rp.kp.addr ? 0 : tk->rp.kp.offset) == 0) : false;
 }
 
 bool trace_kprobe_error_injectable(struct trace_event_call *call)
@@ -811,9 +811,11 @@ static int trace_kprobe_create(int argc,
 			trace_probe_log_err(0, BAD_PROBE_ADDR);
 			goto parse_error;
 		}
-		if (kprobe_on_func_entry(NULL, symbol, offset))
+		ret = kprobe_on_func_entry(NULL, symbol, offset);
+		if (ret == 0)
 			flags |= TPARG_FL_FENTRY;
-		if (offset && is_return && !(flags & TPARG_FL_FENTRY)) {
+		/* Defer the ENOENT case until register kprobe */
+		if (ret == -EINVAL && is_return) {
 			trace_probe_log_err(0, BAD_RETPROBE);
 			goto parse_error;
 		}
