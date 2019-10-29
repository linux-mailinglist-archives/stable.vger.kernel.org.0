Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6176BE8D52
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 17:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390518AbfJ2Qwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 12:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728379AbfJ2Qwc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Oct 2019 12:52:32 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 575E620830;
        Tue, 29 Oct 2019 16:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572367951;
        bh=/xPAn8Sk9dCIzghMhid4D0jMyfoW5DypzcmaK5H2oUM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GOA/bJ0wpR3T53VIloQkigdy+c+Sd+qy2Sq4cWRRqWDnjYCUQdvveTMBYnKHO2XeL
         4Kx9vEk7Gh7hzheKNqc5DD6O3wMiAHp2X7I8/ty7SY8c89FGzDBBV65F5QfgxBbkUq
         h53DlTEOjyXUecLkymNx52eNAtlUUb2BWIn/jSI8=
Date:   Tue, 29 Oct 2019 16:52:26 +0000
From:   Will Deacon <will@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: Ensure VM_WRITE|VM_SHARED ptes are clean by
 default
Message-ID: <20191029165226.GA13281@willie-the-truck>
References: <20191029153051.24367-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029153051.24367-1-catalin.marinas@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 29, 2019 at 03:30:51PM +0000, Catalin Marinas wrote:
> Shared and writable mappings (__S.1.) should be clean (!dirty) initially
> and made dirty on a subsequent write either through the hardware DBM
> (dirty bit management) mechanism or through a write page fault. A clean
> pte for the arm64 kernel is one that has PTE_RDONLY set and PTE_DIRTY
> clear.
> 
> The PAGE_SHARED{,_EXEC} attributes have PTE_WRITE set (PTE_DBM) and
> PTE_DIRTY clear. Prior to commit 73e86cb03cf2 ("arm64: Move PTE_RDONLY
> bit handling out of set_pte_at()"), it was the responsibility of
> set_pte_at() to set the PTE_RDONLY bit and mark the pte clean if the
> software PTE_DIRTY bit was not set. However, the above commit removed
> the pte_sw_dirty() check and the subsequent setting of PTE_RDONLY in
> set_pte_at() while leaving the PAGE_SHARED{,_EXEC} definitions
> unchanged. The result is that shared+writable mappings are now dirty by
> default
> 
> Fix the above by explicitly setting PTE_RDONLY in PAGE_SHARED{,_EXEC}.
> In addition, remove the superfluous PTE_DIRTY bit from the kernel PROT_*
> attributes.
> 
> Fixes: 73e86cb03cf2 ("arm64: Move PTE_RDONLY bit handling out of set_pte_at()")
> Cc: <stable@vger.kernel.org> # 4.14.x-
> Cc: Will Deacon <will@kernel.org>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm64/include/asm/pgtable-prot.h | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
> index 9a21b84536f2..8dc6c5cdabe6 100644
> --- a/arch/arm64/include/asm/pgtable-prot.h
> +++ b/arch/arm64/include/asm/pgtable-prot.h
> @@ -32,11 +32,11 @@
>  #define PROT_DEFAULT		(_PROT_DEFAULT | PTE_MAYBE_NG)
>  #define PROT_SECT_DEFAULT	(_PROT_SECT_DEFAULT | PMD_MAYBE_NG)
>  
> -#define PROT_DEVICE_nGnRnE	(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_DIRTY | PTE_WRITE | PTE_ATTRINDX(MT_DEVICE_nGnRnE))
> -#define PROT_DEVICE_nGnRE	(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_DIRTY | PTE_WRITE | PTE_ATTRINDX(MT_DEVICE_nGnRE))
> -#define PROT_NORMAL_NC		(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_DIRTY | PTE_WRITE | PTE_ATTRINDX(MT_NORMAL_NC))
> -#define PROT_NORMAL_WT		(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_DIRTY | PTE_WRITE | PTE_ATTRINDX(MT_NORMAL_WT))
> -#define PROT_NORMAL		(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_DIRTY | PTE_WRITE | PTE_ATTRINDX(MT_NORMAL))
> +#define PROT_DEVICE_nGnRnE	(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_WRITE | PTE_ATTRINDX(MT_DEVICE_nGnRnE))
> +#define PROT_DEVICE_nGnRE	(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_WRITE | PTE_ATTRINDX(MT_DEVICE_nGnRE))
> +#define PROT_NORMAL_NC		(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_WRITE | PTE_ATTRINDX(MT_NORMAL_NC))
> +#define PROT_NORMAL_WT		(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_WRITE | PTE_ATTRINDX(MT_NORMAL_WT))
> +#define PROT_NORMAL		(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_WRITE | PTE_ATTRINDX(MT_NORMAL))
>  
>  #define PROT_SECT_DEVICE_nGnRE	(PROT_SECT_DEFAULT | PMD_SECT_PXN | PMD_SECT_UXN | PMD_ATTRINDX(MT_DEVICE_nGnRE))
>  #define PROT_SECT_NORMAL	(PROT_SECT_DEFAULT | PMD_SECT_PXN | PMD_SECT_UXN | PMD_ATTRINDX(MT_NORMAL))
> @@ -80,8 +80,9 @@
>  #define PAGE_S2_DEVICE		__pgprot(_PROT_DEFAULT | PAGE_S2_MEMATTR(DEVICE_nGnRE) | PTE_S2_RDONLY | PTE_S2_XN)
>  
>  #define PAGE_NONE		__pgprot(((_PAGE_DEFAULT) & ~PTE_VALID) | PTE_PROT_NONE | PTE_RDONLY | PTE_NG | PTE_PXN | PTE_UXN)
> -#define PAGE_SHARED		__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_PXN | PTE_UXN | PTE_WRITE)
> -#define PAGE_SHARED_EXEC	__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_PXN | PTE_WRITE)
> +/* shared+writable pages are clean by default, hence PTE_RDONLY|PTE_WRITE */
> +#define PAGE_SHARED		__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_RDONLY | PTE_NG | PTE_PXN | PTE_UXN | PTE_WRITE)
> +#define PAGE_SHARED_EXEC	__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_RDONLY | PTE_NG | PTE_PXN | PTE_WRITE)
>  #define PAGE_READONLY		__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_RDONLY | PTE_NG | PTE_PXN | PTE_UXN)
>  #define PAGE_READONLY_EXEC	__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_RDONLY | PTE_NG | PTE_PXN)
>  #define PAGE_EXECONLY		__pgprot(_PAGE_DEFAULT | PTE_RDONLY | PTE_NG | PTE_PXN)

Looks correct to me, and I don't think ptep_set_access_flags() breaks.
I've queued it as a fix.

Will
