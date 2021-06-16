Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668CE3AA397
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 20:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhFPSzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 14:55:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232006AbhFPSzF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 14:55:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E38DA613B4;
        Wed, 16 Jun 2021 18:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623869579;
        bh=Yqry3gXTN7L5llHGJ5LYioszkeOqgnImNugNlvlJamM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ZdUJ7KXNhkuKNAUX1x7Dbc4PeUFd1RBBDmKso0XmPrKjdsmddGAwUrigYr/JM82Wg
         QZYY1HboE2uqd3aDHbef4mKiID3gsuvm5EVze2dABZvbyZheNWkpSQusDL9vvTKeTZ
         llgpyzsvBgZGHBlVCUTvm9DEzi6Hvbi5dJZInB6zEXy5rjMxcXqZdGesyqHMQpTlGH
         9vnvX5X6f8YAkbV0xff+6rjr3kuqkpugsrxF/ZBh7JF/BjFyZohG2TevhZq78dCe75
         ZbfCX4ngCfJiMjfS5mqXkORZczgWyrHbvJC4IDDJol6JXrj9FBaLWKtCUNktRtFrtB
         Ewqj3p90Zv/OQ==
Subject: Re: [PATCH 8/8] membarrier: Rewrite sync_core_before_usermode() and
 improve documentation
To:     Nicholas Piggin <npiggin@gmail.com>, x86@kernel.org
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Hansen <dave.hansen@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
        Will Deacon <will@kernel.org>
References: <cover.1623813516.git.luto@kernel.org>
 <07a8b963002cb955b7516e61bad19514a3acaa82.1623813516.git.luto@kernel.org>
 <1623818343.eko1v01gvr.astroid@bobo.none>
From:   Andy Lutomirski <luto@kernel.org>
Message-ID: <1e248763-9372-6e4e-5dea-cda999000aeb@kernel.org>
Date:   Wed, 16 Jun 2021 11:52:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1623818343.eko1v01gvr.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/15/21 9:45 PM, Nicholas Piggin wrote:
> Excerpts from Andy Lutomirski's message of June 16, 2021 1:21 pm:
>> The old sync_core_before_usermode() comments suggested that a non-icache-syncing
>> return-to-usermode instruction is x86-specific and that all other
>> architectures automatically notice cross-modified code on return to
>> userspace.

>> +/*
>> + * XXX: can a powerpc person put an appropriate comment here?
>> + */
>> +static inline void membarrier_sync_core_before_usermode(void)
>> +{
>> +}
>> +
>> +#endif /* _ASM_POWERPC_SYNC_CORE_H */
> 
> powerpc's can just go in asm/membarrier.h

$ ls arch/powerpc/include/asm/membarrier.h
ls: cannot access 'arch/powerpc/include/asm/membarrier.h': No such file
or directory


> 
> /*
>  * The RFI family of instructions are context synchronising, and
>  * that is how we return to userspace, so nothing is required here.
>  */

Thanks!
