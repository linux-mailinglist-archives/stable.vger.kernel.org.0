Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1285555850F
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbiFWRyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235421AbiFWRwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:52:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CEF5506ED;
        Thu, 23 Jun 2022 10:13:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A795E61D17;
        Thu, 23 Jun 2022 17:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC6CC341C5;
        Thu, 23 Jun 2022 17:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656004393;
        bh=KOnK+vJizyo7Zx4GKRrnV6DYGpqQvLH0I1Zva2gYZN8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ELM+W9fbWFNqyvDff3JptaraGIpkpQfdjAillhDKvA7QxnAAy2p7QzsvkmijUPJux
         JEp+aOQljIHuC8hJObRIIay7LWtJVl1jZZVZPdXRPczaX+Avoi4VVt8K08GUbsYNTG
         KD1cPo8fsb+alKzyAos8HViR0f9DPsJQ7BwolBard5oOXAxuuIqyUJE6vtpy/Xp8DB
         xd/Nq6RJ6wnsp8xIwqfNhcbieYVaJmX8/s+KwapHQ0d1dQvUmWNvk3OY2cXQKusBEF
         uVWMICNVgmDj3VqTp6unU5bnZLGp9G9ef6FR2sL+aHZI33hYP/sBAuTyT7rS/Mnlz7
         tTMWH3u4McBsw==
Date:   Thu, 23 Jun 2022 12:13:07 -0500
From:   Mike Rapoport <rppt@kernel.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] powerpc/book3e: Fix PUD allocation size in
 map_kernel_page()
Message-ID: <YrSfIyDy3rM16NqC@kernel.org>
References: <95ddfd6176d53e6c85e13bd1c358359daa56775f.1655974558.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95ddfd6176d53e6c85e13bd1c358359daa56775f.1655974558.git.christophe.leroy@csgroup.eu>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 23, 2022 at 10:56:17AM +0200, Christophe Leroy wrote:
> Commit 2fb4706057bc ("powerpc: add support for folded p4d page tables")
> erroneously changed PUD setup to a mix of PMD and PUD. Fix it.
> 
> While at it, use PTE_TABLE_SIZE instead of PAGE_SIZE for PTE tables
> in order to avoid any confusion.
> 
> Fixes: 2fb4706057bc ("powerpc: add support for folded p4d page tables")
> Cc: stable@vger.kernel.org
> Cc: Mike Rapoport <rppt@kernel.org>
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>

Acked-by: Mike Rapoport <rppt@linux.ibm.com>

> ---
>  arch/powerpc/mm/nohash/book3e_pgtable.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/mm/nohash/book3e_pgtable.c b/arch/powerpc/mm/nohash/book3e_pgtable.c
> index 7d4368d055a6..b80fc4a91a53 100644
> --- a/arch/powerpc/mm/nohash/book3e_pgtable.c
> +++ b/arch/powerpc/mm/nohash/book3e_pgtable.c
> @@ -96,8 +96,8 @@ int __ref map_kernel_page(unsigned long ea, unsigned long pa, pgprot_t prot)
>  		pgdp = pgd_offset_k(ea);
>  		p4dp = p4d_offset(pgdp, ea);
>  		if (p4d_none(*p4dp)) {
> -			pmdp = early_alloc_pgtable(PMD_TABLE_SIZE);
> -			p4d_populate(&init_mm, p4dp, pmdp);
> +			pudp = early_alloc_pgtable(PUD_TABLE_SIZE);
> +			p4d_populate(&init_mm, p4dp, pudp);
>  		}
>  		pudp = pud_offset(p4dp, ea);
>  		if (pud_none(*pudp)) {
> @@ -106,7 +106,7 @@ int __ref map_kernel_page(unsigned long ea, unsigned long pa, pgprot_t prot)
>  		}
>  		pmdp = pmd_offset(pudp, ea);
>  		if (!pmd_present(*pmdp)) {
> -			ptep = early_alloc_pgtable(PAGE_SIZE);
> +			ptep = early_alloc_pgtable(PTE_TABLE_SIZE);
>  			pmd_populate_kernel(&init_mm, pmdp, ptep);
>  		}
>  		ptep = pte_offset_kernel(pmdp, ea);
> -- 
> 2.36.1
> 

-- 
Sincerely yours,
Mike.
