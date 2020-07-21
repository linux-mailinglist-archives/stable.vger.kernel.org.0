Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1E4B227B79
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 11:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgGUJR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 05:17:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:49202 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbgGUJR3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 05:17:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 08E86AE63;
        Tue, 21 Jul 2020 09:17:34 +0000 (UTC)
Subject: Re: [PATCH] mm/page_alloc: fix memalloc_nocma_{save/restore} APIs
To:     js1304@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kernel-team@lge.com, Christoph Hellwig <hch@infradead.org>,
        Roman Gushchin <guro@fb.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@suse.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, stable@vger.kernel.org
References: <1595302129-23895-1-git-send-email-iamjoonsoo.kim@lge.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <03e6b134-a2ad-0df2-73bc-9b7542a1bddb@suse.cz>
Date:   Tue, 21 Jul 2020 11:17:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1595302129-23895-1-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/21/20 5:28 AM, js1304@gmail.com wrote:
> From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> Currently, memalloc_nocma_{save/restore} API that prevents CMA area
> in page allocation is implemented by using current_gfp_context(). However,
> there are two problems of this implementation.
> 
> First, this doesn't work for allocation fastpath. In the fastpath,
> original gfp_mask is used since current_gfp_context() is introduced in
> order to control reclaim and it is on slowpath. So, CMA area can be
> allocated through the allocation fastpath even if
> memalloc_nocma_{save/restore} APIs are used. Currently, there is just
> one user for these APIs and it has a fallback method to prevent actual
> problem.
> Second, clearing __GFP_MOVABLE in current_gfp_context() has a side effect
> to exclude the memory on the ZONE_MOVABLE for allocation target.
> 
> To fix these problems, this patch changes the implementation to exclude
> CMA area in page allocation. Main point of this change is using the
> alloc_flags. alloc_flags is mainly used to control allocation so it fits
> for excluding CMA area in allocation.

Moreover, the ALLOC_CMA flag already exists for exactly this purpose.

> Fixes: d7fefcc8de91 (mm/cma: add PF flag to force non cma alloc)
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

Thanks!
