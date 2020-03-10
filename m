Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E4117EFBC
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 05:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgCJEnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 00:43:07 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:37561 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgCJEnH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 00:43:07 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48c2X95Y4Mz9sRN;
        Tue, 10 Mar 2020 15:43:05 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1583815385;
        bh=qmq9D3n5l8PTP5jQX3gS5CLZLQI/cN5JYYU8ZLTw0KY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=qiWV7fjlfokz4bg3TOgqXz66gToyiFkA4G6dipx8hdOfUi+SPTdYLZKtpW2RNkQwc
         UKa9huqSDkdLJPo26bUZvcmVJ+6McdiW0j1gZjHRHLcXEopx3JHFStQiQ4jd6FlryF
         uVF1T3LEr4P5W8nqxzDeNK77TOCA3+zWEdpO//xDfHuRhQz9Q2+vB6H4dcX8GcqyyY
         Wp/RgARZI0W0EfzhWY7RRgi9IT5e3Ra3eImJ15HhjgtBnmPWFKbc1H8FhbWvsUthq8
         yMlWfIZQUgzlLbhRgXjEIzKWYZy3W64aKtInyGkOXLzBbGlJEVttAko/FMOPMa4nDH
         MkUzzd3DZDssg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org
Cc:     stefanb@linux.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] powerpc/mm: Fix missing KUAP disable in" failed to apply to 5.4-stable tree
In-Reply-To: <20200310002432.GB24841@sasha-vm>
References: <15837822939038@kroah.com> <20200310002432.GB24841@sasha-vm>
Date:   Tue, 10 Mar 2020 15:43:05 +1100
Message-ID: <878sk8keg6.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha Levin <sashal@kernel.org> writes:
> On Mon, Mar 09, 2020 at 08:31:33PM +0100, gregkh@linuxfoundation.org wrote:
>>
>>The patch below does not apply to the 5.4-stable tree.
>>If someone wants it applied there, or to any other stable or longterm
>>tree, then please email the backport, including the original git commit
>>id to <stable@vger.kernel.org>.
>>
>>thanks,
>>
>>greg k-h
>>
>>------------------ original commit in Linus's tree ------------------
>>
>>From 59bee45b9712c759ea4d3dcc4eff1752f3a66558 Mon Sep 17 00:00:00 2001
>>From: Michael Ellerman <mpe@ellerman.id.au>
>>Date: Tue, 3 Mar 2020 23:28:47 +1100
>>Subject: [PATCH] powerpc/mm: Fix missing KUAP disable in
>> flush_coherent_icache()
>>
>>Stefan reported a strange kernel fault which turned out to be due to a
>>missing KUAP disable in flush_coherent_icache() called from
>>flush_icache_range().
>>
>>The fault looks like:
>>
>>  Kernel attempted to access user page (7fffc30d9c00) - exploit attempt? (uid: 1009)
>>  BUG: Unable to handle kernel data access on read at 0x7fffc30d9c00
>>  Faulting instruction address: 0xc00000000007232c
>>  Oops: Kernel access of bad area, sig: 11 [#1]
>>  LE PAGE_SIZE=64K MMU=Radix SMP NR_CPUS=2048 NUMA PowerNV
>>  CPU: 35 PID: 5886 Comm: sigtramp Not tainted 5.6.0-rc2-gcc-8.2.0-00003-gfc37a1632d40 #79
>>  NIP:  c00000000007232c LR: c00000000003b7fc CTR: 0000000000000000
>>  REGS: c000001e11093940 TRAP: 0300   Not tainted  (5.6.0-rc2-gcc-8.2.0-00003-gfc37a1632d40)
>>  MSR:  900000000280b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 28000884  XER: 00000000
>>  CFAR: c0000000000722fc DAR: 00007fffc30d9c00 DSISR: 08000000 IRQMASK: 0
>>  GPR00: c00000000003b7fc c000001e11093bd0 c0000000023ac200 00007fffc30d9c00
>>  GPR04: 00007fffc30d9c18 0000000000000000 c000001e11093bd4 0000000000000000
>>  GPR08: 0000000000000000 0000000000000001 0000000000000000 c000001e1104ed80
>>  GPR12: 0000000000000000 c000001fff6ab380 c0000000016be2d0 4000000000000000
>>  GPR16: c000000000000000 bfffffffffffffff 0000000000000000 0000000000000000
>>  GPR20: 00007fffc30d9c00 00007fffc30d8f58 00007fffc30d9c18 00007fffc30d9c20
>>  GPR24: 00007fffc30d9c18 0000000000000000 c000001e11093d90 c000001e1104ed80
>>  GPR28: c000001e11093e90 0000000000000000 c0000000023d9d18 00007fffc30d9c00
>>  NIP flush_icache_range+0x5c/0x80
>>  LR  handle_rt_signal64+0x95c/0xc2c
>>  Call Trace:
>>    0xc000001e11093d90 (unreliable)
>>    handle_rt_signal64+0x93c/0xc2c
>>    do_notify_resume+0x310/0x430
>>    ret_from_except_lite+0x70/0x74
>>  Instruction dump:
>>  409e002c 7c0802a6 3c62ff31 3863f6a0 f8010080 48195fed 60000000 48fe4c8d
>>  60000000 e8010080 7c0803a6 7c0004ac <7c00ffac> 7c0004ac 4c00012c 38210070
>>
>>This path through handle_rt_signal64() to setup_trampoline() and
>>flush_icache_range() is only triggered by 64-bit processes that have
>>unmapped their VDSO, which is rare.
>>
>>flush_icache_range() takes a range of addresses to flush. In
>>flush_coherent_icache() we implement an optimisation for CPUs where we
>>know we don't actually have to flush the whole range, we just need to
>>do a single icbi.
>>
>>However we still execute the icbi on the user address of the start of
>>the range we're flushing. On CPUs that also implement KUAP (Power9)
>>that leads to the spurious fault above.
>>
>>We should be able to pass any address, including a kernel address, to
>>the icbi on these CPUs, which would avoid any interaction with KUAP.
>>But I don't want to make that change in a bug fix, just in case it
>>surfaces some strange behaviour on some CPU.
>>
>>So for now just disable KUAP around the icbi. Note the icbi is treated
>>as a load, so we allow read access, not write as you'd expect.
>>
>>Fixes: 890274c2dc4c ("powerpc/64s: Implement KUAP for Radix MMU")
>>Cc: stable@vger.kernel.org # v5.2+
>>Reported-by: Stefan Berger <stefanb@linux.ibm.com>
>>Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>>Link: https://lore.kernel.org/r/20200303235708.26004-1-mpe@ellerman.id.au
>
> I think I've resolved this by also taking:
>
> 23eb7f560a2a ("powerpc: Convert flush_icache_range & friends to C")
> 7a0745c5e03f ("powerpc: define helpers to get L1 icache sizes")

Yeah that's probably best.

I started looking at doing a manual backport and it's non-trivial
because the old version of flush_icache_range() was in asm and we don't
have asm wrappers for the allow_read_from_user() etc. routines.

So we'd either need to write those asm wrappers or move the
allow_read_from_user() etc. into all callers of flush_icache_range().

cheers
