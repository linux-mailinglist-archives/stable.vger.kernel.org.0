Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB9C34FDA4
	for <lists+stable@lfdr.de>; Wed, 31 Mar 2021 12:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234975AbhCaJ7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Mar 2021 05:59:46 -0400
Received: from ozlabs.org ([203.11.71.1]:45529 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234792AbhCaJ7S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Mar 2021 05:59:18 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F9MGr5TPpz9sWQ;
        Wed, 31 Mar 2021 20:59:16 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1617184757;
        bh=p3haphj09CDXdLzCL9waMMLLTSGpd53eETzf7Pujz3c=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=E1HW2jvQHKUIpNfeEsD0pCF2UnBDNvnOcHPByIEebrOXqFdoJXcpfLEJT0z9Ml8Si
         h+m5huudFzCU+jqanSEb0XEtdOPCbEjeiaGFutoGPNrm5xEa3JullVhXanp3sJ5fpW
         tl+YqHFLnA3otpgJ0ewWDhWzYkTTsbzjYMEwfFYLJDxi3SjALPR2IFVzlIV8pdmHsm
         UO6j5SJXJZE7xM2/ga+uPgcxYJIdXJmmTbxhgTDBRYyxcpjXg23fBHVXs20S0iDIUS
         fQ1LTsV1HNFOIMondRjpUJbeexX1oQv7BsC4BDifj/CC9eosK6ufxV3gHrP8vUbhE3
         1CE5X2YtFotPQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: [PATCH] powerpc/vdso: Separate vvar vma from vdso
In-Reply-To: <09e8d68d-54fe-e327-b44f-8f68543edba1@csgroup.eu>
References: <20210326191720.138155-1-dima@arista.com>
 <09e8d68d-54fe-e327-b44f-8f68543edba1@csgroup.eu>
Date:   Wed, 31 Mar 2021 20:59:16 +1100
Message-ID: <8735wby77v.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Christophe Leroy <christophe.leroy@csgroup.eu> writes:
> Le 26/03/2021 =C3=A0 20:17, Dmitry Safonov a =C3=A9crit=C2=A0:
>> Since commit 511157ab641e ("powerpc/vdso: Move vdso datapage up front")
>> VVAR page is in front of the VDSO area. In result it breaks CRIU
>> (Checkpoint Restore In Userspace) [1], where CRIU expects that "[vdso]"
>> from /proc/../maps points at ELF/vdso image, rather than at VVAR data pa=
ge.
>> Laurent made a patch to keep CRIU working (by reading aux vector).
>> But I think it still makes sence to separate two mappings into different
>> VMAs. It will also make ppc64 less "special" for userspace and as
>> a side-bonus will make VVAR page un-writable by debugger (which previous=
ly
>> would COW page and can be unexpected).
>>=20
>> I opportunistically Cc stable on it: I understand that usually such
>> stuff isn't a stable material, but that will allow us in CRIU have
>> one workaround less that is needed just for one release (v5.11) on
>> one platform (ppc64), which we otherwise have to maintain.
>> I wouldn't go as far as to say that the commit 511157ab641e is ABI
>> regression as no other userspace got broken, but I'd really appreciate
>> if it gets backported to v5.11 after v5.12 is released, so as not
>> to complicate already non-simple CRIU-vdso code. Thanks!
>>=20
>> Cc: Andrei Vagin <avagin@gmail.com>
>> Cc: Andy Lutomirski <luto@kernel.org>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
>> Cc: Laurent Dufour <ldufour@linux.ibm.com>
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: linuxppc-dev@lists.ozlabs.org
>> Cc: stable@vger.kernel.org # v5.11
>> [1]: https://github.com/checkpoint-restore/criu/issues/1417
>> Signed-off-by: Dmitry Safonov <dima@arista.com>
>> Tested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
>> ---
>>   arch/powerpc/include/asm/mmu_context.h |  2 +-
>>   arch/powerpc/kernel/vdso.c             | 54 +++++++++++++++++++-------
>>   2 files changed, 40 insertions(+), 16 deletions(-)
>>=20
>
>> @@ -133,7 +135,13 @@ static int __arch_setup_additional_pages(struct lin=
ux_binprm *bprm, int uses_int
>>   	 * install_special_mapping or the perf counter mmap tracking code
>>   	 * will fail to recognise it as a vDSO.
>>   	 */
>> -	mm->context.vdso =3D (void __user *)vdso_base + PAGE_SIZE;
>> +	mm->context.vdso =3D (void __user *)vdso_base + vvar_size;
>> +
>> +	vma =3D _install_special_mapping(mm, vdso_base, vvar_size,
>> +				       VM_READ | VM_MAYREAD | VM_IO |
>> +				       VM_DONTDUMP | VM_PFNMAP, &vvar_spec);
>> +	if (IS_ERR(vma))
>> +		return PTR_ERR(vma);
>>=20=20=20
>>   	/*
>>   	 * our vma flags don't have VM_WRITE so by default, the process isn't
>
>
> IIUC, VM_PFNMAP is for when we have a vvar_fault handler.

Some of the other flags seem odd too.
eg. VM_IO ? VM_DONTDUMP ?


cheers
