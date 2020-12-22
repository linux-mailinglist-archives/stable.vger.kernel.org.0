Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520212E0EDC
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 20:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbgLVTVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 14:21:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727502AbgLVTVF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 14:21:05 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6451C0613D6;
        Tue, 22 Dec 2020 11:20:25 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id s21so8974674pfu.13;
        Tue, 22 Dec 2020 11:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=F5AMnLvseBLwD4CSY72NfvaqVdYyFOwme+T8yzDx3b4=;
        b=NAEFAdESyBeAhxfpWp0L2gvl3DEqFJ3nrPzeclRSSpJ8vtv9sAf6JBaOWZ/EuTduCg
         eAAjkSWS3gkrV7xm0bWp5uBScT9aRj70jvUYSefltZvReHiKLVNbSJ6eoS6YwIhnX0O9
         EIYBsprjoUSOzuApPGT/nXm8thSTvZV+iebQUZftF1jrLL+QXFuZwBbTXhN3FCVasCvq
         VPlq/diIas69vWuOhV8v7V/MjoDy8aOSWRdqbZQ0Wd1Apx7tqai/LlJ4JPTNEJLubRuX
         hVkzPuZb9UwyKGOfZ++fejJWnTXWEJWrBOFBFNW61I75vgt9K21iieIXVAfjsO7Qmr6s
         FeVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=F5AMnLvseBLwD4CSY72NfvaqVdYyFOwme+T8yzDx3b4=;
        b=Jp0BElNFqedCffz5bRE/95sgDffaPQe51aZ9/bk1LIZ+Y2jDM70Y3vM4O9qqDrYR3v
         XXTbZgDIhQtlIUbySCUeAq0fwre2TcO2ZXh/7qPi3YW9mzq9KnR/DTgkuY8eLhMmwqYo
         aIvIG2Zd0HrOMQ3+cMM3Ms5lv2bEd2Xf7N9CG15R6sAcS0hEkTwPBHW9UbwMkuM+im9u
         977X7bGfHxx9qctGPNhtZCmGsvdibfFqzU6EoVNf1QftIIN0nyfa0/sz5Q28EGn9Frm1
         7Zx6AB1z/oYA77gu1smkj6OoMVhW3L0bDhQklaVty3YxjpPB0CRovwiX0VW//qSF97l+
         hPWQ==
X-Gm-Message-State: AOAM532N2bjLKn8wM5wKg3/foso7zzVc9SVx9R/pT2n+UQL72sP4wjgQ
        0Yw2T5fHpq7VpRlfUGHd2GY=
X-Google-Smtp-Source: ABdhPJwUI29C82tgtHYmx78kGGb+xdlrRNFNTXAf8QZn5A/wiuk/5BA6I/kn1gFRkOwOEWcLf8jjBA==
X-Received: by 2002:a05:6a00:22c9:b029:198:15b2:bbd3 with SMTP id f9-20020a056a0022c9b029019815b2bbd3mr928100pfj.64.1608664825069;
        Tue, 22 Dec 2020 11:20:25 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:9423:6a08:cbd0:8220? ([2601:647:4700:9b2:9423:6a08:cbd0:8220])
        by smtp.gmail.com with ESMTPSA id t18sm21640050pfl.138.2020.12.22.11.20.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Dec 2020 11:20:24 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <X+I7TcwMsiS1Bhy/@google.com>
Date:   Tue, 22 Dec 2020 11:20:21 -0800
Cc:     Peter Zijlstra <peterz@infradead.org>,
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
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E36448EB-2888-42FE-A9F2-2DCF0508C138@gmail.com>
References: <X97pprdcRXusLGnq@google.com>
 <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com>
 <20201221172711.GE6640@xz-x1>
 <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
 <X+D0hTZCrWS3P5Pi@google.com>
 <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <D4916F41-DE4A-42C6-8702-944382631A02@gmail.com>
 <X+I7TcwMsiS1Bhy/@google.com>
To:     Yu Zhao <yuzhao@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Dec 22, 2020, at 10:30 AM, Yu Zhao <yuzhao@google.com> wrote:
>=20
> On Tue, Dec 22, 2020 at 04:40:32AM -0800, Nadav Amit wrote:
>>> On Dec 21, 2020, at 1:24 PM, Yu Zhao <yuzhao@google.com> wrote:
>>>=20
>>> On Mon, Dec 21, 2020 at 12:26:22PM -0800, Linus Torvalds wrote:
>>>> On Mon, Dec 21, 2020 at 12:23 PM Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>>>> Using mmap_write_lock() was my initial fix and there was a strong =
pushback
>>>>> on this approach due to its potential impact on performance.
>>>>=20
>>>> =46rom whom?
>>>>=20
>>>> Somebody who doesn't understand that correctness is more important
>>>> than performance? And that userfaultfd is not the most important =
part
>>>> of the system?
>>>>=20
>>>> The fact is, userfaultfd is CLEARLY BUGGY.
>>>>=20
>>>>         Linus
>>>=20
>>> Fair enough.
>>>=20
>>> Nadav, for your patch (you might want to update the commit message).
>>>=20
>>> Reviewed-by: Yu Zhao <yuzhao@google.com>
>>>=20
>>> While we are all here, there is also clear_soft_dirty() that could
>>> use a similar fix=E2=80=A6
>>=20
>> Just an update as for why I have still not sent v2: I fixed
>> clear_soft_dirty(), created a reproducer, and the reproducer kept =
failing.
>>=20
>> So after some debugging, it appears that clear_refs_write() does not =
flush
>> the TLB. It indeed calls tlb_finish_mmu() but since 0758cd830494
>> ("asm-generic/tlb: avoid potential double flush=E2=80=9D), =
tlb_finish_mmu() does not
>> flush the TLB since there is clear_refs_write() does not call to
>> __tlb_adjust_range() (unless there are nested TLBs are pending).
>=20
> Sorry Nadav, I assumed you knew this existing problem fixed by:
> =
https://patchwork.kernel.org/project/linux-mm/cover/20201210121110.10094-1=
-will@kernel.org/
>=20

Thanks, Yu! For some reason I assumed it was already upstreamed and did =
not
look back (yet if I was cc=E2=80=99d on v2=E2=80=A6)

Yet, something still goes bad. Debugging.

