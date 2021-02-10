Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E703163CF
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 11:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhBJK22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 05:28:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:46446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229815AbhBJKZs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 05:25:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D474C64E32;
        Wed, 10 Feb 2021 10:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612952707;
        bh=goQEu9e3DUdyLdPJkIVD/8JBO5fW53S4OsibCRpcfMQ=;
        h=From:To:Cc:Subject:Date:From;
        b=QK7PwMf3PEBn6QQ8rZsCj2smN0jCDbReiumAWK7eIwQK2atk4zwCoIcUTapvambFV
         NmHVnspakEQXey9BVKsQ6oD8ZN8uexKvpexlqocBbzW7oLKsy3t5Jk57WmYOnGXSnG
         PAT+GHNSKdhdst3xYpcswceH3NseGj6pd/pZRQJ3ayLRWO2hCn8xYB2FtuIn8RFIAY
         qntEHsI8vt5SN1dgmHWpM+xb1IVNvqQtmrq4tFAegzxny57V6iZQBMzG29mHMnhmap
         Vkx4VsadsT62+nOasqFopvaKAVQACSvZvluWfas8UlPTKtlv+QJtMeiZWxRjALVzHR
         +miZTm6ZADh6w==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     stable@vger.kernel.org
Cc:     mhiramat@kernel.org, Jianlin.Lv@arm.com, rostedt@goodmis.org
Subject: [PATCH 4.19.y v2] tracing/kprobe: Fix to support kretprobe events on unloaded modules
Date:   Wed, 10 Feb 2021 19:25:04 +0900
Message-Id: <161295270391.312585.12986150404367194307.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 97c753e62e6c31a404183898d950d8c08d752dbd upstream.

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
---
 include/linux/kprobes.h     |    2 +-
 kernel/kprobes.c            |   34 +++++++++++++++++++++++++---------
 kernel/trace/trace_kprobe.c |    4 ++--
 3 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 9f22652d69bb..c28204e22b54 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -245,7 +245,7 @@ extern void kprobes_inc_nmissed_count(struct kprobe *p);
 extern bool arch_within_kprobe_blacklist(unsigned long addr);
 extern int arch_populate_kprobe_blacklist(void);
 extern bool arch_kprobe_on_func_entry(unsigned long offset);
-extern bool kprobe_on_func_entry(kprobe_opcode_t *addr, const char *sym, unsigned long offset);
+extern int kprobe_on_func_entry(kprobe_opcode_t *addr, const char *sym, unsigned long offset);
 
 extern bool within_kprobe_blacklist(unsigned long addr);
 extern int kprobe_add_ksym_blacklist(unsigned long entry);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 2161f519d481..ebbd4320143d 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1921,29 +1921,45 @@ bool __weak arch_kprobe_on_func_entry(unsigned long offset)
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
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 5c17f70c7f2d..61eff45653f5 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -112,9 +112,9 @@ bool trace_kprobe_on_func_entry(struct trace_event_call *call)
 {
 	struct trace_kprobe *tk = (struct trace_kprobe *)call->data;
 
-	return kprobe_on_func_entry(tk->rp.kp.addr,
+	return (kprobe_on_func_entry(tk->rp.kp.addr,
 			tk->rp.kp.addr ? NULL : tk->rp.kp.symbol_name,
-			tk->rp.kp.addr ? 0 : tk->rp.kp.offset);
+			tk->rp.kp.addr ? 0 : tk->rp.kp.offset) == 0);
 }
 
 bool trace_kprobe_error_injectable(struct trace_event_call *call)

