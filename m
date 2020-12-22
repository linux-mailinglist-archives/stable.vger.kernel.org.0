Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C292E0FCB
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 22:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgLVVT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 16:19:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22554 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726540AbgLVVT3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 16:19:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608671882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AkoOcriox08aICF4e6yOPafNyaUMgYdVf0PsmAE3Q6M=;
        b=XYXp0NjYLfJqd4A/cDYFLPDVfkR0CDlgLRO3u1ZmaLuaySTGiSOj4/x/9666ckBGpgPgbe
        86o5Jf0QWEAMYkfAuIY82HV4/qVLvtFUngFH3vXaZ2QCCr9ADTFLQy6TNgnJbyOBqopusY
        6a3FT0OhYoX0CjxO5WQCezOjg8XlHPI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-JTGTxLJxM1aM-UHzYI6zKg-1; Tue, 22 Dec 2020 16:18:00 -0500
X-MC-Unique: JTGTxLJxM1aM-UHzYI6zKg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F14028042A2;
        Tue, 22 Dec 2020 21:17:57 +0000 (UTC)
Received: from mail (ovpn-112-5.rdu2.redhat.com [10.10.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C4B5960BF1;
        Tue, 22 Dec 2020 21:17:53 +0000 (UTC)
Date:   Tue, 22 Dec 2020 16:17:53 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Peter Xu <peterx@redhat.com>, Yu Zhao <yuzhao@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X+JigY1DLyafCBJW@redhat.com>
References: <X+D0hTZCrWS3P5Pi@google.com>
 <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1>
 <B8095F3C-81E3-4AF9-A6A5-F597D51264BD@gmail.com>
 <X+JMiHv+EktzyZgr@redhat.com>
 <E9A1084A-30B3-4328-8B0D-31AD978375AD@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E9A1084A-30B3-4328-8B0D-31AD978375AD@gmail.com>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 22, 2020 at 12:19:49PM -0800, Nadav Amit wrote:
> Perhaps any change to PTE in a page-table should increase a page-table
> generation that we would save in the page-table page-struct (next to the

The current rule is that by the time in the page fault we find a
pte/hugepmd in certain state under the "PT lock", the TLB cannot be
left stale with a more permissive state at that point.

So if under "PT lock" the page fault sees !pte_write, it means no
other CPU can possibly modify the page anymore.

That must be enforced at all times, no sequence number is required if
you enforce that and the whole point of the fix is to enforce that.

This is how things always worked in the page fault and it's perfectly
fine.

For the record I never suggested to change anything in the page fault
code.

So the only way we can leave stale TLB after dropping PT lock with the
mmap_read_lock and concurrent page faults is with a marker:

1) take PT lock
2) leave in the pte/hugepmd a unique identifiable marker
3) change the pte to downgrade permissions
4) drop PT lock and leave stale TLB entries with the upgraded permissions

In point 3) the pte is built in a way that is guaranteed to trigger a
deterministic path in the page fault. And in the way of that
deterministic path you put the marker check for 2) to send the fault
to a dead-end where the stale TLB is actually irrelevant and harmless.

No change to the page fault is needed if you only enforce the above.

Even if we'd take the mmap_write_lock in userfaultfd_writeprotect, you
will still have to deal with the above technique because of
change_prot_numa().

Would you suggest to add a sequence counter and to change all pte_same
in order to make change_prot_numa safer or is it safe enough already
using the above technique that checks the marker in the page fault?

To be safe NUMA balancing is using the same mechanism above of sending
the page fault into a dead end, in order to call the very same
function (change_permissions) with the very same lock (mmap_read_lock)
as userfaultfd_writeprotect.

What happens then in do_numa_page then is different than what happens
in handle_userfault, but both are a dead ends as far as the page fault
code is concerned and they will never come back to the page fault
code. That's how they avoid breaking the page fault.

The final rule for the above logic to work safe for uffd, is that the
marker cannot be cleared until after the deferred TLB flush is
executed (that's where the window for the race existed, and the fix
closed such window).

do_numa_page differs in clearing the marker while the TLB flush still
pending, but it can do that because it puts the same exact pte value
(with the upgraded permissions) that was there before it put the
marker in the pte. In turn do_numa_page makes the pending TLB flush
becomes a noop and it doesn't need to wait for it before removing the
marker. Does that last difference in how the marker is cleared,
warrant to consider what NUMA balancing radically different so to
forbid userfaultfd_writeprotect to use the same logic in the very same
function with the very same lock in order to decrease the VM
complexity? In my view no.

Thanks,
Andrea

