Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F125661F5
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 05:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbiGEDph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 23:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiGEDpg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 23:45:36 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4BD2BE5
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 20:45:34 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VIPwcot_1656992730;
Received: from 30.178.65.49(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0VIPwcot_1656992730)
          by smtp.aliyun-inc.com;
          Tue, 05 Jul 2022 11:45:31 +0800
Message-ID: <36b71543-fc3f-2787-06b8-2d38f1ee5b93@linux.alibaba.com>
Date:   Tue, 5 Jul 2022 11:45:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH 4.19] x86/mm/cpa: Unconditionally avoid WBINDV when we can
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Bin Yang <bin.yang@intel.com>,
        Mark Gross <mark.gross@intel.com>, stable@vger.kernel.org
References: <20220704154508.13317-1-wenyang@linux.alibaba.com>
 <YsMOWwHRUdQ/zLmx@kroah.com>
From:   Wen Yang <wenyang@linux.alibaba.com>
In-Reply-To: <YsMOWwHRUdQ/zLmx@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



在 2022/7/4 下午11:59, Greg Kroah-Hartman 写道:
> On Mon, Jul 04, 2022 at 11:45:08PM +0800, Wen Yang wrote:
>> From: Peter Zijlstra <peterz@infradead.org>
>>
>> commit ddd07b750382adc2b78fdfbec47af8a6e0d8ef37 upstream.
>>
>> CAT has happened, WBINDV is bad (even before CAT blowing away the
>> entire cache on a multi-core platform wasn't nice), try not to use it
>> ever.
>>
>> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> Reviewed-by: Dave Hansen <dave.hansen@intel.com>
>> Cc: Bin Yang <bin.yang@intel.com>
>> Cc: Mark Gross <mark.gross@intel.com>
>> Link: https://lkml.kernel.org/r/20180919085947.933674526@infradead.org
>> Cc: <stable@vger.kernel.org> # 4.19.x
>> Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
>> ---
>>   arch/x86/mm/pageattr.c | 18 ++----------------
>>   1 file changed, 2 insertions(+), 16 deletions(-)
>>
>> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
>> index 101f3ad0d6ad..ab87da7a6043 100644
>> --- a/arch/x86/mm/pageattr.c
>> +++ b/arch/x86/mm/pageattr.c
>> @@ -239,26 +239,12 @@ static void cpa_flush_array(unsigned long *start, int numpages, int cache,
>>   			    int in_flags, struct page **pages)
>>   {
>>   	unsigned int i, level;
>> -#ifdef CONFIG_PREEMPT
>> -	/*
>> -	 * Avoid wbinvd() because it causes latencies on all CPUs,
>> -	 * regardless of any CPU isolation that may be in effect.
>> -	 *
>> -	 * This should be extended for CAT enabled systems independent of
>> -	 * PREEMPT because wbinvd() does not respect the CAT partitions and
>> -	 * this is exposed to unpriviledged users through the graphics
>> -	 * subsystem.
>> -	 */
>> -	unsigned long do_wbinvd = 0;
>> -#else
>> -	unsigned long do_wbinvd = cache && numpages >= 1024; /* 4M threshold */
>> -#endif
>>   
>>   	BUG_ON(irqs_disabled() && !early_boot_irqs_disabled);
>>   
>> -	on_each_cpu(__cpa_flush_all, (void *) do_wbinvd, 1);
>> +	flush_tlb_all();
>>   
>> -	if (!cache || do_wbinvd)
>> +	if (!cache)
>>   		return;
>>   
>>   	/*
>> -- 
>> 2.19.1.6.gb485710b
>>
> 
> Why is this needed on 4.19.y?  What problem does it solve, it looks only
> like an optimization, not a bugfix.
> 
> And if it's a bugfix, why only 4.19.y, why not older kernels too?
> 
> We need more information here please.
> 

On a 128-core Intel(R) Xeon(R) Platinum 8369B CPU @ 2.90GHz server, when 
the user program frequently calls nv_alloc_system_pages to allocate 
large memory, it often causes a delay of about 200 milliseconds for the 
entire system. In this way, other latency-sensitive tasks on this system 
are heavily impacted, causing stability issues in large-scale clusters 
as well.

nv_alloc_system_pages
-> _set_memory_array
-> change_page_attr_set_clr
-> cpa_flush_array
-> on_each_cpu(__cpa_flush_all, (void *) do_wbinvd, 1);


This patch can be directly merged into the 4.19 kernel to solve this 
problem, and most of the machines in our production environment are 4.19 
kernels.

We're also happy to apply it to the 4.14 and 4.9 kernels, and send the 
corresponding patches soon, although there are very few such servers in 
our production clusters.


--
Best wishes,
Wen








