Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC06498582
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 17:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241250AbiAXQ5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 11:57:01 -0500
Received: from mail.efficios.com ([167.114.26.124]:41828 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243796AbiAXQ47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 11:56:59 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 1B379344BCF;
        Mon, 24 Jan 2022 11:56:58 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id nOTX4EkGCWYJ; Mon, 24 Jan 2022 11:56:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 4D7DF344BCD;
        Mon, 24 Jan 2022 11:56:57 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 4D7DF344BCD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1643043417;
        bh=Fuss6rxEbY9C0XsqWjuiCNTFvR+z4EdHL0f9IdHH/Qc=;
        h=From:To:Date:Message-Id;
        b=BhWC1oyDO0mOpXsahbNAIMnb2LECdzsykwGKV3G74D04Rup9ffyoTpykYBsUeH9GJ
         c+46n3JMmxVj7wczzMuhC0AfPsLErzfc+gfJy6nh9xYdLx67VCSBbYAgf/3I+YCE24
         7yA+jFnuDdzpd2a2KfMxvq68GT3S8rBXJcBIWW5VqhrqpsoBrTNyKbPjBqC9V8PVV5
         DS1ioemLmN/1IfCraqau7xO6rx55lXAmNVqxIHpQYkZAhzURG6wtUZTCcAIHv8/HcF
         SeA2PKO1CjKT+Zvv3xhpHDOe8WFft3qMalS9Fl+LQpnEcHaiHhgwmcZDz5foB3D2z3
         XRlTDqES/hsoA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id jgAC8R7owfFM; Mon, 24 Jan 2022 11:56:57 -0500 (EST)
Received: from localhost.localdomain (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by mail.efficios.com (Postfix) with ESMTPSA id 1A034344F05;
        Mon, 24 Jan 2022 11:56:57 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Oskolkov <posk@google.com>, stable@vger.kernel.org
Subject: [PATCH] sched/membarrier: Fix membarrier-rseq fence command missing from query bitmask
Date:   Mon, 24 Jan 2022 11:56:43 -0500
Message-Id: <20220124165643.17247-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: Peter Oskolkov <posk@google.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org> # 5.10+
---
 kernel/sched/membarrier.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index b5add64d9698..3d2825408e3a 100644
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
-- 
2.17.1

