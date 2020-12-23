Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2A62E2235
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 22:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgLWVkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 16:40:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32543 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726014AbgLWVkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 16:40:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608759550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n4KJUOQ5ygu+EEs0eGeRkAyIIxVGqGUkA4CfFbcmhdE=;
        b=dKRNeKokM7953ig9GpA/D8VHXCIld4sC9AzkEenCnL+4qFXZqFfhTG7VQeB+m57jvlshwI
        4fEPHKnfepeodhJK81jOxqXokYjCyQ/8lQsJqaLIHHBpRrKVrKxOQJcnJbUUohLt26l72J
        HGCymxzlWbicmHzwKXLh/ZKc4q/hUKQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-IH7l51CUNKGXJql0Seo12g-1; Wed, 23 Dec 2020 16:39:06 -0500
X-MC-Unique: IH7l51CUNKGXJql0Seo12g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7CFB803622;
        Wed, 23 Dec 2020 21:39:04 +0000 (UTC)
Received: from mail (ovpn-112-5.rdu2.redhat.com [10.10.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F33BD614F5;
        Wed, 23 Dec 2020 21:39:00 +0000 (UTC)
Date:   Wed, 23 Dec 2020 16:39:00 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Yu Zhao <yuzhao@google.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X+O49HrcK1fBDk0Q@redhat.com>
References: <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1>
 <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <X+JJqK91plkBVisG@redhat.com>
 <X+JhwVX3s5mU9ZNx@google.com>
 <X+Js/dFbC5P7C3oO@redhat.com>
 <X+KDwu1PRQ93E2LK@google.com>
 <X+Kxy3oBMSLz8Eaq@redhat.com>
 <X+K7JMrTEC9SpVIB@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X+K7JMrTEC9SpVIB@google.com>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 22, 2020 at 08:36:04PM -0700, Yu Zhao wrote:
> Thanks for the details.

I hope we can find a way put the page_mapcount back where there's a
page_count right now.

If you're so worried about having to maintain a all defined well
documented (or to be documented even better if you ACK it)
marker/catcher for userfaultfd_writeprotect, I can't see how you could
consider to maintain the page fault safe against any random code
leaving too permissive TLB entries out of sync of the more restrictive
pte permissions as it was happening with clear_refs_write, which
worked by luck until page_mapcount was changed to page_count.

page_count is far from optimal, but it is a feature it finally allowed
us to notice that various code (clear_refs_write included apparently
even after the fix) leaves stale too permissive TLB entries when it
shouldn't.

The question is only which way you prefer to fix clear_refs_write and
I don't think we can deviate from those 3 methods that already exist
today. So clear_refs_write will have to pick one of those and
currently it's not falling in the same category with mprotect even
after the fix.

I think if clear_refs_write starts to take the mmap_write_lock and
really start to operate like mprotect, only then we can consider to
make userfaultfd_writeprotect also operate like mprotect.

Even then I'd hope we can at least be allowed to make it operate like
KSM write_protect_page for len <= HPAGE_PMD_SIZE, something that
clear_refs_write cannot do since it works in O(N) and tends to scan
everything at once, so there would be no point to optimize not to
defer the flush, for a process with a tiny amount of virtual memory
mapped.

vm86 also should be fixed to fall in the same category with mprotect,
since performance there is irrelevant.

Thanks,
Andrea

