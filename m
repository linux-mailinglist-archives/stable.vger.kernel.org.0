Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53632E229E
	for <lists+stable@lfdr.de>; Thu, 24 Dec 2020 00:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgLWXGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 18:06:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40398 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726319AbgLWXGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 18:06:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608764708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4IW+6Ci7VWnkZSEHQFQsV4N3ToaQGHBeykrTby9wxas=;
        b=NC4AKFw531KPD4dcvwrFk6dKvYYAX6E6XfLtVVGD7NH29XQtGz3VKMifUPje+W2qrF/uUi
        JgEKLa6DPj9n5jgwIs2nu+ZRO8h2Ao9L4N2DyNIDGkZ5WGYe7IgFrv7wG7A9SFFaMbv+5j
        pZT0BPsiDn44KjawBiCMwYIuRsM+UHg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-wDBks589Py2W9rDH4oAFuQ-1; Wed, 23 Dec 2020 18:05:04 -0500
X-MC-Unique: wDBks589Py2W9rDH4oAFuQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5A721005504;
        Wed, 23 Dec 2020 23:05:01 +0000 (UTC)
Received: from mail (ovpn-112-5.rdu2.redhat.com [10.10.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 47D0D63747;
        Wed, 23 Dec 2020 23:04:58 +0000 (UTC)
Date:   Wed, 23 Dec 2020 18:04:57 -0500
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
Message-ID: <X+PNGYH6LkzZo0SU@redhat.com>
References: <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <X+JJqK91plkBVisG@redhat.com>
 <X+JhwVX3s5mU9ZNx@google.com>
 <X+Js/dFbC5P7C3oO@redhat.com>
 <X+KDwu1PRQ93E2LK@google.com>
 <X+Kxy3oBMSLz8Eaq@redhat.com>
 <X+K7JMrTEC9SpVIB@google.com>
 <X+O49HrcK1fBDk0Q@redhat.com>
 <X+PE38s2Egq4nzKv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X+PE38s2Egq4nzKv@google.com>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 23, 2020 at 03:29:51PM -0700, Yu Zhao wrote:
> I was hesitant to suggest the following because it isn't that straight
> forward. But since you seem to be less concerned with the complexity,
> I'll just bring it on the table -- it would take care of both ufd and
> clear_refs_write, wouldn't it?

It certainly would since this is basically declaring "leaving stale
TLB entries past mmap_read_lock" is now permitted as long as the
pending flush counter is elevated under mmap_sem for reading.

Anything that prevents uffd-wp to take mmap_write_lock looks great to
me, anything, the below included, as long as it looks like easy to
enforce and understand. And the below certainly is.

My view is that the below is at the very least an improvement in terms
of total complexity, compared to v5.10. At least it'll be documented.

So what would be not ok to me is to depend on undocumented not
guaranteed behavior in do_wp_page like the page_mapcount, which is
what we had until now in clear_refs_write and in uffd-wp (but only if
wrprotect raced against un-wrprotect, a tiny window if compared to
clear_refs_write).

Documenting that clearing pte_write and deferring the flush is allowed
if mm_tlb_flush_pending was elevated before taking the PT lock is less
complex and very well defined rule, if compared to what we had before
in the page_mapcount dependency of clear_refs_write which was prone to
break, and in fact it just did.

We'll need a commentary in both userfaultfd_writeprotect and
clear_refs_write that links to the below snippet.

If we abstract it in a header we can hide there also a #ifdef
CONFIG_HAVE_ARCH_SOFT_DIRTY=y && CONFIG_HAVE_ARCH_USERFAULTFD_WP=y &&
CONFIG_USERFAULTFD=y to make it even more explicit.

However it may be simpler to keep it unconditional, I don't mind
either ways. If it was up to me I'd write it to those 3 config options
to be sure I remember where it comes from and to force any other user
to register to be explicit they depend on that.

> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 5e9ca612d7d7..af38c5ee327e 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4403,8 +4403,11 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
>  		goto unlock;
>  	}
>  	if (vmf->flags & FAULT_FLAG_WRITE) {
> -		if (!pte_write(entry))
> +		if (!pte_write(entry)) {
> +			if (mm_tlb_flush_pending(vmf->vma->vm_mm))
> +				flush_tlb_page(vmf->vma, vmf->address);
>  			return do_wp_page(vmf);
> +		}
>  		entry = pte_mkdirty(entry);
>  	}
>  	entry = pte_mkyoung(entry);
> 

