Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3963E2E22DA
	for <lists+stable@lfdr.de>; Thu, 24 Dec 2020 00:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbgLWX4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 18:56:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53471 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727396AbgLWX4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 18:56:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608767718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fX9BrNYtyqUJqlsQzDSDD/LvzkNk1AuVbPuwYkphfN8=;
        b=B5+dGlJsrEAuD+7fCzNVP2eXQyNsjq4LkCzQy8tgzIRsdFqadtSsnJd2U5DKBaOfMncdGc
        mdKeaUUIXY/FdOcS5ke4lP3drKSqAnZ+DhSPnF+IEy/MgkH5lNdUM3v1vaQGCxak7+0g7c
        zRdTvvm8Lkx00GX8oPEOoai/YaFZqsY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-9uL81yDSN_yiXHLV5Sjddg-1; Wed, 23 Dec 2020 18:55:17 -0500
X-MC-Unique: 9uL81yDSN_yiXHLV5Sjddg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15FB1801AC0;
        Wed, 23 Dec 2020 23:55:15 +0000 (UTC)
Received: from mail (ovpn-112-5.rdu2.redhat.com [10.10.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E4405D74C;
        Wed, 23 Dec 2020 23:55:11 +0000 (UTC)
Date:   Wed, 23 Dec 2020 18:55:11 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Yu Zhao <yuzhao@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Minchan Kim <minchan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X+PY3zQeYNnheZhT@redhat.com>
References: <20201221172711.GE6640@xz-x1>
 <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
 <X+D0hTZCrWS3P5Pi@google.com>
 <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <D4916F41-DE4A-42C6-8702-944382631A02@gmail.com>
 <X+O/HT6d+UOa4GfB@redhat.com>
 <F63B134B-C824-4FC1-BE6F-9E03DF947D50@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F63B134B-C824-4FC1-BE6F-9E03DF947D50@gmail.com>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 23, 2020 at 02:45:59PM -0800, Nadav Amit wrote:
> I think it may be reasonable.

Whatever solution used, there will be 2 users of it: uffd-wp will use
whatever technique used by clear_refs_write to avoid the
mmap_write_lock.

My favorite is Yu's patch and not the group lock anymore. The cons is
it changes the VM rules (which kind of reminds me my initial proposal
of adding a spurious tlb flush if mm_tlb_flush_pending is set, except
I didn't correctly specify it'd need to go in the page fault), but it
still appears the simplest.

> Just a proposal: At some point we can also ask ourselves whether the
> “artificial" limitation of the number of software bits per PTE should really
> limit us, or do we want to hold some additional metadata per-PTE by either
> putting it in an adjacent page (holding 64-bits of additional software-bits
> per PTE) or by finding some place in the page-struct to link to this
> metadata (and have the liberty of number of bits per PTE). One of the PTE
> software-bits can be repurposed to say whether there is “extra-metadata”
> associated with the PTE.
> 
> I am fully aware that there will be some overhead associated, but it
> can be limited to less-common use-cases.

That's a good point, so far far we didn't run out so it's not an
immediate concern. (as opposed we run out in page->flags where the
PG_tail went to some LSB).

In general kicking the can down the road sounds like the best thing to
do for those bit shortage matters, until we can't anymore at
least.. There's no gain to the kernel runtime, in doing something
generically good here (again see where PG_tail rightfully went).

So before spending RAM and CPU, we'd need to find a more compact
encoding with the bits we already have available.

This reminds me again we could double check if we could make
VM_UFFD_WP mutually exclusive with VM_SOFTDIRTY.

I wasn't sure if it could ever happen in a legit way to use both at
the same time (CRIU on a app using uffd-wp for its own internal mm
management?).

Theoretically it's too late already for it, but VM_UFFD_WP is
relatively new, if we're sure it cannot ever happen in a legit way, it
would be possible to at least evaluate/discuss it. This is an
immediate matter.

What we'll do if we later run out, is not an immediate matter instead,
because it won't make our life any simpler to resolve it now.

Thanks,
Andrea

