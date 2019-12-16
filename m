Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49D1A120788
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 14:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbfLPNrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 08:47:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40188 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727579AbfLPNrw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 08:47:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2KLAN4ZBm7mQw6EPErstooeuDqde0MxZ8aeQqGLKk1U=; b=3iCBytLQJTNQKbERk1Ou0Oa8r
        OxTzGqtSGn15JzRVQE+Jmcq1kQjgF/gMYSzRaMsauBjxCsMymuuB42kedoFb3sPqYMRCcuiS+CPrH
        bfgZW35CWZDsTbAb94g/W98U+aVd++jAj/rmwOtuzSbWq9EXcnOQ6s9ll94fdKB+W9NcgGZwnwhtQ
        VVYAlw3UUyFSymkgWjUjb0vpLgMQjHMOa/2aHAV8jc3NhPJ3/uL4KXHR0ryqpOuApmYZxZMqx89g2
        kjsuH5c+qV6pHm39ajE6tLHJhEE9BX7G0nu7YyFLSguEwedR+yqXezfy5OgEaAqXySQ1HgMTs33Ck
        LceJjZakA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1igqid-0007BC-11; Mon, 16 Dec 2019 13:47:27 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 319D83007F2;
        Mon, 16 Dec 2019 14:46:03 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5CB252B2A010B; Mon, 16 Dec 2019 14:47:25 +0100 (CET)
Date:   Mon, 16 Dec 2019 14:47:25 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Ajay Kaher <akaher@vmware.com>, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        punit.agrawal@arm.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, willy@infradead.org,
        will.deacon@arm.com, mszeredi@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, srivatsab@vmware.com,
        srivatsa@csail.mit.edu, amakhalov@vmware.com, srinidhir@vmware.com,
        bvikas@vmware.com, anishs@vmware.com, vsirnapalli@vmware.com,
        srostedt@vmware.com, Vlastimil Babka <vbabka@suse.cz>,
        Oscar Salvador <osalvador@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v3 8/8] x86, mm, gup: prevent get_page() race with munmap
 in paravirt guest
Message-ID: <20191216134725.GE2827@hirez.programming.kicks-ass.net>
References: <1576529149-14269-1-git-send-email-akaher@vmware.com>
 <1576529149-14269-9-git-send-email-akaher@vmware.com>
 <20191216130443.GN2844@hirez.programming.kicks-ass.net>
 <87lfrc9z3v.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lfrc9z3v.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 02:30:44PM +0100, Vitaly Kuznetsov wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > On Tue, Dec 17, 2019 at 02:15:48AM +0530, Ajay Kaher wrote:
> >> From: Vlastimil Babka <vbabka@suse.cz>
> >> 
> >> The x86 version of get_user_pages_fast() relies on disabled interrupts to
> >> synchronize gup_pte_range() between gup_get_pte(ptep); and get_page() against
> >> a parallel munmap. The munmap side nulls the pte, then flushes TLBs, then
> >> releases the page. As TLB flush is done synchronously via IPI disabling
> >> interrupts blocks the page release, and get_page(), which assumes existing
> >> reference on page, is thus safe.
> >> However when TLB flush is done by a hypercall, e.g. in a Xen PV guest, there is
> >> no blocking thanks to disabled interrupts, and get_page() can succeed on a page
> >> that was already freed or even reused.
> >> 
> >> We have recently seen this happen with our 4.4 and 4.12 based kernels, with
> >> userspace (java) that exits a thread, where mm_release() performs a futex_wake()
> >> on tsk->clear_child_tid, and another thread in parallel unmaps the page where
> >> tsk->clear_child_tid points to. The spurious get_page() succeeds, but futex code
> >> immediately releases the page again, while it's already on a freelist. Symptoms
> >> include a bad page state warning, general protection faults acessing a poisoned
> >> list prev/next pointer in the freelist, or free page pcplists of two cpus joined
> >> together in a single list. Oscar has also reproduced this scenario, with a
> >> patch inserting delays before the get_page() to make the race window larger.
> >> 
> >> Fix this by removing the dependency on TLB flush interrupts the same way as the
> >
> > This is suppsed to be fixed by:
> >
> > arch/x86/Kconfig:       select HAVE_RCU_TABLE_FREE              if PARAVIRT
> >
> 
> Yes,
> 
> but HAVE_RCU_TABLE_FREE was enabled on x86 only in 4.14:
> 
> commit 9e52fc2b50de3a1c08b44f94c610fbe998c0031a
> Author: Vitaly Kuznetsov <vkuznets@redhat.com>
> Date:   Mon Aug 28 10:22:51 2017 +0200
> 
>     x86/mm: Enable RCU based page table freeing (CONFIG_HAVE_RCU_TABLE_FREE=y)
> 
> and, if I understood correctly, Ajay is suggesting the patch for older
> stable kernels (4.9 and 4.4 I would guess).

It wasn't at all clear this was targeted at old kernels (I only got this
one patch).

And why can't those necro kernels do backports of the upstream solution?
