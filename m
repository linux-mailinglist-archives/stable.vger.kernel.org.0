Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9EA22E0FDC
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 22:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgLVVft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 16:35:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36532 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726384AbgLVVfs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 16:35:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608672862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yBqsHakSTD7XDsy5mwErSb3uXLotZdoXMrPlsNRLmNc=;
        b=IthgD/QzXJjm9B5+5HhsZodOzf7dzrpPkI9z0uiFqUbf6pj3wiNaY0thGB+6DhhwTqLUEz
        xTq0weRIXIF8+AY3+mbQqqVPnSo1Xiw/s4wkPxzy6YhGNTTnIirpA5SVXO5icinN+q/enB
        sSChuqtiCW+8PZAh1FX/UyONthPtYP8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-yRAbj35rPkKUEfuqOGmmYg-1; Tue, 22 Dec 2020 16:34:20 -0500
X-MC-Unique: yRAbj35rPkKUEfuqOGmmYg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6AD9C1005513;
        Tue, 22 Dec 2020 21:34:18 +0000 (UTC)
Received: from mail (ovpn-112-5.rdu2.redhat.com [10.10.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 43C8E10013C1;
        Tue, 22 Dec 2020 21:34:15 +0000 (UTC)
Date:   Tue, 22 Dec 2020 16:34:14 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Andy Lutomirski <luto@kernel.org>, linux-mm <linux-mm@kvack.org>,
        Peter Xu <peterx@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X+JmVmDvBOYuw5Zl@redhat.com>
References: <20201219043006.2206347-1-namit@vmware.com>
 <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
 <DD367393-D1B3-4A84-AF92-9C6BAEAB40DC@gmail.com>
 <CALCETrXLH7vPep-h4fBFSft1YEkyZQo_7W2uh017rHKYT=Occw@mail.gmail.com>
 <719DF2CD-A0BC-4B67-9FBA-A9E0A98AA45E@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <719DF2CD-A0BC-4B67-9FBA-A9E0A98AA45E@gmail.com>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 22, 2020 at 12:58:18PM -0800, Nadav Amit wrote:
> I had somewhat similar ideas - saving in each page-struct the generation,
> which would allow to: (1) extend pte_same() to detect interim changes
> that were reverted (RO->RW->RO) and (2) per-PTE pending flushes.

What don't you feel safe about, what's the problem with RO->RO->RO, I
don't get it.

The pte_same is perfectly ok without sequence counter in my view, I
never seen anything that would not be ok with pte_same given all the
invariant are respected. It's actually a great optimization compared
to any unscalable sequence counter.

The counter would slowdown everything, having to increase a counter
every time you change a pte, no matter if it's a counter per pgtable
or per-vma or per-mm, sounds very bad.

I'd rather prefer to take mmap_lock_write across the whole userfaultfd
ioctl, than having to deal with a new sequence counter increase for
every pte modification on a heavily contended cacheline.

Also note the counter would have solved nothing for
userfaultfd_writeprotect, it's useless to detect stale TLB entries.

See how !pte_write check happens after the counter was already increased:

CPU0			CPU 1		CPU 2
------			--------	-------
userfaultfd_wrprotect(mode_wp = true)
PT lock
atomic set _PAGE_UFFD_WP and clear _PAGE_WRITE
false_shared_counter_counter++ 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
PT unlock

			do_page_fault FAULT_FLAG_WRITE
					userfaultfd_wrprotect(mode_wp = false)
					PT lock
					ATOMIC clear _PAGE_UFFD_WP <- problem
					/* _PAGE_WRITE not set */
					false_shared_counter_counter++ 
					^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					PT unlock
					XXXXXXXXXXXXXX BUG RACE window open here

			PT lock
			counter = false_shared_counter_counter
			^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
			FAULT_FLAG_WRITE is set by CPU
			_PAGE_WRITE is still clear in pte
			PT unlock

			wp_page_copy
			copy_user_page runs with stale TLB

			pte_same(counter, orig_pte, pte) -> PASS
				 ^^^^^^^                    ^^^^
			commit the copy to the pte with the lost writes

deferred tlb flush <- too late
XXXXXXXXXXXXXX BUG RACE window close here
================================================================================

