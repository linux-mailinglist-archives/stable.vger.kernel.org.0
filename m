Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654CB2E0FFF
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 23:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgLVWEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 17:04:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58896 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726652AbgLVWEM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 17:04:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608674565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=urX6b7Ar6vf2kG6DWZuX4Gwil4+VQz0Wx+qVJUk6lNk=;
        b=CpTMyTP8Ypzqz/lF66NWyQie0EmIrbmkGn6ydR7TvGk1sUcUxHbmWkd88Kner6ZlupnaG3
        nqsDuiYWkg/fanlSdj9LAo08zZ8zgJPaNDcsk+q2lb62gRCEMkwQrcPelz8aQEidp2YOvC
        0CeHauo5EKWt2Qjitfk9p4FOklA2SRw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-bjp8P9mIOo6Shx9mSuMVew-1; Tue, 22 Dec 2020 17:02:43 -0500
X-MC-Unique: bjp8P9mIOo6Shx9mSuMVew-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5502801817;
        Tue, 22 Dec 2020 22:02:41 +0000 (UTC)
Received: from mail (ovpn-112-5.rdu2.redhat.com [10.10.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C97D60C66;
        Tue, 22 Dec 2020 22:02:38 +0000 (UTC)
Date:   Tue, 22 Dec 2020 17:02:37 -0500
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
Message-ID: <X+Js/dFbC5P7C3oO@redhat.com>
References: <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1>
 <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <X+JJqK91plkBVisG@redhat.com>
 <X+JhwVX3s5mU9ZNx@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X+JhwVX3s5mU9ZNx@google.com>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 22, 2020 at 02:14:41PM -0700, Yu Zhao wrote:
> This works but I don't prefer this option because 1) this is new
> way of making pte_wrprotect safe and 2) it's specific to ufd and
> can't be applied to clear_soft_dirty() which has no "catcher". No

I didn't look into clear_soft_dirty issue, I can look into that.

To avoid having to deal with a 3rd solution it will have to use one of
the two:

1) avoid deferring tlb flush and enforce a sync flush before dropping
  the PT lock even if mm_mm_tlb_flush_pending is true ->
  write_protect_page in KSM

2) add its own new catcher for its own specific marker (for UFFD-WP
   the marker is _PAGE_UFFD_WP, for change_prot_numa is PROT_NONE on a
   vma->vm_pgprot not PROT_NONE, for soft dirty it could be
   _PAGE_SOFT_DIRTY) to send the page fault to a dead end before the
   pte value is interpreted.

> matter how good the documentation about this new way is now, it
> will be out of date, speaking from my personal experience.

A common catcher for all 3 is not possible because each catcher
depends on whatever marker and whatever pte value they set that may
lead to a different deterministic path where to put the catcher or
multiple paths even. do_numa_page requires a catcher in a different
place already.

Or well, a common catcher for all 3 is technically possible but it'd
perform slower requiring to check things twice.

But perhaps the soft_dirty can use the same catcher of uffd-wp given
the similarity?

> I'd go with what Nadav has -- the memory corruption problem has been
> there for a while and nobody has complained except Nadav. This makes
> me think people is less likely to notice any performance issues from
> holding mmap_lock for write in his patch either.

uffd-wp is a fairly new feature, the current users are irrelevant,
keeping it optimal is just for the future potential.

> But I can't say I have zero concern with the potential performance
> impact given that I have been expecting the fix to go to stable,
> which I care most. So the next option on my list is to have a

Actually stable would be very fine to go with Nadav patch and use the
mmap_lock_write unconditionally. The optimal fix is only relevant for
the future potential, so it's only relevant for Linus's tree.

However the feature is recent enough that it won't require a deep
backport so the optimal fix is likely fine for stable as well,
generally stable prefers the same fix as in the upstream when there's
no major backport rejection issue.

The alternative solution for uffd is to do the deferred flush under
mmap_lock_write if len is > HPAGE_PMD_SIZE, or to tell
change_protection not to defer the flush and to take the
mmap_lock_read for <= HPAGE_PMD_SIZE. That will avoid depending on the
catcher and then userfaultfd_writeprotect(mode_wp=true)
userfaultfd_writeprotect(mode_wp=false) can even run in parallel at
all times. The cons is large userfaultfd_writeprotect will block for
I/O and those would happen at least in the postcopy live snapshotting
use case.

The main cons is that it'd require modification to change_protection
so it actually looks more intrusive, not less.

Overall anything that allows to wrprotect 1 pte with only the
mmap_lock_read exactly like KSM write_protect_page, would be enough for
uffd-wp.

What isn't ok in terms of future potential is unconditional
mmap_lock_write as in the original suggested patch in my view. It
doesn't mean we can take mmap_lock_write when the operation is large
and there is actually more benefit from deferring the flush.

> common "catcher" in do_wp_page() which singles out pages that have
> page_mapcount equal to one and reuse them instead of trying to

I don't think the page_mapcount matters here. If the wp page reuse was
more accurate (as it was before) we wouldn't notice this issue, but it
still would be a bug that there were stale TLB entries. It worked by
luck.

Thanks,
Andrea

