Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3F14CA6BD
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392946AbfJCQqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:46:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392955AbfJCQqw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:46:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4602920867;
        Thu,  3 Oct 2019 16:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121210;
        bh=1XALEhAKuCd7LzKwV2e9wuvt2c6ap39x/F2yqvgyk8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kCNtZd9b68wO6U1/ZdL60dPSJmqdyYaX4QWtdBjuTSePyIEnk0E87OI4Qt5aiI7E0
         smbGp6VJsMVIiamnYvdIuDuDScA1XpxrvK3BQhVVFFZP+XerDM8/jbd4pQXlIjEjna
         tqaPR8OP1Qh25R6IY6xVCOADq+8ykDcfwwfWXQI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 196/344] kprobes: Prohibit probing on BUG() and WARN() address
Date:   Thu,  3 Oct 2019 17:52:41 +0200
Message-Id: <20191003154559.540751683@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit e336b4027775cb458dc713745e526fa1a1996b2a ]

Since BUG() and WARN() may use a trap (e.g. UD2 on x86) to
get the address where the BUG() has occurred, kprobes can not
do single-step out-of-line that instruction. So prohibit
probing on such address.

Without this fix, if someone put a kprobe on WARN(), the
kernel will crash with invalid opcode error instead of
outputing warning message, because kernel can not find
correct bug address.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Acked-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S . Miller <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Naveen N . Rao <naveen.n.rao@linux.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/156750890133.19112.3393666300746167111.stgit@devnote2
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bug.h | 5 +++++
 kernel/kprobes.c    | 3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index fe5916550da8c..f639bd0122f39 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -47,6 +47,11 @@ void generic_bug_clear_once(void);
 
 #else	/* !CONFIG_GENERIC_BUG */
 
+static inline void *find_bug(unsigned long bugaddr)
+{
+	return NULL;
+}
+
 static inline enum bug_trap_type report_bug(unsigned long bug_addr,
 					    struct pt_regs *regs)
 {
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index d9770a5393c89..ebe8315a756a2 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1514,7 +1514,8 @@ static int check_kprobe_address_safe(struct kprobe *p,
 	/* Ensure it is not in reserved area nor out of text */
 	if (!kernel_text_address((unsigned long) p->addr) ||
 	    within_kprobe_blacklist((unsigned long) p->addr) ||
-	    jump_label_text_reserved(p->addr, p->addr)) {
+	    jump_label_text_reserved(p->addr, p->addr) ||
+	    find_bug((unsigned long)p->addr)) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
2.20.1



