Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 197B62DF84F
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 05:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgLUEg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Dec 2020 23:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbgLUEg6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Dec 2020 23:36:58 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB87C061285;
        Sun, 20 Dec 2020 20:36:18 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id b5so5713489pjl.0;
        Sun, 20 Dec 2020 20:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=er+ipeu/poOdqTDZAuNQsbSQR97lvxpQszzjDt9p57c=;
        b=Zqj0pUaVgucofAUfGA6jsA7q+VLNGcoSAj8Eza52YmsdyTiOaQV6/NkRkWx3Obd0VI
         UIOJ0/Jy0f/4tNTRFxm0Rj9kU85DpaZvbp+Q+L/hHS/BOB71rw3/T16YRITjAuW2RHI+
         5dJaVkLT+BLTH3Qi5KcCBFFh/5bw6XtbfVGG8JcL40z7aQVUpsZuFkJvXX2BDMy14Dar
         O86IkXfQrYdEv53Km6XlR1Eqo6+7jsiQ+wyThH5CGFlqoXViLb0bcK3riWEYb+Pb7/k0
         YbUkrmyAXCINgr40djBlxsQzHZwGP0etmbT68oz5cdUfEac+NGO5zOx/sSrmmlJFfYZX
         +UDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=er+ipeu/poOdqTDZAuNQsbSQR97lvxpQszzjDt9p57c=;
        b=HbSEPvnM+llMu6D0j9AStQgUrL7ow9SSWV7EFH1QPKZuL8DAvnWkPLWywSEW4u5y3G
         2hWZ0i2U/ndTG4TkgVPUVNFiD/JTR0FKiLg2W0aDMGlBRTl6uIq+s1EPGNWaCEXmdrG/
         zpa7/576vyudREByihS33W1hh1nVzSvny5XftiZoXvhc0KiP4516ddnlUR5sl4Y3BU5w
         HDMitGkC0KEKbiv8mHdFbnWBz0L2MOz6NT1WJkXrm33oyR4DXVbnYQTs7L8xbDnLttHX
         Cxk5jnsCfSf1aiWv9Od/HNka1L+3foZPvuTvN2Wq0UyE1QoUdm2SS15MKDb2lKtmmVzo
         xV4g==
X-Gm-Message-State: AOAM532Icw82GEAruhKdSFtqMHK4IaozV82cIeBnDvh033zdEBdD6B7c
        LTMgkzXVdYia8BbnvmyGDak=
X-Google-Smtp-Source: ABdhPJxXN03oS9xkXOivxonNzHt1HjuvhYb7hY2h7LR+v05GxmGMpmLMR8ENUsHrk0B2kUBgVE+39Q==
X-Received: by 2002:a17:902:7d88:b029:db:7aa4:864c with SMTP id a8-20020a1709027d88b02900db7aa4864cmr14766782plm.34.1608525377910;
        Sun, 20 Dec 2020 20:36:17 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:104c:8d35:de28:b8dc? ([2601:647:4700:9b2:104c:8d35:de28:b8dc])
        by smtp.gmail.com with ESMTPSA id w27sm11247878pfq.104.2020.12.20.20.36.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Dec 2020 20:36:16 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <X961C3heiGSJ5qVL@redhat.com>
Date:   Sun, 20 Dec 2020 20:36:15 -0800
Cc:     linux-mm <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable@vger.kernel.org, minchan@kernel.org,
        Andy Lutomirski <luto@kernel.org>, yuzhao@google.com,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <729A8C1E-FC5B-4F46-AE01-85E00C66DFFF@gmail.com>
References: <20201219043006.2206347-1-namit@vmware.com>
 <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
 <DD367393-D1B3-4A84-AF92-9C6BAEAB40DC@gmail.com>
 <X961C3heiGSJ5qVL@redhat.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Dec 19, 2020, at 6:20 PM, Andrea Arcangeli <aarcange@redhat.com> =
wrote:
>=20
> On Sat, Dec 19, 2020 at 02:06:02PM -0800, Nadav Amit wrote:
>>> On Dec 19, 2020, at 1:34 PM, Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>>=20
>>> [ cc=E2=80=99ing some more people who have experience with similar =
problems ]
>>>=20
>>>> On Dec 19, 2020, at 11:15 AM, Andrea Arcangeli =
<aarcange@redhat.com> wrote:
>>>>=20
>>>> Hello,
>>>>=20
>>>> On Fri, Dec 18, 2020 at 08:30:06PM -0800, Nadav Amit wrote:
>>>>> Analyzing this problem indicates that there is a real bug since
>>>>> mmap_lock is only taken for read in mwriteprotect_range(). This =
might
>>>>=20
>>>> Never having to take the mmap_sem for writing, and in turn never
>>>> blocking, in order to modify the pagetables is quite an important
>>>> feature in uffd that justifies uffd instead of mprotect. It's not =
the
>>>> most important reason to use uffd, but it'd be nice if that =
guarantee
>>>> would remain also for the UFFDIO_WRITEPROTECT API, not only for the
>>>> other pgtable manipulations.
>>>>=20
>>>>> Consider the following scenario with 3 CPUs (cpu2 is not shown):
>>>>>=20
>>>>> cpu0				cpu1
>>>>> ----				----
>>>>> userfaultfd_writeprotect()
>>>>> [ write-protecting ]
>>>>> mwriteprotect_range()
>>>>> mmap_read_lock()
>>>>> change_protection()
>>>>> change_protection_range()
>>>>> ...
>>>>> change_pte_range()
>>>>> [ defer TLB flushes]
>>>>> 				userfaultfd_writeprotect()
>>>>> 				 mmap_read_lock()
>>>>> 				 change_protection()
>>>>> 				 [ write-unprotect ]
>>>>> 				 ...
>>>>> 				  [ unprotect PTE logically ]
>=20
> Is the uffd selftest failing with upstream or after your kernel
> modification that removes the tlb flush from unprotect?

Please see my reply to Yu. I was wrong in this analysis, and I sent a
correction to my analysis. The problem actually happens when
userfaultfd_writeprotect() unprotects the memory.

> 			} else if (uffd_wp_resolve) {
> 				/*
> 				 * Leave the write bit to be handled
> 				 * by PF interrupt handler, then
> 				 * things like COW could be properly
> 				 * handled.
> 				 */
> 				ptent =3D pte_clear_uffd_wp(ptent);
> 			}
>=20
> Upstraem this will still do pages++, there's a tlb flush before
> change_protection can return here, so I'm confused.
>=20

You are correct. The problem I encountered with =
userfaultfd_writeprotect()
is during unprotecting path.

Having said that, I think that there are additional scenarios that are
problematic. Consider for instance madvise_dontneed_free() that is =
racing
with userfaultfd_writeprotect(). If madvise_dontneed_free() completed
removing the PTEs, but still did not flush, change_pte_range() will see
non-present PTEs, say a flush is not needed, and then
change_protection_range() will not do a flush, and return while
the memory is still not protected.

> I don't share your concern. What matters is the PT lock, so it
> wouldn't be one per pte, but a least an order 9 higher, but let's
> assume one flush per pte.
>=20
> It's either huge mapping and then it's likely running without other
> tlb flushing in background (postcopy snapshotting), or it's a granular
> protect with distributed shared memory in which case the number of
> changd ptes or huge_pmds tends to be always 1 anyway. So it doesn't
> matter if it's deferred.
>=20
> I agree it may require a larger tlb flush review not just mprotect
> though, but it didn't sound particularly complex. Note the
> UFFDIO_WRITEPROTECT is still relatively recent so backports won't
> risk to reject so heavy as to require a band-aid.
>=20
> My second thought is, I don't see exactly the bug and it's not clear
> if it's upstream reproducing this, but assuming this happens on
> upstream, even ignoring everything else happening in the tlb flush
> code, this sounds like purely introduced by userfaultfd_writeprotect()
> vs userfaultfd_writeprotect() (since it's the only place changing
> protection with mmap_sem for reading and note we already unmap and
> flush tlb with mmap_sem for reading in MADV_DONTNEED/MADV_FREE clears
> the dirty bit etc..). Flushing tlbs with mmap_sem for reading is
> nothing new, the only new thing is the flush after wrprotect.
>=20
> So instead of altering any tlb flush code, would it be possible to
> just stick to mmap_lock for reading and then serialize
> userfaultfd_writeprotect() against itself with an additional
> mm->mmap_wprotect_lock mutex? That'd be a very local change to
> userfaultfd too.
>=20
> Can you look if the rule mmap_sem for reading plus a new
> mm->mmap_wprotect_lock mutex or the mmap_sem for writing, whenever
> wrprotecting ptes, is enough to comply with the current tlb flushing
> code, so not to require any change non local to uffd (modulo the
> additional mutex).

So I did not fully understand your solution, but I took your point and
looked again on similar cases. To be fair, despite my experience with =
these
deferred TLB flushes as well as Peter Zijlstra=E2=80=99s great =
documentation, I keep
getting confused (e.g., can=E2=80=99t we somehow combine =
tlb_flush_batched and
tlb_flush_pending ?)

As I said before, my initial scenario was wrong, and the problem is not
userfaultfd_writeprotect() racing against itself. This one seems =
actually
benign to me.

Nevertheless, I do think there is a problem in =
change_protection_range().
Specifically, see the aforementioned scenario of a race between
madvise_dontneed_free() and userfaultfd_writeprotect().

So an immediate solution for such a case can be resolve without holding
mmap_lock for write, by just adding a test for mm_tlb_flush_nested() in
change_protection_range():

        /*
	 * Only flush the TLB if we actually modified any entries
	 * or if there are pending TLB flushes.
	 */
        if (pages || mm_tlb_flush_nested(mm))
                flush_tlb_range(vma, start, end);
=20
To be fair, I am not confident I did not miss other problematic cases.

But for now, this change, with the preserve_write change should address =
the
immediate issues. Let me know if you agree.

Let me know whether you agree.

