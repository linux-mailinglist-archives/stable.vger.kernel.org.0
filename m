Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680B52D0C6A
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 10:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgLGJAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 04:00:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59538 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726024AbgLGJAM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 04:00:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607331528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8K41Zx9hmF0XbY232+l+gSsS96Mr1ICD4AgjtdBRXzo=;
        b=QSxsYl0wyE1E3xG4GfKNr2kCj8yOZ+60azDFvBcm3+f0BrDp+VEMWP/8bBEv6Cab0BhtPp
        BnLxv5w3V2axBlWyLoysOBBuwpMwaGqDT08NIgZc6fzkiRRQr4k8HDoC8UezcJADvdinx6
        uQamCVuecDNTSavS2Mt0+kbZNG8lVnQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-l15_P3LQP72ZCuSiMEZ5Tw-1; Mon, 07 Dec 2020 03:58:42 -0500
X-MC-Unique: l15_P3LQP72ZCuSiMEZ5Tw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 240E4809DCD;
        Mon,  7 Dec 2020 08:58:40 +0000 (UTC)
Received: from [10.36.114.33] (ovpn-114-33.ams2.redhat.com [10.36.114.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 29BC960BD8;
        Mon,  7 Dec 2020 08:58:37 +0000 (UTC)
Subject: Re: +
 mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges.patch
 added to -mm tree
To:     akpm@linux-foundation.org, aarcange@redhat.com, bhe@redhat.com,
        cai@lca.pw, mgorman@suse.de, mhocko@kernel.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        stable@vger.kernel.org, vbabka@suse.cz
References: <20201206005401.qKuAVgOXr%akpm@linux-foundation.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <cb3bfacb-821d-6251-03c5-498dd07727cd@redhat.com>
Date:   Mon, 7 Dec 2020 09:58:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201206005401.qKuAVgOXr%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06.12.20 01:54, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: mm: initialize struct pages in reserved regions outside of the zone ranges
> has been added to the -mm tree.  Its filename is
>      mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Andrea Arcangeli <aarcange@redhat.com>
> Subject: mm: initialize struct pages in reserved regions outside of the zone ranges
> 
> Without this change, the pfn 0 isn't in any zone spanned range, and it's
> also not in any memory.memblock range, so the struct page of pfn 0 wasn't
> initialized and the PagePoison remained set when reserve_bootmem_region
> called __SetPageReserved, inducing a silent boot failure with DEBUG_VM
> (and correctly so, because the crash signaled the nodeid/nid of pfn 0
> would be again wrong).
> 
> There's no enforcement that all memblock.reserved ranges must overlap
> memblock.memory ranges, so the memblock.reserved ranges also require an
> explicit initialization and the zones ranges need to be extended to
> include all memblock.reserved ranges with struct pages too or they'll be
> left uninitialized with PagePoison as it happened to pfn 0.
> 
> Link: https://lkml.kernel.org/r/20201205013238.21663-2-aarcange@redhat.com
> Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather that check each PFN")
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Mike Rapoport <rppt@linux.ibm.com>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Qian Cai <cai@lca.pw>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[...]

I've lost track which patches are we considering right now to solve the
overall issue. I'd appreciate a proper patch series with all relevant
patches.

-- 
Thanks,

David / dhildenb

