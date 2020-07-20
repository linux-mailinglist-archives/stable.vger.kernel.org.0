Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A95C226C3A
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgGTPhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:37:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgGTPho (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:37:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51A3622CB3;
        Mon, 20 Jul 2020 15:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259463;
        bh=WD4szfGsYOlw8JUiQhg/Iv/Jl4Tx01ZNDNwxWsdJSjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SgygmHsAtkZbGNHNzxmwZK2RqpqN8CvF3gED7i8LG+/R4Zb5h3HX3Hzj6Km6uJgOM
         mZRnOZb0+Llk5YqxLA7yIxc9fQ8QmExmFj4gjbuscF7g/HbyPPr2YzRJRXDNgeZ4Ok
         IA+YD2i/o4VTEf6Tk90H8ltmaCd2FGdC7MLs0KHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 4.4 17/58] ARC: entry: fix potential EFA clobber when TIF_SYSCALL_TRACE
Date:   Mon, 20 Jul 2020 17:36:33 +0200
Message-Id: <20200720152747.997581868@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152747.127988571@linuxfoundation.org>
References: <20200720152747.127988571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

commit 00fdec98d9881bf5173af09aebd353ab3b9ac729 upstream.

Trap handler for syscall tracing reads EFA (Exception Fault Address),
in case strace wants PC of trap instruction (EFA is not part of pt_regs
as of current code).

However this EFA read is racy as it happens after dropping to pure
kernel mode (re-enabling interrupts). A taken interrupt could
context-switch, trigger a different task's trap, clobbering EFA for this
execution context.

Fix this by reading EFA early, before re-enabling interrupts. A slight
side benefit is de-duplication of FAKE_RET_FROM_EXCPN in trap handler.
The trap handler is common to both ARCompact and ARCv2 builds too.

This just came out of code rework/review and no real problem was reported
but is clearly a potential problem specially for strace.

Cc: <stable@vger.kernel.org>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/kernel/entry.S |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -168,7 +168,6 @@ END(EV_Extension)
 tracesys:
 	; save EFA in case tracer wants the PC of traced task
 	; using ERET won't work since next-PC has already committed
-	lr  r12, [efa]
 	GET_CURR_TASK_FIELD_PTR   TASK_THREAD, r11
 	st  r12, [r11, THREAD_FAULT_ADDR]	; thread.fault_address
 
@@ -211,15 +210,9 @@ tracesys_exit:
 ; Breakpoint TRAP
 ; ---------------------------------------------
 trap_with_param:
-
-	; stop_pc info by gdb needs this info
-	lr  r0, [efa]
+	mov r0, r12	; EFA in case ptracer/gdb wants stop_pc
 	mov r1, sp
 
-	; Now that we have read EFA, it is safe to do "fake" rtie
-	;   and get out of CPU exception mode
-	FAKE_RET_FROM_EXCPN
-
 	; Save callee regs in case gdb wants to have a look
 	; SP will grow up by size of CALLEE Reg-File
 	; NOTE: clobbers r12
@@ -246,6 +239,10 @@ ENTRY(EV_Trap)
 
 	EXCEPTION_PROLOGUE
 
+	lr  r12, [efa]
+
+	FAKE_RET_FROM_EXCPN
+
 	;============ TRAP 1   :breakpoints
 	; Check ECR for trap with arg (PROLOGUE ensures r9 has ECR)
 	bmsk.f 0, r9, 7
@@ -253,9 +250,6 @@ ENTRY(EV_Trap)
 
 	;============ TRAP  (no param): syscall top level
 
-	; First return from Exception to pure K mode (Exception/IRQs renabled)
-	FAKE_RET_FROM_EXCPN
-
 	; If syscall tracing ongoing, invoke pre-post-hooks
 	GET_CURR_THR_INFO_FLAGS   r10
 	btst r10, TIF_SYSCALL_TRACE


