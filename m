Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59E4DBA463
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391578AbfIVSsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:48:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391571AbfIVSsX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:48:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B2AB21479;
        Sun, 22 Sep 2019 18:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178103;
        bh=1XALEhAKuCd7LzKwV2e9wuvt2c6ap39x/F2yqvgyk8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BxaEZ+9+bLlwTvOAcJQBNP+Jpadeo8PGKa8cx5lYeVNWVI4Gz826dAbv7MTf9LdVa
         wTn5GTbdQLEMxWdcpVpQTgrUOEgycRJNSf7Euc5XibbZuzcpoCbjIGASzoIlMQB2Ro
         0yGe01aX7+6ZnCo9+FJfW4QQrZ9f3jenB5rXLQvs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 164/203] kprobes: Prohibit probing on BUG() and WARN() address
Date:   Sun, 22 Sep 2019 14:43:10 -0400
Message-Id: <20190922184350.30563-164-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

