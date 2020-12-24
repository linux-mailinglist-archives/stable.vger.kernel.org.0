Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C682E241F
	for <lists+stable@lfdr.de>; Thu, 24 Dec 2020 05:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbgLXECo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 23:02:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39430 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725885AbgLXECo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 23:02:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608782477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HaM5vqeoz7uyCdtjEZGPvgmfZfkHGEzfapMlshdVV/I=;
        b=FfPUsKuGuc24WODhykC+7G9ARn1z00ZegTcR7zRH1X7BhleL8iFJLjOp8NUlZlJ6QbYi5L
        mv+ETBBUwlfH5vMK6+QKLat3EcBYK87U6p9juOYjKxVRGsZvyUezM3DhSFwb5u1xEqnKd8
        m0mNM13RWzGw1+0KFYbRZgCZHQWziSc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-UCmXtoJCMlmYJsHL39CugA-1; Wed, 23 Dec 2020 23:01:15 -0500
X-MC-Unique: UCmXtoJCMlmYJsHL39CugA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB646801AAF;
        Thu, 24 Dec 2020 04:01:13 +0000 (UTC)
Received: from mail (ovpn-112-5.rdu2.redhat.com [10.10.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 232995F9B8;
        Thu, 24 Dec 2020 04:01:10 +0000 (UTC)
Date:   Wed, 23 Dec 2020 23:01:09 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Yu Zhao <yuzhao@google.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X+QShVIUbYKAsc35@redhat.com>
References: <X+PE38s2Egq4nzKv@google.com>
 <C332B03D-30B1-4C9C-99C2-E76988BFC4A1@amacapital.net>
 <X+P2OnR+ipY8d2qL@redhat.com>
 <3A6A1049-24C6-4B2D-8C59-21B549F742B4@gmail.com>
 <X+QMKC7jPEeThjB1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <X+QMKC7jPEeThjB1@google.com>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Wed, Dec 23, 2020 at 07:09:10PM -0800, Nadav Amit wrote:
> > I think there are other cases in which Andy’s concern is relevant
> > (MADV_PAGEOUT).

I didn't try to figure how it would help MADV_PAGEOUT. MADV_PAGEOUT
sounds cool feature, but maybe it'd need a way to flush the
invalidates out and a take a static key to enable the buildup of those
ranges?

I wouldn't like to slow down the fast paths even for MADV_PAGEOUT, and
the same applies to uffd-wp and softdirty in fact.

On Wed, Dec 23, 2020 at 08:34:00PM -0700, Yu Zhao wrote:
> That patch only demonstrate a rough idea and I should have been
> elaborate: if we ever decide to go that direction, we only need to
> worry about "jumping through hoops", because the final patch (set)
> I have in mind would not only have the build time optimization Andrea
> suggested but also include runtime optimizations like skipping
> do_swap_page() path and (!PageAnon() || page_mapcount > 1). Rest
> assured, the performance impact on do_wp_page() from occasionally an
> additional TLB flush on top of a page copy is negligible.

Agreed, I just posted something in that direction. Feel free to
refactor it, it's just a tentative implementation to show something
that may deliver all the performance we need in all cases involved
without slowing down the fast paths of non-uffd and non-softdirty
(well 1 branch).

> On Wed, Dec 23, 2020 at 07:09:10PM -0800, Nadav Amit wrote:
> > Perhaps holding some small bitmap based on part of the deferred flushed
> > pages (e.g., bits 12-17 of the address or some other kind of a single
> > hash-function bloom-filter) would be more performant to avoid (most)

The concern here aren't only the page faults having to run the bloom
filter, but how to manage the RAM storage pointed by the bloomfilter
or whatever index into the storage, which would slowdown mprotect.

Granted that mprotect is slow to begin with, but the idea we can't make
it any slower to make MADV_PAGEOUT or uffd-wp or clear_refs run
faster since it's too important and too frequent in comparison.

Just to restrict the potential false positive IPI caused by page_count
inevitable inaccuracies to uffd-wp and softdirty runtimes, a simple
check on vm_flags should be enough.

Thanks,
Andrea

