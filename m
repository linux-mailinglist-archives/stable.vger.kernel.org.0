Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEF0717FD5F
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbgCJMxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727077AbgCJMxU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:53:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DDFB2468F;
        Tue, 10 Mar 2020 12:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844799;
        bh=1d+l+kqG2hH2aBbgPH+auk/JtTL97jzlzJUpenApdvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ltOivEj5d/XXb4eAz13sbw17oQHSwNd02bevGoXBAesnCgwoYBsEkgDIADg9hnR4Y
         Q1whxgs3/nwJoS6MiyFfed9IPBMTiJz1Q8RI501sRwfUQVBMkRmtlcSJk3QdwLEyxt
         XqxQPjspb0rlmtduTpXqR5vqpI6YufQTa8IxSJho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Berger <stefanb@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 124/168] powerpc/mm: Fix missing KUAP disable in flush_coherent_icache()
Date:   Tue, 10 Mar 2020 13:39:30 +0100
Message-Id: <20200310123648.022168973@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 59bee45b9712c759ea4d3dcc4eff1752f3a66558 ]

Stefan reported a strange kernel fault which turned out to be due to a
missing KUAP disable in flush_coherent_icache() called from
flush_icache_range().

The fault looks like:

  Kernel attempted to access user page (7fffc30d9c00) - exploit attempt? (uid: 1009)
  BUG: Unable to handle kernel data access on read at 0x7fffc30d9c00
  Faulting instruction address: 0xc00000000007232c
  Oops: Kernel access of bad area, sig: 11 [#1]
  LE PAGE_SIZE=64K MMU=Radix SMP NR_CPUS=2048 NUMA PowerNV
  CPU: 35 PID: 5886 Comm: sigtramp Not tainted 5.6.0-rc2-gcc-8.2.0-00003-gfc37a1632d40 #79
  NIP:  c00000000007232c LR: c00000000003b7fc CTR: 0000000000000000
  REGS: c000001e11093940 TRAP: 0300   Not tainted  (5.6.0-rc2-gcc-8.2.0-00003-gfc37a1632d40)
  MSR:  900000000280b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 28000884  XER: 00000000
  CFAR: c0000000000722fc DAR: 00007fffc30d9c00 DSISR: 08000000 IRQMASK: 0
  GPR00: c00000000003b7fc c000001e11093bd0 c0000000023ac200 00007fffc30d9c00
  GPR04: 00007fffc30d9c18 0000000000000000 c000001e11093bd4 0000000000000000
  GPR08: 0000000000000000 0000000000000001 0000000000000000 c000001e1104ed80
  GPR12: 0000000000000000 c000001fff6ab380 c0000000016be2d0 4000000000000000
  GPR16: c000000000000000 bfffffffffffffff 0000000000000000 0000000000000000
  GPR20: 00007fffc30d9c00 00007fffc30d8f58 00007fffc30d9c18 00007fffc30d9c20
  GPR24: 00007fffc30d9c18 0000000000000000 c000001e11093d90 c000001e1104ed80
  GPR28: c000001e11093e90 0000000000000000 c0000000023d9d18 00007fffc30d9c00
  NIP flush_icache_range+0x5c/0x80
  LR  handle_rt_signal64+0x95c/0xc2c
  Call Trace:
    0xc000001e11093d90 (unreliable)
    handle_rt_signal64+0x93c/0xc2c
    do_notify_resume+0x310/0x430
    ret_from_except_lite+0x70/0x74
  Instruction dump:
  409e002c 7c0802a6 3c62ff31 3863f6a0 f8010080 48195fed 60000000 48fe4c8d
  60000000 e8010080 7c0803a6 7c0004ac <7c00ffac> 7c0004ac 4c00012c 38210070

This path through handle_rt_signal64() to setup_trampoline() and
flush_icache_range() is only triggered by 64-bit processes that have
unmapped their VDSO, which is rare.

flush_icache_range() takes a range of addresses to flush. In
flush_coherent_icache() we implement an optimisation for CPUs where we
know we don't actually have to flush the whole range, we just need to
do a single icbi.

However we still execute the icbi on the user address of the start of
the range we're flushing. On CPUs that also implement KUAP (Power9)
that leads to the spurious fault above.

We should be able to pass any address, including a kernel address, to
the icbi on these CPUs, which would avoid any interaction with KUAP.
But I don't want to make that change in a bug fix, just in case it
surfaces some strange behaviour on some CPU.

So for now just disable KUAP around the icbi. Note the icbi is treated
as a load, so we allow read access, not write as you'd expect.

Fixes: 890274c2dc4c ("powerpc/64s: Implement KUAP for Radix MMU")
Cc: stable@vger.kernel.org # v5.2+
Reported-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200303235708.26004-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/mem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 6612796ea69c2..96ca90ce0264a 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -363,7 +363,9 @@ static inline bool flush_coherent_icache(unsigned long addr)
 	 */
 	if (cpu_has_feature(CPU_FTR_COHERENT_ICACHE)) {
 		mb(); /* sync */
+		allow_read_from_user((const void __user *)addr, L1_CACHE_BYTES);
 		icbi((void *)addr);
+		prevent_read_from_user((const void __user *)addr, L1_CACHE_BYTES);
 		mb(); /* sync */
 		isync();
 		return true;
-- 
2.20.1



