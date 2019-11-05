Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B76EEFB22
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 11:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388366AbfKEK3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 05:29:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:48128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388353AbfKEK3I (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 05:29:08 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CAE3206BA;
        Tue,  5 Nov 2019 10:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572949747;
        bh=G/WVsUl21Rq64gmthYTkqwJWzp0DE+l2howkOHhPxEw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JL+KtQdhjX7JvfqySLQldcTFbDnaDWodNj1cF1E06zcTwVUFsXU9y/1syzIdkunTl
         iihuftP1aFO1/g6kh0QIh3ufH8MbygWWIjfe1ekhs4LmxAey1FrhLJKnJO0fquUkYv
         zQdg+oQKpIMcjCn2Hkly/srC9lEC703r+2JqWXaM=
Date:   Tue, 5 Nov 2019 10:29:03 +0000
From:   Will Deacon <will@kernel.org>
To:     John Stultz <john.stultz@linaro.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        stable <stable@vger.kernel.org>,
        Alistair Delva <adelva@google.com>,
        Sandeep Patil <sspatil@google.com>
Subject: Re: [PATCH] arm64: Ensure VM_WRITE|VM_SHARED ptes are clean by
 default
Message-ID: <20191105102902.GB29852@willie-the-truck>
References: <20191029153051.24367-1-catalin.marinas@arm.com>
 <CALAqxLXuxZVg0kqNQXF_dH17NzH9m14-Ci_rzruHzmms0V7pvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLXuxZVg0kqNQXF_dH17NzH9m14-Ci_rzruHzmms0V7pvg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi John,

On Mon, Nov 04, 2019 at 05:16:42PM -0800, John Stultz wrote:
> On Tue, Oct 29, 2019 at 8:31 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> >
> > Shared and writable mappings (__S.1.) should be clean (!dirty) initially
> > and made dirty on a subsequent write either through the hardware DBM
> > (dirty bit management) mechanism or through a write page fault. A clean
> > pte for the arm64 kernel is one that has PTE_RDONLY set and PTE_DIRTY
> > clear.
> >
> > The PAGE_SHARED{,_EXEC} attributes have PTE_WRITE set (PTE_DBM) and
> > PTE_DIRTY clear. Prior to commit 73e86cb03cf2 ("arm64: Move PTE_RDONLY
> > bit handling out of set_pte_at()"), it was the responsibility of
> > set_pte_at() to set the PTE_RDONLY bit and mark the pte clean if the
> > software PTE_DIRTY bit was not set. However, the above commit removed
> > the pte_sw_dirty() check and the subsequent setting of PTE_RDONLY in
> > set_pte_at() while leaving the PAGE_SHARED{,_EXEC} definitions
> > unchanged. The result is that shared+writable mappings are now dirty by
> > default
> >
> > Fix the above by explicitly setting PTE_RDONLY in PAGE_SHARED{,_EXEC}.
> > In addition, remove the superfluous PTE_DIRTY bit from the kernel PROT_*
> > attributes.
> >
> > Fixes: 73e86cb03cf2 ("arm64: Move PTE_RDONLY bit handling out of set_pte_at()")
> > Cc: <stable@vger.kernel.org> # 4.14.x-
> > Cc: Will Deacon <will@kernel.org>
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> Hey,
>   So I'm not yet sure why, but I've just validated that this patch is
> causing trouble with booting AOSP on HiKey960 with 5.4-rc6 (-rc5 works
> fine).

Hmm. Annoying this wasn't spotted by CI.

> Its odd, because the system does boot and is alive, but seems to stall
> out at the boot animation, and userland never finishes coming up to
> the home screen. It just sits there without a useful error message
> that I can find so far.  Reverting just this patch seems to solve it
> and it boots all the way.

Given that I don't think the HiKey960 supports h/w DBM, my initial guess
is that the GPU is stuck on a page fault.

> I'll try to dig further to see what might be going on (the mali driver
> is a prime suspect here), but I wanted to raise the flag since we're
> at the end of the -rc cycle.

What exactly are you using for the mali driver?

As an experiment, can you try reverting just the part of the patch that
removes PTE_DIRTY from the PROT_* definitions? (see below)

Thanks,

Will

--->8

diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 8dc6c5cdabe6..17a8eb13f4ce 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -32,11 +32,11 @@
 #define PROT_DEFAULT		(_PROT_DEFAULT | PTE_MAYBE_NG)
 #define PROT_SECT_DEFAULT	(_PROT_SECT_DEFAULT | PMD_MAYBE_NG)
 
-#define PROT_DEVICE_nGnRnE	(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_WRITE | PTE_ATTRINDX(MT_DEVICE_nGnRnE))
-#define PROT_DEVICE_nGnRE	(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_WRITE | PTE_ATTRINDX(MT_DEVICE_nGnRE))
-#define PROT_NORMAL_NC		(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_WRITE | PTE_ATTRINDX(MT_NORMAL_NC))
-#define PROT_NORMAL_WT		(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_WRITE | PTE_ATTRINDX(MT_NORMAL_WT))
-#define PROT_NORMAL		(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_WRITE | PTE_ATTRINDX(MT_NORMAL))
+#define PROT_DEVICE_nGnRnE	(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_DIRTY | PTE_WRITE | PTE_ATTRINDX(MT_DEVICE_nGnRnE))
+#define PROT_DEVICE_nGnRE	(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_DIRTY | PTE_WRITE | PTE_ATTRINDX(MT_DEVICE_nGnRE))
+#define PROT_NORMAL_NC		(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_DIRTY | PTE_WRITE | PTE_ATTRINDX(MT_NORMAL_NC))
+#define PROT_NORMAL_WT		(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_DIRTY | PTE_WRITE | PTE_ATTRINDX(MT_NORMAL_WT))
+#define PROT_NORMAL		(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_DIRTY | PTE_WRITE | PTE_ATTRINDX(MT_NORMAL))
 
 #define PROT_SECT_DEVICE_nGnRE	(PROT_SECT_DEFAULT | PMD_SECT_PXN | PMD_SECT_UXN | PMD_ATTRINDX(MT_DEVICE_nGnRE))
 #define PROT_SECT_NORMAL	(PROT_SECT_DEFAULT | PMD_SECT_PXN | PMD_SECT_UXN | PMD_ATTRINDX(MT_NORMAL))
