Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17DA822369F
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 10:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgGQIKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 04:10:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:51884 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726113AbgGQIKI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jul 2020 04:10:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 238E9AFF1;
        Fri, 17 Jul 2020 08:10:11 +0000 (UTC)
Subject: Re: [PATCH 1/4] mm/page_alloc: fix non cma alloc context
To:     Joonsoo Kim <js1304@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel-team@lge.com,
        Christoph Hellwig <hch@infradead.org>,
        Roman Gushchin <guro@fb.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@suse.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, stable@vger.kernel.org
References: <1594789529-6206-1-git-send-email-iamjoonsoo.kim@lge.com>
 <332d620b-bfe3-3b69-931b-77e3a74edbfd@suse.cz>
 <CAAmzW4NbG0fCtU2mV83pRamUeOEqKKxGTpQK2zuDxzmoF2FVrg@mail.gmail.com>
 <6f18d999-4518-31ce-4cea-9b5b89a577ad@suse.cz>
 <CAAmzW4MLc8bmkYW1q1fL_WRFQHksX-oy9tS-s9Kb-A=ZEeGETQ@mail.gmail.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <5a8b13d5-da40-7b1b-2968-e6701001cc0e@suse.cz>
Date:   Fri, 17 Jul 2020 10:10:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAmzW4MLc8bmkYW1q1fL_WRFQHksX-oy9tS-s9Kb-A=ZEeGETQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/17/20 9:29 AM, Joonsoo Kim wrote:
> 2020년 7월 16일 (목) 오후 4:45, Vlastimil Babka <vbabka@suse.cz>님이 작성:
>>
>> On 7/16/20 9:27 AM, Joonsoo Kim wrote:
>> > 2020년 7월 15일 (수) 오후 5:24, Vlastimil Babka <vbabka@suse.cz>님이 작성:
>> >> >  /*
>> >> >   * get_page_from_freelist goes through the zonelist trying to allocate
>> >> >   * a page.
>> >> > @@ -3706,6 +3714,8 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>> >> >       struct pglist_data *last_pgdat_dirty_limit = NULL;
>> >> >       bool no_fallback;
>> >> >
>> >> > +     current_alloc_flags(gfp_mask, &alloc_flags);
>> >>
>> >> I don't see why to move the test here? It will still be executed in the
>> >> fastpath, if that's what you wanted to avoid.
>> >
>> > I want to execute it on the fastpath, too. Reason that I moved it here
>> > is that alloc_flags could be reset on slowpath. See the code where
>> > __gfp_pfmemalloc_flags() is on. This is the only place that I can apply
>> > this option to all the allocation paths at once.
>>
>> But get_page_from_freelist() might be called multiple times in the slowpath, and
>> also anyone looking for gfp and alloc flags setup will likely not examine this
>> function. I don't see a problem in having it in two places that already deal
>> with alloc_flags setup, as it is now.
> 
> I agree that anyone looking alloc flags will miss that function easily. Okay.
> I will place it on its original place, although we now need to add one
> more place.
> *Three places* are gfp_to_alloc_flags(), prepare_alloc_pages() and
> __gfp_pfmemalloc_flags().

Hm the check below should also work for ALLOC_OOM|ALLOC_NOCMA then.

/* Avoid allocations with no watermarks from looping endlessly */
   if (tsk_is_oom_victim(current) &&
        (alloc_flags == ALLOC_OOM ||
         (gfp_mask & __GFP_NOMEMALLOC)))
            goto nopage;

Maybe it's simpler to change get_page_from_freelist() then. But document well.

> Thanks.
> 

