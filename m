Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6084BCA1B7
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 17:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731269AbfJCP6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:58:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730091AbfJCP6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:58:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A31421848;
        Thu,  3 Oct 2019 15:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118319;
        bh=vjBaosXqtd9ltgOm7s+SR9vWpf2jQAJtR0eeELBX1YY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=llxWVXiOvb/pFN8LN8MhAMFSBIOIVVr7CeJ1Tn00fs898pJtE4RlqEk5kopQH8UlD
         ojTA01GCcgBL9hML2htwZMnRvMfjh9jiAP5yVvkjgwNlQjRl8rZRcFSmuNmeHOJW74
         Pbqcl48PUfARV+Xruw4DRDWzzUlUs8g5YVRELQLg=
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
Subject: [PATCH 4.4 68/99] kprobes: Prohibit probing on BUG() and WARN() address
Date:   Thu,  3 Oct 2019 17:53:31 +0200
Message-Id: <20191003154329.926825063@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
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
index 7f4818673c41f..581a53dfbd310 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -102,6 +102,11 @@ int is_valid_bugaddr(unsigned long addr);
 
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
index a53998cba804c..fdde50d39a46d 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1454,7 +1454,8 @@ static int check_kprobe_address_safe(struct kprobe *p,
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



