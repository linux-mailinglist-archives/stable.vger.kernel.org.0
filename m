Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167E62E2364
	for <lists+stable@lfdr.de>; Thu, 24 Dec 2020 02:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbgLXBW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 20:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgLXBW0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 20:22:26 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF22C06179C
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 17:21:46 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id c79so432080pfc.2
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 17:21:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=wZ+Vbb60i9reBOltL3wNTLG+0CilvA1ys5nYLd3KMME=;
        b=GPuzEKGSkm+C7vd7yDf3Wz3xat4zjRFindzdesJ2x8vxzgswBN32c+fMI7ydV52IYa
         0CnpyYWpIT5UIpNLCJLT0LursrPWXwaEoz7R2yydXK43frH4R4A+jntMJlaFD5M0B8Qr
         A7V90bDlWWT+9qXHEYG+0XKJ6E4c/dPT556xHer1Uy91epEZUdDOw68lb8Z2zN3Ja5o/
         pngRJmI3fiBt6rAcOZJbg0bLmasflbMHYniWeWWXrv3Du2/zUubcsyBVW6V19kpJ/Bkl
         TJINJG1VvuoItplDlaaxoX+s+oNA+XDBuuvYhU0he3caSTiVj/LSoyNVhgOxNb1WoUbG
         eDhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=wZ+Vbb60i9reBOltL3wNTLG+0CilvA1ys5nYLd3KMME=;
        b=LuYtQZjXrloBVQ+gk6dmsJxx1NkrwpGbX+X1hJzdhkeGZ0tQhJR6UcLYrcE31VEziF
         WNv4gb01kruvY4YuTZfuV8jS9mgkfoxktncrp07HflIzAcsTeZOT+7MSSCyZbw4xZKQe
         sz+qtcsF+s4843bWpXNy1Jb1FIEcj0k3U5uNKJZS+0ijMeyzqsKdCQcSmlke+jTx466a
         kiAI696QbBSkBaJAthqf3LjaT9CczoSr4A8kL8lotXdYpEtY9GEAlFqqYfdb9FaFWmTw
         9w0Jh2/EEWqfYWTzQoGAQkmffdlacmgSNuXThH3c2Zo8yZD4CRcr9J9g3Idd2kqfo9eQ
         aY9g==
X-Gm-Message-State: AOAM531WJIecsdGLADi9L+HXBMertPYbQFXxGddC7myneRPbveGYrYtS
        90zgDXI3LoD455EpHD/QewfeWw==
X-Google-Smtp-Source: ABdhPJyl4lyfAfTxxeqYHRT6yUuJzZ3GYfT6m9WSFR4IrXUJ2GEP6j4xehyBLN89bNAraGCM5ueA+g==
X-Received: by 2002:a05:6a00:8c4:b029:196:6931:2927 with SMTP id s4-20020a056a0008c4b029019669312927mr2681447pfu.56.1608772905941;
        Wed, 23 Dec 2020 17:21:45 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:7126:6c30:69f6:6a9? ([2601:646:c200:1ef2:7126:6c30:69f6:6a9])
        by smtp.gmail.com with ESMTPSA id x10sm24208577pff.214.2020.12.23.17.21.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Dec 2020 17:21:45 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Date:   Wed, 23 Dec 2020 17:21:43 -0800
Message-Id: <C332B03D-30B1-4C9C-99C2-E76988BFC4A1@amacapital.net>
References: <X+PE38s2Egq4nzKv@google.com>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <X+PE38s2Egq4nzKv@google.com>
To:     Yu Zhao <yuzhao@google.com>
X-Mailer: iPhone Mail (18B121)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> On Dec 23, 2020, at 2:29 PM, Yu Zhao <yuzhao@google.com> wrote:
>=20

>=20
> I was hesitant to suggest the following because it isn't that straight
> forward. But since you seem to be less concerned with the complexity,
> I'll just bring it on the table -- it would take care of both ufd and
> clear_refs_write, wouldn't it?
>=20
> diff --git a/mm/memory.c b/mm/memory.c
> index 5e9ca612d7d7..af38c5ee327e 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4403,8 +4403,11 @@ static vm_fault_t handle_pte_fault(struct vm_fault *=
vmf)
>        goto unlock;
>    }
>    if (vmf->flags & FAULT_FLAG_WRITE) {
> -        if (!pte_write(entry))
> +        if (!pte_write(entry)) {
> +            if (mm_tlb_flush_pending(vmf->vma->vm_mm))
> +                flush_tlb_page(vmf->vma, vmf->address);
>            return do_wp_page(vmf);
> +        }

I don=E2=80=99t love this as a long term fix. AFAICT we can have mm_tlb_flus=
h_pending set for quite a while =E2=80=94 mprotect seems like it can wait in=
 IO while splitting a huge page, for example. That gives us a window in whic=
h every write fault turns into a TLB flush.

I=E2=80=99m not immediately sure how to do all that much better, though. We c=
ould potentially keep a record of pending ranges that need flushing per mm o=
r per PTL, protected by the PTL, and arrange to do the flush if we notice th=
at flushes are pending when we want to do_wp_page().  At least this would li=
mit us to one point extra flush, at least until the concurrent mprotect (or w=
hatever) makes further progress.  The bookkeeping might be nasty, though.

But x86 already sort of does some of this bookkeeping, and arguably x86=E2=80=
=99s code could be improved by tracking TLB ranges to flush per mm instead o=
f per flush request =E2=80=94 Nadav already got us half way there by making a=
 little cache of flush_tlb_info structs.  IMO it wouldn=E2=80=99t be totally=
 crazy to integrate this better with tlb_gather_mmu to make the pending flus=
h data visible to other CPUs even before actually kicking off the flush. In t=
he limit, this starts to look a bit like a fully async flush mechanism.  We w=
ould have a function to request a flush, and that function would return a ge=
neration count but not actually flush anything.  The case of flushing a rang=
e adjacent to a still-pending range would be explicitly optimized.  Then ano=
ther function would actually initiate and wait for the flush to complete.  A=
nd we could, while holding PTL, scan the list of pending flushes, if any, to=
 see if the PTE we=E2=80=99re looking at has a flush pending.  This is sort o=
f easy in the one-PTL-per-mm case but potentially rather complicated in the s=
plit PTL case.  And I=E2=80=99m genuinely unsure where the =E2=80=9Cbatch=E2=
=80=9D TLB flush interface fits in, because it can create a batch that spans=
 more than one mm.  x86 can deal with this moderately efficiently since we l=
imit the number of live mms per CPU and our flushes are (for now?) per cpu, n=
ot per mm.

u64 gen =3D 0;
for(...)
  gen =3D queue_flush(mm, start, end, freed_tables);
flush_to_gen(mm, gen);

and the wp fault path does:

wait_for_pending_flushes(mm, address);

Other than the possibility of devolving to one flush per operation if one th=
read is page faulting at the same speed that another thread is modifying PTE=
s, this should be decently performant.

