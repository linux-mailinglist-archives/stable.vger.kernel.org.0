Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E6D2E20AF
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 20:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbgLWTFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 14:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727671AbgLWTE7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 14:04:59 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A263CC06179C;
        Wed, 23 Dec 2020 11:04:19 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id h186so10897635pfe.0;
        Wed, 23 Dec 2020 11:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=NzLQl3piTpTW8PTRv8fdrHPax+6ZNWHiDo/bSFizPmQ=;
        b=FsGgEVViY6FgdgcgNws7Rh9fqlwlMDmAS6af9LzCwry9yvMUssiMShgG3obSmk1/aK
         yCpGKyghhwNVUWpX81DBX3xmrwWdZwFordxcxo5ECPDPLSswedjzzDGoWUi5izYeYJLk
         hC6igZ5EIFui1YISXl+L6xTB3bISNAAlmXaicVRS0lOn0GSROSHY0p3u9NwqoFkdz+KW
         S0PKQ0wssSvKsiGHIxvjX9V0MwuJB3mPQ4XAMIdkBBNmkCVJnLcC2C1c7w90Qomommm2
         uzhcvom2f9kWzW/ro5kAUKmvMtllgtjVBKs1vH1rUg+MsVa0TdFFk7AKXaYwP4zyHt1Q
         uSFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=NzLQl3piTpTW8PTRv8fdrHPax+6ZNWHiDo/bSFizPmQ=;
        b=gMvUQZJCFOdyJs5vTW15xss3IbMvZskpl37HTVaAZqbylhA6PVgE5qU+MRVAQp3oOE
         6EpLBbEB4S93LbSw6i/LpU1rat5W+M65hsnuHiAjYEQN/C6zVJBKHE84poJbVtF5qNGL
         RKwFbcC0qnDcvSRtmUdH9epXyzqvytT1nWtzaXFSlNBX67cJ3nUsnYwHEiKg2MFi2TCW
         8FHZpTp7la7/S76NQfXFinkPTS1QxDcyXCrXqKwVr31yyZLB6cbzd74TEe/zHJEsJncx
         jEZdG1NiYzlWDXReByKkTGIXfM/ULUMZi9tqBUqUPeisGedorimVrB4ceW3dfbY3RzFJ
         PQHA==
X-Gm-Message-State: AOAM532Q7pa9VcHh2OK4pSpshv5yy36Krgn47FTN/b2Jhh5JRZItE4LU
        r0Q04CueZ8WiB/AXkCkvZUM=
X-Google-Smtp-Source: ABdhPJzLJBXBveWqh3j9mgJpIR2luF9KsSDRHLkRkbP/bGDQwUrKhKoSkgxCWSZ5pnOVwYemdztkJA==
X-Received: by 2002:a63:1f54:: with SMTP id q20mr25791663pgm.135.1608750259058;
        Wed, 23 Dec 2020 11:04:19 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:50a2:5929:401b:705e? ([2601:647:4700:9b2:50a2:5929:401b:705e])
        by smtp.gmail.com with ESMTPSA id 21sm24534561pfx.84.2020.12.23.11.04.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Dec 2020 11:04:18 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20201223162325.GA22699@willie-the-truck>
Date:   Wed, 23 Dec 2020 11:04:15 -0800
Cc:     Yu Zhao <yuzhao@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Minchan Kim <minchan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C8840F69-3453-4E53-9AAD-679E6C4B9C6D@gmail.com>
References: <20201221172711.GE6640@xz-x1>
 <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
 <X+D0hTZCrWS3P5Pi@google.com>
 <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <D4916F41-DE4A-42C6-8702-944382631A02@gmail.com>
 <X+I7TcwMsiS1Bhy/@google.com>
 <E36448EB-2888-42FE-A9F2-2DCF0508C138@gmail.com>
 <20201223162325.GA22699@willie-the-truck>
To:     Will Deacon <will@kernel.org>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Dec 23, 2020, at 8:23 AM, Will Deacon <will@kernel.org> wrote:
>=20
> On Tue, Dec 22, 2020 at 11:20:21AM -0800, Nadav Amit wrote:
>>> On Dec 22, 2020, at 10:30 AM, Yu Zhao <yuzhao@google.com> wrote:
>>>=20
>>> On Tue, Dec 22, 2020 at 04:40:32AM -0800, Nadav Amit wrote:
>>>>> On Dec 21, 2020, at 1:24 PM, Yu Zhao <yuzhao@google.com> wrote:
>>>>>=20
>>>>> On Mon, Dec 21, 2020 at 12:26:22PM -0800, Linus Torvalds wrote:
>>>>>> On Mon, Dec 21, 2020 at 12:23 PM Nadav Amit =
<nadav.amit@gmail.com> wrote:
>>>>>>> Using mmap_write_lock() was my initial fix and there was a =
strong pushback
>>>>>>> on this approach due to its potential impact on performance.
>>>>>>=20
>>>>>> =46rom whom?
>>>>>>=20
>>>>>> Somebody who doesn't understand that correctness is more =
important
>>>>>> than performance? And that userfaultfd is not the most important =
part
>>>>>> of the system?
>>>>>>=20
>>>>>> The fact is, userfaultfd is CLEARLY BUGGY.
>>>>>>=20
>>>>>>        Linus
>>>>>=20
>>>>> Fair enough.
>>>>>=20
>>>>> Nadav, for your patch (you might want to update the commit =
message).
>>>>>=20
>>>>> Reviewed-by: Yu Zhao <yuzhao@google.com>
>>>>>=20
>>>>> While we are all here, there is also clear_soft_dirty() that could
>>>>> use a similar fix=E2=80=A6
>>>>=20
>>>> Just an update as for why I have still not sent v2: I fixed
>>>> clear_soft_dirty(), created a reproducer, and the reproducer kept =
failing.
>>>>=20
>>>> So after some debugging, it appears that clear_refs_write() does =
not flush
>>>> the TLB. It indeed calls tlb_finish_mmu() but since 0758cd830494
>>>> ("asm-generic/tlb: avoid potential double flush=E2=80=9D), =
tlb_finish_mmu() does not
>>>> flush the TLB since there is clear_refs_write() does not call to
>>>> __tlb_adjust_range() (unless there are nested TLBs are pending).
>>>=20
>>> Sorry Nadav, I assumed you knew this existing problem fixed by:
>>> =
https://patchwork.kernel.org/project/linux-mm/cover/20201210121110.10094-1=
-will@kernel.org/
>>=20
>> Thanks, Yu! For some reason I assumed it was already upstreamed and =
did not
>> look back (yet if I was cc=E2=80=99d on v2=E2=80=A6)
>=20
> I'll repost in the new year, as it was a bit tight for the merge =
window.
> I've made a note to put you on cc.

No worries. I just like to complain. I read v1 but forgot.

>=20
>> Yet, something still goes bad. Debugging.
>=20
> Did you figure this out? I tried to read the whole thread, but it's a =
bit
> of a rollercoaster.

Yes, it was embarrassing bug of mine (not in any code sent). The
soft-dirty code is entangled and the deep nesting of the code
is unnecessary and confusing.

I tried not to change much to ease backporting and merging with
your pending patch, but some merging will be needed.

