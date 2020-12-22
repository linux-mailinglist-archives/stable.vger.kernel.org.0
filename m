Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF7AC2E0F6B
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 21:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgLVUfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 15:35:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:57876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgLVUfc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 15:35:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBE2522B2B
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 20:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608669292;
        bh=p6xKICnqooK/rn2BF9K9yaO+3IBNYsaVfdCpfQPveGU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SLKXP6jrkz/rqEjR50YozmGriXfGRnR3X8pWmdzGRL4xrqf0CgvW0SEv4e+UYJ8Vt
         mqWWztiFWl9oqLT9EwcQl5K/BYtEcauJ382MV5Ew7Ajtt38YjOCGQkffUYQTCxvp+Y
         6tKdgjoHKK0ZcUtt3wxn+5pW1pxRBchufAOxarwtuWqk+jGmI/LlZFyMxxTFV0ZjZf
         m6sVGdFSWTTjJgRUF2Zr6mioXLy/xo03f19tplhp9NvZhmF7Njhqh6m8uwyeuotF9c
         EXGEOPiwBSFliAHbbYuMCvxDeJoTBvQL+R/Lz+4mtVJURQqTSs/WnXqD+W+UW39EKa
         5VVGKwdkYBekg==
Received: by mail-wr1-f52.google.com with SMTP id 91so15997622wrj.7
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 12:34:51 -0800 (PST)
X-Gm-Message-State: AOAM530XOHTQAx+OCuoylblK0hW5cvLDZCBTOmB6ISdEHY/uMnsuEJyR
        PpZ4I72tup2iVpclNa13NU66lxC/30TQcurMYPYq2A==
X-Google-Smtp-Source: ABdhPJwO+xzWqh2HS90TjCvmcwzK37BMFuVHXXj/xQOQL2gX5GxNaX+rXIJ8+69OQJax3KDvljpQFskv6YHY3ZzT1Zs=
X-Received: by 2002:a5d:43c3:: with SMTP id v3mr25514235wrr.184.1608669290441;
 Tue, 22 Dec 2020 12:34:50 -0800 (PST)
MIME-Version: 1.0
References: <20201219043006.2206347-1-namit@vmware.com> <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com> <DD367393-D1B3-4A84-AF92-9C6BAEAB40DC@gmail.com>
In-Reply-To: <DD367393-D1B3-4A84-AF92-9C6BAEAB40DC@gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 22 Dec 2020 12:34:38 -0800
X-Gmail-Original-Message-ID: <CALCETrXLH7vPep-h4fBFSft1YEkyZQo_7W2uh017rHKYT=Occw@mail.gmail.com>
Message-ID: <CALCETrXLH7vPep-h4fBFSft1YEkyZQo_7W2uh017rHKYT=Occw@mail.gmail.com>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Andy Lutomirski <luto@kernel.org>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 19, 2020 at 2:06 PM Nadav Amit <nadav.amit@gmail.com> wrote:
> > [ I have in mind another solution, such as keeping in each page-table a
> > =E2=80=9Ctable-generation=E2=80=9D which is the mm-generation at the ti=
me of the change,
> > and only flush if =E2=80=9Ctable-generation=E2=80=9D=3D=3D=E2=80=9Cmm-g=
eneration=E2=80=9D, but it requires
> > some thought on how to avoid adding new memory barriers. ]
> >
> > IOW: I think the change that you suggest is insufficient, and a proper
> > solution is too intrusive for =E2=80=9Cstable".
> >
> > As for performance, I can add another patch later to remove the TLB flu=
sh
> > that is unnecessarily performed during change_protection_range() that d=
oes
> > permission promotion. I know that your concern is about the =E2=80=9Cpr=
otect=E2=80=9D case
> > but I cannot think of a good immediate solution that avoids taking mmap=
_lock
> > for write.
> >
> > Thoughts?
>
> On a second thought (i.e., I don=E2=80=99t know what I was thinking), doi=
ng so =E2=80=94
> checking mm_tlb_flush_pending() on every PTE read which is potentially
> dangerous and flushing if needed - can lead to huge amount of TLB flushes
> and shootodowns as the counter might be elevated for considerable amount =
of
> time.

I've lost track as to whether we still think that this particular
problem is really a problem, but could we perhaps make the
tlb_flush_pending field be per-ptl instead of per-mm?  Depending on
how it gets used, it could plausibly be done without atomics or
expensive barriers by using PTL to protect the field.

FWIW, x86 has a mm generation counter, and I don't think it would be
totally crazy to find a way to expose an mm generation to core code.
I don't think we'd want to expose the specific data structures that
x86 uses to track it -- they're very tailored to the oddities of x86
TLB management.  x86 also doesn't currently have any global concept of
which mm generation is guaranteed to have been propagated to all CPUs
-- we track the generation in the pagetables and, per cpu, the
generation that we know that CPU has seen.  x86 could offer a function
"ensure that all CPUs catch up to mm generation G and don't return
until this happens" and its relative "have all CPUs caught up to mm
generation G", but these would need to look at data from multiple CPUs
and would probably be too expensive on very large systems to use in
normal page faults unless we were to cache the results somewhere.
Making a nice cache for this is surely doable, but maybe more
complexity than we'd want.

--Andy
