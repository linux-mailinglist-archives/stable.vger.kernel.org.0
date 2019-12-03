Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2392A111ECA
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbfLCWv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:51:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729882AbfLCWvZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:51:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFCCC21582;
        Tue,  3 Dec 2019 22:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413484;
        bh=PvrA4J+W8QBDfWcmIS4V90Fx1g6lwnCedsz7K6EiqCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZpVGuDXEwvfViMnoTSgc20IiAh/vlIYIMxMwLy1lEFQnOK7tOMWMgeXLdm+1S6zxT
         4IeS139TTbn+27F35JZ56h9wJhzV8ad1ZsOhC/feoGS7iYulCJZ31JiyXMj2WzNbaT
         IKLmFyF4KSAMRdbuGOn60ffMRTne9guDBQ7hUr7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Righi <righi.andrea@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yonghong Song <yhs@fb.com>, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 128/321] kprobes: Blacklist symbols in arch-defined prohibited area
Date:   Tue,  3 Dec 2019 23:33:14 +0100
Message-Id: <20191203223433.811052655@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index aed90788db5c1..f4e4095ec7eae 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2096,6 +2096,47 @@ void dump_kprobe(struct kprobe *kp)
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
@@ -2107,26 +2148,24 @@ NOKPROBE_SYMBOL(dump_kprobe);
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



