Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403572E228F
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 23:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgLWWqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 17:46:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbgLWWqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 17:46:44 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC0CC061794;
        Wed, 23 Dec 2020 14:46:03 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id iq13so147965pjb.3;
        Wed, 23 Dec 2020 14:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=0gM77z9qiu4cf/vMjZqQd+73V4+IFV7TM5e+1+zFyXg=;
        b=JiNrZGyyOlrL/TtQQdx4zb8cxFJhOqwSFGR5bkKgQYmxswgl0plS1h4kxnM7UzZfYc
         R2aXM4rP+lWe0Im9ueqwS8A7N1WMrKY+0v3ad1Kky9K8W7i9gurhdqbIYQUTkqG7w329
         TLnBblDTfyY3PAQbULjAM+cbIlopqLzzn6S8Tt4KGaN/7zLqnUFfIUvy9/O9cNeyTMCn
         xzn1CqWEJd0eBgMsjVJodQUm2GbzsGs/wajEM7qi2e0JLvbm0XNvxZBYBLULtSelJ4E8
         VfJbQmQ4PbB7rBb3GvslMU4vyCB8Vo2HRz2wA/HPntbHx0so5d9xgdEe4glx5lIYs0du
         UtAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=0gM77z9qiu4cf/vMjZqQd+73V4+IFV7TM5e+1+zFyXg=;
        b=W+pmETKBR/98hsqI580MJMGZvaXoKdtp5kSoy09iK5UszVMrJPDfdSzw/KpTVLkT87
         eVuNzg5bm1QljbS1QyjBpY9ddE5btvbKdNOu1TA9ZIzcFsVUxyjphKTp4ZVo0MIVtfTY
         RTIDSb4Dvz+049LsK5BvRXJfrTKYe34ZSJe5jL2PBGuE5R1MgedwpK9U9lT/PimaQ4tz
         dmrXUqkpOmEn6D53jpLkppUaWuMY488ts83rjvoor5FJxhDbzUGwCg7j5qRs6qMsF1WJ
         f2imJV/p2zCP613zUXZjaZ7nPUBLhU0dEAncLieAKz6NoV64KSTc+cwg6yA+EOxvCMot
         i7Sw==
X-Gm-Message-State: AOAM532tFsFtunXzz11HV5NTVna4NaLLxd3aGfz74o8b1jLdHTpl4Gto
        odah0M68Xy2mUwCQ1htPC5k=
X-Google-Smtp-Source: ABdhPJxxN/by8wSi4sx7VGSfiAMnkSzB+vIfE15e3a+L8kGj7riJDxTJ9H711r1N1k6yacIAMP+79w==
X-Received: by 2002:a17:90b:11d7:: with SMTP id gv23mr1619814pjb.2.1608763563202;
        Wed, 23 Dec 2020 14:46:03 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:50a2:5929:401b:705e? ([2601:647:4700:9b2:50a2:5929:401b:705e])
        by smtp.gmail.com with ESMTPSA id z7sm25119015pfq.193.2020.12.23.14.46.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Dec 2020 14:46:01 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <X+O/HT6d+UOa4GfB@redhat.com>
Date:   Wed, 23 Dec 2020 14:45:59 -0800
Cc:     Yu Zhao <yuzhao@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Minchan Kim <minchan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F63B134B-C824-4FC1-BE6F-9E03DF947D50@gmail.com>
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
 <X+O/HT6d+UOa4GfB@redhat.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Dec 23, 2020, at 2:05 PM, Andrea Arcangeli <aarcange@redhat.com> =
wrote:
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
>>=20
>> So I have a patch for this issue too: arguably the tlb_gather =
interface is
>> not the right one for clear_refs_write() that does not clear PTEs but
>> changes them.
>>=20
>> Yet, sadly, my reproducer keeps falling (less frequently, but still). =
So I
>> will keep debugging to see what goes wrong. I will send v2 once I =
figure out
>> what the heck is wrong in the code or my reproducer.
>=20
> If you put the page_mapcount check back in do_wp_page instead of
> page_count, it'll stop reproducing but the bug is still very much
> there...

I know. I designed the (re)producer just to be able to hit the bug =
without
changing the kernel (and test my fix), but I am fully aware that it =
would
not work on older kernels although the bug is still there.

> And then we'll have to enforce uffd-wp cannot be registered if
> VM_SOFTDIRTY is set or the other way around so that VM_UFFD* is
> mutually exclusive with VM_SOFTDIRTY. So then we can also unify the
> bit so they all use the same software bit in the pgtable (that's
> something I considered anyway originally since it doesn't make whole
> lot of sense to use the two features on the same vma at the same
> time).

I think it may be reasonable.

Just a proposal: At some point we can also ask ourselves whether the
=E2=80=9Cartificial" limitation of the number of software bits per PTE =
should really
limit us, or do we want to hold some additional metadata per-PTE by =
either
putting it in an adjacent page (holding 64-bits of additional =
software-bits
per PTE) or by finding some place in the page-struct to link to this
metadata (and have the liberty of number of bits per PTE). One of the =
PTE
software-bits can be repurposed to say whether there is =
=E2=80=9Cextra-metadata=E2=80=9D
associated with the PTE.

I am fully aware that there will be some overhead associated, but it
can be limited to less-common use-cases.

