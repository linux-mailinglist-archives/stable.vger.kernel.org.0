Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2125EEE49
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389984AbfKDWJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:09:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:42670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390418AbfKDWJd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:09:33 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CE6F20650;
        Mon,  4 Nov 2019 22:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905372;
        bh=mY9b+i7LidgwnXe/Qx61bnZHFbA9frZCx9Me8Ze/Sm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dNDp+mcmL1zuYWBTxNAQLuu0C/CbAHV3KSZJ7oDyUZtuyv26uOcv86rY1xqHGKhu+
         JnWXioVG94lrxitryGRF8Aqk29ZzUaraAq99Tmpbkdh62nOstTpt5tje93XrO5rv6i
         nqyZbhJiVsTAGcrUfP1u6T2KgpPoPBjhwsYdc05A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.3 122/163] s390/unwind: fix mixing regs and sp
Date:   Mon,  4 Nov 2019 22:45:12 +0100
Message-Id: <20191104212149.057129464@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

commit a1d863ac3e1085e1fea9caafd87252d08731de2e upstream.

unwind_for_each_frame stops after the first frame if regs->gprs[15] <=
sp.

The reason is that in case regs are specified, the first frame should be
regs->psw.addr and the second frame should be sp->gprs[8]. However,
currently the second frame is regs->gprs[15], which confuses
outside_of_stack().

Fix by introducing a flag to distinguish this special case from
unwinding the interrupt handler, for which the current behavior is
appropriate.

Fixes: 78c98f907413 ("s390/unwind: introduce stack unwind API")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: stable@vger.kernel.org # v5.2+
Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/include/asm/unwind.h |    1 +
 arch/s390/kernel/unwind_bc.c   |   18 +++++++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

--- a/arch/s390/include/asm/unwind.h
+++ b/arch/s390/include/asm/unwind.h
@@ -35,6 +35,7 @@ struct unwind_state {
 	struct task_struct *task;
 	struct pt_regs *regs;
 	unsigned long sp, ip;
+	bool reuse_sp;
 	int graph_idx;
 	bool reliable;
 	bool error;
--- a/arch/s390/kernel/unwind_bc.c
+++ b/arch/s390/kernel/unwind_bc.c
@@ -46,10 +46,15 @@ bool unwind_next_frame(struct unwind_sta
 
 	regs = state->regs;
 	if (unlikely(regs)) {
-		sp = READ_ONCE_NOCHECK(regs->gprs[15]);
-		if (unlikely(outside_of_stack(state, sp))) {
-			if (!update_stack_info(state, sp))
-				goto out_err;
+		if (state->reuse_sp) {
+			sp = state->sp;
+			state->reuse_sp = false;
+		} else {
+			sp = READ_ONCE_NOCHECK(regs->gprs[15]);
+			if (unlikely(outside_of_stack(state, sp))) {
+				if (!update_stack_info(state, sp))
+					goto out_err;
+			}
 		}
 		sf = (struct stack_frame *) sp;
 		ip = READ_ONCE_NOCHECK(sf->gprs[8]);
@@ -107,9 +112,9 @@ void __unwind_start(struct unwind_state
 {
 	struct stack_info *info = &state->stack_info;
 	unsigned long *mask = &state->stack_mask;
+	bool reliable, reuse_sp;
 	struct stack_frame *sf;
 	unsigned long ip;
-	bool reliable;
 
 	memset(state, 0, sizeof(*state));
 	state->task = task;
@@ -134,10 +139,12 @@ void __unwind_start(struct unwind_state
 	if (regs) {
 		ip = READ_ONCE_NOCHECK(regs->psw.addr);
 		reliable = true;
+		reuse_sp = true;
 	} else {
 		sf = (struct stack_frame *) sp;
 		ip = READ_ONCE_NOCHECK(sf->gprs[8]);
 		reliable = false;
+		reuse_sp = false;
 	}
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -151,5 +158,6 @@ void __unwind_start(struct unwind_state
 	state->sp = sp;
 	state->ip = ip;
 	state->reliable = reliable;
+	state->reuse_sp = reuse_sp;
 }
 EXPORT_SYMBOL_GPL(__unwind_start);


