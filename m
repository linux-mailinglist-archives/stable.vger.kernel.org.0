Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3E52E0F51
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 21:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgLVUUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 15:20:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:52596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbgLVUUG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 15:20:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7005523133
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 20:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608668365;
        bh=mXrauKSE9SR6fvVV4uNsc75DoOCwPZAdIHnBX7if57M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aEwxO/bFWk3IH/MxTKqrjzFlAnchKQNCXcXVz5B529HTN4x2fmzTXjf8xJjN/uldl
         fc6EX/84JFTXxFGnzli6OAL5KavuHZl4veW5AfmtlXBezn+bKB3HHxXuXFkBULbvoo
         lx1pw4beDG9SeRmTML1dMDFWKYKFeiBSsYldq7oDaqgSP7zW3V9TlmsfwnizhkbF2f
         eNvQAc0HQ5U8YQ7xd7N7MmPa9FKBZ27KEWNYTc5vxqm/iJq+wyhTHjeSIkS8RE9JGo
         itH9HPZONETy9Ntd6nUgZFl3qeQIALwVfTFef6C4QzYKPwo2PnFqUKV7vvPlttK09t
         t9JSRb6eGVYOQ==
Received: by mail-wr1-f50.google.com with SMTP id m5so15819831wrx.9
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 12:19:25 -0800 (PST)
X-Gm-Message-State: AOAM530iimxoHvZIjuZLeXP6DeLpcWYPKmGMsjLH6Jv3TmlxMFtmV8Rc
        XXIB20eqjRJhvqANCLD6LG7AjgJQmmD/awvFSWPnGg==
X-Google-Smtp-Source: ABdhPJz6jcNMaCJEbA/qYO2R4S8Dxtkj7kmxvWhr/9NQt2mGn5LTdId4WdOeqrSgFEr9UzhLFIEXP10x0wfqWAT6xLI=
X-Received: by 2002:adf:e64b:: with SMTP id b11mr25822587wrn.257.1608668363950;
 Tue, 22 Dec 2020 12:19:23 -0800 (PST)
MIME-Version: 1.0
References: <X97pprdcRXusLGnq@google.com> <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com>
 <20201221172711.GE6640@xz-x1> <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
 <X+D0hTZCrWS3P5Pi@google.com> <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com> <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com> <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1> <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com> <CAHk-=wj=CcOHQpG0cUGfoMCt2=Uaifpqq-p-mMOmW8XmrBn4fQ@mail.gmail.com>
In-Reply-To: <CAHk-=wj=CcOHQpG0cUGfoMCt2=Uaifpqq-p-mMOmW8XmrBn4fQ@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 22 Dec 2020 12:19:11 -0800
X-Gmail-Original-Message-ID: <CALCETrVdT4jSa3UKU8rQ2KO8CE1Jq2r23ZwuqmynAo6kYUwA=Q@mail.gmail.com>
Message-ID: <CALCETrVdT4jSa3UKU8rQ2KO8CE1Jq2r23ZwuqmynAo6kYUwA=Q@mail.gmail.com>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andy Lutomirski <luto@kernel.org>, Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>, Yu Zhao <yuzhao@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 21, 2020 at 8:16 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, Dec 21, 2020 at 7:19 PM Andy Lutomirski <luto@kernel.org> wrote:
> >
> > Ugh, this is unpleasantly complicated.
>
> What I *should* have said is that *because* userfaultfd is changing
> the VM layout, it should always act as if it had to take the mmap_sem
> for writing, and that the RW->RO change is an example of when
> downgrading that write-lock to a read lock is simply not valid -
> because it basically breaks the rules about what a lookup (ie a read)
> can do.
>
> A lookup can never turn a writable page non-writable. A lookup -
> through COW - _can_ turn a read-only page writable. So that's why
> "RO->RW" can be ok under the read lock, but RW->RO is not.
>
> Does that clarify the situation when I phrase it that way instead?

It's certainly more clear, but I'm still not thrilled with a bunch of
functions in different files maintained by different people that
cooperate using an undocumented lockless protocol.  It makes me
nervous from a maintainability standpoint even if the code is, in
fact, entirely correct.

But I didn't make my question clear either: when I asked about
mark_screen_rdonly(), I wasn't asking about locking or races at all.
mark_screen_rdonly() will happily mark *any* PTE readonly.  I can
easily believe that writable mappings of non-shared mappings all
follow the same CoW rules in the kernel and that, assuming all the
locking is correct, marking them readonly is conceptually okay.  But
shared mappings are a whole different story.  Is it actually the case
that all, or even most, drivers and other sources of shared mappings
will function correctly if one of their PTEs becomes readonly behind
their back?  Or maybe there are less bizarre ways for this to happen
without vm86 shenanigans and this is completely safe after all.

P.S. This whole mess reminds me that I need to take a closer look at
the upcoming SHSTK code.  Shadow stack pages violate all common sense
about how the various PTE bits work.
