Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5EB22E21EB
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 22:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbgLWVJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 16:09:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22094 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726462AbgLWVJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 16:09:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608757690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RYnXjHYiiVv40HCt96H+XMsKFz2eVvyli5eMvixzfvQ=;
        b=gV85LsCN5+olAuLd6xkZV+CTthfNtyvkSoHWnSo0uLQpml2DCLWJh67WHPJesa8XwEFloQ
        PaxaPRTiML0aIDYrG4xKm5+OvKzVo4exP5CGNZqmn/O908c1265yqyPX5xVloPZhsvJEL+
        fSYjmv4U+XAZJuqPGfzlYNCManBzkPY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-Q437fpR2O4avZGKoe9yFaw-1; Wed, 23 Dec 2020 16:08:07 -0500
X-MC-Unique: Q437fpR2O4avZGKoe9yFaw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C16C11842142;
        Wed, 23 Dec 2020 21:08:04 +0000 (UTC)
Received: from mail (ovpn-112-5.rdu2.redhat.com [10.10.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D48D25D9C6;
        Wed, 23 Dec 2020 21:07:59 +0000 (UTC)
Date:   Wed, 23 Dec 2020 16:07:59 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Yu Zhao <yuzhao@google.com>, Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <X+Oxr6Zu5xAIY8Qp@redhat.com>
References: <20201221223041.GL6640@xz-x1>
 <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <X+JJqK91plkBVisG@redhat.com>
 <X+JhwVX3s5mU9ZNx@google.com>
 <X+Js/dFbC5P7C3oO@redhat.com>
 <X+KDwu1PRQ93E2LK@google.com>
 <X+Kxy3oBMSLz8Eaq@redhat.com>
 <X+K7JMrTEC9SpVIB@google.com>
 <20201223155235.GC6404@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201223155235.GC6404@xz-x1>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 23, 2020 at 10:52:35AM -0500, Peter Xu wrote:
> On Tue, Dec 22, 2020 at 08:36:04PM -0700, Yu Zhao wrote:
> > In your patch, do we need to take wrprotect_rwsem in
> > handle_userfault() as well? Otherwise, it seems userspace would have
> > to synchronize between its wrprotect ioctl and fault handler? i.e.,
> > the fault hander needs to be aware that the content of write-
> > protected pages can actually change before the iotcl returns.
> 
> The handle_userfault() thread should be sleeping until another uffd_wp_resolve
> fixes the page fault for it.  However when the uffd_wp_resolve ioctl comes,
> then rwsem (either the group rwsem lock as Andrea proposed, or the mmap_sem, or
> any new rwsem lock we'd like to introduce, maybe per-uffd rather than per-mm)
> should have guaranteed the previous wr-protect ioctls are finished and tlb must
> have been flushed until this thread continues.
> 
> And I don't know why it matters even if the data changed - IMHO what uffd-wp

The data will change indeed and it's fine.

> wants to do is simply to make sure after wr-protect ioctl returns to userspace,
> no change on the page should ever happen anymore.  So "whether data changed"
> seems matter more on the ioctl thread rather than the handle_userfault()
> thread.  IOW, I think data changes before tlb flush but after pte wr-protect is
> always fine - but that's not fine anymore if the syscall returns.

Agreed.

From the userland point of view all it matters is that the writes
through the stale TLB entries will stop in both the two cases:

1) before returning from the UFFDIO_WRITEPROTECT(mode_wp = true) ioctl syscall

2) before a parallel UFFDIO_WRITEPROTECT(mode_wp = false) can clear
   the _PAGE_UFFD_WP marker in the pte/hugepmd under the PT lock,
   assuming the syscall at point 1) is still in flight

Both points are guaranteed at all times by the group lock now, so
userland cannot even measure or perceive the existence of any stale
TLB at any given time in the whole uffd-wp workload.

So it's perfectly safe and identical as NUMA balancing and requires
zero extra locking in handle_userfault().

handle_userfault() is a dead end that simply waits and when it's the
right time it restarts the page fault. It can have occasional false positives
after f9bf352224d7d4612b55b8d0cd0eaa981a3246cf, false positive as in
restarting too soon, but even then it's perfectly safe since it's
equivalent of one more CPU hitting the page fault path. As long as the
marker is there, any spurious userfault will re-enter
handle_userfault().

handle_userfault() doesn't care about the data and in turn it cannot
care less about any stale TLB either. Userland cares but userland
cannot make any assumption about writes being fully stopped, until the
ioctl returned anyway and by that time the pending flush will be done
and in fact by the time userland can make any assumption also the
mmap_write_lock would have been released with the first proposed patch.

Thanks,
Andrea

