Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFE33F62B0
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhHXQb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:31:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229896AbhHXQbQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:31:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 885AF6127B;
        Tue, 24 Aug 2021 16:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629822631;
        bh=88cAadYJmUnTaRYiMI1JA+OIlkT2sO/mIm8B4EQIKrI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t5J9rz3EFd3O4+7qETnknPF7tCDfP6mTgExEy7BZfEV71Kz9xmzYL2MKhQqjOtZ00
         x8WFfBK7OXmfcNHXY1NI5CSVSALAEVbGGNOpS9dcDuHqQfBaGBNyvlCmQlXHJ8RMKG
         VhVVmA2LCWSmB9NyIq4KGtDdcEdFWzlCDrArEuPhi8pNqBwzE4OMm1d09qWT+aBMJz
         Mq5YVaGluaiUeK4ftAtzozj/yIlz2SJ09u7IZ12cC8MnjZ7f5DcnLuGNPM19y9GAJ1
         6kVtbAy034JbSrp/1JMKUKPoHxHJZp5NXfEfGdxY4rAny7W6xjsHE5mhtKKQPprU4c
         dJ1KPH00WluTg==
Date:   Tue, 24 Aug 2021 12:30:30 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Gianluca Anzolin <gianluca@sottospazio.it>,
        netfilter-devel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Request for a backport to Linux v5.4
Message-ID: <YSUepiKWvjzKXsia@sashalap>
References: <c1088b68-1804-d009-9627-d649162cdfff@sottospazio.it>
 <20210824154629.GA6610@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210824154629.GA6610@breakpoint.cc>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 24, 2021 at 05:46:29PM +0200, Florian Westphal wrote:
>Gianluca Anzolin <gianluca@sottospazio.it> wrote:
>
>[ CC stable ]
>
>> I'm writing to request a backport of the following commit:
>>
>>    2e34328b396a netfilter: nft_exthdr: fix endianness of tcp option cast
>> to the stable version of Linux v5.4.
>
>Hello stable maintainers, can you please pick this change
>for 5.4, 4.19 and 4.14?
>
>It applies cleanly to all of those branches.
>I'll leave rest as full-quote for context.
>
>> This bugfix never landed to Linux v5.4: a later similar endianness bugfix
>> (b428336676db) instead did (see commit 666d1d1a0584).
>>
>> The aforementioned commit fixes an endianness bug in the mangling of the MSS
>> tcp option for nftables.
>>
>> This bug bites hard big-endian routers (MIPS for example) running the PPPoE
>> stack and nftables.
>>
>> The following rule:
>>
>>     nft add rule ip filter forward tcp flags syn tcp option maxseg size set
>> rt mtu
>>
>> instead of changing the MSS value the one in the routing cache, ZEROES it,
>> disrupting the tcp connections.
>>
>> A backport would be nice because Linux v5.4 is the release used in the
>> upcoming stable release of OpenWRT (21.02).
>>
>> I already submitted a bug-report to OpenWRT a few weeks ago but I've got no
>> answer yet maybe because they still use iptables as the default netfilter
>> tool, even if they offer nftables as an alternative.
>>
>> Still I think this bug should be fixed in the stable versions of the kernel.
>>
>> This way it will also come to OpenWRT when they update the kernel to the
>> latest minor version, even if the maintainers don't see the my bug report is
>> ignored.
>>
>> I'd like to thank you for the attention you paid to this message even if I
>> probably didn't follow the right process for reporting the problem.

I've queued it up, thanks!

-- 
Thanks,
Sasha
