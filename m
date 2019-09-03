Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB237A6FC7
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731219AbfICQfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:35:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730969AbfICQ1x (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF84A23789;
        Tue,  3 Sep 2019 16:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528072;
        bh=IYyyR7M7rGBO8OqHSI9KXgCb+rxiIEbdYid7/md1cm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCiBhg12JczNeZ1/hWa1Giip1v343kkPWQ9z7TrObducII42aYGSPSNICC2t45sUR
         muQrXB3D2RB6XgcXM9W2j/KLc6m3lkfKO5mr/YehEbgqrtUAFClWuhpgVDFI7kpr7P
         V0IFrwSlRxlmThAIt6R4SbVuR2gKD5YgyBklmPN0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 086/167] x86/ftrace: Fix warning and considate ftrace_jmp_replace() and ftrace_call_replace()
Date:   Tue,  3 Sep 2019 12:23:58 -0400
Message-Id: <20190903162519.7136-86-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

[ Upstream commit 745cfeaac09ce359130a5451d90cb0bd4094c290 ]

Arnd reported the following compiler warning:

arch/x86/kernel/ftrace.c:669:23: error: 'ftrace_jmp_replace' defined but not used [-Werror=unused-function]

The ftrace_jmp_replace() function now only has a single user and should be
simply moved by that user. But looking at the code, it shows that
ftrace_jmp_replace() is similar to ftrace_call_replace() except that instead
of using the opcode of 0xe8 it uses 0xe9. It makes more sense to consolidate
that function into one implementation that both ftrace_jmp_replace() and
ftrace_call_replace() use by passing in the op code separate.

The structure in ftrace_code_union is also modified to replace the "e8"
field with the more appropriate name "op".

Cc: stable@vger.kernel.org
Reported-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Link: http://lkml.kernel.org/r/20190304200748.1418790-1-arnd@arndb.de
Fixes: d2a68c4effd8 ("x86/ftrace: Do not call function graph from dynamic trampolines")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/ftrace.c | 42 ++++++++++++++++------------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 50d309662d78c..5790671857e55 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -53,7 +53,7 @@ int ftrace_arch_code_modify_post_process(void)
 union ftrace_code_union {
 	char code[MCOUNT_INSN_SIZE];
 	struct {
-		unsigned char e8;
+		unsigned char op;
 		int offset;
 	} __attribute__((packed));
 };
@@ -63,20 +63,23 @@ static int ftrace_calc_offset(long ip, long addr)
 	return (int)(addr - ip);
 }
 
-static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
+static unsigned char *
+ftrace_text_replace(unsigned char op, unsigned long ip, unsigned long addr)
 {
 	static union ftrace_code_union calc;
 
-	calc.e8		= 0xe8;
+	calc.op		= op;
 	calc.offset	= ftrace_calc_offset(ip + MCOUNT_INSN_SIZE, addr);
 
-	/*
-	 * No locking needed, this must be called via kstop_machine
-	 * which in essence is like running on a uniprocessor machine.
-	 */
 	return calc.code;
 }
 
+static unsigned char *
+ftrace_call_replace(unsigned long ip, unsigned long addr)
+{
+	return ftrace_text_replace(0xe8, ip, addr);
+}
+
 static inline int
 within(unsigned long addr, unsigned long start, unsigned long end)
 {
@@ -686,22 +689,6 @@ int __init ftrace_dyn_arch_init(void)
 	return 0;
 }
 
-#if defined(CONFIG_X86_64) || defined(CONFIG_FUNCTION_GRAPH_TRACER)
-static unsigned char *ftrace_jmp_replace(unsigned long ip, unsigned long addr)
-{
-	static union ftrace_code_union calc;
-
-	/* Jmp not a call (ignore the .e8) */
-	calc.e8		= 0xe9;
-	calc.offset	= ftrace_calc_offset(ip + MCOUNT_INSN_SIZE, addr);
-
-	/*
-	 * ftrace external locks synchronize the access to the static variable.
-	 */
-	return calc.code;
-}
-#endif
-
 /* Currently only x86_64 supports dynamic trampolines */
 #ifdef CONFIG_X86_64
 
@@ -923,8 +910,8 @@ static void *addr_from_call(void *ptr)
 		return NULL;
 
 	/* Make sure this is a call */
-	if (WARN_ON_ONCE(calc.e8 != 0xe8)) {
-		pr_warn("Expected e8, got %x\n", calc.e8);
+	if (WARN_ON_ONCE(calc.op != 0xe8)) {
+		pr_warn("Expected e8, got %x\n", calc.op);
 		return NULL;
 	}
 
@@ -995,6 +982,11 @@ void arch_ftrace_trampoline_free(struct ftrace_ops *ops)
 #ifdef CONFIG_DYNAMIC_FTRACE
 extern void ftrace_graph_call(void);
 
+static unsigned char *ftrace_jmp_replace(unsigned long ip, unsigned long addr)
+{
+	return ftrace_text_replace(0xe9, ip, addr);
+}
+
 static int ftrace_mod_jmp(unsigned long ip, void *func)
 {
 	unsigned char *new;
-- 
2.20.1

