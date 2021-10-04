Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F07420CD3
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235227AbhJDNJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:09:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235450AbhJDNI1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:08:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A103B61A50;
        Mon,  4 Oct 2021 13:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352533;
        bh=uNXtQ6CUxI7znXWkr52AmElWMoSvtHOsiADZFiPKlE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hlZCkUdtBuAlD+HURXSWBEgVQowCLIskqQMQVzolfzBzzICt+B982spnAf2IaQnxi
         roMegSa0VbkgaKc0khNADWUQg0rbwLBewTWnYVFR/bWZNhHvcTHqyl5KlZlXs1V/0N
         jPKTXPy0aKjkwzJIzuoPKN6WbkuC4FPC7w2VowTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.19 06/95] xen/x86: fix PV trap handling on secondary processors
Date:   Mon,  4 Oct 2021 14:51:36 +0200
Message-Id: <20211004125033.779097480@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125033.572932188@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

commit 0594c58161b6e0f3da8efa9c6e3d4ba52b652717 upstream.

The initial observation was that in PV mode under Xen 32-bit user space
didn't work anymore. Attempts of system calls ended in #GP(0x402). All
of the sudden the vector 0x80 handler was not in place anymore. As it
turns out up to 5.13 redundant initialization did occur: Once from
cpu_initialize_context() (through its VCPUOP_initialise hypercall) and a
2nd time while each CPU was brought fully up. This 2nd initialization is
now gone, uncovering that the 1st one was flawed: Unlike for the
set_trap_table hypercall, a full virtual IDT needs to be specified here;
the "vector" fields of the individual entries are of no interest. With
many (kernel) IDT entries still(?) (i.e. at that point at least) empty,
the syscall vector 0x80 ended up in slot 0x20 of the virtual IDT, thus
becoming the domain's handler for vector 0x20.

Make xen_convert_trap_info() fit for either purpose, leveraging the fact
that on the xen_copy_trap_info() path the table starts out zero-filled.
This includes moving out the writing of the sentinel, which would also
have lead to a buffer overrun in the xen_copy_trap_info() case if all
(kernel) IDT entries were populated. Convert the writing of the sentinel
to clearing of the entire table entry rather than just the address
field.

(I didn't bother trying to identify the commit which uncovered the issue
in 5.14; the commit named below is the one which actually introduced the
bad code.)

Fixes: f87e4cac4f4e ("xen: SMP guest support")
Cc: stable@vger.kernel.org
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/7a266932-092e-b68f-f2bb-1473b61adc6e@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/xen/enlighten_pv.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -720,8 +720,8 @@ static void xen_write_idt_entry(gate_des
 	preempt_enable();
 }
 
-static void xen_convert_trap_info(const struct desc_ptr *desc,
-				  struct trap_info *traps)
+static unsigned xen_convert_trap_info(const struct desc_ptr *desc,
+				      struct trap_info *traps, bool full)
 {
 	unsigned in, out, count;
 
@@ -731,17 +731,18 @@ static void xen_convert_trap_info(const
 	for (in = out = 0; in < count; in++) {
 		gate_desc *entry = (gate_desc *)(desc->address) + in;
 
-		if (cvt_gate_to_trap(in, entry, &traps[out]))
+		if (cvt_gate_to_trap(in, entry, &traps[out]) || full)
 			out++;
 	}
-	traps[out].address = 0;
+
+	return out;
 }
 
 void xen_copy_trap_info(struct trap_info *traps)
 {
 	const struct desc_ptr *desc = this_cpu_ptr(&idt_desc);
 
-	xen_convert_trap_info(desc, traps);
+	xen_convert_trap_info(desc, traps, true);
 }
 
 /* Load a new IDT into Xen.  In principle this can be per-CPU, so we
@@ -751,6 +752,7 @@ static void xen_load_idt(const struct de
 {
 	static DEFINE_SPINLOCK(lock);
 	static struct trap_info traps[257];
+	unsigned out;
 
 	trace_xen_cpu_load_idt(desc);
 
@@ -758,7 +760,8 @@ static void xen_load_idt(const struct de
 
 	memcpy(this_cpu_ptr(&idt_desc), desc, sizeof(idt_desc));
 
-	xen_convert_trap_info(desc, traps);
+	out = xen_convert_trap_info(desc, traps, false);
+	memset(&traps[out], 0, sizeof(traps[0]));
 
 	xen_mc_flush();
 	if (HYPERVISOR_set_trap_table(traps))


