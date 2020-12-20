Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958722DF462
	for <lists+stable@lfdr.de>; Sun, 20 Dec 2020 09:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgLTIH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Dec 2020 03:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbgLTIH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Dec 2020 03:07:29 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D90C0613CF;
        Sun, 20 Dec 2020 00:06:42 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id b5so4663591pjl.0;
        Sun, 20 Dec 2020 00:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=3Wcun+zv/hhQE2K3TcWCKWB24fTPBiCA4UQ28awSatM=;
        b=I7yhK5wXqmGnt4AwF/BbAz/ynHIuyVIarnQXVsSVeupjujJdEMpZ6QnSvmvqaZE5fg
         AGk5XJbnKwCrWDICN0byKxPNEYzqXPCQkZHrjG0XPebHvPK9D8kHudqiwmBAgZs7KBt+
         i+Ff8k3SQWJdFj6Byu434Xs9126dZnExTR5qvwjNCyi6SS+R4TD4gIxNJnuGDQ+2/+7m
         icjJp+JmD29qB2fZfnD6eEuhffOk5Dsio5fJmoGOdazVwFJEiL333USGDYPqlBeioLcs
         Qh8tsnahBUi2M/nMggb4SLqn63m5HU9CeOOSgZtbhWIaZRj5czh/HZFbsfnL8D+dA5IH
         m3ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=3Wcun+zv/hhQE2K3TcWCKWB24fTPBiCA4UQ28awSatM=;
        b=bV2V5kDIUtBConrNnXxtB3GzZs2ILaIh5iHXign8FE6FoBwqcni3G332Dqg/dUa6qF
         hsIIgcmo7by4YUbt/vf1ck6XBqA6fCPyzrZezeB55bp9CIPpq+xj1dzMDuE9r0W8Q2is
         o5FaF6waolLXSidvtknWoevRYprR3AJUVUwwMGXkbtwh6Wc6ksdV0sMAsDysBeTiWd1N
         4pdQBXSOmitMQbZxsCebv9szQyk9b0iZ3AkyxwTVF5azv4BcaSWGVtR24ZZu+OvUDbUm
         19aquWFpCqHWwRgBPmOd8yhwMCG4eU5lSHggEphQh9OVzaCAKXTUm2OyhDYRv6D+22Qd
         xWQg==
X-Gm-Message-State: AOAM5312kgZoQ3wGtLIu7b8/6pPizhj1Ge5ZSGXvWQWDktYpTZUpKyII
        akiQxElcHsuRNDPapFtsnEY=
X-Google-Smtp-Source: ABdhPJwPlS6ZPqw+MisTBKarDSPQd+plS4TfpstHjZVwno3BIEi3z/ZaweENtfBX2IsioSakFZ/DaQ==
X-Received: by 2002:a17:90a:398d:: with SMTP id z13mr12209076pjb.1.1608451601658;
        Sun, 20 Dec 2020 00:06:41 -0800 (PST)
Received: from [10.0.1.10] (c-24-4-128-201.hsd1.ca.comcast.net. [24.4.128.201])
        by smtp.gmail.com with ESMTPSA id s29sm13830137pgn.65.2020.12.20.00.06.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Dec 2020 00:06:40 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <X97pprdcRXusLGnq@google.com>
Date:   Sun, 20 Dec 2020 00:06:38 -0800
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
Message-Id: <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com>
References: <20201219043006.2206347-1-namit@vmware.com>
 <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
 <X97pprdcRXusLGnq@google.com>
To:     Yu Zhao <yuzhao@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Dec 19, 2020, at 10:05 PM, Yu Zhao <yuzhao@google.com> wrote:
>=20
> On Sat, Dec 19, 2020 at 01:34:29PM -0800, Nadav Amit wrote:
>> [ cc=E2=80=99ing some more people who have experience with similar =
problems ]
>>=20
>>> On Dec 19, 2020, at 11:15 AM, Andrea Arcangeli <aarcange@redhat.com> =
wrote:
>>>=20
>>> Hello,
>>>=20
>>> On Fri, Dec 18, 2020 at 08:30:06PM -0800, Nadav Amit wrote:
>>>> Analyzing this problem indicates that there is a real bug since
>>>> mmap_lock is only taken for read in mwriteprotect_range(). This =
might
>>>=20
>>> Never having to take the mmap_sem for writing, and in turn never
>>> blocking, in order to modify the pagetables is quite an important
>>> feature in uffd that justifies uffd instead of mprotect. It's not =
the
>>> most important reason to use uffd, but it'd be nice if that =
guarantee
>>> would remain also for the UFFDIO_WRITEPROTECT API, not only for the
>>> other pgtable manipulations.
>>>=20
>>>> Consider the following scenario with 3 CPUs (cpu2 is not shown):
>>>>=20
>>>> cpu0				cpu1
>>>> ----				----
>>>> userfaultfd_writeprotect()
>>>> [ write-protecting ]
>>>> mwriteprotect_range()
>>>> mmap_read_lock()
>>>> change_protection()
>>>> change_protection_range()
>>>>  ...
>>>>  change_pte_range()
>>>>  [ defer TLB flushes]
>>>> 				userfaultfd_writeprotect()
>>>> 				 mmap_read_lock()
>>>> 				 change_protection()
>>>> 				 [ write-unprotect ]
>>>> 				 ...
>>>> 				  [ unprotect PTE logically ]
>>>> 				...
>>>> 				[ page-fault]
>>>> 				...
>>>> 				wp_page_copy()
>>>> 				[ set new writable page in PTE]
>=20
> I don't see any problem in this example -- wp_page_copy() calls
> ptep_clear_flush_notify(), which should take care of the stale entry
> left by cpu0.
>=20
> That being said, I suspect the memory corruption you observed is
> related this example, with cpu1 running something else that flushes
> conditionally depending on pte_write().
>=20
> Do you know which type of pages were corrupted? file, anon, etc.

First, Yu, you are correct. My analysis is incorrect, but let me have
another try (below). To answer your (and Andrea=E2=80=99s) question - =
this happens
with upstream without any changes, excluding a small fix to the =
selftest,
since it failed (got stuck) due to missing wake events. [1]

We are talking about anon memory.

So to correct myself, I think that what I really encountered was =
actually
during MM_CP_UFFD_WP_RESOLVE (i.e., when the protection is removed). The
problem was that in this case the =E2=80=9Cwrite=E2=80=9D-bit was =
removed during unprotect.
Sorry for the strange formatting to fit within 80 columns:


[ Start: PTE is writable ]

cpu0				cpu1			cpu2
----				----			----
							[ Writable PTE=20=

							  cached in TLB =
]
userfaultfd_writeprotect()			=09
[ write-*unprotect* ]
mwriteprotect_range()
mmap_read_lock()
change_protection()

change_protection_range()
 ...
 change_pte_range()
 [ *clear* =E2=80=9Cwrite=E2=80=9D-bit ]
 [ defer TLB flushes]
				[ page-fault ]
				=E2=80=A6
				wp_page_copy()
				 cow_user_page()
				  [ copy page ]
							[ write to old
							  page ]
				=E2=80=A6
				 set_pte_at_notify()

[ End: cpu2 write not copied form old to new page. ]


So this was actually resolved by the second part of the patch - changing
preserve_write in change_pte_range(). I removed the acquisition of =
mmap_lock
for write, left the change in change_pte_range() and the test passes.

Let me give some more thought on whether a mmap_lock is needed=20
for write. I need to rehash this TLB flushing algorithm.

Thanks,
Nadav

[1] https://lore.kernel.org/patchwork/patch/1346386=
