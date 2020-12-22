Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76222E0831
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 10:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgLVJjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 04:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgLVJjL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 04:39:11 -0500
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE63EC0613D3;
        Tue, 22 Dec 2020 01:38:30 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id j8so2836865oon.3;
        Tue, 22 Dec 2020 01:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=GdOuNcmMMWH4z8sKpbvhRSL0GxJAY00N8icJZcixgRw=;
        b=KnWDrnUIm/QDsqn03+KLVq7vICriGback2SD3UVuwGF4E8dfq/oGJ4UdMf33MCSS3Q
         /Qs242BaKjd5AsW/liitV+duls56pSRtKmbpbcasJLfnW1v4eFPhVRZz6CY1AwTmhcUc
         z8Oe+E6mcNKVOHL1wfsBPTmvK1Xgs9Q0+YnmqPxIFO8ydN8ZHlz8AOQq9pl4WRZLxs2I
         ug8V3GALqSXCFhC/O+ebCIHUEDTVbOhjrp0KlEoxSvjgi3sfo6gx6wVFucrObaOLWlV0
         /Pe3cLmVVk7SLqrfmmDAM1hw/LTHpl8j/RZCk1PA8Y4KgIm4RU4XftWIK6IouGEIUOOY
         zfMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=GdOuNcmMMWH4z8sKpbvhRSL0GxJAY00N8icJZcixgRw=;
        b=WPsdk4MKdqYTGptwpqP86u/H35e+MHQGjrEreBAm+T0ZR+DIDkSBhppGVX0N8clU7t
         Vo14kP/uwzeobqzFs6ctyROB0wTcdhEWt7JXgrz6VrAy4F94q7oGZwLI5jaHNNLkO7PC
         iKyEZNtknbZxD6BUJ4r1TsQrHZi5qu/UK9O+S9MIGOFkMTtk8jqQu5GZ0Zh2pwwGftaY
         oPyuAjRKACKLoc+PdzRzq3W/ro/usxyVcW3jAV607U5sPTdC7+pnsdxjQH+9zFG5YmTv
         6K8vAFTSunM++dgN5buXVNSjcp/CveqD+rXngPFcDznpFf9OcMrKvVBmv6J9G39XsKb3
         dH3g==
X-Gm-Message-State: AOAM530JDMboNBUHEoHo9YNQVu1eYxdJ12eIqUGfmadY1Eq7ZYlp/WV5
        ZvpJHZlY3rV+nrncxtZ5gt4=
X-Google-Smtp-Source: ABdhPJzv2y/wl75u+LajXaDBgiMwbLVLmfiq0P2hPYaynriPLuJgfYNAVHm2Te03f2t6xsOg2yxGIQ==
X-Received: by 2002:a4a:9c01:: with SMTP id y1mr14202402ooj.15.1608629910042;
        Tue, 22 Dec 2020 01:38:30 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:9423:6a08:cbd0:8220? ([2601:647:4700:9b2:9423:6a08:cbd0:8220])
        by smtp.gmail.com with ESMTPSA id i194sm2011461oib.30.2020.12.22.01.38.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Dec 2020 01:38:29 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
Date:   Tue, 22 Dec 2020 01:38:27 -0800
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, Yu Zhao <yuzhao@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <757EEA98-4935-4283-849B-22CBFC352C45@gmail.com>
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
 <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
To:     Andy Lutomirski <luto@kernel.org>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Dec 21, 2020, at 7:19 PM, Andy Lutomirski <luto@kernel.org> wrote:
>=20
> On Mon, Dec 21, 2020 at 3:22 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Mon, Dec 21, 2020 at 2:30 PM Peter Xu <peterx@redhat.com> wrote:
>>> AFAIU mprotect() is the only one who modifies the pte using the mmap =
write
>>> lock.  NUMA balancing is also using read mmap lock when changing pte
>>> protections, while my understanding is mprotect() used write lock =
only because
>>> it manipulates the address space itself (aka. vma layout) rather =
than modifying
>>> the ptes, so it needs to.
>>=20
>> So it's ok to change the pte holding only the PTE lock, if it's a
>> *one*way* conversion.
>>=20
>> That doesn't break the "re-check the PTE contents" model (which
>> predates _all_ of the rest: NUMA, userfaultfd, everything - it's
>> pretty much the original model for our page table operations, and =
goes
>> back to the dark ages even before SMP and the existence of a page
>> table lock).
>>=20
>> So for example, a COW will always create a different pte (not just
>> because the page number itself changes - you could imagine a page
>> getting re-used and changing back - but because it's always a RO->RW
>> transition).
>>=20
>> So two COW operations cannot "undo" each other and fool us into
>> thinking nothing changed.
>>=20
>> Anything that changes RW->RO - like fork(), for example - needs to
>> take the mmap_lock.
>=20
> Ugh, this is unpleasantly complicated.  I will admit that any API that
> takes an address and more-or-less-blindly marks it RO makes me quite
> nervous even assuming all the relevant locks are held.  At least
> userfaultfd refuses to operate on VM_SHARED VMAs, but we have another
> instance of this (with mmap_sem held for write) in x86:
> mark_screen_rdonly().  Dare I ask how broken this is?  We could likely
> get away with deleting it entirely.

If you only look at the function in isolation, it seems broken. It =
should
have flushed the TLB before releasing the mmap_lock. After the
mmap_write_unlock() and before the actual flush, a #PF on another thread =
can
happen, and a similar scenario to the one that is mentioned in this =
thread
(copying while a stale PTE in the TLBs is not-writeprotected) might =
happen.

Having said that, I do not know this code and the context in which this
function is called, so I do not know whether there are other mitigating
factors.

Funny, I had a deja-vu and indeed you have already raised (other) TLB =
issues
with mark_screen_rdonly() 3 years ago. At the time you said "I'd like to
delete it.=E2=80=9D [1]

[1] https://lore.kernel.org/patchwork/patch/782486/#976151=
