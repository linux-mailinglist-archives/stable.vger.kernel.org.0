Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E700B2DF2CE
	for <lists+stable@lfdr.de>; Sun, 20 Dec 2020 03:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgLTCvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 21:51:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30158 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726786AbgLTCvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 21:51:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608432595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NoHRpV085pjeRA/k08rN9TlOWSM2SBKc9GvOdVexZRU=;
        b=PL7HL7DYXR3kMLnG3ZQ3yVRpYytkHB04z4vd8CkuFLLxdM5/WWf73AlpBW2IyDetbdH3+Y
        kevc8CWfhRcBMWs/qYMFFUIbYLK6vId6aaaQahH1RbDvVtTV7UkCIeQUH5AqU4wwjgDyzz
        fucfa1QOssXijuwVLG4TaZZX0M7LBkY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-sbqyOewWMcmhWZBgBKFAcQ-1; Sat, 19 Dec 2020 21:49:52 -0500
X-MC-Unique: sbqyOewWMcmhWZBgBKFAcQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A2B21005513;
        Sun, 20 Dec 2020 02:49:50 +0000 (UTC)
Received: from mail (ovpn-119-164.rdu2.redhat.com [10.10.119.164])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9989F19D9C;
        Sun, 20 Dec 2020 02:49:45 +0000 (UTC)
Date:   Sat, 19 Dec 2020 21:49:45 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Nadav Amit <nadav.amit@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        linux-mm <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X967yWAoaTejRk5y@redhat.com>
References: <20201219043006.2206347-1-namit@vmware.com>
 <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
 <CALCETrVtsdeOtGWMUcmT1dzDBxRpecpZDe02L61qEmJmFxSvYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVtsdeOtGWMUcmT1dzDBxRpecpZDe02L61qEmJmFxSvYw@mail.gmail.com>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 19, 2020 at 06:01:39PM -0800, Andy Lutomirski wrote:
> I missed the beginning of this thread, but it looks to me like
> userfaultfd changes PTEs with not locking except mmap_read_lock().  It

There's no mmap_read_lock, I assume you mean mmap_lock for reading.

The ptes are changed always with the PT lock, in fact there's no
problem with the PTE updates. The only difference with mprotect
runtime is that the mmap_lock is taken for reading. And the effect
contested for this change doesn't affect the PTE, but supposedly the
tlb flushing deferral.

The change_protection_range is identical to what already happens with
zap_page_range. zap_page_range is called with mmap_lock for reading
in MADV_DONTNEED, and by munmap with mmap_lock for
writing. change_protection_range is called with mmap_lock for writing
by mprotect, and mmap_lock for reading by UFFDIO_WRITEPROTECT.

> also calls inc_tlb_flush_pending(), which is very explicitly
> documented as requiring the pagetable lock.  Those docs must be wrong,

The comment in inc_tlb_flush_pending() shows the pagetable lock is
taken after inc_tlb_flush_pending():

	 *	atomic_inc(&mm->tlb_flush_pending);
	 *	spin_lock(&ptl);

> because mprotect() uses the mmap_sem write lock, which is just fine,
> but ISTM some kind of mutual exclusion with proper acquire/release
> ordering is indeed needed.  So the userfaultfd code seems bogus.

If there's a bug, it'd be nice to fix without taking the mmap_lock for
writing.

The vma is guaranteed not modified, so I think it'd be pretty bad if
we had to give in the mmap_lock for writing just to wait for a tlb
flush that is issued deferred in the context of
userfaultfd_writeprotect.

> I think userfaultfd either needs to take a real lock (probably doesn't
> matter which) or the core rules about PTEs need to be rewritten.

It's not exactly clear how the do_wp_page could run on cpu1 before the
unprotect did an extra flush, I guess the trace needs one more
cpu/thread?

Anyway to wait the wrprotect to do the deferred flush, before the
unprotect can even start, one more mutex in the mm to take in all
callers of change_protection_range with the mmap_lock for reading may
be enough.

Thanks,
Andrea

