Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29C221CD69
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 04:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbgGMCx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jul 2020 22:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728048AbgGMCx4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jul 2020 22:53:56 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793DEC061794
        for <stable@vger.kernel.org>; Sun, 12 Jul 2020 19:53:56 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id b4so10889840qkn.11
        for <stable@vger.kernel.org>; Sun, 12 Jul 2020 19:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LfGl8MgHNTkh4eHPxpTYeSeTP47fmrEcX6XAsbs0NMI=;
        b=Kw6VSrObxjDxE1uwXFX7RhwxDOATo6vFk6W0yzVhg0cOvCuPoaY5Vu3UbcalkfgGMz
         7qSpyIqBd2UVYIKuAKsD7zqu0AEAj6BHw/je/DGse6tg508fK+qih5rH7dezypuhlYss
         SJfc6u3W6Uf3sw97BQeoc1Ww+6JP9tm+RLAJI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LfGl8MgHNTkh4eHPxpTYeSeTP47fmrEcX6XAsbs0NMI=;
        b=LpwTTK7gia4p4s0tuIR4G0reZQy1eg96BgnbkzymMHNwkIc8WZV9d8FM5Z330BdVK8
         m5KYMS/Q44tq4xmdVGGN7J0t9Wmcuwu9bcqQGY8lkFh+B6F165fuC0L/s8T/vjFXtR1t
         cTQVMChZ71uoszZZWWYXbvQg3ryiT1uEojTi3mLt8AoJpRx8YFHN/oU0Ta7eTng8yu/6
         i2eBdipjAb4SJxvktHV2DjHgtd6sWqP2KSh14zKDQ4o+t9dVvxFEWIQhHQfsGv2QZmph
         L1gWx0ruoFdxVDOtga5n7WsaNZ5NTZHEaZ/leCDeGFDbNILLONY9OcPKvMv8Bfufao4z
         po6g==
X-Gm-Message-State: AOAM532oVQa6L1UbXwvvznlXuBIBD5r1Fm1viUh6oI2GUChHSLimoPS9
        1ksmqGeRsOj5tf1HbR2Ek2D4ww==
X-Google-Smtp-Source: ABdhPJzNUoy4InAuw5dwqvsnFRKP1vnKgkRK10qXoyJdbcfTTpEXJt4daYmo5h0D1MLrh1rHettGCw==
X-Received: by 2002:a37:4592:: with SMTP id s140mr76769699qka.245.1594608835452;
        Sun, 12 Jul 2020 19:53:55 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:cad3:ffff:feb3:bd59])
        by smtp.gmail.com with ESMTPSA id t138sm16463758qka.15.2020.07.12.19.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 19:53:54 -0700 (PDT)
Date:   Sun, 12 Jul 2020 22:53:54 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>,
        lkft-triage@lists.linaro.org, Chris Down <chris@chrisdown.name>,
        Michel Lespinasse <walken@google.com>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Brian Geffon <bgeffon@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>, pugaowei@gmail.com,
        Jerome Glisse <jglisse@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: WARNING: at mm/mremap.c:211 move_page_tables in i386
Message-ID: <20200713025354.GB3644504@google.com>
References: <CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com>
 <CAHk-=wgRcFSnQt=T95S+1dPkyvCuVAVGQ37JDvRg41h8hRqO3Q@mail.gmail.com>
 <CA+G9fYuL=xJPLbQJVzDfXB8uNiCWdXpL=joDsnATEFCzyFh_1g@mail.gmail.com>
 <CAHk-=wgB6Ds6yqbZZmscKNuAiNR2J0Pf3a8UrbdfewYxHE7SbA@mail.gmail.com>
 <20200712215041.GA3644504@google.com>
 <CAHk-=whxP0Gj70pJN5R7Qec4qjrGr+G9Ex7FJi7=_fPcdQ2ocQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whxP0Gj70pJN5R7Qec4qjrGr+G9Ex7FJi7=_fPcdQ2ocQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Linus,

On Sun, Jul 12, 2020 at 03:58:06PM -0700, Linus Torvalds wrote:
> On Sun, Jul 12, 2020 at 2:50 PM Joel Fernandes <joel@joelfernandes.org> wrote:
> >
> > I reproduced Naresh's issue on a 32-bit x86 machine and the below patch fixes it.
> > The issue is solely within execve() itself and the way it allocates/copies the
> > temporary stack.
> >
> > It is actually indeed an overlapping case because the length of the
> > stack is big enough to cause overlap. The VMA grows quite a bit because of
> > all the page faults that happen due to the copy of the args/env. Then during
> > the move of overlapped region, it finds that a PMD is already allocated.
> 
> Oh, ok, I think I see.
> 
> So the issue is that while move_normal_pmd() _itself_ will be clearing
> the old pmd entries when it copies them, the 4kB copies that happened
> _before_ this time will not have cleared the old pmd that they were
> in.
> 
> So we've had a deeper stack, and we've already copied some of it one
> page at a time, and we're done with those 4kB entries, but now we hit
> a 2MB-aligned case and want to move that down. But when it does that,
> it hits the (by now hopefully empty) pmd that used to contain the 4kB
> entries we copied earlier.
> 
> So we've cleared the page table, but we've simply never called
> pgtable_clear() here, because the page table got cleared in
> move_ptes() when it did that
> 
>                 pte = ptep_get_and_clear(mm, old_addr, old_pte);
> 
> on the previous old pte entries.
> 
> That makes sense to me. Does that match what you see? Because when I
> said it wasn't overlapped, I was really talking about that one single
> pmd move itself not being overlapped.

This matches exactly what you mentioned.

Here is some analysis with specific numbers:

Some time during execve(), the copy_strings() causes page faults. During this
the VMA is growing and new PMD is allocated during the page fault:

copy_strings: Copying args/env old process's memory 8067420 to new stack bfb0eec6 (len 4096)
handle_mm_fault: vma: bfb0d000 c0000000
handle_mm_fault: pmd_alloc: ad: bfb0dec6 ptr: f46d0bf8

Here we see that the the pmd entry's (pmd_t *) pointer value is f46d0bf8 and
the fault was on address bfb0dec6.

Similarly, I note the pattern of other copy_strings() faulting and do the
following mapping:

address space	 	pmd entry pointer
0xbfe00000-0xc0000000	f4698ff8
0xbfc00000-0xbfe00000	f4698ff0
0xbfa00000-0xbfc00000	f4698fe8

This is all from tracing the copy_strings().

Then later, the kernel decides to move the VMA down. The VMA total size 5MB.
The stack is initially at a 1MB aligned address: 0xbfb00000 . exec requests
move_page_tables() to move it down by 4MB. That is, to 0xbf700000 which is
also 1MB aligned.  This is an overlapping move.

move_page_tables starts, I see the following prints before the warning fires.

The plan of attack should be, first copy 1MB using move_ptes() like you said.
Then it hits 2MB aligned boundary and starts move_normal_pmd(). For both
move_ptes() and move_normal_pmd(), a pmd_alloc() first happens which is
printed below:

move_page_tables: move_page_tables old=bfb00000 (len:5242880) new=bf700000
move_page_tables: pmd_alloc: ad: bf700000 ptr: f4698fd8
move_page_tables: move_ptes old=bfb00000->bfc00000 new=bf700000
move_page_tables: pmd_alloc: ad: bf800000 ptr: f4698fe0
move_page_tables: move_normal_pmd: old: bfc00000-c0000000 new: bf800000 (val: 0)
move_page_tables: pmd_alloc: ad: bfa00000 ptr: f4698fe8
move_page_tables: move_normal_pmd: old: bfe00000-c0000000 new: bfa00000 (val: 34164067)

So basically, it did 1MB worth of move_ptes(), and twice 2MB worth of
move_normal_pmd.  Since the shift was only 4MB, it hit an already allocated
PMD during the second move_normal_pmd. The warning fires as that
move_normal_pmd() sees 0xbf800000 is already allocated before.

As you said, this is harmless.

One thing I observed by code reading is move_page_tables() is (in the case of
mremap)  only called for non-overlapping moves (through mremap_to() or
move_vma() as the case maybe). It makes me nervous we are doing an
overlapping move and causing some bug inadvertently.

Could you let me know if there is any reason why we should not make the new
stack's location as non-overlapping, just to keep things simple? (Assuming
we fix the issues related to overriding you mentioned below).

> > The below patch fixes it and is not warning anymore in 30 minutes of testing
> > so far.
> 
> So I'm not hugely happy with the patch, I have to admit.
> 
> Why?
> 
> Because:
> 
> > +       /* Ensure the temporary stack is shifted by atleast its size */
> > +       if (stack_shift < (vma->vm_end - vma->vm_start))
> > +               stack_shift = (vma->vm_end - vma->vm_start);
> 
> This basically overrides the random stack shift done by arch_align_stack().
> 
> Yeah, yeah, arch_align_stack() is kind of misnamed. It _used_ to do
> what the name implies it does, which on x86 is to just give the
> minimum ABI-specified 16-byte stack alignment.
> But these days, what it really does is say "align the stack pointer,
> but also shift it down by a random amount within 8kB so that the start
> of the stack isn't some repeatable thing that an attacker can
> trivially control with the right argv/envp size.."

Got it, thanks I will work on improving the patch along these lines.

> I don't think it works right anyway because we then PAGE_ALIGN() it,
> but whatever.

:)

> But it looks like what you're doing means that now the size of the
> stack will override that shift, and that means that now the
> randomization is entirely undone. No?

Yes, true. I will work on fixing it.

> Plus you do it after we've also checked that we haven't grown the
> stack down to below mmap_min_addr().
> 
> But maybe I misread that patch.
> 
> But I do feel like you figured out why the bug happened, now we're
> just discussing whether the patch is the right thing to do.

Yes.

> Maybe saying "doing the pmd copies for the initial stack isn't
> important, so let's just note this as a special case and get rid of
> the WARN_ON()" might be an alternative solution.

Personally, I feel it is better to keep the warning just so in the future we
can detect any bugs.

thanks,

 - Joel

