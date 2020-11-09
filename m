Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB612ABC21
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730942AbgKINej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:34:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:58510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730912AbgKINFo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:05:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C18DA2076E;
        Mon,  9 Nov 2020 13:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927140;
        bh=mglHCfp/UlQYcz/a9qJD1teai+Xwpt9IhvQcoqPxHFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IdQBdKfO4GXofRgo/ovYtmwlU5KpzqHL4FgYg1aG3/UQaeA9i5tu8m2TXPAQrlyrL
         ogR5lw0Ya15O2TKlvluzQ+1yP/kmOL7yFYLJW5wOc6Om8hDVNCSyNJeqfcQ0QUFw68
         nmmRU+3QmXE1D8rY7WhuBHZyBLsrtL6rNeukBAXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Waldemar Brodkorb <wbx@uclibc-ng.org>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 4.9 117/117] Revert "ARC: entry: fix potential EFA clobber when TIF_SYSCALL_TRACE"
Date:   Mon,  9 Nov 2020 13:55:43 +0100
Message-Id: <20201109125031.231095251@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
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
@@ -156,6 +156,7 @@ END(EV_Extension)
 tracesys:
 	; save EFA in case tracer wants the PC of traced task
 	; using ERET won't work since next-PC has already committed
+	lr  r12, [efa]
 	GET_CURR_TASK_FIELD_PTR   TASK_THREAD, r11
 	st  r12, [r11, THREAD_FAULT_ADDR]	; thread.fault_address
 
@@ -198,9 +199,15 @@ tracesys_exit:
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
@@ -227,10 +234,6 @@ ENTRY(EV_Trap)
 
 	EXCEPTION_PROLOGUE
 
-	lr  r12, [efa]
-
-	FAKE_RET_FROM_EXCPN
-
 	;============ TRAP 1   :breakpoints
 	; Check ECR for trap with arg (PROLOGUE ensures r9 has ECR)
 	bmsk.f 0, r9, 7
@@ -238,6 +241,9 @@ ENTRY(EV_Trap)
 
 	;============ TRAP  (no param): syscall top level
 
+	; First return from Exception to pure K mode (Exception/IRQs renabled)
+	FAKE_RET_FROM_EXCPN
+
 	; If syscall tracing ongoing, invoke pre-post-hooks
 	GET_CURR_THR_INFO_FLAGS   r10
 	btst r10, TIF_SYSCALL_TRACE


