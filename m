Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7087F0D2
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390234AbfHBJdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:33:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391265AbfHBJc6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:32:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0E2D2182B;
        Fri,  2 Aug 2019 09:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738377;
        bh=zDAXhg2aoXgYrA/23yNZ8hKX+GpRXOajXh1+D3hH7pI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YCu8o3Oiqwp1TiYwbkiO1a/V7T6UiHYF4zx36aREw1yXwCAUijNZRPDiRHczp3JpY
         i9uRFM/OlPNcV9G6tnPWYU9CKj8aW5sGENmMdjsd878qSC4wzp9TGD07Wcq9o11mVj
         6tjRry95dcqPx09riEWDFJQ/mgfhJ7zkvAuwTexc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 080/158] powerpc/watchpoint: Restore NV GPRs while returning from exception
Date:   Fri,  2 Aug 2019 11:28:21 +0200
Message-Id: <20190802092220.345680088@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>

commit f474c28fbcbe42faca4eb415172c07d76adcb819 upstream.

powerpc hardware triggers watchpoint before executing the instruction.
To make trigger-after-execute behavior, kernel emulates the
instruction. If the instruction is 'load something into non-volatile
register', exception handler should restore emulated register state
while returning back, otherwise there will be register state
corruption. eg, adding a watchpoint on a list can corrput the list:

  # cat /proc/kallsyms | grep kthread_create_list
  c00000000121c8b8 d kthread_create_list

Add watchpoint on kthread_create_list->prev:

  # perf record -e mem:0xc00000000121c8c0

Run some workload such that new kthread gets invoked. eg, I just
logged out from console:

  list_add corruption. next->prev should be prev (c000000001214e00), \
	but was c00000000121c8b8. (next=c00000000121c8b8).
  WARNING: CPU: 59 PID: 309 at lib/list_debug.c:25 __list_add_valid+0xb4/0xc0
  CPU: 59 PID: 309 Comm: kworker/59:0 Kdump: loaded Not tainted 5.1.0-rc7+ #69
  ...
  NIP __list_add_valid+0xb4/0xc0
  LR __list_add_valid+0xb0/0xc0
  Call Trace:
  __list_add_valid+0xb0/0xc0 (unreliable)
  __kthread_create_on_node+0xe0/0x260
  kthread_create_on_node+0x34/0x50
  create_worker+0xe8/0x260
  worker_thread+0x444/0x560
  kthread+0x160/0x1a0
  ret_from_kernel_thread+0x5c/0x70

List corruption happened because it uses 'load into non-volatile
register' instruction:

Snippet from __kthread_create_on_node:

  c000000000136be8:     addis   r29,r2,-19
  c000000000136bec:     ld      r29,31424(r29)
        if (!__list_add_valid(new, prev, next))
  c000000000136bf0:     mr      r3,r30
  c000000000136bf4:     mr      r5,r28
  c000000000136bf8:     mr      r4,r29
  c000000000136bfc:     bl      c00000000059a2f8 <__list_add_valid+0x8>

Register state from WARN_ON():

  GPR00: c00000000059a3a0 c000007ff23afb50 c000000001344e00 0000000000000075
  GPR04: 0000000000000000 0000000000000000 0000001852af8bc1 0000000000000000
  GPR08: 0000000000000001 0000000000000007 0000000000000006 00000000000004aa
  GPR12: 0000000000000000 c000007ffffeb080 c000000000137038 c000005ff62aaa00
  GPR16: 0000000000000000 0000000000000000 c000007fffbe7600 c000007fffbe7370
  GPR20: c000007fffbe7320 c000007fffbe7300 c000000001373a00 0000000000000000
  GPR24: fffffffffffffef7 c00000000012e320 c000007ff23afcb0 c000000000cb8628
  GPR28: c00000000121c8b8 c000000001214e00 c000007fef5b17e8 c000007fef5b17c0

Watchpoint hit at 0xc000000000136bec.

  addis   r29,r2,-19
   => r29 = 0xc000000001344e00 + (-19 << 16)
   => r29 = 0xc000000001214e00

  ld      r29,31424(r29)
   => r29 = *(0xc000000001214e00 + 31424)
   => r29 = *(0xc00000000121c8c0)

0xc00000000121c8c0 is where we placed a watchpoint and thus this
instruction was emulated by emulate_step. But because handle_dabr_fault
did not restore emulated register state, r29 still contains stale
value in above register state.

Fixes: 5aae8a5370802 ("powerpc, hw_breakpoints: Implement hw_breakpoints for 64-bit server processors")
Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc: stable@vger.kernel.org # 2.6.36+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/exceptions-64s.S |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1719,7 +1719,7 @@ handle_page_fault:
 	addi	r3,r1,STACK_FRAME_OVERHEAD
 	bl	do_page_fault
 	cmpdi	r3,0
-	beq+	12f
+	beq+	ret_from_except_lite
 	bl	save_nvgprs
 	mr	r5,r3
 	addi	r3,r1,STACK_FRAME_OVERHEAD
@@ -1734,7 +1734,12 @@ handle_dabr_fault:
 	ld      r5,_DSISR(r1)
 	addi    r3,r1,STACK_FRAME_OVERHEAD
 	bl      do_break
-12:	b       ret_from_except_lite
+	/*
+	 * do_break() may have changed the NV GPRS while handling a breakpoint.
+	 * If so, we need to restore them with their updated values. Don't use
+	 * ret_from_except_lite here.
+	 */
+	b       ret_from_except
 
 
 /* We have a page fault that hash_page could handle but HV refused


