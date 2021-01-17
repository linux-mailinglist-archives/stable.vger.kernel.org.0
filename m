Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47BF2F9141
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 08:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbhAQHdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 02:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbhAQHdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 02:33:07 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EFAC061573;
        Sat, 16 Jan 2021 23:32:27 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id m6so8292628pfm.6;
        Sat, 16 Jan 2021 23:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=sBCeRfGu3HpuvJkTgZps1o7i3Djrk1XekJ+FW6NcBqc=;
        b=dEmqzX6MzUfLYobSu1aZQcbPqdtr+PoobwUvgSutjIUk5jYrWmY96/Ar8lCz7v/N/H
         XAflD5Fs45bb/eZ8Gfw+A0bNu20iXGdf9QqcAEJwb+joLWMuroZ8znoL+qaTiO9rmm9C
         J0o+Q7lXt5IDZUvS7tBRpg2tAa2UHXwxfjDrrOlvsK2gS8KXJ5B3tpwZ00dgSc7fsYVn
         DaZZVk+OvWl6ofIgd7oy1s6QgOPAHiVMFxmSYatvO5PDRtz/PZHdBFuP0SMgxN9Lv6Go
         wQL80mwYLSU/3XFjudprp5/OFNS6GRHahRd+OYx+j7ju3x9adYm48ZnYJZYStt3cvuk5
         bBMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=sBCeRfGu3HpuvJkTgZps1o7i3Djrk1XekJ+FW6NcBqc=;
        b=a/+5FipyQ3wlR6Y/DNiBzT+bwdp3HkVMc82tTCLXZfJ7vn6QXX+O5no58xQiec2y50
         zyeDpjsCpLGmfh+wUpKeBOiB8xzgFyTI07szgo5OfwVJFPAbuWta21Cc8gtWH2dNm2Pi
         bfYInOLP2/8pyGqhJ2vfTBGJCSmRsV660/RdWVWnpKMKCvTcKQDlZwC17YYkihjPSKGb
         VsyW20dXprTSfH2OPDj4W8wfh62rx+DHcJcSORn3hYSemIypKklvzfI5yhEJ532HHMV4
         nggm9HixbY3gkic40lgHGvJ/sixmkZHpHDPFh+RMcsBjDwASdQf7SG7G5xJxk11kOakZ
         3syw==
X-Gm-Message-State: AOAM533+CeyELVVwzkWNKh33OlkfwkW2Ltrnt1kwz6kTkDt0Eko+4woN
        il0BrQSxfeN3uFAcrKDhsVU=
X-Google-Smtp-Source: ABdhPJz4HmBhYzLyT3UJ9TwbKiLmgP2cMQv0LvOHakHdeqzb/EXgR825ZilvQT0XrXc/3UZ/1K+MBw==
X-Received: by 2002:a05:6a00:2296:b029:1b6:6972:2f2a with SMTP id f22-20020a056a002296b02901b669722f2amr3457483pfe.69.1610868745983;
        Sat, 16 Jan 2021 23:32:25 -0800 (PST)
Received: from [192.168.88.245] (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id u1sm12207007pjr.51.2021.01.16.23.32.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 Jan 2021 23:32:25 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <YAO/9YVceghRYo4T@google.com>
Date:   Sat, 16 Jan 2021 23:32:22 -0800
Cc:     Will Deacon <will@kernel.org>,
        Laurent Dufour <ldufour@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vinayak Menon <vinmenon@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>, surenb@google.com,
        Mel Gorman <mgorman@suse.de>
Content-Transfer-Encoding: quoted-printable
Message-Id: <85DAADF4-2537-40BD-8580-A57C201FF5F3@gmail.com>
References: <CAHk-=wj=CcOHQpG0cUGfoMCt2=Uaifpqq-p-mMOmW8XmrBn4fQ@mail.gmail.com>
 <20210105153727.GK3040@hirez.programming.kicks-ass.net>
 <bfb1cbe6-a705-469d-c95a-776624817e33@codeaurora.org>
 <0201238b-e716-2a3c-e9ea-d5294ff77525@linux.vnet.ibm.com>
 <X/3VE64nr91WCtuM@hirez.programming.kicks-ass.net>
 <ec912505-ed4d-a45d-2ed4-7586919da4de@linux.vnet.ibm.com>
 <C7D5A74C-25BF-458A-AAD9-61E484B9F225@gmail.com>
 <X/3+6ZnRCNOwhjGT@google.com>
 <2C7AE23B-ACA3-4D55-A907-AF781C5608F0@gmail.com>
 <20210112214337.GA10434@willie-the-truck> <YAO/9YVceghRYo4T@google.com>
To:     Yu Zhao <yuzhao@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Jan 16, 2021, at 8:41 PM, Yu Zhao <yuzhao@google.com> wrote:
>=20
> On Tue, Jan 12, 2021 at 09:43:38PM +0000, Will Deacon wrote:
>> On Tue, Jan 12, 2021 at 12:38:34PM -0800, Nadav Amit wrote:
>>>> On Jan 12, 2021, at 11:56 AM, Yu Zhao <yuzhao@google.com> wrote:
>>>> On Tue, Jan 12, 2021 at 11:15:43AM -0800, Nadav Amit wrote:
>>>>> I will send an RFC soon for per-table deferred TLB flushes =
tracking.
>>>>> The basic idea is to save a generation in the page-struct that =
tracks
>>>>> when deferred PTE change took place, and track whenever a TLB =
flush
>>>>> completed. In addition, other users - such as mprotect - would use
>>>>> the tlb_gather interface.
>>>>>=20
>>>>> Unfortunately, due to limited space in page-struct this would only
>>>>> be possible for 64-bit (and my implementation is only for x86-64).
>>>>=20
>>>> I don't want to discourage you but I don't think this would end up
>>>> well. PPC doesn't necessarily follow one-page-struct-per-table =
rule,
>>>> and I've run into problems with this before while trying to do
>>>> something similar.
>>>=20
>>> Discourage, discourage. Better now than later.
>>>=20
>>> It will be relatively easy to extend the scheme to be per-VMA =
instead of
>>> per-table for architectures that prefer it this way. It does require
>>> TLB-generation tracking though, which Andy only implemented for x86, =
so I
>>> will focus on x86-64 right now.
>>=20
>> Can you remind me of what we're missing on arm64 in this area, =
please? I'm
>> happy to help get this up and running once you have something I can =
build
>> on.
>=20
> I noticed arm/arm64 don't support ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH.
> Would it be something worth pursuing? Arm has been using mm_cpumask,
> so it might not be too difficult I guess?

[ +Mel Gorman who implemented ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH ]

IIUC, there are at least two bugs in x86 implementation.

First, there is a missing memory barrier in tlbbatch_add_mm() between
inc_mm_tlb_gen() and the read of mm_cpumask().

Second, try_to_unmap_flush() clears flush_required after flushing. =
Another
thread can call set_tlb_ubc_flush_pending() after the flush and before
flush_required is cleared, and the indication that a TLB flush is =
pending
can be lost.

I am working on addressing these issues among others, but, as you =
already
saw, I am a bit slow.

On a different but related topic: Another thing that I noticed that Arm =
does
not do is batching TLB flushes across VMAs. Since Arm does not have its =
own
tlb_end_vma(), it uses the default tlb_end_vma(), which flushes each VMA
separately. Peter Zijlstra=E2=80=99s comment says that there are =
advantages in
flushing each VMA separately, but I am not sure it is better or =
intentional
(especially since x86 does not do so).

I am trying to remove the arch-specific tlb_end_vma() and have a config
option to control this behavior.

Again, sorry for being slow. I hope to send an RFC soon.

