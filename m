Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388BF2E2412
	for <lists+stable@lfdr.de>; Thu, 24 Dec 2020 04:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgLXDbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 22:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728280AbgLXDbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 22:31:23 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F94C061794;
        Wed, 23 Dec 2020 19:30:43 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id f14so443404pju.4;
        Wed, 23 Dec 2020 19:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=tPmNTzdXNZi8m1t8uo8B9JQpXn5P/PEOVeaeX2In4ao=;
        b=EARqp4RXMHAwoT75eHexGYdpftgE7+/9giHbUFmJeRKxl8bb68OKXHDt2goPqlA/39
         J9QHhzRKf1ftUex/JQf208YnNG0dFgqxCMqTV2xH4btVOIZw6WsyUjRrgPSklXggOn/V
         azX+fZcuvBONeA79UwOJAwZ/Dj6Ve6WcUeeu1DZQfgKHouvn+L9P5B8UgCC+QX9WJY+c
         8ZKIMCCgawveY+u0LoWJvUQrQrppjZGThf7XAHCM9H0dyLVyNPWaRp0nZ6xkWhr4m0v0
         7S1v/qrcuwCBV/MrjOrNJG502mxkBETIcfungictZMNI8/rDGBFa5QvKhxI53RBxC60a
         TSZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=tPmNTzdXNZi8m1t8uo8B9JQpXn5P/PEOVeaeX2In4ao=;
        b=uedyRy4oHheR3nftvny/Pz/zmVZxiKNrIeUHBLvyZc/W/F27yjLlOjEi6Xx8vl9XcE
         8UrHOtZFobgUTLmblW8+FImIfWRwhO+qoRG9Zfcik5wT6wzni9Jf/MfbsC+Y2nAxbqMh
         FM0thI0CyfS4CcnLcBWELImCVPS2d4i3F1Sn5j6XuQjS6sdD8iu8anrZ7Rb9w4/PXbN3
         E8Ob0Jlq01THx0BhIi2w8ZPD+/DYTGjpuaQA4pKM9lhcc2PgV5BijiHwAwOgWOYCn//z
         y+el9rhNmsKU6Rm/kO4XwV2Mjsz1hq8v56a39RljSnudPt+QXGj0Vx375vukOQO+7Ymj
         WlFQ==
X-Gm-Message-State: AOAM530C1KYAgNAfgeU3CynebnDy1h0gWi07fGmYeU8rEsCOd20CdlfE
        v4GSIEu2YhnbXMLwnAML3EQ=
X-Google-Smtp-Source: ABdhPJxC2GB+3NzCqEB4kk72085mvlPkbxuY7NwYdlHfIXgauu/ASicfIb/rPLDHR0/qWINP/J07yQ==
X-Received: by 2002:a17:902:7292:b029:dc:ac9:25b5 with SMTP id d18-20020a1709027292b02900dc0ac925b5mr28509309pll.2.1608780642620;
        Wed, 23 Dec 2020 19:30:42 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:50a2:5929:401b:705e? ([2601:647:4700:9b2:50a2:5929:401b:705e])
        by smtp.gmail.com with ESMTPSA id w18sm25100682pfj.120.2020.12.23.19.30.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Dec 2020 19:30:41 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <3A6A1049-24C6-4B2D-8C59-21B549F742B4@gmail.com>
Date:   Wed, 23 Dec 2020 19:30:39 -0800
Cc:     Andy Lutomirski <luto@amacapital.net>, Yu Zhao <yuzhao@google.com>,
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
Message-Id: <59E54984-DD1D-4BD2-8F22-45634B764F6A@gmail.com>
References: <X+PE38s2Egq4nzKv@google.com>
 <C332B03D-30B1-4C9C-99C2-E76988BFC4A1@amacapital.net>
 <X+P2OnR+ipY8d2qL@redhat.com>
 <3A6A1049-24C6-4B2D-8C59-21B549F742B4@gmail.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Dec 23, 2020, at 7:09 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
>> On Dec 23, 2020, at 6:00 PM, Andrea Arcangeli <aarcange@redhat.com> =
wrote:
>>=20
>> On Wed, Dec 23, 2020 at 05:21:43PM -0800, Andy Lutomirski wrote:
>>> I don=E2=80=99t love this as a long term fix. AFAICT we can have =
mm_tlb_flush_pending set for quite a while =E2=80=94 mprotect seems like =
it can wait in IO while splitting a huge page, for example. That gives =
us a window in which every write fault turns into a TLB flush.
>>=20
>> mprotect can't run concurrently with a page fault in the first place.
>>=20
>> One other near zero cost improvement easy to add if this would be "if
>> (vma->vm_flags & (VM_SOFTDIRTY|VM_UFFD_WP))" and it could be made
>> conditional to the two config options too.
>>=20
>> Still I don't mind doing it in some other way, uffd-wp has much =
easier
>> time doing it in another way in fact.
>>=20
>> Whatever performs better is fine, but queuing up pending invalidate
>> ranges don't look very attractive since it'd be a fixed cost that =
we'd
>> always have to pay even when there's no fault (and there can't be any
>> fault at least for mprotect).
>=20
> I think there are other cases in which Andy=E2=80=99s concern is =
relevant
> (MADV_PAGEOUT).
>=20
> Perhaps holding some small bitmap based on part of the deferred =
flushed
> pages (e.g., bits 12-17 of the address or some other kind of a single
> hash-function bloom-filter) would be more performant to avoid (most)
> unnecessary TLB flushes. It will be cleared before a TLB flush and set =
while
> holding the PTL.
>=20
> Checking if a flush is needed, under the PTL, would require a single =
memory
> access (although potentially cache miss). It will however require one =
atomic
> operation for each page-table whose PTEs=E2=80=99 flushes are deferred =
- in contrast
> to the current scheme which requires two atomic operations for the =
*entire*
> operation.

Just to finish my thought - clearing the bitmap is the tricky part,
which I still did not figure out.=
