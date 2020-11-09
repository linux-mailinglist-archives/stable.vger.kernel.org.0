Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B6B2AB8EC
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730353AbgKIM7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 07:59:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:53770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729493AbgKIM7b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 07:59:31 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AF752076E;
        Mon,  9 Nov 2020 12:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926771;
        bh=5TuVnIfOp5I5e6AJUXfi2mmscxJEsNiAj1XcbH3No4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DIFceCwIRe1VqbD/ZJ1TZkfL2sf/hHLka7qWFh/FpHx40cpZ82uDDRk4du+1W8pKe
         /+k3By8vpuLASYWsZColrVV4vkE/jp8//a4kETmJTwzcdBR7J+6aXYvgIPnnrsSBvH
         b2SrQ+stS92xYkmkKGifTwl0l5zxs8xBfJzmA4DI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Waldemar Brodkorb <wbx@uclibc-ng.org>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 4.4 86/86] Revert "ARC: entry: fix potential EFA clobber when TIF_SYSCALL_TRACE"
Date:   Mon,  9 Nov 2020 13:55:33 +0100
Message-Id: <20201109125024.915324799@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
References: <20201109125020.852643676@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineet Gupta <Vineet.Gupta1@synopsys.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arc/kernel/entry.S |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -168,6 +168,7 @@ END(EV_Extension)
 tracesys:
 	; save EFA in case tracer wants the PC of traced task
 	; using ERET won't work since next-PC has already committed
+	lr  r12, [efa]
 	GET_CURR_TASK_FIELD_PTR   TASK_THREAD, r11
 	st  r12, [r11, THREAD_FAULT_ADDR]	; thread.fault_address
 
@@ -210,9 +211,15 @@ tracesys_exit:
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
@@ -239,10 +246,6 @@ ENTRY(EV_Trap)
 
 	EXCEPTION_PROLOGUE
 
-	lr  r12, [efa]
-
-	FAKE_RET_FROM_EXCPN
-
 	;============ TRAP 1   :breakpoints
 	; Check ECR for trap with arg (PROLOGUE ensures r9 has ECR)
 	bmsk.f 0, r9, 7
@@ -250,6 +253,9 @@ ENTRY(EV_Trap)
 
 	;============ TRAP  (no param): syscall top level
 
+	; First return from Exception to pure K mode (Exception/IRQs renabled)
+	FAKE_RET_FROM_EXCPN
+
 	; If syscall tracing ongoing, invoke pre-post-hooks
 	GET_CURR_THR_INFO_FLAGS   r10
 	btst r10, TIF_SYSCALL_TRACE


