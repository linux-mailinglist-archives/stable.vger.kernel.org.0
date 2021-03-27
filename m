Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C45234B871
	for <lists+stable@lfdr.de>; Sat, 27 Mar 2021 18:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhC0RUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Mar 2021 13:20:25 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:41635 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230296AbhC0RUI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 27 Mar 2021 13:20:08 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4F75FL0fb4z9ty5P;
        Sat, 27 Mar 2021 18:20:06 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id X-4yeutIqUOF; Sat, 27 Mar 2021 18:20:06 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4F75FK6plhz9ty5N;
        Sat, 27 Mar 2021 18:20:05 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 0E59F8B777;
        Sat, 27 Mar 2021 18:20:06 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id BhNcRVEsIzab; Sat, 27 Mar 2021 18:20:05 +0100 (CET)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 484DD8B771;
        Sat, 27 Mar 2021 18:20:05 +0100 (CET)
Subject: Re: [PATCH] powerpc/vdso: Separate vvar vma from vdso
To:     Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org,
        Laurent Dufour <ldufour@linux.ibm.com>
References: <20210326191720.138155-1-dima@arista.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <52562f46-6767-ba04-7301-04c6209fe4f1@csgroup.eu>
Date:   Sat, 27 Mar 2021 18:19:37 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210326191720.138155-1-dima@arista.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 26/03/2021 à 20:17, Dmitry Safonov a écrit :
> Since commit 511157ab641e ("powerpc/vdso: Move vdso datapage up front")
> VVAR page is in front of the VDSO area. In result it breaks CRIU
> (Checkpoint Restore In Userspace) [1], where CRIU expects that "[vdso]"
> from /proc/../maps points at ELF/vdso image, rather than at VVAR data page.
> Laurent made a patch to keep CRIU working (by reading aux vector).
> But I think it still makes sence to separate two mappings into different
> VMAs. It will also make ppc64 less "special" for userspace and as
> a side-bonus will make VVAR page un-writable by debugger (which previously
> would COW page and can be unexpected).
> 
> I opportunistically Cc stable on it: I understand that usually such
> stuff isn't a stable material, but that will allow us in CRIU have
> one workaround less that is needed just for one release (v5.11) on
> one platform (ppc64), which we otherwise have to maintain.

Why is that a workaround, and why for one release only ? I think the solution proposed by Laurentto 
use the aux vector AT_SYSINFO_EHDR should work with any past and future release.

> I wouldn't go as far as to say that the commit 511157ab641e is ABI
> regression as no other userspace got broken, but I'd really appreciate
> if it gets backported to v5.11 after v5.12 is released, so as not
> to complicate already non-simple CRIU-vdso code. Thanks!
> 
> Cc: Andrei Vagin <avagin@gmail.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Laurent Dufour <ldufour@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: stable@vger.kernel.org # v5.11
> [1]: https://github.com/checkpoint-restore/criu/issues/1417
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> Tested-by: Christophe Leroy <christophe.leroy@csgroup.eu>

I tested it with sifreturn_vdso selftest and it worked, because that selftest doesn't involve VDSO data.

But if I do a mremap() on the VDSO text vma without remapping VVAR to keep the same distance between 
the two vmas, gettimeofday() crashes. The reason is that the code obtains the address of the data by 
calculating a fix difference from its own address with the below macro, the delta being resolved at 
link time:

.macro get_datapage ptr
	bcl	20, 31, .+4
999:
	mflr	\ptr
#if CONFIG_PPC_PAGE_SHIFT > 14
	addis	\ptr, \ptr, (_vdso_datapage - 999b)@ha
#endif
	addi	\ptr, \ptr, (_vdso_datapage - 999b)@l
.endm

So the datapage needs to remain at the same distance from the code at all time.

Wondering how the other architectures do to have two independant VMAs and be able to move one 
independantly of the other.

Christophe
