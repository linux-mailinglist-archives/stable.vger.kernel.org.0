Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03151293301
	for <lists+stable@lfdr.de>; Tue, 20 Oct 2020 04:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390541AbgJTCUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 22:20:03 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:35222 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390538AbgJTCUC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 22:20:02 -0400
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C20CEC00A7;
        Tue, 20 Oct 2020 02:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1603160402; bh=Y5kCe7twpvpAVlRszOPR/AKOY980wsss/eMlLX4vYD0=;
        h=From:To:Cc:Subject:Date:From;
        b=BBmBAqsYTIqhj205PkATalZZvP46q05w9Z39AokxS6jNjbgwvyI6Vp5ICtTOZMHW2
         0qUkxeL4fMoGxP/Jdz8+l+3iL6xSgiG9p5zw0yfKAUG39pKhDk+IoDTRrcZTizKeSu
         dpCvP+pWz1uF/wEVqcQYvKGwxVShiXpUJc1OXj2H6Cl7qi+EaCa9855TS7VoTH9FXt
         quDzntNpYJFjy4FKAOLJheRDcmY8NS5OE1ffGKq2DIqVGhbOIO8BxRathzGgwWF8lw
         CBiZlknCU56RX58qXSCUnsbtLGJymWZaT2MTKbMtG0UQFmk4yagUtdropjiNoCZqI0
         IfqEhmCvC3ctw==
Received: from vineetg-Latitude-7400.internal.synopsys.com (unknown [10.13.183.89])
        by mailhost.synopsys.com (Postfix) with ESMTP id 37221A0099;
        Tue, 20 Oct 2020 02:19:58 +0000 (UTC)
X-SNPS-Relay: synopsys.com
From:   Vineet Gupta <Vineet.Gupta1@synopsys.com>
To:     stable@vger.kernel.org
Cc:     linux-snps-arc@lists.infradead.org, linux-kernel@vger.kernel.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Waldemar Brodkorb <wbx@uclibc-ng.org>
Subject: [PATCH] Revert "ARC: entry: fix potential EFA clobber when TIF_SYSCALL_TRACE"
Date:   Mon, 19 Oct 2020 19:19:57 -0700
Message-Id: <20201020021957.1260521-1-vgupta@synopsys.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 00fdec98d9881bf5173af09aebd353ab3b9ac729.
(but only from 5.2 and prior kernels)

The original commit was a preventive fix based on code-review and was
auto-picked for stable back-port (for better or worse).
It was OK for v5.3+ kernels, but turned up needing an implicit change
68e5c6f073bcf70 "(ARC: entry: EV_Trap expects r10 (vs. r9) to have
 exception cause)" merged in v5.3 which itself was not backported.
So to summarize the stable backport of this patch for v5.2 and prior
kernels is busted and it won't boot.

The obvious solution is backport 68e5c6f073bcf70 but that is a pain as
it doesn't revert cleanly and each of affected kernels (so far v4.19,
v4.14, v4.9, v4.4) needs a slightly different massaged varaint.
So the easier fix is to simply revert the backport from 5.2 and prior.
The issue was not a big deal as it would cause strace to sporadically
not work correctly.

Waldemar Brodkorb first reported this when running ARC uClibc regressions
on latest stable kernels (with offending backport). Once he bisected it,
the analysis was trivial, so thx to him for this.

Reported-by: Waldemar Brodkorb <wbx@uclibc-ng.org>
Bisected-by: Waldemar Brodkorb <wbx@uclibc-ng.org>
Cc: stable <stable@vger.kernel.org> # 5.2 and prior
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/kernel/entry.S | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index ea00c8a17f07..60406ec62eb8 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -165,6 +165,7 @@ END(EV_Extension)
 tracesys:
 	; save EFA in case tracer wants the PC of traced task
 	; using ERET won't work since next-PC has already committed
+	lr  r12, [efa]
 	GET_CURR_TASK_FIELD_PTR   TASK_THREAD, r11
 	st  r12, [r11, THREAD_FAULT_ADDR]	; thread.fault_address
 
@@ -207,9 +208,15 @@ tracesys_exit:
 ; Breakpoint TRAP
 ; ---------------------------------------------
 trap_with_param:
-	mov r0, r12	; EFA in case ptracer/gdb wants stop_pc
+
+	; stop_pc info by gdb needs this info
+	lr  r0, [efa]
 	mov r1, sp
 
+	; Now that we have read EFA, it is safe to do "fake" rtie
+	;   and get out of CPU exception mode
+	FAKE_RET_FROM_EXCPN
+
 	; Save callee regs in case gdb wants to have a look
 	; SP will grow up by size of CALLEE Reg-File
 	; NOTE: clobbers r12
@@ -236,10 +243,6 @@ ENTRY(EV_Trap)
 
 	EXCEPTION_PROLOGUE
 
-	lr  r12, [efa]
-
-	FAKE_RET_FROM_EXCPN
-
 	;============ TRAP 1   :breakpoints
 	; Check ECR for trap with arg (PROLOGUE ensures r10 has ECR)
 	bmsk.f 0, r10, 7
@@ -247,6 +250,9 @@ ENTRY(EV_Trap)
 
 	;============ TRAP  (no param): syscall top level
 
+	; First return from Exception to pure K mode (Exception/IRQs renabled)
+	FAKE_RET_FROM_EXCPN
+
 	; If syscall tracing ongoing, invoke pre-post-hooks
 	GET_CURR_THR_INFO_FLAGS   r10
 	btst r10, TIF_SYSCALL_TRACE
-- 
2.25.1

