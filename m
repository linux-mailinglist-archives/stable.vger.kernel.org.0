Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55874A4222
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358420AbiAaLK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349210AbiAaLGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:06:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334DBC061394;
        Mon, 31 Jan 2022 03:04:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2D22B82A59;
        Mon, 31 Jan 2022 11:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3979FC340E8;
        Mon, 31 Jan 2022 11:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627086;
        bh=A87i1zJgpgfpgVNLS/bYqudetWowmmB8GJRnlDrhw9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qzvc0p+oQf2nZqzS5n6jfCvaioZK6f0IDsX+/uyRehccWYf+s+Nb4iNphDVlcb0Un
         3ysgIzOJfmliAxEMgR5c0q6LbmXN5eAjGS0rmhn8/LN6YWht2Qq728U7P3V50T6kBU
         Hnyxc0ZoHrtUSulKriZPH8YjxTZIuydrpFVOc0h4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 037/100] sched/membarrier: Fix membarrier-rseq fence command missing from query bitmask
Date:   Mon, 31 Jan 2022 11:55:58 +0100
Message-Id: <20220131105221.694727913@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit 809232619f5b15e31fb3563985e705454f32621f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/membarrier.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -19,11 +19,11 @@
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
@@ -31,7 +31,8 @@
 	| MEMBARRIER_CMD_REGISTER_GLOBAL_EXPEDITED			\
 	| MEMBARRIER_CMD_PRIVATE_EXPEDITED				\
 	| MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED			\
-	| MEMBARRIER_PRIVATE_EXPEDITED_SYNC_CORE_BITMASK)
+	| MEMBARRIER_PRIVATE_EXPEDITED_SYNC_CORE_BITMASK		\
+	| MEMBARRIER_PRIVATE_EXPEDITED_RSEQ_BITMASK)
 
 static void ipi_mb(void *info)
 {


