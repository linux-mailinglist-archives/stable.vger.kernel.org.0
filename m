Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D20B616D0
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbfGGTnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:43:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57554 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727602AbfGGTiL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:11 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz9-0006kJ-2y; Sun, 07 Jul 2019 20:38:07 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz7-0005dw-5r; Sun, 07 Jul 2019 20:38:05 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "Christophe Leroy" <christophe.leroy@c-s.fr>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.995998582@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 095/129] powerpc/32: Clear on-stack exception marker
 upon exception return
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 9580b71b5a7863c24a9bd18bcd2ad759b86b1eff upstream.

Clear the on-stack STACK_FRAME_REGS_MARKER on exception exit in order
to avoid confusing stacktrace like the one below.

  Call Trace:
  [c0e9dca0] [c01c42a0] print_address_description+0x64/0x2bc (unreliable)
  [c0e9dcd0] [c01c4684] kasan_report+0xfc/0x180
  [c0e9dd10] [c0895130] memchr+0x24/0x74
  [c0e9dd30] [c00a9e38] msg_print_text+0x124/0x574
  [c0e9dde0] [c00ab710] console_unlock+0x114/0x4f8
  [c0e9de40] [c00adc60] vprintk_emit+0x188/0x1c4
  --- interrupt: c0e9df00 at 0x400f330
      LR = init_stack+0x1f00/0x2000
  [c0e9de80] [c00ae3c4] printk+0xa8/0xcc (unreliable)
  [c0e9df20] [c0c27e44] early_irq_init+0x38/0x108
  [c0e9df50] [c0c15434] start_kernel+0x310/0x488
  [c0e9dff0] [00003484] 0x3484

With this patch the trace becomes:

  Call Trace:
  [c0e9dca0] [c01c42c0] print_address_description+0x64/0x2bc (unreliable)
  [c0e9dcd0] [c01c46a4] kasan_report+0xfc/0x180
  [c0e9dd10] [c0895150] memchr+0x24/0x74
  [c0e9dd30] [c00a9e58] msg_print_text+0x124/0x574
  [c0e9dde0] [c00ab730] console_unlock+0x114/0x4f8
  [c0e9de40] [c00adc80] vprintk_emit+0x188/0x1c4
  [c0e9de80] [c00ae3e4] printk+0xa8/0xcc
  [c0e9df20] [c0c27e44] early_irq_init+0x38/0x108
  [c0e9df50] [c0c15434] start_kernel+0x310/0x488
  [c0e9dff0] [00003484] 0x3484

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/entry_32.S | 9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -757,6 +757,9 @@ fast_exception_return:
 	mtcr	r10
 	lwz	r10,_LINK(r11)
 	mtlr	r10
+	/* Clear the exception_marker on the stack to avoid confusing stacktrace */
+	li	r10, 0
+	stw	r10, 8(r11)
 	REST_GPR(10, r11)
 	mtspr	SPRN_SRR1,r9
 	mtspr	SPRN_SRR0,r12
@@ -987,6 +990,9 @@ END_FTR_SECTION_IFSET(CPU_FTR_NEED_PAIRE
 	mtcrf	0xFF,r10
 	mtlr	r11
 
+	/* Clear the exception_marker on the stack to avoid confusing stacktrace */
+	li	r10, 0
+	stw	r10, 8(r1)
 	/*
 	 * Once we put values in SRR0 and SRR1, we are in a state
 	 * where exceptions are not recoverable, since taking an
@@ -1024,6 +1030,9 @@ exc_exit_restart_end:
 	mtlr	r11
 	lwz	r10,_CCR(r1)
 	mtcrf	0xff,r10
+	/* Clear the exception_marker on the stack to avoid confusing stacktrace */
+	li	r10, 0
+	stw	r10, 8(r1)
 	REST_2GPRS(9, r1)
 	.globl exc_exit_restart
 exc_exit_restart:

