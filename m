Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBA21953B9
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 03:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbfHTBsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 21:48:01 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46609 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728615AbfHTBsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 21:48:00 -0400
Received: by mail-pf1-f196.google.com with SMTP id q139so2295749pfc.13
        for <stable@vger.kernel.org>; Mon, 19 Aug 2019 18:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=RfLs+sRfBSDgb+tBIhChiANAEUhKiMw/rtbpKhN6zaY=;
        b=xDgOvr7dIvIKX4kULkDv9+SPhMsQwKzSH0sKoqyXx/wpx5DHVoyuaCtOBzG7HwuRYp
         jh8X8OfTPK5SowqYmxTCsg/xKHv5iG8CBBSXHn+pHgPpPDEBO3xZvClGHHr9/V5Osy+E
         FUAIaGka/yjKUD9VxaCbcIDwAuVdeaZdXfPqg/23hXjLcYhNGoTDXJEioXK2eF/wdcSj
         vINbNRuNtkq3oXEXtMgq/SXF3lXNzxo/PJrxwQUVM68i62c44Ofjb2IwbBDn0ZAJb/Mk
         vBUPUOUVATwFGL18ru1BrsD/w8Fnpivid49hcQhPvzboCRhk+cL4mfmFKt39vO552iHQ
         QkCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=RfLs+sRfBSDgb+tBIhChiANAEUhKiMw/rtbpKhN6zaY=;
        b=rl4+UqK3+fM72xUI4BaAmpx7Ut+iIGAbhCSMo1cAKo+sPOUoJMMWdi8cD0a6xoBhrP
         hikB3jsYIe32xckEGIBK+e7TRbSMK+ktQ/9Ea7N5MNpHjph0IqNfMeQUN0HCHaeaNxUv
         5natPJTCD7Au1oJSdJmTRf34wNQrB7K4s470AanIpfgXAmGJunVMoF8N5JoDvfk4//fb
         UMHoyvnl8uQfA+/KpRSsRSX43WrNIutVGV2dojhXuhatnMFWFeqA1/kL/n5rS/BsXJ0q
         FAyKn+UujvfeOibgwYaFPLaumYzLIHrUU2Q9qvwr1NMjCU/gYXhCNKiXodPCPrFKdUsv
         cd8w==
X-Gm-Message-State: APjAAAWbCDgZo010bfCsEUm50UMBMhbo04TYZBzVYTHJhrIUUd+A7kyK
        v6lmgBXkc5XvMtcv8qN/Eh4wQg==
X-Google-Smtp-Source: APXvYqwVegiYT4hHAvpHnbXs+lPZw+l1k9sXk0MQ52n1ouVNqGK5erNtO31mcO6BFgTZIuKjY+o1eQ==
X-Received: by 2002:a65:4841:: with SMTP id i1mr22588419pgs.316.1566265679652;
        Mon, 19 Aug 2019 18:47:59 -0700 (PDT)
Received: from localhost ([49.205.218.65])
        by smtp.gmail.com with ESMTPSA id s20sm16948435pfe.169.2019.08.19.18.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 18:47:59 -0700 (PDT)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     Nicholas Piggin <npiggin@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Reza Arbab <arbab@linux.ibm.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Chandan Rajendra <chandan@linux.ibm.com>,
        christophe leroy <christophe.leroy@c-s.fr>,
        Mahesh Salgaonkar <mahesh@linux.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>, stable@vger.kernel.org
Subject: Re: [PATCH v10 2/7] powerpc/mce: Fix MCE handling for huge pages
In-Reply-To: <1566223931.kpuwkor3n7.astroid@bobo.none>
References: <20190815003941.18655-1-santosh@fossix.org> <20190815003941.18655-3-santosh@fossix.org> <1566223931.kpuwkor3n7.astroid@bobo.none>
Date:   Tue, 20 Aug 2019 07:17:56 +0530
Message-ID: <87ef1gppyr.fsf@santosiv.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Nick,

Nicholas Piggin <npiggin@gmail.com> writes:

> Santosh Sivaraj's on August 15, 2019 10:39 am:
>> From: Balbir Singh <bsingharora@gmail.com>
>> 
>> The current code would fail on huge pages addresses, since the shift would
>> be incorrect. Use the correct page shift value returned by
>> __find_linux_pte() to get the correct physical address. The code is more
>> generic and can handle both regular and compound pages.
>> 
>> Fixes: ba41e1e1ccb9 ("powerpc/mce: Hookup derror (load/store) UE errors")
>> Signed-off-by: Balbir Singh <bsingharora@gmail.com>
>> [arbab@linux.ibm.com: Fixup pseries_do_memory_failure()]
>> Signed-off-by: Reza Arbab <arbab@linux.ibm.com>
>> Co-developed-by: Santosh Sivaraj <santosh@fossix.org>
>> Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
>> Tested-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
>> Cc: stable@vger.kernel.org # v4.15+
>> ---
>>  arch/powerpc/include/asm/mce.h       |  2 +-
>>  arch/powerpc/kernel/mce_power.c      | 55 ++++++++++++++--------------
>>  arch/powerpc/platforms/pseries/ras.c |  9 ++---
>>  3 files changed, 32 insertions(+), 34 deletions(-)
>> 
>> diff --git a/arch/powerpc/include/asm/mce.h b/arch/powerpc/include/asm/mce.h
>> index a4c6a74ad2fb..f3a6036b6bc0 100644
>> --- a/arch/powerpc/include/asm/mce.h
>> +++ b/arch/powerpc/include/asm/mce.h
>> @@ -209,7 +209,7 @@ extern void release_mce_event(void);
>>  extern void machine_check_queue_event(void);
>>  extern void machine_check_print_event_info(struct machine_check_event *evt,
>>  					   bool user_mode, bool in_guest);
>> -unsigned long addr_to_pfn(struct pt_regs *regs, unsigned long addr);
>> +unsigned long addr_to_phys(struct pt_regs *regs, unsigned long addr);
>>  #ifdef CONFIG_PPC_BOOK3S_64
>>  void flush_and_reload_slb(void);
>>  #endif /* CONFIG_PPC_BOOK3S_64 */
>> diff --git a/arch/powerpc/kernel/mce_power.c b/arch/powerpc/kernel/mce_power.c
>> index a814d2dfb5b0..e74816f045f8 100644
>> --- a/arch/powerpc/kernel/mce_power.c
>> +++ b/arch/powerpc/kernel/mce_power.c
>> @@ -20,13 +20,14 @@
>>  #include <asm/exception-64s.h>
>>  
>>  /*
>> - * Convert an address related to an mm to a PFN. NOTE: we are in real
>> - * mode, we could potentially race with page table updates.
>> + * Convert an address related to an mm to a physical address.
>> + * NOTE: we are in real mode, we could potentially race with page table updates.
>>   */
>> -unsigned long addr_to_pfn(struct pt_regs *regs, unsigned long addr)
>> +unsigned long addr_to_phys(struct pt_regs *regs, unsigned long addr)
>>  {
>> -	pte_t *ptep;
>> -	unsigned long flags;
>> +	pte_t *ptep, pte;
>> +	unsigned int shift;
>> +	unsigned long flags, phys_addr;
>>  	struct mm_struct *mm;
>>  
>>  	if (user_mode(regs))
>> @@ -35,14 +36,21 @@ unsigned long addr_to_pfn(struct pt_regs *regs, unsigned long addr)
>>  		mm = &init_mm;
>>  
>>  	local_irq_save(flags);
>> -	if (mm == current->mm)
>> -		ptep = find_current_mm_pte(mm->pgd, addr, NULL, NULL);
>> -	else
>> -		ptep = find_init_mm_pte(addr, NULL);
>> +	ptep = __find_linux_pte(mm->pgd, addr, NULL, &shift);
>>  	local_irq_restore(flags);
>> +
>>  	if (!ptep || pte_special(*ptep))
>>  		return ULONG_MAX;
>> -	return pte_pfn(*ptep);
>> +
>> +	pte = *ptep;
>> +	if (shift > PAGE_SHIFT) {
>> +		unsigned long rpnmask = (1ul << shift) - PAGE_SIZE;
>> +
>> +		pte = __pte(pte_val(pte) | (addr & rpnmask));
>> +	}
>> +	phys_addr = pte_pfn(pte) << PAGE_SHIFT;
>> +
>> +	return phys_addr;
>>  }
>
> This should remain addr_to_pfn I think. None of the callers care what
> size page the EA was mapped with. 'pfn' is referring to the Linux pfn,
> which is the small page number.
>
>   if (shift > PAGE_SHIFT)
>     return (pte_pfn(*ptep) | ((addr & ((1UL << shift) - 1)) >> PAGE_SHIFT);
>   else
>     return pte_pfn(*ptep);
>
> Something roughly like that, then you don't have to change any callers
> or am I missing something?

Here[1] you asked to return the real address rather than pfn, which all
callers care about. So made the changes accordingly.

[1] https://www.spinics.net/lists/kernel/msg3187658.html

Thanks,
Santosh
>
> Thanks,
> Nick
