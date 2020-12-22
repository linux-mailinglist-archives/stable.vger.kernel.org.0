Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24C82E0F5B
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 21:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbgLVU1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 15:27:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44179 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727231AbgLVU1h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 15:27:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608668770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s7akrYpynUQd+BLDMzyxOvN0FZj7YM32yeR9YZxTgZw=;
        b=hjiglSOhEJ8p3qdrhk0jrBvcpfIhE7bH56urC7EakRZgGDrj3YxGsnhSJApVKZY9gIXxkF
        fWipWpk4DXp9S10T2ZQuFJ3IA3Mp/bU3EiGt4N6dFzxDVkeNE8vAuDvg99Xw5evXHDcOCX
        U9InMe57kIGlWC+kHf7Qpm4nfR8KC7U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-KhixZ06fOeqJknDg46z2uA-1; Tue, 22 Dec 2020 15:26:08 -0500
X-MC-Unique: KhixZ06fOeqJknDg46z2uA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE031180E469;
        Tue, 22 Dec 2020 20:26:06 +0000 (UTC)
Received: from mail (ovpn-112-5.rdu2.redhat.com [10.10.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A34BB5D9CC;
        Tue, 22 Dec 2020 20:26:03 +0000 (UTC)
Date:   Tue, 22 Dec 2020 15:26:03 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>, Yu Zhao <yuzhao@google.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X+JWW/Q5kNGhG8JM@redhat.com>
References: <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1>
 <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <X+JJqK91plkBVisG@redhat.com>
 <20201222201553.GM874@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201222201553.GM874@casper.infradead.org>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 22, 2020 at 08:15:53PM +0000, Matthew Wilcox wrote:
> On Tue, Dec 22, 2020 at 02:31:52PM -0500, Andrea Arcangeli wrote:
> > My previous suggestion to use a mutex to serialize
> > userfaultfd_writeprotect with a mutex will still work, but we can run
> > as many wrprotect and un-wrprotect as we want in parallel, as long as
> > they're not simultaneous, we can do much better than a mutex.
> > 
> > Ideally we would need a new two_group_semaphore, where each group can
> > run as many parallel instances as it wants, but no instance of one
> > group can run in parallel with any instance of the other group. AFIK
> > such a kind of lock doesn't exist right now.
> 
> Kent and I worked on one for a bit, and we called it a red-black mutex.
> If team red had the lock, more members of team red could join in.
> If team black had the lock, more members of team black could join in.
> I forget what our rule was around fairness (if team red has the lock,
> and somebody from team black is waiting, can another member of team red
> take the lock, or must they block?)

In this case they would need to block and provide full fairness.

Well maybe just a bit of unfariness (to let a few more through the
door before it shuts) wouldn't be a deal breaker but it would need to
be bound or it'd starve the other color/side indefinitely. Otherwise
an ioctl mode_wp = true would block forever, if more ioctl mode_wp =
false keep coming in other CPUs (or the other way around).

The approximation with rwsem and two atomics provides full fariness in
both read and write mode (originally the read would stave the write
IIRC which was an issue for all mprotect etc.. not anymore thankfully).

> It was to solve the direct-IO vs buffered-IO problem (you can have as many
> direct-IO readers/writers at once or you can have as many buffered-IO
> readers/writers at once, but exclude a mix of direct and buffered I/O).
> In the end, we decided it didn't work all that well.

Well mixing buffered and direct-IO is certainly not a good practice so
it's reasonable to leave it up to userland to serialize if such mix is
needed, the kernel behavior is undefined if the mix is concurrent out
of order.

