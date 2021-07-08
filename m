Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439483BF93D
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 13:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhGHLou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 07:44:50 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:57227 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbhGHLot (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 07:44:49 -0400
Received: (Authenticated sender: alex@ghiti.fr)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 1B799240009;
        Thu,  8 Jul 2021 11:42:02 +0000 (UTC)
Subject: Re: [PATCH -fixes] riscv: Fix PTDUMP output now BPF region moved back
 to module region
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
        jszhang@kernel.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <mhng-fe8bcaf3-d184-4584-99f5-6ea4b9144934@palmerdabbelt-glaptop>
From:   Alex Ghiti <alex@ghiti.fr>
Message-ID: <b2922513-e542-d8c0-a29d-a8990d838479@ghiti.fr>
Date:   Thu, 8 Jul 2021 13:42:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <mhng-fe8bcaf3-d184-4584-99f5-6ea4b9144934@palmerdabbelt-glaptop>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 7/07/2021 à 01:16, Palmer Dabbelt a écrit :
> On Thu, 24 Jun 2021 05:17:21 PDT (-0700), alex@ghiti.fr wrote:
>> BPF region was moved back to the region below the kernel at the end of 
>> the
>> module region in commit 3a02764c372c ("riscv: Ensure BPF_JIT_REGION_START
>> aligned with PMD size"), so reflect this change in kernel page table
>> output.
>>
>> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
>> ---
>>  arch/riscv/mm/ptdump.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/riscv/mm/ptdump.c b/arch/riscv/mm/ptdump.c
>> index 0536ac84b730..22d6555d89dc 100644
>> --- a/arch/riscv/mm/ptdump.c
>> +++ b/arch/riscv/mm/ptdump.c
>> @@ -98,8 +98,8 @@ static struct addr_marker address_markers[] = {
>>      {0, "vmalloc() end"},
>>      {0, "Linear mapping"},
>>  #ifdef CONFIG_64BIT
>> -    {0, "Modules mapping"},
>> -    {0, "Kernel mapping (kernel, BPF)"},
>> +    {0, "Modules/BPF mapping"},
>> +    {0, "Kernel mapping"},
>>  #endif
>>      {-1, NULL},
>>  };
> 
> Thanks, this is on for-next.

As this fix was for 5.13, I add stable in cc.

Cc: stable@vger.kernel.org # v5.13

> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
