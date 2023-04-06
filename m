Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8DD6D9F2F
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 19:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240062AbjDFRur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 13:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239535AbjDFRuq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 13:50:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F014C16
        for <stable@vger.kernel.org>; Thu,  6 Apr 2023 10:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680803405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J+gH6uw8oA2NExpsXjcHJ57Iz7fOEmYQlyHrV2brvqc=;
        b=REEpvoH4J5eSwHOeFtb8H4Qixa99k3qxmSihZbgn1kb3bv7oD3gJiasStDgm/xzqzluWMF
        0jMJw7D7xhsmBFyaFgCzvsnjkKENn3e9v+Unsc1no0OPR8lrkqraMLX9muRyKpsKezyp7f
        hjW7WRlrxL/pZtyQ9J/Mji/Y1p9tRGE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-8FgcOZboPc-1G0s19ZzwPg-1; Thu, 06 Apr 2023 13:50:03 -0400
X-MC-Unique: 8FgcOZboPc-1G0s19ZzwPg-1
Received: by mail-wm1-f71.google.com with SMTP id d11-20020a05600c34cb00b003ee89ce8cc3so18562076wmq.7
        for <stable@vger.kernel.org>; Thu, 06 Apr 2023 10:50:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680803402; x=1683395402;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J+gH6uw8oA2NExpsXjcHJ57Iz7fOEmYQlyHrV2brvqc=;
        b=zmQuQebhif/cNe70d2Do4fnzhoWEXqwlQ0mPEB6ppA/7UInF5kdvUlIKWYSFTcB7PG
         fB1j7tkgu/ED8XufsRmXvN+6lrqgesUGRuBaLwOKGC9KDWXBOUZv2xuUuFBgHLNJIa1e
         kJA+IXlAvH0tEhromv0sXshCTEHic1+2D6IKYrDgtSEy2rPQaG6HhoS/Qrlz7ZL8gGZt
         DCP/y0xpahd35S1d/0NW7Midsq4aMaccbi1swNVeOVGZUKmQJRb62+q6hngKVeaXJrv9
         lztKV1elhCsa/azdTUCNj5RlJnX/MqtO/LSVZPVzmk5ZmuMdoZB4pcumt1rZFw8bsrSQ
         tbCQ==
X-Gm-Message-State: AAQBX9cEOEzMV2/nPOweUKNHP1C4hPnIO6JN9R9HADoiWiUF+xJXe+VH
        0R+gIPZLUrDeKrw/8qyw4yjJFUmB4L0h1HYoISAqK0lR0p23j2NquN0Gu++7DIuH7RWqTpWbJij
        f6keoQWJeb5BN21uz
X-Received: by 2002:adf:ffc6:0:b0:2cf:eb5d:70b5 with SMTP id x6-20020adfffc6000000b002cfeb5d70b5mr8002104wrs.15.1680803402210;
        Thu, 06 Apr 2023 10:50:02 -0700 (PDT)
X-Google-Smtp-Source: AKy350ad59zWuMu7whj0wmSURS5JUKE13e/DU1YY3SEyOltrsCwrZk78B+LPq9aeWxcIY9kBuxK5hg==
X-Received: by 2002:adf:ffc6:0:b0:2cf:eb5d:70b5 with SMTP id x6-20020adfffc6000000b002cfeb5d70b5mr8002071wrs.15.1680803401790;
        Thu, 06 Apr 2023 10:50:01 -0700 (PDT)
Received: from ?IPV6:2003:cb:c705:6300:a8be:c1ad:41a1:2bf7? (p200300cbc7056300a8bec1ad41a12bf7.dip0.t-ipconnect.de. [2003:cb:c705:6300:a8be:c1ad:41a1:2bf7])
        by smtp.gmail.com with ESMTPSA id z14-20020adfd0ce000000b002c55306f6edsm2321939wrh.54.2023.04.06.10.50.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 10:50:01 -0700 (PDT)
Message-ID: <14d50ddd-507e-46e7-1a32-72466dec2a40@redhat.com>
Date:   Thu, 6 Apr 2023 19:49:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v5 1/2] mm: vmscan: ignore non-LRU-based reclaim in memcg
 reclaim
Content-Language: en-US
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Peter Xu <peterx@redhat.com>, NeilBrown <neilb@suse.de>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@kernel.org>, Yu Zhao <yuzhao@google.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
References: <20230405185427.1246289-1-yosryahmed@google.com>
 <20230405185427.1246289-2-yosryahmed@google.com>
 <a8cb406a-70cd-aa47-fdda-50cd0eb8c941@redhat.com>
 <CAJD7tkbNsLo8Cd0nOm22oxD14GMppPoLNOHx2f8BJZA1wkpWnQ@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <CAJD7tkbNsLo8Cd0nOm22oxD14GMppPoLNOHx2f8BJZA1wkpWnQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06.04.23 16:07, Yosry Ahmed wrote:
> Thanks for taking a look, David!
> 
> On Thu, Apr 6, 2023 at 3:31 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 05.04.23 20:54, Yosry Ahmed wrote:
>>> We keep track of different types of reclaimed pages through
>>> reclaim_state->reclaimed_slab, and we add them to the reported number
>>> of reclaimed pages.  For non-memcg reclaim, this makes sense. For memcg
>>> reclaim, we have no clue if those pages are charged to the memcg under
>>> reclaim.
>>>
>>> Slab pages are shared by different memcgs, so a freed slab page may have
>>> only been partially charged to the memcg under reclaim.  The same goes for
>>> clean file pages from pruned inodes (on highmem systems) or xfs buffer
>>> pages, there is no simple way to currently link them to the memcg under
>>> reclaim.
>>>
>>> Stop reporting those freed pages as reclaimed pages during memcg reclaim.
>>> This should make the return value of writing to memory.reclaim, and may
>>> help reduce unnecessary reclaim retries during memcg charging.  Writing to
>>> memory.reclaim on the root memcg is considered as cgroup_reclaim(), but
>>> for this case we want to include any freed pages, so use the
>>> global_reclaim() check instead of !cgroup_reclaim().
>>>
>>> Generally, this should make the return value of
>>> try_to_free_mem_cgroup_pages() more accurate. In some limited cases (e.g.
>>> freed a slab page that was mostly charged to the memcg under reclaim),
>>> the return value of try_to_free_mem_cgroup_pages() can be underestimated,
>>> but this should be fine. The freed pages will be uncharged anyway, and we
>>
>> Can't we end up in extreme situations where
>> try_to_free_mem_cgroup_pages() returns close to 0 although a huge amount
>> of memory for that cgroup was freed up.
>>
>> Can you extend on why "this should be fine" ?
>>
>> I suspect that overestimation might be worse than underestimation. (see
>> my comment proposal below)
> 
> In such extreme scenarios even though try_to_free_mem_cgroup_pages()
> would return an underestimated value, the freed memory for the cgroup
> will be uncharged. try_charge() (and most callers of
> try_to_free_mem_cgroup_pages()) do so in a retry loop, so even if
> try_to_free_mem_cgroup_pages() returns an underestimated value
> charging will succeed the next time around.
> 
> The only case where this might be a problem is if it happens in the
> final retry, but I guess we need to be *really* unlucky for this
> extreme scenario to happen. One could argue that if we reach such a
> situation the cgroup will probably OOM soon anyway.
> 
>>
>>> can charge the memcg the next time around as we usually do memcg reclaim
>>> in a retry loop.
>>>
>>> The next patch performs some cleanups around reclaim_state and adds an
>>> elaborate comment explaining this to the code. This patch is kept
>>> minimal for easy backporting.
>>>
>>> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>>> Cc: stable@vger.kernel.org
>>
>> Fixes: ?
>>
>> Otherwise it's hard to judge how far to backport this.
> 
> It's hard to judge. The issue has been there for a while, but
> memory.reclaim just made it more user visible. I think we can
> attribute it to per-object slab accounting, because before that any
> freed slab pages in cgroup reclaim would be entirely charged to that
> cgroup.
> 
> Although in all fairness, other types of freed pages that use
> reclaim_state->reclaimed_slab cannot be attributed to the cgroup under
> reclaim have been there before that. I guess slab is the most
> significant among them tho, so for the purposes of backporting I
> guess:
> 
> Fixes: f2fe7b09a52b ("mm: memcg/slab: charge individual slab objects
> instead of pages")
> 
>>
>>> ---
>>>
>>> global_reclaim(sc) does not exist in kernels before 6.3. It can be
>>> replaced with:
>>> !cgroup_reclaim(sc) || mem_cgroup_is_root(sc->target_mem_cgroup)
>>>
>>> ---
>>>    mm/vmscan.c | 8 +++++---
>>>    1 file changed, 5 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index 9c1c5e8b24b8f..c82bd89f90364 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -5346,8 +5346,10 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>>>                vmpressure(sc->gfp_mask, memcg, false, sc->nr_scanned - scanned,
>>>                           sc->nr_reclaimed - reclaimed);
>>>
>>> -     sc->nr_reclaimed += current->reclaim_state->reclaimed_slab;
>>> -     current->reclaim_state->reclaimed_slab = 0;
>>
>> Worth adding a comment like
>>
>> /*
>>    * Slab pages cannot universally be linked to a single memcg. So only
>>    * account them as reclaimed during global reclaim. Note that we might
>>    * underestimate the amount of memory reclaimed (but won't overestimate
>>    * it).
>>    */
>>
>> but ...
>>
>>> +     if (global_reclaim(sc)) {
>>> +             sc->nr_reclaimed += current->reclaim_state->reclaimed_slab;
>>> +             current->reclaim_state->reclaimed_slab = 0;
>>> +     }
>>>
>>>        return success ? MEMCG_LRU_YOUNG : 0;
>>>    }
>>> @@ -6472,7 +6474,7 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>>>
>>>        shrink_node_memcgs(pgdat, sc);
>>>
>>
>> ... do we want to factor the add+clear into a simple helper such that we
>> can have above comment there?
>>
>> static void cond_account_reclaimed_slab(reclaim_state, sc)
>> {
>>          /*
>>           * Slab pages cannot universally be linked to a single memcg. So
>>           * only account them as reclaimed during global reclaim. Note
>>           * that we might underestimate the amount of memory reclaimed
>>           * (but won't overestimate it).
>>           */
>>          if (global_reclaim(sc)) {
>>                  sc->nr_reclaimed += reclaim_state->reclaimed_slab;
>>                  reclaim_state->reclaimed_slab = 0;
>>          }
>> }
>>
>> Yes, effective a couple LOC more, but still straight-forward for a
>> stable backport
> 
> The next patch in the series performs some refactoring and cleanups,
> among which we add a helper called flush_reclaim_state() that does
> exactly that and contains a sizable comment. I left this outside of
> this patch in v5 to make the effective change as small as possible for
> backporting. Looks like it can be confusing tho without the comment.
> 
> How about I pull this part to this patch as well for v6?

As long as it's a helper similar to what I proposed, I think that makes 
a lot of sense (and doesn't particularly bloat this patch).

-- 
Thanks,

David / dhildenb

