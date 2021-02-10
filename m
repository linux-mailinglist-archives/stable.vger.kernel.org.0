Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414C43163B4
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 11:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhBJKYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 05:24:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230489AbhBJKWl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 05:22:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73DDF64E53;
        Wed, 10 Feb 2021 10:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612952520;
        bh=tMu8y9gKpKhT7k5kbtkYQ9wuDfv13TiiOrjpeMamVLI=;
        h=From:To:Cc:Subject:Date:From;
        b=T/eoxvZU/vI7isci0VpLO82SHdFSJAwK4gwGTHxwV7wh5FSnL5hJEyi/cbPXPY7D1
         6WZ2+vhXwBRMOE4zYaNHxWZLJcNv3HnQkDnKu2DDRcReLywhGy+jMNrLiVShhl2/cc
         /WFzA+8TzvQk/nqCeRIetKtzCO9CnMfgPGIeM5axP8PCQZKp2eWUHubuWfSJmlOjaN
         gdrUbs8pOt8572z+ovPFUvBu4vAtJ3hMxPELiBQl+1SCqRhs9tOODE0bcaUV2W4Ino
         QdAFWLGTj5dmrUcoGWcykMkXnw0EUoCCAP5H2wellG9WlRdxmUHd70eqflSF4lt/13
         gMLQl+LxywfEQ==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     stable@vger.kernel.org
Cc:     mhiramat@kernel.org, Jianlin.Lv@arm.com, rostedt@goodmis.org
Subject: [PATCH 5.4.y] tracing/kprobe: Fix to support kretprobe events on unloaded modules
Date:   Wed, 10 Feb 2021 19:21:57 +0900
Message-Id: <161295251675.311731.1025064176598613505.stgit@devnote2>
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
 kernel/trace/trace_kprobe.c |   10 ++++++----
 3 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index a60488867dd0..a121fd8e7c3a 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -232,7 +232,7 @@ extern void kprobes_inc_nmissed_count(struct kprobe *p);
 extern bool arch_within_kprobe_blacklist(unsigned long addr);
 extern int arch_populate_kprobe_blacklist(void);
 extern bool arch_kprobe_on_func_entry(unsigned long offset);
-extern bool kprobe_on_func_entry(kprobe_opcode_t *addr, const char *sym, unsigned long offset);
+extern int kprobe_on_func_entry(kprobe_opcode_t *addr, const char *sym, unsigned long offset);
 
 extern bool within_kprobe_blacklist(unsigned long addr);
 extern int kprobe_add_ksym_blacklist(unsigned long entry);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 283c8b01ce78..8f9fbc74021d 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1948,29 +1948,45 @@ bool __weak arch_kprobe_on_func_entry(unsigned long offset)
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
index 1074a69beff3..233322c77b76 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -220,9 +220,9 @@ bool trace_kprobe_on_func_entry(struct trace_event_call *call)
 {
 	struct trace_kprobe *tk = trace_kprobe_primary_from_call(call);
 
-	return tk ? kprobe_on_func_entry(tk->rp.kp.addr,
+	return tk ? (kprobe_on_func_entry(tk->rp.kp.addr,
 			tk->rp.kp.addr ? NULL : tk->rp.kp.symbol_name,
-			tk->rp.kp.addr ? 0 : tk->rp.kp.offset) : false;
+			tk->rp.kp.addr ? 0 : tk->rp.kp.offset) == 0) : false;
 }
 
 bool trace_kprobe_error_injectable(struct trace_event_call *call)
@@ -811,9 +811,11 @@ static int trace_kprobe_create(int argc, const char *argv[])
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

