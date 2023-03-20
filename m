Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACDA6C2261
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 21:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjCTURX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 16:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCTURW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 16:17:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62651D907;
        Mon, 20 Mar 2023 13:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=vJY8jKToHd8+Kg5E3edi1QUWHeaaaoycoz45vWtsFB4=; b=vNnQefJX4YTN2NyTDlsr84Dc+R
        EHhJLQhHUazB7469F/UWQmi346XjrebvEcH3PCbVsNvaZqCjz1gBwqoyx6zhxPdOJBOU3kCrIPZAP
        oIZ+9Yum7nwupiTbqHrGwA483ezvqqHMcP4oJGSd/g7UKbSywduars0sz2FTrePfJINJCXxQUG8qD
        A0tbVv8t2y7T8eta0NU1QBJHhbwp1JioKAmsAZ6doVJ4PHS3gxwyXLrM//iXrDv/+auD3QhZ08pnk
        LWTeaD4AE9hmcRATb83zeLu/Qyunf5weca12E+Fj1ZDuL9F8zswEdmCUgwWcPeFbOoSGaQcd8qSjz
        8Zm6bG7g==;
Received: from [2601:1c2:980:9ec0::21b4]
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1peLwV-00AOl0-0Q;
        Mon, 20 Mar 2023 20:17:19 +0000
Message-ID: <bc1afc02-967b-73b3-49a0-b8d22cb96b35@infradead.org>
Date:   Mon, 20 Mar 2023 13:17:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6/7 v4] sh: fix Kconfig entry for NUMA => SMP
Content-Language: en-US
To:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        linux-kernel@vger.kernel.org
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org,
        stable@vger.kernel.org
References: <20230306040037.20350-1-rdunlap@infradead.org>
 <20230306040037.20350-7-rdunlap@infradead.org>
 <2186c0e97e6747e71ebceade317f88a7cc016772.camel@physik.fu-berlin.de>
 <c9a748cb2ee6145a3ffe85ca55a28b990f6be68c.camel@physik.fu-berlin.de>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <c9a748cb2ee6145a3ffe85ca55a28b990f6be68c.camel@physik.fu-berlin.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/20/23 13:13, John Paul Adrian Glaubitz wrote:
> Hi Randy!
> 
> On Sun, 2023-03-19 at 21:20 +0100, John Paul Adrian Glaubitz wrote:
>> On Sun, 2023-03-05 at 20:00 -0800, Randy Dunlap wrote:
>>> Fix SUPERH builds that select SYS_SUPPORTS_NUMA but do not select
>>> SYS_SUPPORTS_SMP and SMP.
>>>
>>> kernel/sched/topology.c is only built for CONFIG_SMP and then the NUMA
>>> code + data inside topology.c is only built when CONFIG_NUMA is
>>> set/enabled, so these arch/sh/ configs need to select SMP and
>>> SYS_SUPPORTS_SMP to build the NUMA support.
>>>
>>> Fixes this build error in multiple SUPERH configs:
>>>
>>> mm/page_alloc.o: In function `get_page_from_freelist':
>>> page_alloc.c:(.text+0x2ca8): undefined reference to `node_reclaim_distance'
>>>
>>> Fixes: 357d59469c11 ("sh: Tidy up dependencies for SH-2 build.")
>>> Fixes: 9109a30e5a54 ("sh: add support for sh7366 processor")
>>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>>> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
>>> Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
>>> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
>>> Cc: Rich Felker <dalias@libc.org>
>>> Cc: linux-sh@vger.kernel.org
>>> Cc: stable@vger.kernel.org
>>> ---
>>> v2: skipped
>>> v3: skipped
>>> v4: refresh & resend
>>>
>>>  arch/sh/Kconfig |    4 ++++
>>>  1 file changed, 4 insertions(+)
>>>
>>> diff -- a/arch/sh/Kconfig b/arch/sh/Kconfig
>>> --- a/arch/sh/Kconfig
>>> +++ b/arch/sh/Kconfig
>>> @@ -477,6 +477,8 @@ config CPU_SUBTYPE_SH7722
>>>  	select CPU_SHX2
>>>  	select ARCH_SHMOBILE
>>>  	select ARCH_SPARSEMEM_ENABLE
>>> +	select SYS_SUPPORTS_SMP
>>> +	select SMP
>>>  	select SYS_SUPPORTS_NUMA
>>>  	select SYS_SUPPORTS_SH_CMT
>>>  	select PINCTRL
>>> @@ -487,6 +489,8 @@ config CPU_SUBTYPE_SH7366
>>>  	select CPU_SHX2
>>>  	select ARCH_SHMOBILE
>>>  	select ARCH_SPARSEMEM_ENABLE
>>> +	select SYS_SUPPORTS_SMP
>>> +	select SMP
>>>  	select SYS_SUPPORTS_NUMA
>>>  	select SYS_SUPPORTS_SH_CMT
>>>  
>>
>> It seems that we need this change for these configurations as well:
>>
>> - config CPU_SHX3
>> - config CPU_SUBTYPE_SH7785
>>
>> Although I can trigger a build failure for CPU_SUBTYPE_SH7785 only when
>> setting CONFIG_NUMA=y:
>>
>>   CC      net/ipv6/addrconf_core.o
>> mm/slab.c: In function 'slab_memory_callback':
>> mm/slab.c:1127:23: error: implicit declaration of function 'init_cache_node_node'; did you mean 'drain_cache_node_node'? [-Werror=implicit-function-declaration]
>>  1127 |                 ret = init_cache_node_node(nid);
>>       |                       ^~~~~~~~~~~~~~~~~~~~
>>       |                       drain_cache_node_node
>>
>> I would expect this error to be reproducible for CPU_SHX3 as well when
>> CONFIG_NUMA=y but CONFIG_SMP=n. But for some reason, I am not seeing
>> the error then.
> 
> Can you make this change for config CPU_SUBTYPE_SH7785 as well?
> 
> Then the change should be fine.

Will do. Thanks.

-- 
~Randy
