Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64FE0240C56
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 19:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbgHJRsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 13:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbgHJRsq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 13:48:46 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B073DC061756;
        Mon, 10 Aug 2020 10:48:45 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id kq25so10273054ejb.3;
        Mon, 10 Aug 2020 10:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wy7QyDpFuzkHPrzR9VLX8BuWPNLwEm7m4KeC1bb6KKo=;
        b=JMWfnEbb4LjkZ3+Yq8xPRKK+w2Nrs8eZAszU1coBAJwcuuP5rxJPxhOUZeouSlSxYT
         r+5ozBDt8x0pcsdEGgE1kOS7JliyLgxTLrrLU7kaEsDAvgczpI9SDbYSqkV8PlI5fgrP
         IMZidoJV0Nb2SpzpReN3GspH31LWngN3MVWok7FmQkQZix4ZsjGclzLNrl8PCZfyMLJP
         fsWcOa1FNz6lXvNPuvFzIWwcYjWiPS0g4IHcj+Jj6UCnkzq949zPXAQPAawDd4T/UFCD
         eJ7oKxPedFEjibsBu0u2El44VfEXf0aVVzF65g/9eXVM8hen4d9khdhvKVza4x/KA/Jb
         91fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wy7QyDpFuzkHPrzR9VLX8BuWPNLwEm7m4KeC1bb6KKo=;
        b=aDIcCQaWpAg4fOggv2lhJcxd08SiJoq6mP4NTLtiJkfxjzE0uGIVEk+JXBgF92NtYb
         te6nD5HRmf/TIsG0G6gPVFCCpoiKhdrSXq4HmBZOxiQwLsperAef6Pyry4Qbhzunu6QV
         KRC42gu75AGkZb9AvUw3ezylLok7p41JotRCy0XHL2ecWdrDZHXjkqNVj8Sgack6r6Ug
         QA/ar0pHxFQhi/jpIbm7ADvA5VlrUccbkAefAi6p+oXgsV/dtKUCtGhRgSORt2ecEXyX
         dWktLYUyM5dglpUN4se8TG7PbS7RXeYxv1k8SR6mMGtfy1+qyEyh4FkseSBfWqhp90D3
         8g0g==
X-Gm-Message-State: AOAM531s2CIppQcD1t7KTtolM/6UBo4fTZBNnc5tLYBXfPHmYG+KmYM8
        Ab6QazIyUmv7K+FPwh16xZqV0yT/HKMjDb1PR9g=
X-Google-Smtp-Source: ABdhPJw7r6HquCXHI4BiI9C7jkR2ziLS9yOn7t4kE+lHXbpm0evpqv5sarboSgnlI1vWCvakAgkGBBxP4z5gMIr+kXc=
X-Received: by 2002:a17:906:3993:: with SMTP id h19mr4692664eje.111.1597081722348;
 Mon, 10 Aug 2020 10:48:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
 <20200807061706.unk5_0KtC%akpm@linux-foundation.org> <CAHk-=wiK1oh8T_GNdnQk4UERuWmLQMnXuia8CpJ5QVzSAKuffQ@mail.gmail.com>
 <CAHbLzkrSQ8CT5jaT-8LFtnEg-63qdZNoHe6XBc3F4orxuHt-7A@mail.gmail.com> <CAHk-=wjoOtcAvkYQThDQ5u+jFqbtwOsSJH1DtLDfokMOd4K93w@mail.gmail.com>
In-Reply-To: <CAHk-=wjoOtcAvkYQThDQ5u+jFqbtwOsSJH1DtLDfokMOd4K93w@mail.gmail.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Mon, 10 Aug 2020 10:48:19 -0700
Message-ID: <CAHbLzkrRyFrDKpCBH6X7kSOKJxrPg34ccX2ik6u4zO94=94BtQ@mail.gmail.com>
Subject: Re: [patch 001/163] mm/memory.c: avoid access flag update TLB flush
 for retried page fault
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Hillf Danton <hdanton@sina.com>,
        Hugh Dickins <hughd@google.com>,
        Josef Bacik <josef@toxicpanda.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        stable <stable@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Xu <xuyu@linux.alibaba.com>,
        Yang Shi <yang.shi@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 7, 2020 at 9:34 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, Aug 7, 2020 at 1:53 PM Yang Shi <shy828301@gmail.com> wrote:
> >
> > I'm supposed Catalin would submit his proposal (flush local TLB for
> > spurious TLB fault on ARM) for this specific regression per the
> > discussion, right?
>
> I think arm64 should do that regardless, yes.
>
> But I would also be ok with a version that does the FAULT_FLAG_TRIED
> testing, but does it only for that spurious TLB flushing.
>
> This "let's not update the page tables at all" is wrong, when the only
> problem was the TLB flushing.
>
> So changing the current (but quesitonable)
>
>                 if (vmf->flags & FAULT_FLAG_WRITE)
>                         flush_tlb_fix_spurious_fault(vmf->vma, vmf->address);
>
> to be
>
>                 if (vmf->flags & (FAULT_FLAG_WRITE | FAULT_FLAG_TRIED))
>                         flush_tlb_fix_spurious_fault(vmf->vma, vmf->address);

It looks the retried fault still flush TLB with this change.

Shouldn't we do something like this to skip spurious TLB flush:

@@ -4251,6 +4251,9 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
                                vmf->flags & FAULT_FLAG_WRITE)) {
                update_mmu_cache(vmf->vma, vmf->address, vmf->pte);
        } else {
+               if (vmf->flags & FAULT_FLAG_TRIED)
+                       goto unlock;
+
                /*
                 * This is needed only for protection faults but the arch code
                 * is not yet telling us if this is a protection fault or not.

>
> would be fine.
>
> But this patch that changes any semantics outside just the flushin gis
> a complete no-no.
>
>                 Linus
