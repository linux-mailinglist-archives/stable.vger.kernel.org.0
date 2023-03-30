Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06216D0F75
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 21:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbjC3T4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 15:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbjC3T4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 15:56:09 -0400
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E679EFF19;
        Thu, 30 Mar 2023 12:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1680206164;
        bh=ccdCK8cB1yDs2Qew7hb2Qs/bMNJYZZtrVs8VhxEJ4v8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=GC8dpnFqcrogDv720XejMUUpwoNhZrhNHwZHtxeA8YFLTRkrdizktLBcyp7sIj5A/
         kEO1vhD1f0m2q8TJL+J/VZ4NcjitpLNEkWCL5OV4AMYlwe7uU1+Qj13S76ECZZ36xx
         aXwgwAMQ+O7Qyl+77CukTcWbChw7OS6vxS003VtdwEaCkC8ztqEJ4u8glCNLFzDERo
         SzjTLMvRxnPMQ3L1jLr08URNU07TrX+Vat/oTCk4e2RwuIMOTCCnTo4wH5vZ3dNXE9
         vkEvtxkqMIhRUN4outwRjTX0IhsQqBS0GX1qvOsMiiOdm2npBWrokJR6W2d5OifJHe
         ULM1EJJgyXr1Q==
Received: from [172.16.0.188] (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4PnZ103kdcztBL;
        Thu, 30 Mar 2023 15:56:04 -0400 (EDT)
Message-ID: <91a414dd-9d21-01a1-536a-fee698080f1a@efficios.com>
Date:   Thu, 30 Mar 2023 15:56:18 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/1] mm: Fix memory leak on mm_init error handling
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-mm@kvack.org, stable@vger.kernel.org
References: <20230330133822.66271-1-mathieu.desnoyers@efficios.com>
 <20230330124230.9f3d4f63374eb15a3b990ff8@linux-foundation.org>
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20230330124230.9f3d4f63374eb15a3b990ff8@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023-03-30 15:42, Andrew Morton wrote:
> On Thu, 30 Mar 2023 09:38:22 -0400 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
>> commit f1a7941243c1 ("mm: convert mm's rss stats into percpu_counter")
>> introduces a memory leak by missing a call to destroy_context() when a
>> percpu_counter fails to allocate.
>>
>> Before introducing the per-cpu counter allocations, init_new_context()
>> was the last call that could fail in mm_init(), and thus there was no
>> need to ever invoke destroy_context() in the error paths. Adding the
>> following percpu counter allocations adds error paths after
>> init_new_context(), which means its associated destroy_context() needs
>> to be called when percpu counters fail to allocate.
>>
>> ...
>>
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -1171,6 +1171,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
>>   fail_pcpu:
>>   	while (i > 0)
>>   		percpu_counter_destroy(&mm->rss_stat[--i]);
>> +	destroy_context(mm);
>>   fail_nocontext:
>>   	mm_free_pgd(mm);
>>   fail_nopgd:
> 
> Is there really a leak?  I wasn't able to find a version of
> init_new_context() which performs allocation.

AFAIU, at least on powerpc:

arch/powerpc/mm/book3s64/mmu_context.c: init_new_context() calls 
radix__init_new_context() or hash__init_new_context() which
leak IDs through ida_alloc_range.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

