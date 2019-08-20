Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF6F954C2
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 05:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbfHTDE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 23:04:28 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38797 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728719AbfHTDE1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 23:04:27 -0400
Received: by mail-pl1-f193.google.com with SMTP id m12so1964253plt.5;
        Mon, 19 Aug 2019 20:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :user-agent:message-id:content-transfer-encoding;
        bh=5DCEuK+1vbR1GiKVHEUvjv6cUUnrYia947cf4DJEdNk=;
        b=Pxhgx1qhn8Pkav9ExU92pqR+Optprmxz+MRtGw2MwXRWVUALsKTVrGOJgRsPTa2P7H
         oUfU79y0eddjMs//c8VMgwEThxHVRiDEuL4xIWu2OnPGNmbh5Zjz2k4O1f2h1yXzlLWl
         COBaTHEHGfy2rpghEGkYcgLz2YP5n4CLCiDDlNufwHr5whWe/5368RURAaXOHKPQJk7u
         xE3PD2b1wJXEaSQXXhZm8T6Y9DkTTfp8oXaU+TJALhmfUBGhLC9yCBcMfGilp67BGwAB
         fz+zVr27fSkHdHtzBQ8zPGVXDSr7DuiHbLZAG66nQy5P7rJfMfcmgADrBhQqlTCe3J36
         3ztQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:user-agent:message-id:content-transfer-encoding;
        bh=5DCEuK+1vbR1GiKVHEUvjv6cUUnrYia947cf4DJEdNk=;
        b=fH32kIH0bq6tj86tSWPPu4nAa5rXgY0tXEKb+Yi1U1AUKqV7E3LLqJGxMlusSpuD1E
         lLZd8YfU0TtiTFxnSCgfwzN/y0VVlhRsJPV/VoS0J5H8eeNjVCNfUMnjDkIIDGqXuEo+
         0lODUYcT/0JvL+5ABZXXvhNYixtbULAqVaKfozoEkfkDKzFPvkAqLwDm4GTivuKlolzH
         dBAlTe50nKOupyGldakzmS6HcBHWEMyPc/WIzXGBtxVtEmdjIQVY2ZJXspt1RfagS//1
         s1Fl1Q8/aPNYKqg1Ryexbx8pmOLh+6uDauZskm87i0KibeawaKPhzTp0Sj1YOiX8VXPF
         lnBQ==
X-Gm-Message-State: APjAAAXJ1KFdFDYJA+xkHhrAxzy2FORTVK7HhIWmKYIlOdiaGxe660qv
        D06cUf8Jt1XzBBYQHnXELN6t85rH
X-Google-Smtp-Source: APXvYqzcrRI1jj4TBVQ/g5QjFSA1AoznIRz/+8wJyP2IW+lRKb60+MpmtXcs0fV6EGMkyF9EP5Zl2A==
X-Received: by 2002:a17:902:4d45:: with SMTP id o5mr22408906plh.146.1566270266734;
        Mon, 19 Aug 2019 20:04:26 -0700 (PDT)
Received: from localhost ([193.114.104.176])
        by smtp.gmail.com with ESMTPSA id s16sm18532451pfs.6.2019.08.19.20.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 20:04:26 -0700 (PDT)
Date:   Tue, 20 Aug 2019 13:04:19 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v10 2/7] powerpc/mce: Fix MCE handling for huge pages
To:     Linux Kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Santosh Sivaraj <santosh@fossix.org>
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Reza Arbab <arbab@linux.ibm.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Chandan Rajendra <chandan@linux.ibm.com>,
        christophe leroy <christophe.leroy@c-s.fr>,
        Mahesh Salgaonkar <mahesh@linux.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>, stable@vger.kernel.org
References: <20190815003941.18655-1-santosh@fossix.org>
        <20190815003941.18655-3-santosh@fossix.org>
        <1566223931.kpuwkor3n7.astroid@bobo.none>
        <87ef1gppyr.fsf@santosiv.in.ibm.com>
In-Reply-To: <87ef1gppyr.fsf@santosiv.in.ibm.com>
MIME-Version: 1.0
User-Agent: astroid/0.15.0 (https://github.com/astroidmail/astroid)
Message-Id: <1566269915.1518r8e03n.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Santosh Sivaraj's on August 20, 2019 11:47 am:
> Hi Nick,
>=20
> Nicholas Piggin <npiggin@gmail.com> writes:
>=20
>> Santosh Sivaraj's on August 15, 2019 10:39 am:
>>> From: Balbir Singh <bsingharora@gmail.com>
>>>=20
>>> The current code would fail on huge pages addresses, since the shift wo=
uld
>>> be incorrect. Use the correct page shift value returned by
>>> __find_linux_pte() to get the correct physical address. The code is mor=
e
>>> generic and can handle both regular and compound pages.
>>>=20
>>> Fixes: ba41e1e1ccb9 ("powerpc/mce: Hookup derror (load/store) UE errors=
")
>>> Signed-off-by: Balbir Singh <bsingharora@gmail.com>
>>> [arbab@linux.ibm.com: Fixup pseries_do_memory_failure()]
>>> Signed-off-by: Reza Arbab <arbab@linux.ibm.com>
>>> Co-developed-by: Santosh Sivaraj <santosh@fossix.org>
>>> Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
>>> Tested-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
>>> Cc: stable@vger.kernel.org # v4.15+
>>> ---
>>>  arch/powerpc/include/asm/mce.h       |  2 +-
>>>  arch/powerpc/kernel/mce_power.c      | 55 ++++++++++++++--------------
>>>  arch/powerpc/platforms/pseries/ras.c |  9 ++---
>>>  3 files changed, 32 insertions(+), 34 deletions(-)
>>>=20
>>> diff --git a/arch/powerpc/include/asm/mce.h b/arch/powerpc/include/asm/=
mce.h
>>> index a4c6a74ad2fb..f3a6036b6bc0 100644
>>> --- a/arch/powerpc/include/asm/mce.h
>>> +++ b/arch/powerpc/include/asm/mce.h
>>> @@ -209,7 +209,7 @@ extern void release_mce_event(void);
>>>  extern void machine_check_queue_event(void);
>>>  extern void machine_check_print_event_info(struct machine_check_event =
*evt,
>>>  					   bool user_mode, bool in_guest);
>>> -unsigned long addr_to_pfn(struct pt_regs *regs, unsigned long addr);
>>> +unsigned long addr_to_phys(struct pt_regs *regs, unsigned long addr);
>>>  #ifdef CONFIG_PPC_BOOK3S_64
>>>  void flush_and_reload_slb(void);
>>>  #endif /* CONFIG_PPC_BOOK3S_64 */
>>> diff --git a/arch/powerpc/kernel/mce_power.c b/arch/powerpc/kernel/mce_=
power.c
>>> index a814d2dfb5b0..e74816f045f8 100644
>>> --- a/arch/powerpc/kernel/mce_power.c
>>> +++ b/arch/powerpc/kernel/mce_power.c
>>> @@ -20,13 +20,14 @@
>>>  #include <asm/exception-64s.h>
>>> =20
>>>  /*
>>> - * Convert an address related to an mm to a PFN. NOTE: we are in real
>>> - * mode, we could potentially race with page table updates.
>>> + * Convert an address related to an mm to a physical address.
>>> + * NOTE: we are in real mode, we could potentially race with page tabl=
e updates.
>>>   */
>>> -unsigned long addr_to_pfn(struct pt_regs *regs, unsigned long addr)
>>> +unsigned long addr_to_phys(struct pt_regs *regs, unsigned long addr)
>>>  {
>>> -	pte_t *ptep;
>>> -	unsigned long flags;
>>> +	pte_t *ptep, pte;
>>> +	unsigned int shift;
>>> +	unsigned long flags, phys_addr;
>>>  	struct mm_struct *mm;
>>> =20
>>>  	if (user_mode(regs))
>>> @@ -35,14 +36,21 @@ unsigned long addr_to_pfn(struct pt_regs *regs, uns=
igned long addr)
>>>  		mm =3D &init_mm;
>>> =20
>>>  	local_irq_save(flags);
>>> -	if (mm =3D=3D current->mm)
>>> -		ptep =3D find_current_mm_pte(mm->pgd, addr, NULL, NULL);
>>> -	else
>>> -		ptep =3D find_init_mm_pte(addr, NULL);
>>> +	ptep =3D __find_linux_pte(mm->pgd, addr, NULL, &shift);
>>>  	local_irq_restore(flags);
>>> +
>>>  	if (!ptep || pte_special(*ptep))
>>>  		return ULONG_MAX;
>>> -	return pte_pfn(*ptep);
>>> +
>>> +	pte =3D *ptep;
>>> +	if (shift > PAGE_SHIFT) {
>>> +		unsigned long rpnmask =3D (1ul << shift) - PAGE_SIZE;
>>> +
>>> +		pte =3D __pte(pte_val(pte) | (addr & rpnmask));
>>> +	}
>>> +	phys_addr =3D pte_pfn(pte) << PAGE_SHIFT;
>>> +
>>> +	return phys_addr;
>>>  }
>>
>> This should remain addr_to_pfn I think. None of the callers care what
>> size page the EA was mapped with. 'pfn' is referring to the Linux pfn,
>> which is the small page number.
>>
>>   if (shift > PAGE_SHIFT)
>>     return (pte_pfn(*ptep) | ((addr & ((1UL << shift) - 1)) >> PAGE_SHIF=
T);
>>   else
>>     return pte_pfn(*ptep);
>>
>> Something roughly like that, then you don't have to change any callers
>> or am I missing something?
>=20
> Here[1] you asked to return the real address rather than pfn, which all
> callers care about. So made the changes accordingly.
>=20
> [1] https://www.spinics.net/lists/kernel/msg3187658.html

Ah I did suggest it, but I meant _exact_ physical address :) The one
matching the effective address you gave it.

As it is now, the physical address is truncated at the small page size,
so if you do that you might as well just keep it as a pfn and no change
to callers.

I would also prefer getting the pfn as above rather than constructing a
new pte, which is a neat hack but is not a normal pattern.

Thanks,
Nick
=
