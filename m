Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0DF2E04AD
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 04:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgLVDU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 22:20:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:47166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgLVDU3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Dec 2020 22:20:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B16722D2B
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 03:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608607188;
        bh=FotjZisX966kuUXL0D8Gn9J6bdxuHo48V44mRV8iSi8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XhUcubjnh2HyUFiUydLIFRTZ7/sGFH/GXPhv3g6TDB0sf+Aa2byWq7GCahRO7EMlQ
         cjfsgp9lH573lB+lF3d2jfe0ohjW5dntXU0xBQtzfxtB6p+gM2aoUDasS0d0CwAL7c
         4iVjbydOweneVPK3C5y64Hz5gyBxBVRlf+c4w/aFpoNe07S6/W1g+NQijEfw2xy/4O
         tFivUdIkgWU/g4y/jmnJC4ECtj/zcYO3nMlNGbBSsK0D6b8kAcDMiiuL32BDKJS6o/
         14dlF461YQaPzd2yTkagSzG2BwM1vCWHBnuYNzstIzbE/wF2IZUJIDVaiWcnftpfQC
         UKf7jsgXOXnOQ==
Received: by mail-wr1-f51.google.com with SMTP id m5so13077549wrx.9
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 19:19:48 -0800 (PST)
X-Gm-Message-State: AOAM533wEE+dgGVAgytuWyIY0QvaMoYAFXt4I+asLsqiFGfywPktt/wq
        eyey9oHoI3NFak7jG3PWvA6Rx49tqBscLhFADPZIFA==
X-Google-Smtp-Source: ABdhPJwTCgH3BmlX+GODdwcxPSZVy++AHA4Lx/hL1P4NF3Nxh69XC7OXOw9Si7NYZsjkZA/RhLZin44WT3xNAvcGE2Y=
X-Received: by 2002:adf:db43:: with SMTP id f3mr22479424wrj.70.1608607186744;
 Mon, 21 Dec 2020 19:19:46 -0800 (PST)
MIME-Version: 1.0
References: <X97pprdcRXusLGnq@google.com> <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com>
 <20201221172711.GE6640@xz-x1> <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
 <X+D0hTZCrWS3P5Pi@google.com> <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com> <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com> <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1> <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
In-Reply-To: <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 21 Dec 2020 19:19:35 -0800
X-Gmail-Original-Message-ID: <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
Message-ID: <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Peter Xu <peterx@redhat.com>, Nadav Amit <nadav.amit@gmail.com>,
        Yu Zhao <yuzhao@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 21, 2020 at 3:22 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, Dec 21, 2020 at 2:30 PM Peter Xu <peterx@redhat.com> wrote:
> >
> > AFAIU mprotect() is the only one who modifies the pte using the mmap write
> > lock.  NUMA balancing is also using read mmap lock when changing pte
> > protections, while my understanding is mprotect() used write lock only because
> > it manipulates the address space itself (aka. vma layout) rather than modifying
> > the ptes, so it needs to.
>
> So it's ok to change the pte holding only the PTE lock, if it's a
> *one*way* conversion.
>
> That doesn't break the "re-check the PTE contents" model (which
> predates _all_ of the rest: NUMA, userfaultfd, everything - it's
> pretty much the original model for our page table operations, and goes
> back to the dark ages even before SMP and the existence of a page
> table lock).
>
> So for example, a COW will always create a different pte (not just
> because the page number itself changes - you could imagine a page
> getting re-used and changing back - but because it's always a RO->RW
> transition).
>
> So two COW operations cannot "undo" each other and fool us into
> thinking nothing changed.
>
> Anything that changes RW->RO - like fork(), for example - needs to
> take the mmap_lock.

Ugh, this is unpleasantly complicated.  I will admit that any API that
takes an address and more-or-less-blindly marks it RO makes me quite
nervous even assuming all the relevant locks are held.  At least
userfaultfd refuses to operate on VM_SHARED VMAs, but we have another
instance of this (with mmap_sem held for write) in x86:
mark_screen_rdonly().  Dare I ask how broken this is?  We could likely
get away with deleting it entirely.

--Andy
