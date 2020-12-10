Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89F82D5FC8
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391575AbgLJPbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 10:31:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:46262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390792AbgLJPbo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 10:31:44 -0500
From:   Masami Hiramatsu <mhiramat@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Solar Designer <solar@openwall.com>, Eddy_Wu@trendmicro.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/2] kprobes: Remove NMI context check
Date:   Fri, 11 Dec 2020 00:30:58 +0900
Message-Id: <160761425763.3585575.15837172081484340228.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e03b4a084ea6b0a18b0e874baec439e69090c168 upstream.

The in_nmi() check in pre_handler_kretprobe() is meant to avoid
recursion, and blindly assumes that anything NMI is recursive.

However, since commit:

  9b38cc704e84 ("kretprobe: Prevent triggering kretprobe from within kprobe_flush_task")

there is a better way to detect and avoid actual recursion.

By setting a dummy kprobe, any actual exceptions will terminate early
(by trying to handle the dummy kprobe), and recursion will not happen.

Employ this to avoid the kretprobe_table_lock() recursion, replacing
the over-eager in_nmi() check.

Cc: stable@vger.kernel.org # 5.9.x
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lkml.kernel.org/r/159870615628.1229682.6087311596892125907.stgit@devnote2
---
 kernel/kprobes.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index e995541d277d..b885d884603d 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1359,7 +1359,8 @@ static void cleanup_rp_inst(struct kretprobe *rp)
 	struct hlist_node *next;
 	struct hlist_head *head;
 
-	/* No race here */
+	/* To avoid recursive kretprobe by NMI, set kprobe busy here */
+	kprobe_busy_begin();
 	for (hash = 0; hash < KPROBE_TABLE_SIZE; hash++) {
 		kretprobe_table_lock(hash, &flags);
 		head = &kretprobe_inst_table[hash];
@@ -1369,6 +1370,8 @@ static void cleanup_rp_inst(struct kretprobe *rp)
 		}
 		kretprobe_table_unlock(hash, &flags);
 	}
+	kprobe_busy_end();
+
 	free_rp_inst(rp);
 }
 NOKPROBE_SYMBOL(cleanup_rp_inst);
@@ -1937,17 +1940,6 @@ static int pre_handler_kretprobe(struct kprobe *p, struct pt_regs *regs)
 	unsigned long hash, flags = 0;
 	struct kretprobe_instance *ri;
 
-	/*
-	 * To avoid deadlocks, prohibit return probing in NMI contexts,
-	 * just skip the probe and increase the (inexact) 'nmissed'
-	 * statistical counter, so that the user is informed that
-	 * something happened:
-	 */
-	if (unlikely(in_nmi())) {
-		rp->nmissed++;
-		return 0;
-	}
-
 	/* TODO: consider to only swap the RA after the last pre_handler fired */
 	hash = hash_ptr(current, KPROBE_HASH_BITS);
 	raw_spin_lock_irqsave(&rp->lock, flags);

