Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BE62E02B8
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 23:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgLUWz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 17:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgLUWz5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 17:55:57 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F33C0613D3;
        Mon, 21 Dec 2020 14:55:16 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id f9so7295181pfc.11;
        Mon, 21 Dec 2020 14:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=MWSksfPTMswDsSxUE3HtTa45ybxXErt7UyS5LoWsn/c=;
        b=W9zTbSghxh6v348guyuA8D2WaWyQuM04ndJ+7kg1cjkAtQGFWQMaaWs0rnQ59b9X59
         VbJ9Oq13LwCmBEfBvhe6IvXteCX804g1YEVFPI3kHzBWuSGgH5LJ7ltDlOuDWR9adLFO
         kGLt7I8oSMMd2Y5FrMNYdJZ2hDrJYaYwUPbRGxQiCdSygTOyVxaWUSOl0nBsUbxEIcK7
         Dy7Enqx21GcTgWtVM3LzorT4i6jiRXp6x2nt8ZVcmVpQQclUrE8Y+s6lyagMS6gXOwKJ
         vFKrtHvALQxAV50D2Ks5cKAYtxrI1YMhqLupQy0PhKDMtH+Y9q1XPx0mUkUb9SDuHffg
         kDXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=MWSksfPTMswDsSxUE3HtTa45ybxXErt7UyS5LoWsn/c=;
        b=AH/UkFZ/dho/9znD/pN1xI32qsSMZ/J0pV7tC3HTyY1/U60NB/ywxnwx5rSXL105H0
         bIFNbA1Ci2BfLc2pR+DyTMNtZUD/wT1rgIWoS7Xg9LgHSKYz4d4Y1daf9lhXfcdt4jsX
         PrLbVfF0ouOuCxSlEtCtJNGdHrGrih9Cqta7ZjiCxPHZajEsRYcMvc247vN1E6NBNwD5
         jNGLnN0ZVb8tj/O4Fy6ozBKFpAeb86TNDwEEwoUncOVtwi8kw89BixaqYEgZsGjkDfUb
         qZIdCHvHL0KBMY3EAqCf6k+7hOW1z85J+VTGecF1Kar5qLYC5TGEN+9k9pckuL4gJTGn
         Qvkw==
X-Gm-Message-State: AOAM530zggRhI5xA3nJ4GVZag9l4CZ7kdA8O6Hjn0lAe9DMH4X0HwxxC
        HXDC2K3Hh7fdheV82ajDsaJPdSwyaVEHfQ==
X-Google-Smtp-Source: ABdhPJz649QHJ7ppWUE4OSOx0WGT1P7riOXSwtwTXLKDsRV5Nb6XAYZ0eENXLGVYxRcaFGtfNAQaeA==
X-Received: by 2002:a63:3d8c:: with SMTP id k134mr17310482pga.53.1608591316225;
        Mon, 21 Dec 2020 14:55:16 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:104c:8d35:de28:b8dc? ([2601:647:4700:9b2:104c:8d35:de28:b8dc])
        by smtp.gmail.com with ESMTPSA id j14sm16788607pjm.10.2020.12.21.14.55.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Dec 2020 14:55:15 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20201221223041.GL6640@xz-x1>
Date:   Mon, 21 Dec 2020 14:55:12 -0800
Cc:     Yu Zhao <yuzhao@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Content-Transfer-Encoding: quoted-printable
Message-Id: <B8095F3C-81E3-4AF9-A6A5-F597D51264BD@gmail.com>
References: <X97pprdcRXusLGnq@google.com>
 <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com>
 <20201221172711.GE6640@xz-x1>
 <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
 <X+D0hTZCrWS3P5Pi@google.com>
 <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1>
To:     Peter Xu <peterx@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Dec 21, 2020, at 2:30 PM, Peter Xu <peterx@redhat.com> wrote:
>=20
> On Mon, Dec 21, 2020 at 01:49:55PM -0800, Nadav Amit wrote:
>> BTW: In general, I think that you are right, and that changing of =
PTEs
>> should not require taking mmap_lock for write. However, I am not sure
>> cow_user_page() is not the only one that poses a problem and whether =
a more
>> systematic solution is needed. If cow_user_pages() is the only =
problem, do
>> you think it is possible to do the copying while holding the PTL? It =
works
>> for normal-pages, but I am not sure whether special-pages pose =
special
>> problems.
>>=20
>> Anyhow, this is an enhancement that we can try later.
>=20
> AFAIU mprotect() is the only one who modifies the pte using the mmap =
write
> lock.  NUMA balancing is also using read mmap lock when changing pte
> protections, while my understanding is mprotect() used write lock only =
because
> it manipulates the address space itself (aka. vma layout) rather than =
modifying
> the ptes, so it needs to.

You are correct about NUMA balancing in general. Yet in practice it is =
not
an issue in our =E2=80=9Cuse-case=E2=80=9D since NUMA balancing =
preserves the write-bit.

> At the pte level, it seems always to be the pgtable lock that =
serializes things.
>=20
> So it's perfectly legal to me for e.g. a driver to modify ptes with =
the read
> lock of mmap_sem, unless I'm severely mistaken.. as long as the =
pgtable lock is
> taken when doing so.
>=20
> If there's a driver that manipulated the ptes, changed the content of =
the page,
> recover the ptes to origin, and all these happen right after =
wp_page_copy()
> unlocked the pgtable lock but before wp_page_copy() retakes the same =
lock
> again, we may face the same issue finding that the page got copied =
contains
> corrupted data at last.  While I don't know what to blame on the =
driver either
> because it seems to be exactly following the rules.

The driver would have to do so without flushing the TLB. Having said =
that,
the driver could have used inc_tlb_flush_pending() and batch flushes.

>=20
> I believe changing into write lock would solve the race here because =
tlb
> flushing would be guaranteed along the way, but I'm just a bit worried =
it's not
> the best way to go..

It might be too big of a hammer. But the question that comes to my mind =
is,
if it is ok to change the PTEs without mmap_lock held for write, why
wouldn=E2=80=99t mmap_write_downgrade() be executed before =
mprotect_fixup() (so
mprotect change of PTE would not be done with the write-lock)? If you =
did
so, you would have the same problem as the one we encountered =
(concurrent
protect-unprotect allow concurrent cow-#PF copying the wrong data).

So as an alternative solution, I can do copying under the PTL after
flushing, which seems to solve the problem. First copying (without a =
lock)
and then comparing seems to me as suboptimal - I do not think the =
benefit
(if there is one) of shortening the time in which the lock is taken - =
worth
the additional compare (and the complexity with special pages).

There are 2 problems in doing so:

1. I think that copy_user_highpage() and __copy_from_user_inatomic() can =
be
called while holding the PTL, but I am not sure.

2. For special pages we would need 2 TLB flushes: one to ensure the
write-bit is cleared, and a second one after we clear the PTE. We
can limit ourselves to soft-dirty/UFFD VMAs, but if we have your
hypothetical driver, this would not be good enough.

