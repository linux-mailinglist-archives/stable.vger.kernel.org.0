Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 565EB14B69F
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgA1OE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:04:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728073AbgA1OE2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:04:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E043E24692;
        Tue, 28 Jan 2020 14:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220267;
        bh=cbYy2+euM7xYchVQx+xCkIdw6yAt6rfHSmNFuVYtaoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KYAUHxRSFbCsjGpW3aj9gqrgARWLJEuZAHvEBBbFRtO3obmiCbTRfqzotYoMM0sjD
         wf2Ua/COOwqoNEPVUZ1errskU7JGJubK6yCsMm4bAXJTm6XG6UA4myBakBbehF5Bju
         q+8XBjl+L+lKX2Ah7rbIUPnEJr6I7OtfOv/8i2Pk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Marillat <marillat@debian.org>,
        Romain Dolbeau <romain@dolbeau.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 046/104] powerpc/mm/hash: Fix sharing context ids between kernel & userspace
Date:   Tue, 28 Jan 2020 15:00:07 +0100
Message-Id: <20200128135824.089383317@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

commit 5d2e5dd5849b4ef5e8ec35e812cdb732c13cd27e upstream.

Commit 0034d395f89d ("powerpc/mm/hash64: Map all the kernel regions in
the same 0xc range") has a bug in the definition of MIN_USER_CONTEXT.

The result is that the context id used for the vmemmap and the lowest
context id handed out to userspace are the same. The context id is
essentially the process identifier as far as the first stage of the
MMU translation is concerned.

This can result in multiple SLB entries with the same VSID (Virtual
Segment ID), accessible to the kernel and some random userspace
process that happens to get the overlapping id, which is not expected
eg:

  07 c00c000008000000 40066bdea7000500  1T  ESID=   c00c00  VSID=      66bdea7 LLP:100
  12 0002000008000000 40066bdea7000d80  1T  ESID=      200  VSID=      66bdea7 LLP:100

Even though the user process and the kernel use the same VSID, the
permissions in the hash page table prevent the user process from
reading or writing to any kernel mappings.

It can also lead to SLB entries with different base page size
encodings (LLP), eg:

  05 c00c000008000000 00006bde0053b500 256M ESID=c00c00000  VSID=    6bde0053b LLP:100
  09 0000000008000000 00006bde0053bc80 256M ESID=        0  VSID=    6bde0053b LLP:  0

Such SLB entries can result in machine checks, eg. as seen on a G5:

  Oops: Machine check, sig: 7 [#1]
  BE PAGE SIZE=64K MU-Hash SMP NR_CPUS=4 NUMA Power Mac
  NIP: c00000000026f248 LR: c000000000295e58 CTR: 0000000000000000
  REGS: c0000000erfd3d70 TRAP: 0200 Tainted: G M (5.5.0-rcl-gcc-8.2.0-00010-g228b667d8ea1)
  MSR: 9000000000109032 <SF,HV,EE,ME,IR,DR,RI> CR: 24282048 XER: 00000000
  DAR: c00c000000612c80 DSISR: 00000400 IRQMASK: 0
  ...
  NIP [c00000000026f248] .kmem_cache_free+0x58/0x140
  LR  [c088000008295e58] .putname 8x88/0xa
  Call Trace:
    .putname+0xB8/0xa
    .filename_lookup.part.76+0xbe/0x160
    .do_faccessat+0xe0/0x380
    system_call+0x5c/ex68

This happens with 256MB segments and 64K pages, as the duplicate VSID
is hit with the first vmemmap segment and the first user segment, and
older 32-bit userspace maps things in the first user segment.

On other CPUs a machine check is not seen. Instead the userspace
process can get stuck continuously faulting, with the fault never
properly serviced, due to the kernel not understanding that there is
already a HPTE for the address but with inaccessible permissions.

On machines with 1T segments we've not seen the bug hit other than by
deliberately exercising it. That seems to be just a matter of luck
though, due to the typical layout of the user virtual address space
and the ranges of vmemmap that are typically populated.

To fix it we add 2 to MIN_USER_CONTEXT. This ensures the lowest
context given to userspace doesn't overlap with the VMEMMAP context,
or with the context for INVALID_REGION_ID.

Fixes: 0034d395f89d ("powerpc/mm/hash64: Map all the kernel regions in the same 0xc range")
Cc: stable@vger.kernel.org # v5.2+
Reported-by: Christian Marillat <marillat@debian.org>
Reported-by: Romain Dolbeau <romain@dolbeau.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
[mpe: Account for INVALID_REGION_ID, mostly rewrite change log]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200123102547.11623-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/book3s/64/mmu-hash.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/book3s/64/mmu-hash.h
+++ b/arch/powerpc/include/asm/book3s/64/mmu-hash.h
@@ -600,8 +600,11 @@ extern void slb_set_size(u16 size);
  *
  */
 #define MAX_USER_CONTEXT	((ASM_CONST(1) << CONTEXT_BITS) - 2)
+
+// The + 2 accounts for INVALID_REGION and 1 more to avoid overlap with kernel
 #define MIN_USER_CONTEXT	(MAX_KERNEL_CTX_CNT + MAX_VMALLOC_CTX_CNT + \
-				 MAX_IO_CTX_CNT + MAX_VMEMMAP_CTX_CNT)
+				 MAX_IO_CTX_CNT + MAX_VMEMMAP_CTX_CNT + 2)
+
 /*
  * For platforms that support on 65bit VA we limit the context bits
  */


