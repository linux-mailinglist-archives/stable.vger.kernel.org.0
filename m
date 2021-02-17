Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B87731DEF1
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 19:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233549AbhBQSRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 13:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233301AbhBQSRk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 13:17:40 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B66C061756
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 10:17:00 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id n10so8975812pgl.10
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 10:17:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=Gi5brysudot778XfmQVyx+aFXT8IJ2mHpa0FTPkL6QA=;
        b=JDl2MhLCKhOanylnBiOEISbmJ/fonCREql9eNZHng2H7QwzVFaolfNg+s/F0hE+eQI
         cir2nRyVipOFEdPTN776AvYbVQCj4y+QZ1IfarCboeoTw30HyqCHN28Cklg5UeKtQzO3
         K+nUCfCVrBslJkoW4kIw6wJDhHd5BTn7DGOb+XZJTcNK1leoU0WHZ6+oshreIlUjc46A
         BEdYP0Wh1g76zpGnNwbZPPyzYIyQKDBaUpHuUgsWMRdgpuvBl4+9+rXzvFC3qc6Oh1o1
         UnplyjT1+j5iWUEHy1a2es5vbA27tH0vPIXN6VJotGrnqYQOWnpg8DhwV94t+buCqPn2
         ilwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=Gi5brysudot778XfmQVyx+aFXT8IJ2mHpa0FTPkL6QA=;
        b=HGO655HRcIjVTL30fgyvdT8N0RIphz7YNZiyqNDGmJCT3+hosrR7PDYLBu1gvWcPpw
         0YMINJdlMU9WyDMkgWfncQPbHXk//yt7jzShvtaSaWjNHFoxekTBJ8htKOrzqKdKZ2Xf
         2iDuHM3XUIU6Pt/SFsFlpZNIlntvX2AWFCCGcUwIg1YjRV3yOxbE1TSb3gUUiRs4fVeb
         nCnn0hvYzFu2F47Uzk2nuKqYHZQWercd1vGEoMZeSNmGQK7Nt/PhmxKc9hYNednHEPu3
         r5XKUpdVB9MsZ/xtiAtLcpI+xb4MQTRSPy/OEhLRWhFy1t1v/ciSbjcnPXmlK1/1s3h/
         kivA==
X-Gm-Message-State: AOAM531HdVihLroLnbjS7uhduRRaZsrXSKnp381ooeuiZhuq8k/qdYPo
        CW+IWCYorugnHOuJLmw200gE/A==
X-Google-Smtp-Source: ABdhPJwkPj5MkgTeombBs7pS0/rjx65B5ONZ/wzcQkeUkP51XCckDsu8TF+UwXtCGcplyrsMAymmSQ==
X-Received: by 2002:a63:a0d:: with SMTP id 13mr560363pgk.130.1613585819166;
        Wed, 17 Feb 2021 10:16:59 -0800 (PST)
Received: from [2620:15c:17:3:984e:d574:ca36:ce3c] ([2620:15c:17:3:984e:d574:ca36:ce3c])
        by smtp.gmail.com with ESMTPSA id j73sm3295845pfd.170.2021.02.17.10.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 10:16:58 -0800 (PST)
Date:   Wed, 17 Feb 2021 10:16:57 -0800 (PST)
From:   David Rientjes <rientjes@google.com>
To:     Vlastimil Babka <vbabka@suse.cz>
cc:     linux-mm@kvack.org, Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm, compaction: make fast_isolate_freepages() stay within
 zone
In-Reply-To: <20210217173300.6394-1-vbabka@suse.cz>
Message-ID: <f871a4c-45fe-d7c1-a686-2eefe22543ee@google.com>
References: <20210217173300.6394-1-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 17 Feb 2021, Vlastimil Babka wrote:

> Compaction always operates on pages from a single given zone when isolating
> both pages to migrate and freepages. Pageblock boundaries are intersected with
> zone boundaries to be safe in case zone starts or ends in the middle of
> pageblock. The use of pageblock_pfn_to_page() protects against non-contiguous
> pageblocks.
> 
> The functions fast_isolate_freepages() and fast_isolate_around() don't
> currently protect the fast freepage isolation thoroughly enough against these
> corner cases, and can result in freepage isolation operate outside of zone
> boundaries:
> 
> - in fast_isolate_freepages() if we get a pfn from the first pageblock of a
>   zone that starts in the middle of that pageblock, 'highest' can be a pfn
>   outside of the zone. If we fail to isolate anything in this function, we
>   may then call fast_isolate_around() on a pfn outside of the zone and there
>   effectively do a set_pageblock_skip(page_to_pfn(highest)) which may currently
>   hit a VM_BUG_ON() in some configurations
> - fast_isolate_around() checks only the zone end boundary and not beginning,
>   nor that the pageblock is contiguous (with pageblock_pfn_to_page()) so it's
>   possible that we end up calling isolate_freepages_block() on a range of pfn's
>   from two different zones and end up e.g. isolating freepages under the wrong
>   zone's lock.
> 
> This patch should fix the above issues.
> 
> Fixes: 5a811889de10 ("mm, compaction: use free lists to quickly locate a migration target")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: David Rientjes <rientjes@google.com>
