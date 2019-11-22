Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83DA71065CA
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbfKVG0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:26:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:55458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727838AbfKVFun (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 438B72070E;
        Fri, 22 Nov 2019 05:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401842;
        bh=uI7WqOCmD7pPLkF6NG+fgAmT0gxRGJ+luTIViUcMrsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGDjY7nQu9Minmqz1bq32PtsP2TampjnWNqDlBYiruYMcuzW6wpVQmUdhkn6rEajJ
         1aPFtxQPv18ylFajvJUvtJaioEHphSCtjy06UyFwFlMiFDuupziPwWIYcGZllMjgh1
         OK/E1ugv4BrnOIhkKmWw4Kct2tktz0nb53cwXPug=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrea Righi <righi.andrea@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "David S . Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yonghong Song <yhs@fb.com>, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 082/219] kprobes: Blacklist symbols in arch-defined prohibited area
Date:   Fri, 22 Nov 2019 00:46:54 -0500
Message-Id: <20191122054911.1750-75-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit fb1a59fae8baa3f3c69b72a87ff94fc4fa5683ec ]

Blacklist symbols in arch-defined probe-prohibited areas.
With this change, user can see all symbols which are prohibited
to probe in debugfs.

All archtectures which have custom prohibit areas should define
its own arch_populate_kprobe_blacklist() function, but unless that,
all symbols marked __kprobes are blacklisted.

Reported-by: Andrea Righi <righi.andrea@gmail.com>
Tested-by: Andrea Righi <righi.andrea@gmail.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Yonghong Song <yhs@fb.com>
Link: http://lkml.kernel.org/r/154503485491.26176.15823229545155174796.stgit@devbox
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kprobes.h |  3 ++
 kernel/kprobes.c        | 67 ++++++++++++++++++++++++++++++++---------
 2 files changed, 56 insertions(+), 14 deletions(-)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 32cae0f35b9d4..9adb92ad24d3f 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -243,10 +243,13 @@ extern int arch_init_kprobes(void);
 extern void show_registers(struct pt_regs *regs);
 extern void kprobes_inc_nmissed_count(struct kprobe *p);
 extern bool arch_within_kprobe_blacklist(unsigned long addr);
+extern int arch_populate_kprobe_blacklist(void);
 extern bool arch_kprobe_on_func_entry(unsigned long offset);
 extern bool kprobe_on_func_entry(kprobe_opcode_t *addr, const char *sym, unsigned long offset);
 
 extern bool within_kprobe_blacklist(unsigned long addr);
+extern int kprobe_add_ksym_blacklist(unsigned long entry);
+extern int kprobe_add_area_blacklist(unsigned long start, unsigned long end);
 
 struct kprobe_insn_cache {
 	struct mutex mutex;
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index b8efca9dc2cbb..c4f1acb2e7d20 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2090,6 +2090,47 @@ void dump_kprobe(struct kprobe *kp)
 }
 NOKPROBE_SYMBOL(dump_kprobe);
 
+int kprobe_add_ksym_blacklist(unsigned long entry)
+{
+	struct kprobe_blacklist_entry *ent;
+	unsigned long offset = 0, size = 0;
+
+	if (!kernel_text_address(entry) ||
+	    !kallsyms_lookup_size_offset(entry, &size, &offset))
+		return -EINVAL;
+
+	ent = kmalloc(sizeof(*ent), GFP_KERNEL);
+	if (!ent)
+		return -ENOMEM;
+	ent->start_addr = entry;
+	ent->end_addr = entry + size;
+	INIT_LIST_HEAD(&ent->list);
+	list_add_tail(&ent->list, &kprobe_blacklist);
+
+	return (int)size;
+}
+
+/* Add all symbols in given area into kprobe blacklist */
+int kprobe_add_area_blacklist(unsigned long start, unsigned long end)
+{
+	unsigned long entry;
+	int ret = 0;
+
+	for (entry = start; entry < end; entry += ret) {
+		ret = kprobe_add_ksym_blacklist(entry);
+		if (ret < 0)
+			return ret;
+		if (ret == 0)	/* In case of alias symbol */
+			ret = 1;
+	}
+	return 0;
+}
+
+int __init __weak arch_populate_kprobe_blacklist(void)
+{
+	return 0;
+}
+
 /*
  * Lookup and populate the kprobe_blacklist.
  *
@@ -2101,26 +2142,24 @@ NOKPROBE_SYMBOL(dump_kprobe);
 static int __init populate_kprobe_blacklist(unsigned long *start,
 					     unsigned long *end)
 {
+	unsigned long entry;
 	unsigned long *iter;
-	struct kprobe_blacklist_entry *ent;
-	unsigned long entry, offset = 0, size = 0;
+	int ret;
 
 	for (iter = start; iter < end; iter++) {
 		entry = arch_deref_entry_point((void *)*iter);
-
-		if (!kernel_text_address(entry) ||
-		    !kallsyms_lookup_size_offset(entry, &size, &offset))
+		ret = kprobe_add_ksym_blacklist(entry);
+		if (ret == -EINVAL)
 			continue;
-
-		ent = kmalloc(sizeof(*ent), GFP_KERNEL);
-		if (!ent)
-			return -ENOMEM;
-		ent->start_addr = entry;
-		ent->end_addr = entry + size;
-		INIT_LIST_HEAD(&ent->list);
-		list_add_tail(&ent->list, &kprobe_blacklist);
+		if (ret < 0)
+			return ret;
 	}
-	return 0;
+
+	/* Symbols in __kprobes_text are blacklisted */
+	ret = kprobe_add_area_blacklist((unsigned long)__kprobes_text_start,
+					(unsigned long)__kprobes_text_end);
+
+	return ret ? : arch_populate_kprobe_blacklist();
 }
 
 /* Module notifier call back, checking kprobes on the module */
-- 
2.20.1

