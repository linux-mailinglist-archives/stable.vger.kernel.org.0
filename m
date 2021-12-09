Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE7646E24D
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 07:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbhLIGM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 01:12:26 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:35947 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbhLIGM0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 01:12:26 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4J8kBC4GVSz4xgY;
        Thu,  9 Dec 2021 17:08:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1639030132;
        bh=D8SbP/O7wam578TW1HYdDVA3VPmkytsHTRymA1Ss3gg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Tg5lQFWCAqaidtyGRXagjacrGIp7N/xOSDR014fQubYxl+gIoM6VXXAGTbya+TjNV
         9mgppM94THhjuhSGsiiW5ivjTxJDSbH/Szd1i/C+HdojrMq4lLmBUcLXtLKfC96KEr
         WPlNPR3Qx6QmSvmLX0tj/+M2TxDRqlPNmWKQJXxWuFSq57ibcioymYSU+yvoXZsm0t
         HMOshmqKY4hs3W2FiN9lrJGN5rbBg7bY7OEy/G+BUbIy55WIFvQrxRuUZ3T+EX7sA3
         oFqXc24SoL3INzYBX1D3oXPFvNND/yarp82mu0pVfKSOM5aUy4qgVSXVdzccRYbt0d
         1eczW8i3M6+nA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "mbizon@freebox.fr" <mbizon@freebox.fr>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] powerpc/603: Fix boot failure with DEBUG_PAGEALLOC and
 KFENCE
In-Reply-To: <191754d3-e13d-6fe2-db4b-99d78cbf2a2e@csgroup.eu>
References: <aea33b4813a26bdb9378b5f273f00bd5d4abe240.1638857364.git.christophe.leroy@csgroup.eu>
 <12988dafdf7e14ba6db69ab483a2eb53e411fc0d.camel@freebox.fr>
 <191754d3-e13d-6fe2-db4b-99d78cbf2a2e@csgroup.eu>
Date:   Thu, 09 Dec 2021 17:08:48 +1100
Message-ID: <8735n2nwcv.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Christophe Leroy <christophe.leroy@csgroup.eu> writes:
> Le 07/12/2021 =C3=A0 11:34, Maxime Bizon a =C3=A9crit=C2=A0:
>>=20
>> On Tue, 2021-12-07 at 06:10 +0000, Christophe Leroy wrote:
>>=20
>> Hello,
>>=20
>> With the patch applied and
>>=20
>> CONFIG_DEBUG_PAGEALLOC=3Dy
>> CONFIG_DEBUG_PAGEALLOC_ENABLE_DEFAULT=3Dy
>> CONFIG_DEBUG_VM=3Dy
>>=20
>> I get tons of this during boot:
>>=20
>> [    0.000000] Dentry cache hash table entries: 262144 (order: 8, 104857=
6 bytes, linear)
>> [    0.000000] Inode-cache hash table entries: 131072 (order: 7, 524288 =
bytes, linear)
>> [    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
>> [    0.000000] ------------[ cut here ]------------
>> [    0.000000] WARNING: CPU: 0 PID: 0 at arch/powerpc/mm/pgtable.c:194 s=
et_pte_at+0x18/0x160
>> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 5.15.0+ #442
>> [    0.000000] NIP:  80015ebc LR: 80016728 CTR: 800166e4
>> [    0.000000] REGS: 80751dd0 TRAP: 0700   Not tainted  (5.15.0+)
>> [    0.000000] MSR:  00021032 <ME,IR,DR,RI>  CR: 42228882  XER: 20000000
>> [    0.000000]
>> [    0.000000] GPR00: 800b8dc8 80751e80 806c6300 807311d8 807a1000 8ffff=
e84 80751ea8 00000000
>> [    0.000000] GPR08: 007a1591 00000001 007a1180 00000000 42224882 00000=
000 3ff9c608 3fffd79c
>> [    0.000000] GPR16: 00000000 00000000 00000000 00000000 00000000 00000=
000 800166e4 807a2000
>> [    0.000000] GPR24: 807a1fff 807311d8 807311d8 807a2000 80768804 00000=
000 807a1000 007a1180
>> [    0.000000] NIP [80015ebc] set_pte_at+0x18/0x160
>> [    0.000000] LR [80016728] set_page_attr+0x44/0xc0
>> [    0.000000] Call Trace:
>> [    0.000000] [80751e80] [80058570] console_unlock+0x340/0x428 (unrelia=
ble)
>> [    0.000000] [80751ea0] [00000000] 0x0
>> [    0.000000] [80751ec0] [800b8dc8] __apply_to_page_range+0x144/0x2a8
>> [    0.000000] [80751f00] [80016918] __kernel_map_pages+0x54/0x64
>> [    0.000000] [80751f10] [800cfeb0] __free_pages_ok+0x1b0/0x440
>> [    0.000000] [80751f50] [805cfc8c] memblock_free_all+0x1d8/0x274
>> [    0.000000] [80751f90] [805c5e0c] mem_init+0x3c/0xd0
>> [    0.000000] [80751fb0] [805c0bdc] start_kernel+0x404/0x5c4
>> [    0.000000] [80751ff0] [000033f0] 0x33f0
>> [    0.000000] Instruction dump:
>> [    0.000000] 7c630034 83e1000c 5463d97e 7c0803a6 38210010 4e800020 942=
1ffe0 93e1001c
>> [    0.000000] 83e60000 81250000 71290001 41820014 <0fe00000> 7c0802a6 9=
3c10018 90010024
>>=20
>>=20
>
> That's unrelated to this patch.
>
> The problem is linked to patch c988cfd38e48 ("powerpc/32: use=20
> set_memory_attr()"), which changed from using __set_pte_at() to using=20
> set_memory_attr() which uses set_pte_at().
>
> set_pte_at() has additional checks and shall not be used to updating an=20
> existing PTE.
>
> Wondering if I should just use __set_pte_at() instead like in the past,=20
> or do like commit 9f7853d7609d ("powerpc/mm: Fix set_memory_*() against=20
> concurrent accesses") and use pte_update()
>
> Michael, Aneesh, any suggestion ?

The motivation for using pte_update() in that commit is that it does the
update atomically and also handles flushing the HPTE for 64-bit Hash.

But the books/32 version of pte_update() doesn't do that. In fact
there's some HPTE handling in __set_pte_at(), but then also a comment
saying it's handling in a subsequent flush_tlb_xxx().

So that doesn't really help make a decision :)

On the other hand, could you convert those set_memory_attr() calls to
change_memory_attr() and then eventually drop the former?

cheers
