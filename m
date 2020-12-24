Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5BB32E242F
	for <lists+stable@lfdr.de>; Thu, 24 Dec 2020 05:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgLXEiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 23:38:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgLXEiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 23:38:18 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E147AC061794;
        Wed, 23 Dec 2020 20:37:37 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id y8so735179plp.8;
        Wed, 23 Dec 2020 20:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=UHW8D/vLiku736lshJK5k759PLM13qxM1Fi6BXa63YY=;
        b=Nq+JY8nHgUqHfOT6yEF6/xKweUQlO9WUlrTDx9SK0nrwgVi9Tj5cOo/IgtgsB5EZcj
         NPBXBOdu1WHZq+3FwviapmJHpM7oZqDQGvCFDL1ve+Fj31ykI4L1446cda/hwELyYNCQ
         wIcVI+rgNEUXD6A7AI6sRkOTzOLfs1y+Q6xnEQOiP0E/2mlf7+BGYgr9td7WVz+R5mLq
         MN++ezk0QZ6W9o4qL7+NRvckJnOpi6+LT63XshA9a0tBH0pmRjWtFWrUswGN6fUcZ4Dp
         sFI91iUssAWJjIULiBr3SHFvNdP8c2Ix3dt+UlBxnAtWKCRl2eiliCwbh18VYWzhfmGp
         CMvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=UHW8D/vLiku736lshJK5k759PLM13qxM1Fi6BXa63YY=;
        b=ESg+BITEF/WkrLmP0HBhWMZuwDO0y42y+psm2U9iek/yo9xaPfCDPB4JrQnRMyBs4Q
         H3ByomMaOjjvkEr/ZYhh6PatGz1tEnAETWm/IxECzYC3eWD/9CeTr/qgqDLiQyg8uL7v
         IblS8yXG052D8Bt3EbTE/wX7Po6yhOmc/r+5xO4GLDLUdQoninjm/Drp+2TE1ltQGWrS
         OvlFlUq86uRBvdWkHLwMqDHfjfwfZHKNrGp3yhZaLgc6SPqZdist01P9ACcFXQaKW4/U
         ErDDgSOglw/H4BgXnOVrlhJ1a8d0FXAPyBsSpUqdIBcFW8i7QY1pbHPVb+KYwLqBFRjJ
         dsSw==
X-Gm-Message-State: AOAM533yhgkikFjkkxPpnnHfZ5KN/8EzsQfdmokeLG1UF344v9i0m8dx
        TZZEQ/y5xHfpERDrwYIKuCU=
X-Google-Smtp-Source: ABdhPJzBX9lMKB1TKXCnFnQ69ZdbGJ3J4yr372TJ9wiR76j0X09Mu+pA+Lh6lXr97dVxVEEpmcCJjg==
X-Received: by 2002:a17:90a:c592:: with SMTP id l18mr2717382pjt.228.1608784657017;
        Wed, 23 Dec 2020 20:37:37 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:50a2:5929:401b:705e? ([2601:647:4700:9b2:50a2:5929:401b:705e])
        by smtp.gmail.com with ESMTPSA id y5sm18875764pgs.90.2020.12.23.20.37.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Dec 2020 20:37:35 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <X+QMKC7jPEeThjB1@google.com>
Date:   Wed, 23 Dec 2020 20:37:33 -0800
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <AF841145-ECD7-4675-8FE6-D1E3D471427E@gmail.com>
References: <X+PE38s2Egq4nzKv@google.com>
 <C332B03D-30B1-4C9C-99C2-E76988BFC4A1@amacapital.net>
 <X+P2OnR+ipY8d2qL@redhat.com>
 <3A6A1049-24C6-4B2D-8C59-21B549F742B4@gmail.com>
 <X+QMKC7jPEeThjB1@google.com>
To:     Yu Zhao <yuzhao@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Dec 23, 2020, at 7:34 PM, Yu Zhao <yuzhao@google.com> wrote:
>=20
> On Wed, Dec 23, 2020 at 07:09:10PM -0800, Nadav Amit wrote:
>>> On Dec 23, 2020, at 6:00 PM, Andrea Arcangeli <aarcange@redhat.com> =
wrote:
>>>=20
>>> On Wed, Dec 23, 2020 at 05:21:43PM -0800, Andy Lutomirski wrote:
>>>> I don=E2=80=99t love this as a long term fix. AFAICT we can have =
mm_tlb_flush_pending set for quite a while =E2=80=94 mprotect seems like =
it can wait in IO while splitting a huge page, for example. That gives =
us a window in which every write fault turns into a TLB flush.
>>>=20
>>> mprotect can't run concurrently with a page fault in the first =
place.
>>>=20
>>> One other near zero cost improvement easy to add if this would be =
"if
>>> (vma->vm_flags & (VM_SOFTDIRTY|VM_UFFD_WP))" and it could be made
>>> conditional to the two config options too.
>>>=20
>>> Still I don't mind doing it in some other way, uffd-wp has much =
easier
>>> time doing it in another way in fact.
>>>=20
>>> Whatever performs better is fine, but queuing up pending invalidate
>>> ranges don't look very attractive since it'd be a fixed cost that =
we'd
>>> always have to pay even when there's no fault (and there can't be =
any
>>> fault at least for mprotect).
>>=20
>> I think there are other cases in which Andy=E2=80=99s concern is =
relevant
>> (MADV_PAGEOUT).
>=20
> That patch only demonstrate a rough idea and I should have been
> elaborate: if we ever decide to go that direction, we only need to
> worry about "jumping through hoops", because the final patch (set)
> I have in mind would not only have the build time optimization Andrea
> suggested but also include runtime optimizations like skipping
> do_swap_page() path and (!PageAnon() || page_mapcount > 1). Rest
> assured, the performance impact on do_wp_page() from occasionally an
> additional TLB flush on top of a page copy is negligible.

I agree with you to a certain extent, since there is anyhow another TLB
flush in this path when the PTE is set after copying.

Yet, I think that having a combined and efficient central mechanism for
pending TLB flushes is important even for robustness: to prevent the
development of new independent deferred flushing schemes. I specifically =
do
not like tlb_flush_batched which every time that I look at gets me =
confused.
For example the following code completely confuses me:

  void flush_tlb_batched_pending(struct mm_struct *mm)
  {      =20
        if (data_race(mm->tlb_flush_batched)) {
                flush_tlb_mm(mm);

                /*=20
                 * Do not allow the compiler to re-order the clearing of
                 * tlb_flush_batched before the tlb is flushed.
                 */
                barrier();
                mm->tlb_flush_batched =3D false;
        }
  }

=E2=80=A6 and then I ask myself (no answer):

1. What prevents concurrent flush_tlb_batched_pending() which is called =
by
madvise_free_pte_range(), for instance from madvise_free_pte_range(), =
from
clearing new deferred flush indication that was just set by
set_tlb_ubc_flush_pending()? Can it cause a missed TLB flush later?

2. Why the write to tlb_flush_batched is not done with WRITE_ONCE()?

3. Should we have smp_wmb() instead of barrier()? (probably the =
barrier() is
not needed at all since flush_tlb_mm() serializes if a flush is needed).

4. Why do we need 2 deferred TLB flushing mechanisms?

