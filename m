Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99206D9423
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 12:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237167AbjDFKcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 06:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236628AbjDFKb6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 06:31:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E7D83E1
        for <stable@vger.kernel.org>; Thu,  6 Apr 2023 03:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680777061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DSkVqfN4fVdY5K7jYUBTl5KelyFFapb4DkfrIbimWkQ=;
        b=cyfPao4TlFJAFRjpI0/wUZXG/XTxj9VrPUTicUeIvz08RjyQzBrwm8JtPjmA5MFshOdyIY
        TBLasHxiqS2p+hBA/MZdkghmlmK9qXDvWI9maZx8d+f2YUqM70XHy/LOsmgiCYePKQh4E7
        nFH0CR6I2vnlhhe1Vl9omEX7bozXkF0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-ABPzXDb8OYCsTTwq0opDOA-1; Thu, 06 Apr 2023 06:31:00 -0400
X-MC-Unique: ABPzXDb8OYCsTTwq0opDOA-1
Received: by mail-wm1-f72.google.com with SMTP id bg33-20020a05600c3ca100b003ef6d684105so15899466wmb.1
        for <stable@vger.kernel.org>; Thu, 06 Apr 2023 03:31:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680777059; x=1683369059;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :content-language:references:cc:to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DSkVqfN4fVdY5K7jYUBTl5KelyFFapb4DkfrIbimWkQ=;
        b=xiIHscMKK3lduh3VcejALRwK4a/1jtiZgVDlkhrQvXS9zMrCW365GyH0SzwLI5xRJk
         IEBxZS7qTw2f7ZdWCA9IM4M0l5A1Cc2uruYhd7Bpa5E0Ip5+IOeif6loMz1m7Smayzol
         o1EtwnHW4Nr9aVPL9ot1E2oMSmqswLCvNfKYX7WpaGUP9gHCGsD2tApI9gNJ/IcCJBgu
         qT6cd4rVg2qoIzjlYtB0FKdwZvks9ReeuA/1/cOqehS62y4p1XgBOXNlQB5tAwOCiv2B
         kE4f+I9IS2J97ckI3ZJuQ6Rw2xruP6c5c5SiqzE/7u7hQ60N61BpTXlNDbP+TWKO/6zJ
         GdWw==
X-Gm-Message-State: AAQBX9e16gntr7BytUQhJpYrgW6NvmcS7QGvf8Vg/Y9uc36d+QP8G6GH
        D0gQEwUUuSBpZnnKd4jcs1qH60ByfAJk+aoKkU5dvorQsu1PdsE7mts/AVqgJpJnUIT1s+xACxO
        mEp5h39phV/IHOU5M
X-Received: by 2002:adf:ce8b:0:b0:2db:43ed:1baa with SMTP id r11-20020adfce8b000000b002db43ed1baamr6300022wrn.24.1680777059257;
        Thu, 06 Apr 2023 03:30:59 -0700 (PDT)
X-Google-Smtp-Source: AKy350bKzMGZCBY5+zcpx2zh++U0Vc78+mn9MAu7M75vPKKNUIUrRAHnNEOxAL/yv6as0YHwbBEW9w==
X-Received: by 2002:adf:ce8b:0:b0:2db:43ed:1baa with SMTP id r11-20020adfce8b000000b002db43ed1baamr6299994wrn.24.1680777058780;
        Thu, 06 Apr 2023 03:30:58 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id r10-20020adfe68a000000b002c7b229b1basm1423645wrm.15.2023.04.06.03.30.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 03:30:58 -0700 (PDT)
Message-ID: <a8cb406a-70cd-aa47-fdda-50cd0eb8c941@redhat.com>
Date:   Thu, 6 Apr 2023 12:30:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
To:     Yosry Ahmed <yosryahmed@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
        Dave Chinner <david@fromorbit.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
References: <20230405185427.1246289-1-yosryahmed@google.com>
 <20230405185427.1246289-2-yosryahmed@google.com>
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v5 1/2] mm: vmscan: ignore non-LRU-based reclaim in memcg
 reclaim
In-Reply-To: <20230405185427.1246289-2-yosryahmed@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05.04.23 20:54, Yosry Ahmed wrote:
> We keep track of different types of reclaimed pages through
> reclaim_state->reclaimed_slab, and we add them to the reported number
> of reclaimed pages.  For non-memcg reclaim, this makes sense. For memcg
> reclaim, we have no clue if those pages are charged to the memcg under
> reclaim.
> 
> Slab pages are shared by different memcgs, so a freed slab page may have
> only been partially charged to the memcg under reclaim.  The same goes for
> clean file pages from pruned inodes (on highmem systems) or xfs buffer
> pages, there is no simple way to currently link them to the memcg under
> reclaim.
> 
> Stop reporting those freed pages as reclaimed pages during memcg reclaim.
> This should make the return value of writing to memory.reclaim, and may
> help reduce unnecessary reclaim retries during memcg charging.  Writing to
> memory.reclaim on the root memcg is considered as cgroup_reclaim(), but
> for this case we want to include any freed pages, so use the
> global_reclaim() check instead of !cgroup_reclaim().
> 
> Generally, this should make the return value of
> try_to_free_mem_cgroup_pages() more accurate. In some limited cases (e.g.
> freed a slab page that was mostly charged to the memcg under reclaim),
> the return value of try_to_free_mem_cgroup_pages() can be underestimated,
> but this should be fine. The freed pages will be uncharged anyway, and we

Can't we end up in extreme situations where 
try_to_free_mem_cgroup_pages() returns close to 0 although a huge amount 
of memory for that cgroup was freed up.

Can you extend on why "this should be fine" ?

I suspect that overestimation might be worse than underestimation. (see 
my comment proposal below)

> can charge the memcg the next time around as we usually do memcg reclaim
> in a retry loop.
> 
> The next patch performs some cleanups around reclaim_state and adds an
> elaborate comment explaining this to the code. This patch is kept
> minimal for easy backporting.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> Cc: stable@vger.kernel.org

Fixes: ?

Otherwise it's hard to judge how far to backport this.

> ---
> 
> global_reclaim(sc) does not exist in kernels before 6.3. It can be
> replaced with:
> !cgroup_reclaim(sc) || mem_cgroup_is_root(sc->target_mem_cgroup)
> 
> ---
>   mm/vmscan.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9c1c5e8b24b8f..c82bd89f90364 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5346,8 +5346,10 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>   		vmpressure(sc->gfp_mask, memcg, false, sc->nr_scanned - scanned,
>   			   sc->nr_reclaimed - reclaimed);
>   
> -	sc->nr_reclaimed += current->reclaim_state->reclaimed_slab;
> -	current->reclaim_state->reclaimed_slab = 0;

Worth adding a comment like

/*
  * Slab pages cannot universally be linked to a single memcg. So only
  * account them as reclaimed during global reclaim. Note that we might
  * underestimate the amount of memory reclaimed (but won't overestimate
  * it).
  */

but ...

> +	if (global_reclaim(sc)) {
> +		sc->nr_reclaimed += current->reclaim_state->reclaimed_slab;
> +		current->reclaim_state->reclaimed_slab = 0;
> +	}
>   
>   	return success ? MEMCG_LRU_YOUNG : 0;
>   }
> @@ -6472,7 +6474,7 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>   
>   	shrink_node_memcgs(pgdat, sc);
>   

... do we want to factor the add+clear into a simple helper such that we 
can have above comment there?

static void cond_account_reclaimed_slab(reclaim_state, sc)
{	
	/*
  	 * Slab pages cannot universally be linked to a single memcg. So
	 * only account them as reclaimed during global reclaim. Note
	 * that we might underestimate the amount of memory reclaimed
	 * (but won't overestimate it).
	 */
	if (global_reclaim(sc)) {
		sc->nr_reclaimed += reclaim_state->reclaimed_slab;
		reclaim_state->reclaimed_slab = 0;
	}
}

Yes, effective a couple LOC more, but still straight-forward for a 
stable backport

> -	if (reclaim_state) {
> +	if (reclaim_state && global_reclaim(sc)) {
>   		sc->nr_reclaimed += reclaim_state->reclaimed_slab;
>   		reclaim_state->reclaimed_slab = 0;
>   	}

-- 
Thanks,

David / dhildenb

