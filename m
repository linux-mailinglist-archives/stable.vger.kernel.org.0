Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243832ACC94
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 04:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387505AbgKJD4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:56:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:57896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387494AbgKJD4G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:56:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9796C21D46;
        Tue, 10 Nov 2020 03:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980565;
        bh=qbHcvlzqFuLIR9LiKRTeh7JUpad01HtQVpdI1xKgW5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNo54VY3yEY7sOPwAoUW5y5svbXlVyls21+MUUKECxIiHBS8JeutVggI1IBBRQjsd
         +rOpBvrd/EBSWJ59rfz8tCeEEAXn/DRcfa9FwNa5/BGAS46TuWAC05DrnlPGla6qGJ
         Wu/VoPTfYzGf4xHR8/2paKNTeAAdvDn281x182U4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 18/21] kprobes: Tell lockdep about kprobe nesting
Date:   Mon,  9 Nov 2020 22:55:38 -0500
Message-Id: <20201110035541.424648-18-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035541.424648-1-sashal@kernel.org>
References: <20201110035541.424648-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

[ Upstream commit 645f224e7ba2f4200bf163153d384ceb0de5462e ]

Since the kprobe handlers have protection that prohibits other handlers from
executing in other contexts (like if an NMI comes in while processing a
kprobe, and executes the same kprobe, it will get fail with a "busy"
return). Lockdep is unaware of this protection. Use lockdep's nesting api to
differentiate between locks taken in INT3 context and other context to
suppress the false warnings.

Link: https://lore.kernel.org/r/20201102160234.fa0ae70915ad9e2b21c08b85@kernel.org

Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kprobes.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 2161f519d4812..2ce9053de6ae4 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1204,7 +1204,13 @@ __acquires(hlist_lock)
 
 	*head = &kretprobe_inst_table[hash];
 	hlist_lock = kretprobe_table_lock_ptr(hash);
-	raw_spin_lock_irqsave(hlist_lock, *flags);
+	/*
+	 * Nested is a workaround that will soon not be needed.
+	 * There's other protections that make sure the same lock
+	 * is not taken on the same CPU that lockdep is unaware of.
+	 * Differentiate when it is taken in NMI context.
+	 */
+	raw_spin_lock_irqsave_nested(hlist_lock, *flags, !!in_nmi());
 }
 NOKPROBE_SYMBOL(kretprobe_hash_lock);
 
@@ -1213,7 +1219,13 @@ static void kretprobe_table_lock(unsigned long hash,
 __acquires(hlist_lock)
 {
 	raw_spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
-	raw_spin_lock_irqsave(hlist_lock, *flags);
+	/*
+	 * Nested is a workaround that will soon not be needed.
+	 * There's other protections that make sure the same lock
+	 * is not taken on the same CPU that lockdep is unaware of.
+	 * Differentiate when it is taken in NMI context.
+	 */
+	raw_spin_lock_irqsave_nested(hlist_lock, *flags, !!in_nmi());
 }
 NOKPROBE_SYMBOL(kretprobe_table_lock);
 
@@ -1884,7 +1896,12 @@ static int pre_handler_kretprobe(struct kprobe *p, struct pt_regs *regs)
 
 	/* TODO: consider to only swap the RA after the last pre_handler fired */
 	hash = hash_ptr(current, KPROBE_HASH_BITS);
-	raw_spin_lock_irqsave(&rp->lock, flags);
+	/*
+	 * Nested is a workaround that will soon not be needed.
+	 * There's other protections that make sure the same lock
+	 * is not taken on the same CPU that lockdep is unaware of.
+	 */
+	raw_spin_lock_irqsave_nested(&rp->lock, flags, 1);
 	if (!hlist_empty(&rp->free_instances)) {
 		ri = hlist_entry(rp->free_instances.first,
 				struct kretprobe_instance, hlist);
@@ -1895,7 +1912,7 @@ static int pre_handler_kretprobe(struct kprobe *p, struct pt_regs *regs)
 		ri->task = current;
 
 		if (rp->entry_handler && rp->entry_handler(ri, regs)) {
-			raw_spin_lock_irqsave(&rp->lock, flags);
+			raw_spin_lock_irqsave_nested(&rp->lock, flags, 1);
 			hlist_add_head(&ri->hlist, &rp->free_instances);
 			raw_spin_unlock_irqrestore(&rp->lock, flags);
 			return 0;
-- 
2.27.0

