Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203BA3D5495
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 09:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhGZHHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 03:07:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231621AbhGZHHV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 03:07:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B7BF604AC;
        Mon, 26 Jul 2021 07:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627285670;
        bh=4THFm2VQvdBKNzDLFNozcRgr4hamq5GBSa93hs/uej4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bElM3JM8sktVjZRZXO8hahOPJI32aQx2iXWFDkKfDb7d6HsgFGJ61RKWFvxfsAuIf
         wNaNo+hTBzBQ4CfxP7Txf9fFqmA7ykOPnwNPFDgm7OTAZG/wYPRYBV8/jgI5kdngG5
         elqlByt9a3tAbHGfYX8uXBj8NuXVAJpgjW9ewjYI=
Date:   Mon, 26 Jul 2021 09:47:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Huang Pei <huangpei@loongson.cn>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        ambrosehua@gmail.com, Bibo Mao <maobibo@loongson.cn>,
        stable@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Li Xuefeng <lixuefeng@loongson.cn>,
        Yang Tiezhu <yangtiezhu@loongson.cn>,
        Gao Juxin <gaojuxin@loongson.cn>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Jinyang He <hejinyang@loongson.cn>
Subject: Re: [PATCH] Revert "MIPS: add PMD table accounting into
 MIPS'pmd_alloc_one"
Message-ID: <YP5on1dqm4/GMAA/@kroah.com>
References: <20210726072642.551510-1-huangpei@loongson.cn>
 <20210726072642.551510-2-huangpei@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726072642.551510-2-huangpei@loongson.cn>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 26, 2021 at 03:26:42PM +0800, Huang Pei wrote:
> This reverts commit 002d8b395fa1c0679fc3c3e68873de6c1cc300a2.
> 
> Commit b2b29d6d011944 (mm: account PMD tables like PTE tables) is
> introduced between v5.9 and v5.10, so this fix (commit 002d8b395fa1)
> should NOT apply to any pre-5.10 branch.
> 
> Signed-off-by: Huang Pei <huangpei@loongson.cn>
> ---
>  arch/mips/include/asm/pgalloc.h | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/mips/include/asm/pgalloc.h b/arch/mips/include/asm/pgalloc.h
> index dd10854321ca..166842337eb2 100644
> --- a/arch/mips/include/asm/pgalloc.h
> +++ b/arch/mips/include/asm/pgalloc.h
> @@ -62,15 +62,11 @@ do {							\
>  
>  static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
>  {
> -	pmd_t *pmd = NULL;
> -	struct page *pg;
> +	pmd_t *pmd;
>  
> -	pg = alloc_pages(GFP_KERNEL | __GFP_ACCOUNT, PMD_ORDER);
> -	if (pg) {
> -		pgtable_pmd_page_ctor(pg);
> -		pmd = (pmd_t *)page_address(pg);
> +	pmd = (pmd_t *) __get_free_pages(GFP_KERNEL, PMD_ORDER);
> +	if (pmd)
>  		pmd_init((unsigned long)pmd, (unsigned long)invalid_pte_table);
> -	}
>  	return pmd;
>  }
>  
> -- 
> 2.25.1
> 

Queued up everywhere, thanks.

greg k-h
