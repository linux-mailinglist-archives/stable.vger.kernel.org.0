Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F70549CAF7
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 14:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235148AbiAZNhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 08:37:54 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:57124 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240486AbiAZNhv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 08:37:51 -0500
Date:   Wed, 26 Jan 2022 13:37:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643204270;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qgWC/j9vvHRiJ1aesc9zKJZuMQm1gEs0oXzGNKru0W4=;
        b=arjDFbaRSKXd1stWtmza7naEckCt1YvzZc+myHg/2Gx7pYSEcm9aUkEFZIKGxb6hMuQlrS
        sHezDT36D9Eg74Ni/OtnjzNSNxBbIOHEx7Z7PAMwYp8perajZl2hD9Gte3MUmhraBBxWST
        91h9Ro/jw345pluhtqwuq9Ho0sy3jEeuFWw/I7CipEDza5l0uRd+2eaqqCoR2CweRVDQOK
        g4Tfu0xNwi2kJspU7RwSpJ3w6M6kdzs7kG033BT80fe9RCEZPTCVvru24ELrKIF+It5GjI
        RV/admGkKpJjQ5Fi/gifGiigfvRgPicvVsSc4opIY0ePWvb9CjC883SKepROfw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643204270;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qgWC/j9vvHRiJ1aesc9zKJZuMQm1gEs0oXzGNKru0W4=;
        b=T+Yf1LuTPDK6qQWDThdM0j/44vx6GtO9xrkNdU4966m/JXh/cJcJ4TeXBAPfodUsCjhxA8
        TjJ3WOwnfgHRTgDQ==
From:   "tip-bot2 for Mathieu Desnoyers" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: sched/urgent] sched/membarrier: Fix membarrier-rseq fence
 command missing from query bitmask
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20220117203010.30129-1-mathieu.desnoyers@efficios.com>
References: <20220117203010.30129-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Message-ID: <164320426897.16921.6733520040853654052.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the sched/urgent branch of tip:

Commit-ID:     809232619f5b15e31fb3563985e705454f32621f
Gitweb:        https://git.kernel.org/tip/809232619f5b15e31fb3563985e705454f32621f
Author:        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
AuthorDate:    Mon, 17 Jan 2022 15:30:10 -05:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Tue, 25 Jan 2022 22:30:25 +01:00

sched/membarrier: Fix membarrier-rseq fence command missing from query bitmask

The membarrier command MEMBARRIER_CMD_QUERY allows querying the
available membarrier commands. When the membarrier-rseq fence commands
were added, a new MEMBARRIER_CMD_PRIVATE_EXPEDITED_RSEQ_BITMASK was
introduced with the intent to expose them with the MEMBARRIER_CMD_QUERY
command, the but it was never added to MEMBARRIER_CMD_BITMASK.

The membarrier-rseq fence commands are therefore not wired up with the
query command.

Rename MEMBARRIER_CMD_PRIVATE_EXPEDITED_RSEQ_BITMASK to
MEMBARRIER_PRIVATE_EXPEDITED_RSEQ_BITMASK (the bitmask is not a command
per-se), and change the erroneous
MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED_RSEQ_BITMASK (which does not
actually exist) to MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED_RSEQ.

Wire up MEMBARRIER_PRIVATE_EXPEDITED_RSEQ_BITMASK in
MEMBARRIER_CMD_BITMASK. Fixing this allows discovering availability of
the membarrier-rseq fence feature.

Fixes: 2a36ab717e8f ("rseq/membarrier: Add MEMBARRIER_CMD_PRIVATE_EXPEDITED_RSEQ")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org> # 5.10+
Link: https://lkml.kernel.org/r/20220117203010.30129-1-mathieu.desnoyers@efficios.com
---
 kernel/sched/membarrier.c |  9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index b5add64..3d28254 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -147,11 +147,11 @@
 #endif
 
 #ifdef CONFIG_RSEQ
-#define MEMBARRIER_CMD_PRIVATE_EXPEDITED_RSEQ_BITMASK		\
+#define MEMBARRIER_PRIVATE_EXPEDITED_RSEQ_BITMASK		\
 	(MEMBARRIER_CMD_PRIVATE_EXPEDITED_RSEQ			\
-	| MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED_RSEQ_BITMASK)
+	| MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED_RSEQ)
 #else
-#define MEMBARRIER_CMD_PRIVATE_EXPEDITED_RSEQ_BITMASK	0
+#define MEMBARRIER_PRIVATE_EXPEDITED_RSEQ_BITMASK	0
 #endif
 
 #define MEMBARRIER_CMD_BITMASK						\
@@ -159,7 +159,8 @@
 	| MEMBARRIER_CMD_REGISTER_GLOBAL_EXPEDITED			\
 	| MEMBARRIER_CMD_PRIVATE_EXPEDITED				\
 	| MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED			\
-	| MEMBARRIER_PRIVATE_EXPEDITED_SYNC_CORE_BITMASK)
+	| MEMBARRIER_PRIVATE_EXPEDITED_SYNC_CORE_BITMASK		\
+	| MEMBARRIER_PRIVATE_EXPEDITED_RSEQ_BITMASK)
 
 static void ipi_mb(void *info)
 {
