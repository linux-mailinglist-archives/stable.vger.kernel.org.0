Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86114304BEF
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725306AbhAZV55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 16:57:57 -0500
Received: from foss.arm.com ([217.140.110.172]:52150 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727140AbhAZSej (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 13:34:39 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2E0D106F;
        Tue, 26 Jan 2021 10:33:47 -0800 (PST)
Received: from [10.37.12.25] (unknown [10.37.12.25])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F2E5A3F66B;
        Tue, 26 Jan 2021 10:33:45 -0800 (PST)
Subject: Re: [PATCH] arm64: Fix kernel address detection of __is_lm_address()
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com, stable@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
References: <20210126134056.45747-1-vincenzo.frascino@arm.com>
 <20210126163638.GA3509@gaia>
From:   Vincenzo Frascino <vincenzo.frascino@arm.com>
Message-ID: <1fe8bff7-3ed2-ae96-e52b-dad59cd22539@arm.com>
Date:   Tue, 26 Jan 2021 18:37:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210126163638.GA3509@gaia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/26/21 4:36 PM, Catalin Marinas wrote:
> On Tue, Jan 26, 2021 at 01:40:56PM +0000, Vincenzo Frascino wrote:
>> Currently, the __is_lm_address() check just masks out the top 12 bits
>> of the address, but if they are 0, it still yields a true result.
>> This has as a side effect that virt_addr_valid() returns true even for
>> invalid virtual addresses (e.g. 0x0).
>>
>> Fix the detection checking that it's actually a kernel address starting
>> at PAGE_OFFSET.
>>
>> Fixes: f4693c2716b35 ("arm64: mm: extend linear region for 52-bit VA configurations")
>> Cc: <stable@vger.kernel.org> # 5.4.x
> 
> Not sure what happened with the Fixes tag but that's definitely not what
> it fixes. The above is a 5.11 commit that preserves the semantics of an
> older commit. So it should be:
> 
> Fixes: 68dd8ef32162 ("arm64: memory: Fix virt_addr_valid() using __is_lm_address()")
> 

Yes that is correct. I moved the release to which applies backword but I forgot
to update the fixes tag I suppose.

...

> 
> Anyway, no need to repost, I can update the fixes tag myself.
>

Thank you for this.

> In terms of stable backports, it may be cleaner to backport 7bc1a0f9e176
> ("arm64: mm: use single quantity to represent the PA to VA translation")
> which has a Fixes tag already but never made it to -stable. On top of
> this, we can backport Ard's latest f4693c2716b35 ("arm64: mm: extend
> linear region for 52-bit VA configurations"). I just tried these locally
> and the conflicts were fairly trivial.
> 

Ok, thank you for digging it. I will give it a try tomorrow.

-- 
Regards,
Vincenzo
