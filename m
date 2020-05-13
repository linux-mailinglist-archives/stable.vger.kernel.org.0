Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D120F1D0FEC
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730571AbgEMKfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 06:35:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728258AbgEMKfv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 06:35:51 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EBDF206CC;
        Wed, 13 May 2020 10:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589366150;
        bh=w+5s3lus8Lc4nK4veaC2q/cQhOAAUh0GIUPg/jDsBxY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s/4QjkSoXbi4KctO3OmQR1vCFqC3KmZonuvzK6SJTWe3YH8B5Hs9Qa3kwuyTI9r1p
         3D6C3G4BI0KpPqyTIhd5qLHbIItevxj/tuiguynZmMSWdF+3WJZbhgR27dZNDzL8wu
         vpBl8YFgD8Zlu6g59MAdL4jiDFCaOiaGcLCSHAXk=
Date:   Wed, 13 May 2020 11:35:45 +0100
From:   Will Deacon <will@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>, sashal@kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, catalin.marinas@arm.com,
        kyrylo.tkachov@arm.com, linux- stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] arm64: hugetlb: avoid potential NULL
 dereference" failed to apply to 4.9-stable tree
Message-ID: <20200513103545.GA20278@willie-the-truck>
References: <158928280292134@kroah.com>
 <CA+G9fYvoMhYHihJCq9eF7F0YwaL+s-n7nzPERmzbr08iL_Jwgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvoMhYHihJCq9eF7F0YwaL+s-n7nzPERmzbr08iL_Jwgw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[+Sasha, as I think he did the backport]

On Wed, May 13, 2020 at 04:02:09PM +0530, Naresh Kamboju wrote:
> On Tue, 12 May 2020 at 16:56, <gregkh@linuxfoundation.org> wrote:
> >
> >
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> >
> > thanks,
> >
> > greg k-h
> >
> > ------------------ original commit in Linus's tree ------------------
> >
> > From 027d0c7101f50cf03aeea9eebf484afd4920c8d3 Mon Sep 17 00:00:00 2001
> > From: Mark Rutland <mark.rutland@arm.com>
> > Date: Tue, 5 May 2020 13:59:30 +0100
> > Subject: [PATCH] arm64: hugetlb: avoid potential NULL dereference
> > MIME-Version: 1.0
> > Content-Type: text/plain; charset=UTF-8
> > Content-Transfer-Encoding: 8bit
> >
> > The static analyzer in GCC 10 spotted that in huge_pte_alloc() we may
> > pass a NULL pmdp into pte_alloc_map() when pmd_alloc() returns NULL:
> >
> > |   CC      arch/arm64/mm/pageattr.o
> > |   CC      arch/arm64/mm/hugetlbpage.o
> > |                  from arch/arm64/mm/hugetlbpage.c:10:
> > | arch/arm64/mm/hugetlbpage.c: In function ‘huge_pte_alloc’:
> > | ./arch/arm64/include/asm/pgtable-types.h:28:24: warning: dereference of NULL ‘pmdp’ [CWE-690] [-Wanalyzer-null-dereference]
> > | ./arch/arm64/include/asm/pgtable.h:436:26: note: in expansion of macro ‘pmd_val’
> > | arch/arm64/mm/hugetlbpage.c:242:10: note: in expansion of macro ‘pte_alloc_map’
> > |     |arch/arm64/mm/hugetlbpage.c:232:10:
> > |     |./arch/arm64/include/asm/pgtable-types.h:28:24:
> > | ./arch/arm64/include/asm/pgtable.h:436:26: note: in expansion of macro ‘pmd_val’
> > | arch/arm64/mm/hugetlbpage.c:242:10: note: in expansion of macro ‘pte_alloc_map’
> >
> > This can only occur when the kernel cannot allocate a page, and so is
> > unlikely to happen in practice before other systems start failing.
> >
> > We can avoid this by bailing out if pmd_alloc() fails, as we do earlier
> > in the function if pud_alloc() fails.
> >
> > Fixes: 66b3923a1a0f ("arm64: hugetlb: add support for PTE contiguous bit")
> > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> > Reported-by: Kyrill Tkachov <kyrylo.tkachov@arm.com>
> > Cc: <stable@vger.kernel.org> # 4.5.x-
> > Cc: Will Deacon <will@kernel.org>
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> >
> > diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> > index bbeb6a5a6ba6..0be3355e3499 100644
> > --- a/arch/arm64/mm/hugetlbpage.c
> > +++ b/arch/arm64/mm/hugetlbpage.c
> > @@ -230,6 +230,8 @@ pte_t *huge_pte_alloc(struct mm_struct *mm,
> >                 ptep = (pte_t *)pudp;
> >         } else if (sz == (CONT_PTE_SIZE)) {
> >                 pmdp = pmd_alloc(mm, pudp, addr);
> > +               if (!pmdp)
> > +                       return NULL;
> >
> >                 WARN_ON(addr & (sz - 1));
> >                 /*
> >
> 
> on stable-rc 4.9 branch arm64 architecture build failed.
> 
>   CC      arch/arm64/mm/hugetlbpage.o
> arch/arm64/mm/hugetlbpage.c: In function 'huge_pte_alloc':
> arch/arm64/mm/hugetlbpage.c:106:8: error: 'pmdp' undeclared (first use
> in this function); did you mean 'pmd'?
>    if (!pmdp)
>         ^~~~
>         pmd
> arch/arm64/mm/hugetlbpage.c:106:8: note: each undeclared identifier is
> reported only once for each function it appears in
> scripts/Makefile.build:304: recipe for target
> 'arch/arm64/mm/hugetlbpage.o' failed
> 
> ref:
> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.9/DISTRO=lkft,MACHINE=hikey,label=docker-lkft/893/consoleText
> 
> -- 
> Linaro LKFT
> https://lkft.linaro.org
