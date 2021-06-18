Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5655C3ACEEC
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 17:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235327AbhFRPa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 11:30:29 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:49705 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235749AbhFRP3i (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Jun 2021 11:29:38 -0400
Received: from localhost (mailhub3.si.c-s.fr [192.168.12.233])
        by localhost (Postfix) with ESMTP id 4G62q23V0dzBCLV;
        Fri, 18 Jun 2021 17:27:26 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id agQHzAYYeUsd; Fri, 18 Jun 2021 17:27:26 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4G62q12wtwzBCL9;
        Fri, 18 Jun 2021 17:27:25 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 5059F8B84B;
        Fri, 18 Jun 2021 17:27:25 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 9CJLhPmF_CRb; Fri, 18 Jun 2021 17:27:25 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 814148B84A;
        Fri, 18 Jun 2021 17:27:24 +0200 (CEST)
Subject: Re: [PATCH 8/8] membarrier: Rewrite sync_core_before_usermode() and
 improve documentation
To:     Andy Lutomirski <luto@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>, x86@kernel.org
Cc:     Will Deacon <will@kernel.org>, linux-mm@kvack.org,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Dave Hansen <dave.hansen@intel.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paul Mackerras <paulus@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
References: <cover.1623813516.git.luto@kernel.org>
 <07a8b963002cb955b7516e61bad19514a3acaa82.1623813516.git.luto@kernel.org>
 <1623818343.eko1v01gvr.astroid@bobo.none>
 <1e248763-9372-6e4e-5dea-cda999000aeb@kernel.org>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <d1f62354-5249-f258-1a31-d3e8aebc29d7@csgroup.eu>
Date:   Fri, 18 Jun 2021 17:27:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1e248763-9372-6e4e-5dea-cda999000aeb@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 16/06/2021 à 20:52, Andy Lutomirski a écrit :
> On 6/15/21 9:45 PM, Nicholas Piggin wrote:
>> Excerpts from Andy Lutomirski's message of June 16, 2021 1:21 pm:
>>> The old sync_core_before_usermode() comments suggested that a non-icache-syncing
>>> return-to-usermode instruction is x86-specific and that all other
>>> architectures automatically notice cross-modified code on return to
>>> userspace.
> 
>>> +/*
>>> + * XXX: can a powerpc person put an appropriate comment here?
>>> + */
>>> +static inline void membarrier_sync_core_before_usermode(void)
>>> +{
>>> +}
>>> +
>>> +#endif /* _ASM_POWERPC_SYNC_CORE_H */
>>
>> powerpc's can just go in asm/membarrier.h
> 
> $ ls arch/powerpc/include/asm/membarrier.h
> ls: cannot access 'arch/powerpc/include/asm/membarrier.h': No such file
> or directory

https://github.com/torvalds/linux/blob/master/arch/powerpc/include/asm/membarrier.h


Was added by https://github.com/torvalds/linux/commit/3ccfebedd8cf54e291c809c838d8ad5cc00f5688

> 
> 
>>
>> /*
>>   * The RFI family of instructions are context synchronising, and
>>   * that is how we return to userspace, so nothing is required here.
>>   */
> 
> Thanks!
> 
