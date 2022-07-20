Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A95D57B436
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 11:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbiGTJ4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 05:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiGTJ4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 05:56:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939F824BFC
        for <stable@vger.kernel.org>; Wed, 20 Jul 2022 02:56:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39522B81EC4
        for <stable@vger.kernel.org>; Wed, 20 Jul 2022 09:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4556C3411E;
        Wed, 20 Jul 2022 09:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658310979;
        bh=js06Zg0/NwvC0ll2TLX/8d7GWkdHV1uNtr+se9/lMyY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nEAWi+BZoodU8aqDlpfTe71beJpglLiLkahwWEvZ++HAOhKIcq31gUbhahV4GCFU+
         5W2fRlekj4qQNll/xZhNUanrW4I55dcheTleZbP205D/kQ0fO3KqNRJsedSj8wT28J
         a/l/FLhnl6Ck24qDZPv/yXDBDUmtlORXv0JAs556sLvUtNNIBXG4jjufHVWFkhiOJA
         6x++zvvf3YPZNWKCxwl3B9AaQ+LR+U6sskdiutsAgF36s9FVzjML/5AJUW6SETlug6
         R4HbvjNWs0ajnSiCkpWxi3PrRW8ILGsD6My9S9I6jozWa2f3+XxMowoaEEtQBCCZ1O
         oOihtc+yVxN3Q==
Date:   Wed, 20 Jul 2022 10:56:15 +0100
From:   Will Deacon <will@kernel.org>
To:     Peter Collingbourne <pcc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] arm64: set UXN on swapper page tables
Message-ID: <20220720095614.GD15752@willie-the-truck>
References: <20220719234909.1398992-1-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719234909.1398992-1-pcc@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 19, 2022 at 04:49:09PM -0700, Peter Collingbourne wrote:
> On a system that implements FEAT_EPAN, read/write access to the idmap
> is denied because UXN is not set on the swapper PTEs. As a result,
> idmap_kpti_install_ng_mappings panics the kernel when accessing
> __idmap_kpti_flag. Fix it by setting UXN on these PTEs.
> 
> Fixes: 18107f8a2df6 ("arm64: Support execute-only permissions with Enhanced PAN")
> Cc: <stable@vger.kernel.org> # 5.15
> Link: https://linux-review.googlesource.com/id/Ic452fa4b4f74753e54f71e61027e7222a0fae1b1
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> ---
> This fix is no longer needed since commit c3cee924bd85 ("arm64: head:
> cover entire kernel image in initial ID map"), which moved __idmap_kpti_flag
> to .data, but that commit is currently only present in next.
> 
>  arch/arm64/include/asm/kernel-pgtable.h | 4 ++--
>  arch/arm64/kernel/head.S                | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kernel-pgtable.h b/arch/arm64/include/asm/kernel-pgtable.h
> index 96dc0f7da258..a971d462f531 100644
> --- a/arch/arm64/include/asm/kernel-pgtable.h
> +++ b/arch/arm64/include/asm/kernel-pgtable.h
> @@ -103,8 +103,8 @@
>  /*
>   * Initial memory map attributes.
>   */
> -#define SWAPPER_PTE_FLAGS	(PTE_TYPE_PAGE | PTE_AF | PTE_SHARED)
> -#define SWAPPER_PMD_FLAGS	(PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S)
> +#define SWAPPER_PTE_FLAGS	(PTE_TYPE_PAGE | PTE_AF | PTE_SHARED | PTE_UXN)
> +#define SWAPPER_PMD_FLAGS	(PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S | PMD_SECT_UXN)
>  
>  #if ARM64_KERNEL_USES_PMD_MAPS
>  #define SWAPPER_MM_MMUFLAGS	(PMD_ATTRINDX(MT_NORMAL) | SWAPPER_PMD_FLAGS)
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 6a98f1a38c29..8a93a0a7489b 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -285,7 +285,7 @@ SYM_FUNC_START_LOCAL(__create_page_tables)
>  	subs	x1, x1, #64
>  	b.ne	1b
>  
> -	mov	x7, SWAPPER_MM_MMUFLAGS
> +	mov_q	x7, SWAPPER_MM_MMUFLAGS

Heh, nice find:

Acked-by: Will Deacon <will@kernel.org>

Catalin, I guess this needs to land for 5.19 given that it's no longer
relevant after the idmap rework pending for 5.20? If it all explodes in
-next, I can merge in for-next/fixes.

Will
