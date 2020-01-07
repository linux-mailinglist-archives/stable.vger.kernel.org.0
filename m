Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77C441333E4
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbgAGVCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:02:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:41608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728070AbgAGVCS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:02:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5137620678;
        Tue,  7 Jan 2020 21:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430937;
        bh=2rtwEMXNd6kcYUKaal2MNGmLUidol/gOaLQgC4FGeQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHQS0+SNAMV69whku4zWWRZcCrr6u7VdQTM4H5IonYjTWZX894LKdUOdC6GrxoslQ
         mMAF6tXuQmz2rqvX2PoQ9cfV6M6mbziKtfzHv9mb1Xr4gFqf3C9VGH8ThR5fsT9vos
         3iNtG2AjZpg38uEeUGdgWGKVQII/xNSZPn1vGmqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 157/191] powerpc/mm: Mark get_slice_psize() & slice_addr_is_low() as notrace
Date:   Tue,  7 Jan 2020 21:54:37 +0100
Message-Id: <20200107205341.365216307@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 91a063c956084fb21cf2523bce6892514e3f1799 upstream.

These slice routines are called from the SLB miss handler, which can
lead to warnings from the IRQ code, because we have not reconciled the
IRQ state properly:

  WARNING: CPU: 72 PID: 30150 at arch/powerpc/kernel/irq.c:258 arch_local_irq_restore.part.0+0xcc/0x100
  Modules linked in:
  CPU: 72 PID: 30150 Comm: ftracetest Not tainted 5.5.0-rc2-gcc9x-g7e0165b2f1a9 #1
  NIP:  c00000000001d83c LR: c00000000029ab90 CTR: c00000000026cf90
  REGS: c0000007eee3b960 TRAP: 0700   Not tainted  (5.5.0-rc2-gcc9x-g7e0165b2f1a9)
  MSR:  8000000000021033 <SF,ME,IR,DR,RI,LE>  CR: 22242844  XER: 20000000
  CFAR: c00000000001d780 IRQMASK: 0
  ...
  NIP arch_local_irq_restore.part.0+0xcc/0x100
  LR  trace_graph_entry+0x270/0x340
  Call Trace:
    trace_graph_entry+0x254/0x340 (unreliable)
    function_graph_enter+0xe4/0x1a0
    prepare_ftrace_return+0xa0/0x130
    ftrace_graph_caller+0x44/0x94	# (get_slice_psize())
    slb_allocate_user+0x7c/0x100
    do_slb_fault+0xf8/0x300
    instruction_access_slb_common+0x140/0x180

Fixes: 48e7b7695745 ("powerpc/64s/hash: Convert SLB miss handlers to C")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191221121337.4894-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/slice.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/mm/slice.c
+++ b/arch/powerpc/mm/slice.c
@@ -50,7 +50,7 @@ static void slice_print_mask(const char
 
 #endif
 
-static inline bool slice_addr_is_low(unsigned long addr)
+static inline notrace bool slice_addr_is_low(unsigned long addr)
 {
 	u64 tmp = (u64)addr;
 
@@ -659,7 +659,7 @@ unsigned long arch_get_unmapped_area_top
 				       mm_ctx_user_psize(&current->mm->context), 1);
 }
 
-unsigned int get_slice_psize(struct mm_struct *mm, unsigned long addr)
+unsigned int notrace get_slice_psize(struct mm_struct *mm, unsigned long addr)
 {
 	unsigned char *psizes;
 	int index, mask_index;


