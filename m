Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF8C2E0F8C
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 22:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgLVU7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 15:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgLVU7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 15:59:01 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6088DC0613D3;
        Tue, 22 Dec 2020 12:58:21 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id j13so2003103pjz.3;
        Tue, 22 Dec 2020 12:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=hFSc9FSGfXt5RJ/U1wrUckzp9K5oSW3F5ZWFwEZmzz4=;
        b=EZ9+2eTOIuphksIUHGK4Bd+RgU5J1ftLLzRO1FURanj77kxWwUT3/WDxpSPNs3Pt6E
         D2YuqBw8Q5mYQH+n9xIMfYZPeKsfp8oI2pUW4CpBGH2+n4i4MmbLRhI8KQUhXcqtSSy0
         mwlS915LvFAYmy8p5FaHyMNM5dToIx8aGssmSK1y7jBadSfaGiRt6MJBl9unaq9ACxcZ
         fu29VOlqGACOPVjbUvOPHHKxWVWgv8HGU9h3+Nw0JfGEaUUgqMzFEmgDXfHKFEsHZw8J
         GiGSy5sbuamuZsYCUBnjYWMmXwf017HZ83ZipjNsKYzHTx4B8Gsimz6NA5sxzD9ZuLmV
         2y7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=hFSc9FSGfXt5RJ/U1wrUckzp9K5oSW3F5ZWFwEZmzz4=;
        b=OuNdcFSgedexAAeQU8SlZroYIpu8MKVAjcvUAkaJKUr+NXjnQRVOGKQWLc1s27BJgp
         WidDdpu/zCpAijTtp3iSB837EIELDmpZgqNzcRQOlaER38in0lTVLfJTO/Bhio54QJry
         ZUZl2mvKvZqZaNnP4K2ZuqAzr03N1vmiMzo5j7Y/1VCYik1YQ7Qbn9+7kk1sS05H+NI+
         bpI45cZUelIHM61kWiTgo/L8U/E+G4RONyVD02nLm6zyym1hsJ/iAtjT6Nxs5OLaTMbg
         HyU7WLY0lPj3YOQiEjn/MNmuyra4LxfF4c2EDPu0yBG0nHQyrBr1KMW81X6ytG5B0xAI
         TwRA==
X-Gm-Message-State: AOAM532h6owd6WiU8wgHOZl2GBB/Zw3TmXYzGsY/JwqJNfwSE2QgAJ/P
        c9yyhGU65/NhqGeHzar4L6A=
X-Google-Smtp-Source: ABdhPJxtWe0H6ZwfwtolSaz++yJc8Ub6des8zIFUZYieKDj2Z3Jd+LIpa+8rO/POkVF5Jh57KKSklg==
X-Received: by 2002:a17:902:bf4a:b029:da:d0b8:6489 with SMTP id u10-20020a170902bf4ab02900dad0b86489mr22482160pls.58.1608670700762;
        Tue, 22 Dec 2020 12:58:20 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:9423:6a08:cbd0:8220? ([2601:647:4700:9b2:9423:6a08:cbd0:8220])
        by smtp.gmail.com with ESMTPSA id a29sm21727154pfr.73.2020.12.22.12.58.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Dec 2020 12:58:19 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CALCETrXLH7vPep-h4fBFSft1YEkyZQo_7W2uh017rHKYT=Occw@mail.gmail.com>
Date:   Tue, 22 Dec 2020 12:58:18 -0800
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <719DF2CD-A0BC-4B67-9FBA-A9E0A98AA45E@gmail.com>
References: <20201219043006.2206347-1-namit@vmware.com>
 <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
 <DD367393-D1B3-4A84-AF92-9C6BAEAB40DC@gmail.com>
 <CALCETrXLH7vPep-h4fBFSft1YEkyZQo_7W2uh017rHKYT=Occw@mail.gmail.com>
To:     Andy Lutomirski <luto@kernel.org>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Dec 22, 2020, at 12:34 PM, Andy Lutomirski <luto@kernel.org> wrote:
>=20
> On Sat, Dec 19, 2020 at 2:06 PM Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>> [ I have in mind another solution, such as keeping in each =
page-table a
>>> =E2=80=9Ctable-generation=E2=80=9D which is the mm-generation at the =
time of the change,
>>> and only flush if =E2=80=9Ctable-generation=E2=80=9D=3D=3D=E2=80=9Cmm-=
generation=E2=80=9D, but it requires
>>> some thought on how to avoid adding new memory barriers. ]
>>>=20
>>> IOW: I think the change that you suggest is insufficient, and a =
proper
>>> solution is too intrusive for =E2=80=9Cstable".
>>>=20
>>> As for performance, I can add another patch later to remove the TLB =
flush
>>> that is unnecessarily performed during change_protection_range() =
that does
>>> permission promotion. I know that your concern is about the =
=E2=80=9Cprotect=E2=80=9D case
>>> but I cannot think of a good immediate solution that avoids taking =
mmap_lock
>>> for write.
>>>=20
>>> Thoughts?
>>=20
>> On a second thought (i.e., I don=E2=80=99t know what I was thinking), =
doing so =E2=80=94
>> checking mm_tlb_flush_pending() on every PTE read which is =
potentially
>> dangerous and flushing if needed - can lead to huge amount of TLB =
flushes
>> and shootodowns as the counter might be elevated for considerable =
amount of
>> time.
>=20
> I've lost track as to whether we still think that this particular
> problem is really a problem,

If you mean =E2=80=9Cproblem=E2=80=9D as to whether there is a =
correctness issue with
userfaultfd and soft-dirty deferred flushes under mmap_read_lock() - yes
there is a problem and I produced these failures on upstream.

If you mean =E2=80=9Cproblem=E2=80=9D as to performance - I do not know.

> but could we perhaps make the
> tlb_flush_pending field be per-ptl instead of per-mm?  Depending on
> how it gets used, it could plausibly be done without atomics or
> expensive barriers by using PTL to protect the field.
>=20
> FWIW, x86 has a mm generation counter, and I don't think it would be
> totally crazy to find a way to expose an mm generation to core code.
> I don't think we'd want to expose the specific data structures that
> x86 uses to track it -- they're very tailored to the oddities of x86
> TLB management.  x86 also doesn't currently have any global concept of
> which mm generation is guaranteed to have been propagated to all CPUs
> -- we track the generation in the pagetables and, per cpu, the
> generation that we know that CPU has seen.  x86 could offer a function
> "ensure that all CPUs catch up to mm generation G and don't return
> until this happens" and its relative "have all CPUs caught up to mm
> generation G", but these would need to look at data from multiple CPUs
> and would probably be too expensive on very large systems to use in
> normal page faults unless we were to cache the results somewhere.
> Making a nice cache for this is surely doable, but maybe more
> complexity than we'd want.

I had somewhat similar ideas - saving in each page-struct the =
generation,
which would allow to: (1) extend pte_same() to detect interim changes
that were reverted (RO->RW->RO) and (2) per-PTE pending flushes.

Obviously, I cannot do it as part of this fix. But moreover, it seems to =
me
that it would require a memory barrier after updating the PTEs and =
before
reading the current generation (that would be saved per page-table). I
try to think about schemes that would use the per-CPU generation =
instead,
but still could not and did not have the time to figure it out.

