Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F042D9DDE
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 18:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408597AbgLNRhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 12:37:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:46000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408580AbgLNRhK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:10 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.9 003/105] kprobes: Remove NMI context check
Date:   Mon, 14 Dec 2020 18:27:37 +0100
Message-Id: <20201214172555.444157078@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kprobes.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1359,7 +1359,8 @@ static void cleanup_rp_inst(struct kretp
 	struct hlist_node *next;
 	struct hlist_head *head;
 
-	/* No race here */
+	/* To avoid recursive kretprobe by NMI, set kprobe busy here */
+	kprobe_busy_begin();
 	for (hash = 0; hash < KPROBE_TABLE_SIZE; hash++) {
 		kretprobe_table_lock(hash, &flags);
 		head = &kretprobe_inst_table[hash];
@@ -1369,6 +1370,8 @@ static void cleanup_rp_inst(struct kretp
 		}
 		kretprobe_table_unlock(hash, &flags);
 	}
+	kprobe_busy_end();
+
 	free_rp_inst(rp);
 }
 NOKPROBE_SYMBOL(cleanup_rp_inst);
@@ -1937,17 +1940,6 @@ static int pre_handler_kretprobe(struct
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


