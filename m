Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647BD442E54
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 13:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhKBMlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 08:41:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40970 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229924AbhKBMlo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 08:41:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635856750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jIkHBillbCKCZYFZuYQdXQ8luVuR63mT21wNxhTkVuM=;
        b=CKI7pBVvy5Sve/5KVNjxxyCyyxB0tToL1SIWoJqR5kS91C5Tn+NTOUIJo5FOuIW/YjpAit
        f8rru3R1ZiPt3nM0UVB0fIrOA828O7SUrnn+6USXktsWlArFNnZs+2/C5LuLNZrhcQq9i5
        fj+mmbah4FJBvG4EYKSNb2/5KSwwqhE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-dIw4f4VaMDuNnzVYkwM3vg-1; Tue, 02 Nov 2021 08:39:09 -0400
X-MC-Unique: dIw4f4VaMDuNnzVYkwM3vg-1
Received: by mail-wm1-f72.google.com with SMTP id o22-20020a1c7516000000b0030d6f9c7f5fso6904793wmc.1
        for <stable@vger.kernel.org>; Tue, 02 Nov 2021 05:39:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=jIkHBillbCKCZYFZuYQdXQ8luVuR63mT21wNxhTkVuM=;
        b=3iNXAQ6jHoLJ2XzodLix8TsFRYvKJf+Qqj9j0NuQvgtl1cPTTZ8bjPeXKV/FYvrP7z
         x+mUNw/1ICp67xBFnGP6TSBMayvmY9vVMdqrLVRQecEYN6nMucIqx0fb+hB2eAveuHhp
         m6/xNTwIdaXKmI/dfIiX0Z2bDGJKEfWQFrm9WeFzMtxpk2QsUDzbLuk28KUz8Cl5ZEyf
         /ml7rNALa4vwS4VI29KnwUj3GDmqrEGNUF8YVS6ckzgpjIeovdAtwwcTwOEAzT55ciXh
         Z81YIzUUxdSLd9UkTZmRtxHxkPVAjx1hrKjCfMAQ3mWfLBZhbrqF8L8rT8F3ZecRgVCp
         B48g==
X-Gm-Message-State: AOAM531du7Z4Mc9rgsi8nlhXPUwqPQAMTRa/VI61NAHueX8jUMOZScbg
        8kOi+qSWA/CqGt9XhIdgpGDhig1Aa9FiGKggWApF4rG1rL2dzCu9ZDfmIXnBUQWMdV6lNLLg7a7
        necyMEL3bf7m3eGGw
X-Received: by 2002:a5d:648b:: with SMTP id o11mr47850884wri.56.1635856747723;
        Tue, 02 Nov 2021 05:39:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyPAtManKqas0sqXcvZrMMHN6XCbXPcL93RLbXpskjnJsSOhAZs99TXw5dZs5B4HcxSez/rGg==
X-Received: by 2002:a5d:648b:: with SMTP id o11mr47850848wri.56.1635856747513;
        Tue, 02 Nov 2021 05:39:07 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6810.dip0.t-ipconnect.de. [91.12.104.16])
        by smtp.gmail.com with ESMTPSA id h14sm2656442wmq.34.2021.11.02.05.39.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 05:39:07 -0700 (PDT)
Message-ID: <e7aed7c0-b7b1-4a94-f323-0bcde2f879d2@redhat.com>
Date:   Tue, 2 Nov 2021 13:39:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] mm: fix panic in __alloc_pages
Content-Language: en-US
To:     Michal Hocko <mhocko@suse.com>
Cc:     Alexey Makhalov <amakhalov@vmware.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Oscar Salvador <OSalvador@suse.com>
References: <20211101201312.11589-1-amakhalov@vmware.com>
 <YYDtDkGNylpAgPIS@dhcp22.suse.cz>
 <7136c959-63ff-b866-b8e4-f311e0454492@redhat.com>
 <C69EF2FE-DFF6-492E-AD40-97A53739C3EC@vmware.com>
 <YYD/FkpAk5IvmOux@dhcp22.suse.cz>
 <b2e4a611-45a6-732a-a6d3-6042afd2af6e@redhat.com>
 <E34422F0-A44A-48FD-AE3B-816744359169@vmware.com>
 <b3908fce-6b07-8390-b691-56dd2f85c05f@redhat.com>
 <YYEkqH8l0ASWv/JT@dhcp22.suse.cz>
 <42abfba6-b27e-ca8b-8cdf-883a9398b506@redhat.com>
 <YYEun6s/mF9bE+rQ@dhcp22.suse.cz>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <YYEun6s/mF9bE+rQ@dhcp22.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>> Yes, but a zonelist cannot be correct for an offline node, where we might
>> not even have an allocated pgdat yet. No pgdat, no zonelist. So as soon as
>> we allocate the pgdat and set the node online (->hotadd_new_pgdat()), the zone lists have to be correct. And I can spot an build_all_zonelists() in hotadd_new_pgdat().
> 
> Yes, that is what I had in mind. We are talking about two things here.
> Memoryless nodes and offline nodes. The later sounds like a bug to me.

Agreed. memoryless nodes should just have proper zonelists -- which
seems to be the case.

>> Maybe __alloc_pages_bulk() and alloc_pages_node() should bail out directly
>> (VM_BUG()) in case we're providing an offline node with eventually no/stale pgdat as
>> preferred nid.
> 
> Historically, those allocation interfaces were not trying to be robust
> against wrong inputs because that adds cpu cycles for everybody for
> "what if buggy" code. This has worked (surprisingly) well. Memory less
> nodes have brought in some confusion but this is still something that we
> can address on a higher level. Nobody give arbitrary nodes as an input.
> cpu_to_node might be tricky because it can point to a memory less node
> which along with __GFP_THISNODE is very likely not something anybody
> wants. Hence cpu_to_mem should be used for allocations. I hate we have
> two very similar APIs...

To be precise, I'm wondering if we should do:

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 55b2ec1f965a..8c49b88336ee 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -565,7 +565,7 @@ static inline struct page *
 __alloc_pages_node(int nid, gfp_t gfp_mask, unsigned int order)
 {
        VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
-       VM_WARN_ON((gfp_mask & __GFP_THISNODE) && !node_online(nid));
+       VM_WARN_ON(!node_online(nid));

        return __alloc_pages(gfp_mask, order, nid, NULL);
 }

(Or maybe VM_BUG_ON)

Because it cannot possibly work and we'll dereference NULL later.

> 
> But something seems wrong in this case. cpu_to_node shouldn't return
> offline nodes. That is just a land mine. It is not clear to me how the
> cpu has been brought up so that the numa node allocation was left
> behind. As pointed in other email add_cpu resp. cpu_up is not it.
> Is it possible that the cpu bring up was only half way?

I tried to follow the code (what sets a CPU present, what sets a CPU
online, when do we update cpu_to_node() mapping) and IMHO it's all a big
mess. Maybe it's clearer to people familiar with that code, but CPU
hotplug in general seems to be a confusing piece of (arch-specific) code.

Also, I have no clue if cpu_to_node() mapping will get invalidated after
unplugging that CPU, or if the mapping will simply stay around for all
eternity ...

-- 
Thanks,

David / dhildenb

