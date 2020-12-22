Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567E52E0FC4
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 22:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgLVVPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 16:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbgLVVPl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 16:15:41 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729D4C061793;
        Tue, 22 Dec 2020 13:15:01 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id q4so8052645plr.7;
        Tue, 22 Dec 2020 13:15:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=A45ut6uIN2L7+l/sGdjppxZEAFQcj4+IojMqRdpCWPw=;
        b=c8jRMCmsalURJ1YVIlU5QMM+NG0JN1KFoToMjJlrbfR3mOzkizoWL55frFWy56GgR9
         Ss5J6fLwYa/byWMZEU9OSBParGw4elM98HVdSlIuTBYF4WFAIvYeIxAR1rEl3eKomNnF
         MaOrAktl1qZMMvCi9A0uswxcspCSq8Dxfh2TMSR1S+YTeS07GfMOGP4SxdvHs6rgR/Vm
         kUzMpHbBtUonFb5SpPYc/0gZNG2k/gNyvT/zw0YK5bdTf3JTNq8jVCQkPTNnqH30vhzf
         ndnDmZJIh0w+lG9vL5yumEb37QNJYil1RDeQHlJIpinyfcVFk/MbHVTswNiddty+jWZ2
         EXbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=A45ut6uIN2L7+l/sGdjppxZEAFQcj4+IojMqRdpCWPw=;
        b=SaUY5ltOyAsFgs3MKcgDqmzq1LHCuOuR+I5S4IrJK+p592iBHAMptmrerUJ1EOIX+l
         G/4pAKaD1FVvR6Mm2uTA1kwBuHmaXtKPik9XwEacXxyDC79xswI8GRzgpegx2hHYZQF0
         nU+Ph26eHDztokjFNwZHAHnRIVsD2E5qfj7uxts5lK5sZqKp1D5KHe/6vvjdebUfb6GB
         zDoQRspRwApKdXp0ssPZ5ucfItSki0Y8kaPtMFaJZe9EX8F9yDm2jiXza6bJyRCt/8A2
         xRytH18XgIx/p4/ht+/y8MzCXrq3COyFsSDT4cZi05gRdAVieiDopmCZWOYOyj4kl03p
         WxJg==
X-Gm-Message-State: AOAM532eguILgjIuMCt1KTU2CC8GFUMz9aLDcOdLnFmp0RRwdwZBfLUH
        z+T8QE1IEsoJp4YlateuyPY=
X-Google-Smtp-Source: ABdhPJzpHrQHlRj/syPSMFmEb6JKEwxRHbyaGwX8U+lpMwdYupT0/TDliy14n+a3fAs2h+1xxf1JNQ==
X-Received: by 2002:a17:90a:d308:: with SMTP id p8mr23890678pju.110.1608671700816;
        Tue, 22 Dec 2020 13:15:00 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:9423:6a08:cbd0:8220? ([2601:647:4700:9b2:9423:6a08:cbd0:8220])
        by smtp.gmail.com with ESMTPSA id a8sm21078104pfo.209.2020.12.22.13.14.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Dec 2020 13:14:59 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <X+JJqK91plkBVisG@redhat.com>
Date:   Tue, 22 Dec 2020 13:14:58 -0800
Cc:     Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, Yu Zhao <yuzhao@google.com>,
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
Message-Id: <55080C83-4047-4AA9-B6A3-785A1E4E17B1@gmail.com>
References: <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
 <X+D0hTZCrWS3P5Pi@google.com>
 <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1>
 <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <X+JJqK91plkBVisG@redhat.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Dec 22, 2020, at 11:31 AM, Andrea Arcangeli <aarcange@redhat.com> =
wrote:
>=20
> =46rom 4ace4d1b53f5cb3b22a5c2dc33facc4150b112d6 Mon Sep 17 00:00:00 =
2001
> From: Andrea Arcangeli <aarcange@redhat.com>
> Date: Tue, 22 Dec 2020 14:30:16 -0500
> Subject: [PATCH 1/1] mm: userfaultfd: avoid leaving stale TLB after
> userfaultfd_writeprotect()
>=20
> change_protection() is called by userfaultfd_writeprotect() with the
> mmap_lock_read like in change_prot_numa().
>=20
> The page fault code in wp_copy_page() rightfully assumes if the CPU
> issued a write fault and the write bit in the pagetable is not set, no
> CPU can write to the page. That's wrong assumption after
> userfaultfd_writeprotect(). That's also wrong assumption after
> change_prot_numa() where the regular page fault code also would assume
> that if the present bit is not set and the page fault is running,
> there should be no stale TLB entry, but there is still.
>=20
> So to stay safe, the page fault code must be prevented to run as long
> as long as the TLB flush remains pending. That is already achieved by
> the do_numa_page() path for change_prot_numa() and by the
> userfaultfd_pte_wp() path for userfaultfd_writeprotect().
>=20
> The problem that needs fixing is that an un-wrprotect
> (i.e. userfaultfd_writeprotect() with UFFDIO_WRITEPROTECT_MODE_WP not
> set) could run in between the original wrprotect
> (i.e. userfaultfd_writeprotect() with UFFDIO_WRITEPROTECT_MODE_WP set)
> and wp_copy_page, while the TLB flush remains pending.

I may need to read your patch more carefully, but in general I do not =
like
the approach. You are much more experienced than I am, but IMHO the TLB
flushing logic needs to be further simplified and generalized and not =
the
other way around.

The complexity is already too high. We have tlb_flush_batched and
tlb_flush_pending, which I think should be (somehow) combined.
tlb_gather_mmu() is designed for zapping, but can=E2=80=99t it be =
modified to suit
protection changes to avoid buggy use-cases (as the wrong use in
clear_refs_write() ) ?

So adding new userfaultfd specific code, which potentially does not =
address
all the interactions (now or the future), is concerning.

In this regard, a similar problem to the one in userfaultfd
(mmap_read_lock() while write-protecting) already exists with soft-dirty
clearing, so any solution should also address the soft-dirty issue.

