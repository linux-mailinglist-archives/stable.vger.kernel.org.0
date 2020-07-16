Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D5E221D90
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 09:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgGPHqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 03:46:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:35558 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbgGPHqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jul 2020 03:46:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 62992ABF4;
        Thu, 16 Jul 2020 07:46:02 +0000 (UTC)
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
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <6f18d999-4518-31ce-4cea-9b5b89a577ad@suse.cz>
Date:   Thu, 16 Jul 2020 09:45:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAmzW4NbG0fCtU2mV83pRamUeOEqKKxGTpQK2zuDxzmoF2FVrg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/16/20 9:27 AM, Joonsoo Kim wrote:
> 2020년 7월 15일 (수) 오후 5:24, Vlastimil Babka <vbabka@suse.cz>님이 작성:
>> >  /*
>> >   * get_page_from_freelist goes through the zonelist trying to allocate
>> >   * a page.
>> > @@ -3706,6 +3714,8 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>> >       struct pglist_data *last_pgdat_dirty_limit = NULL;
>> >       bool no_fallback;
>> >
>> > +     current_alloc_flags(gfp_mask, &alloc_flags);
>>
>> I don't see why to move the test here? It will still be executed in the
>> fastpath, if that's what you wanted to avoid.
> 
> I want to execute it on the fastpath, too. Reason that I moved it here
> is that alloc_flags could be reset on slowpath. See the code where
> __gfp_pfmemalloc_flags() is on. This is the only place that I can apply
> this option to all the allocation paths at once.

But get_page_from_freelist() might be called multiple times in the slowpath, and
also anyone looking for gfp and alloc flags setup will likely not examine this
function. I don't see a problem in having it in two places that already deal
with alloc_flags setup, as it is now.

> Thanks.
> 
>> > +
>> >  retry:
>> >       /*
>> >        * Scan zonelist, looking for a zone with enough free.
>> > @@ -4339,10 +4349,6 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
>> >       } else if (unlikely(rt_task(current)) && !in_interrupt())
>> >               alloc_flags |= ALLOC_HARDER;
>> >
>> > -#ifdef CONFIG_CMA
>> > -     if (gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
>> > -             alloc_flags |= ALLOC_CMA;
>> > -#endif
>>
>> I would just replace this here with:
>> alloc_flags = current_alloc_flags(gfp_mask, alloc_flags);
>>
>> >       return alloc_flags;
>> >  }
>> >
>> > @@ -4808,9 +4814,6 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
>> >       if (should_fail_alloc_page(gfp_mask, order))
>> >               return false;
>> >
>> > -     if (IS_ENABLED(CONFIG_CMA) && ac->migratetype == MIGRATE_MOVABLE)
>> > -             *alloc_flags |= ALLOC_CMA;
>>
>> And same here... Ah, I see. current_alloc_flags() should probably take a
>> migratetype parameter instead of gfp_mask then.
>>
>> > -
>> >       return true;
>> >  }
>> >
>> >
>>
> 

