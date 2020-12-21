Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095782DF8D1
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 06:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbgLUF0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 00:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728348AbgLUF0k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 00:26:40 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCC8C061282;
        Sun, 20 Dec 2020 21:26:00 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id m6so5813913pfm.6;
        Sun, 20 Dec 2020 21:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=UY74sHg/BA6KOJPIsWgBN2j7tXUCvLn2yKJfFPzwzzA=;
        b=QK2rTnltcVN5AOQJW8BoJLkPSY5P0Z+ip1xksQoAgkA+zYubkrZLwmkDEgmrPKjG9Q
         eMLj5uxfDqfiXgbPdsQAuRMA0MrWqzJGXWemJtaCit+PFtFpYUlK9RBUOHF8kuarI+H8
         OJEg3poEd2GnwdJX2+pfolmkTEcIUANjQaShtODGCxkKiq7Eybpr3tKtxG8hIY1ZMbk8
         R6c/jTfIw1jnCe/CzPH1wGno9YihLgNDslpJ070tcWNC2/EIv4XKIDufFGjg0bhPQpob
         J2k0FgMg0kihKXT1yzholRHV3QqHvKNfYlciO+08PBY7u9ogoX+aV3nnrZxly+JjQQes
         L24A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=UY74sHg/BA6KOJPIsWgBN2j7tXUCvLn2yKJfFPzwzzA=;
        b=gTMHKNRqFwZLNgamPHiOO4G5hOhQDzw6SyzKs0GQahBLLZq9tT5711PAwtBOnoiSWD
         hkbW6v8IJdb7zCiy/ocpR15tzfJFiYtpWq3Rf2dfyrAZpM/Uzlm1TleBxaQwlZwX3NyM
         fPziaOMd/elRxkQN4R9xNVh2XbhPemo8uPpfjQ0GkM3vk58ryRHHR9kZWO5DTWj/yYyP
         v+nbyWk+ZPga4HOKlUVJiKOCmqNI+CoRvoze+D1WWlsY3FVSFLVhHnVaUpymjI/1BIwi
         Vair+FS8jwdL7zas/aOnDrk1J7AgPTL3bNiCaztzudHQz/AJJQ/pFbKc/XUAW7cuow71
         UZqg==
X-Gm-Message-State: AOAM530H8z4u4PbBfPC4FmpyYI/HUWvMuodIs6ewtKbDN9P5iqNwa6Bk
        5IWc43O2CMT6tCZfHvO20zQEKybcLLs/hA==
X-Google-Smtp-Source: ABdhPJwovMk9JGoOBCcucNZN6nBvz6rLKaSPX1BElViDYKRoJjkij41PQF+4XXSXwuGL5EgL2OHUxw==
X-Received: by 2002:a65:5588:: with SMTP id j8mr13697777pgs.245.1608528359819;
        Sun, 20 Dec 2020 21:25:59 -0800 (PST)
Received: from [10.0.1.14] (c-24-4-128-201.hsd1.ca.comcast.net. [24.4.128.201])
        by smtp.gmail.com with ESMTPSA id d10sm14924404pfn.218.2020.12.20.21.25.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Dec 2020 21:25:58 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <X+AuxIkwmyo/9TD/@google.com>
Date:   Sun, 20 Dec 2020 21:25:56 -0800
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable@vger.kernel.org, minchan@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7986D881-3EBD-4197-A1A0-3B06BB2300B1@gmail.com>
References: <20201219043006.2206347-1-namit@vmware.com>
 <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
 <DD367393-D1B3-4A84-AF92-9C6BAEAB40DC@gmail.com>
 <X961C3heiGSJ5qVL@redhat.com>
 <729A8C1E-FC5B-4F46-AE01-85E00C66DFFF@gmail.com>
 <X+AuxIkwmyo/9TD/@google.com>
To:     Yu Zhao <yuzhao@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Dec 20, 2020, at 9:12 PM, Yu Zhao <yuzhao@google.com> wrote:
>=20
> On Sun, Dec 20, 2020 at 08:36:15PM -0800, Nadav Amit wrote:
>>> On Dec 19, 2020, at 6:20 PM, Andrea Arcangeli <aarcange@redhat.com> =
wrote:
>>>=20
>>> On Sat, Dec 19, 2020 at 02:06:02PM -0800, Nadav Amit wrote:
>>>>> On Dec 19, 2020, at 1:34 PM, Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>>>>=20
>>>>> [ cc=E2=80=99ing some more people who have experience with similar =
problems ]
>>>>>=20
>>>>>> On Dec 19, 2020, at 11:15 AM, Andrea Arcangeli =
<aarcange@redhat.com> wrote:
>>>>>>=20
>>>>>> Hello,
>>>>>>=20
>>>>>> On Fri, Dec 18, 2020 at 08:30:06PM -0800, Nadav Amit wrote:
>>>>>>> Analyzing this problem indicates that there is a real bug since
>>>>>>> mmap_lock is only taken for read in mwriteprotect_range(). This =
might
>>>>>>=20
>>>>>> Never having to take the mmap_sem for writing, and in turn never
>>>>>> blocking, in order to modify the pagetables is quite an important
>>>>>> feature in uffd that justifies uffd instead of mprotect. It's not =
the
>>>>>> most important reason to use uffd, but it'd be nice if that =
guarantee
>>>>>> would remain also for the UFFDIO_WRITEPROTECT API, not only for =
the
>>>>>> other pgtable manipulations.
>>>>>>=20
>>>>>>> Consider the following scenario with 3 CPUs (cpu2 is not shown):
>>>>>>>=20
>>>>>>> cpu0				cpu1
>>>>>>> ----				----
>>>>>>> userfaultfd_writeprotect()
>>>>>>> [ write-protecting ]
>>>>>>> mwriteprotect_range()
>>>>>>> mmap_read_lock()
>>>>>>> change_protection()
>>>>>>> change_protection_range()
>>>>>>> ...
>>>>>>> change_pte_range()
>>>>>>> [ defer TLB flushes]
>>>>>>> 				userfaultfd_writeprotect()
>>>>>>> 				 mmap_read_lock()
>>>>>>> 				 change_protection()
>>>>>>> 				 [ write-unprotect ]
>>>>>>> 				 ...
>>>>>>> 				  [ unprotect PTE logically ]
>>>=20
>>> Is the uffd selftest failing with upstream or after your kernel
>>> modification that removes the tlb flush from unprotect?
>>=20
>> Please see my reply to Yu. I was wrong in this analysis, and I sent a
>> correction to my analysis. The problem actually happens when
>> userfaultfd_writeprotect() unprotects the memory.
>>=20
>>> } else if (uffd_wp_resolve) {
>>> 				/*
>>> 				 * Leave the write bit to be handled
>>> 				 * by PF interrupt handler, then
>>> 				 * things like COW could be properly
>>> 				 * handled.
>>> 				 */
>>> 				ptent =3D pte_clear_uffd_wp(ptent);
>>> 			}
>>>=20
>>> Upstraem this will still do pages++, there's a tlb flush before
>>> change_protection can return here, so I'm confused.
>>=20
>> You are correct. The problem I encountered with =
userfaultfd_writeprotect()
>> is during unprotecting path.
>>=20
>> Having said that, I think that there are additional scenarios that =
are
>> problematic. Consider for instance madvise_dontneed_free() that is =
racing
>> with userfaultfd_writeprotect(). If madvise_dontneed_free() completed
>> removing the PTEs, but still did not flush, change_pte_range() will =
see
>> non-present PTEs, say a flush is not needed, and then
>> change_protection_range() will not do a flush, and return while
>> the memory is still not protected.
>>=20
>>> I don't share your concern. What matters is the PT lock, so it
>>> wouldn't be one per pte, but a least an order 9 higher, but let's
>>> assume one flush per pte.
>>>=20
>>> It's either huge mapping and then it's likely running without other
>>> tlb flushing in background (postcopy snapshotting), or it's a =
granular
>>> protect with distributed shared memory in which case the number of
>>> changd ptes or huge_pmds tends to be always 1 anyway. So it doesn't
>>> matter if it's deferred.
>>>=20
>>> I agree it may require a larger tlb flush review not just mprotect
>>> though, but it didn't sound particularly complex. Note the
>>> UFFDIO_WRITEPROTECT is still relatively recent so backports won't
>>> risk to reject so heavy as to require a band-aid.
>>>=20
>>> My second thought is, I don't see exactly the bug and it's not clear
>>> if it's upstream reproducing this, but assuming this happens on
>>> upstream, even ignoring everything else happening in the tlb flush
>>> code, this sounds like purely introduced by =
userfaultfd_writeprotect()
>>> vs userfaultfd_writeprotect() (since it's the only place changing
>>> protection with mmap_sem for reading and note we already unmap and
>>> flush tlb with mmap_sem for reading in MADV_DONTNEED/MADV_FREE =
clears
>>> the dirty bit etc..). Flushing tlbs with mmap_sem for reading is
>>> nothing new, the only new thing is the flush after wrprotect.
>>>=20
>>> So instead of altering any tlb flush code, would it be possible to
>>> just stick to mmap_lock for reading and then serialize
>>> userfaultfd_writeprotect() against itself with an additional
>>> mm->mmap_wprotect_lock mutex? That'd be a very local change to
>>> userfaultfd too.
>>>=20
>>> Can you look if the rule mmap_sem for reading plus a new
>>> mm->mmap_wprotect_lock mutex or the mmap_sem for writing, whenever
>>> wrprotecting ptes, is enough to comply with the current tlb flushing
>>> code, so not to require any change non local to uffd (modulo the
>>> additional mutex).
>>=20
>> So I did not fully understand your solution, but I took your point =
and
>> looked again on similar cases. To be fair, despite my experience with =
these
>> deferred TLB flushes as well as Peter Zijlstra=E2=80=99s great =
documentation, I keep
>> getting confused (e.g., can=E2=80=99t we somehow combine =
tlb_flush_batched and
>> tlb_flush_pending ?)
>>=20
>> As I said before, my initial scenario was wrong, and the problem is =
not
>> userfaultfd_writeprotect() racing against itself. This one seems =
actually
>> benign to me.
>>=20
>> Nevertheless, I do think there is a problem in =
change_protection_range().
>> Specifically, see the aforementioned scenario of a race between
>> madvise_dontneed_free() and userfaultfd_writeprotect().
>>=20
>> So an immediate solution for such a case can be resolve without =
holding
>> mmap_lock for write, by just adding a test for mm_tlb_flush_nested() =
in
>> change_protection_range():
>>=20
>>        /*
>> 	 * Only flush the TLB if we actually modified any entries
>> 	 * or if there are pending TLB flushes.
>> 	 */
>>        if (pages || mm_tlb_flush_nested(mm))
>>                flush_tlb_range(vma, start, end);
>>=20
>> To be fair, I am not confident I did not miss other problematic =
cases.
>>=20
>> But for now, this change, with the preserve_write change should =
address the
>> immediate issues. Let me know if you agree.
>>=20
>> Let me know whether you agree.
>=20
> The problem starts in UFD, and is related to tlb flush. But its focal
> point is in do_wp_page(). I'd suggest you look at function and see
> what it does before and after the commits I listed, with the following
> conditions
>=20
> PageAnon(), !PageKsm(), !PageSwapCache(), !pte_write(),
> page_mapcount() =3D 1, page_count() > 1 or PageLocked()
>=20
> when it runs against the two UFD examples you listed.

Thanks for your quick response. I wanted to write a lengthy response, =
but I
do want to sleep on it. I presume page_count() > 1, since I have =
multiple
concurrent page-faults on the same address in my test, but I will check.

Anyhow, before I give a further response, I was just wondering - since =
you
recently dealt with soft-dirty issue as I remember - isn't this =
problematic
COW for non-COW page scenario, in which the copy races with writes to a =
page
which is protected in the PTE but not in all TLB, also problematic for
soft-dirty clearing?

