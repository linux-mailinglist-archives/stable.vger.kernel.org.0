Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091023F16CB
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 11:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237692AbhHSJ4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 05:56:42 -0400
Received: from foss.arm.com ([217.140.110.172]:34300 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232750AbhHSJ4l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Aug 2021 05:56:41 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2EDE1FB;
        Thu, 19 Aug 2021 02:56:05 -0700 (PDT)
Received: from [10.163.69.73] (unknown [10.163.69.73])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 947EA3F70D;
        Thu, 19 Aug 2021 02:55:59 -0700 (PDT)
Subject: Re: [PATCH 2/2] powerpc: rectify selection to
 ARCH_ENABLE_SPLIT_PMD_PTLOCK
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Neuling <mikey@neuling.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc:     stable@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210819093226.13955-1-lukas.bulwahn@gmail.com>
 <20210819093226.13955-3-lukas.bulwahn@gmail.com>
From:   Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <12a996cb-5c54-afab-f095-708a08931cad@arm.com>
Date:   Thu, 19 Aug 2021 15:26:44 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210819093226.13955-3-lukas.bulwahn@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/19/21 3:02 PM, Lukas Bulwahn wrote:
> Commit 66f24fa766e3 ("mm: drop redundant ARCH_ENABLE_SPLIT_PMD_PTLOCK")
> selects the non-existing config ARCH_ENABLE_PMD_SPLIT_PTLOCK in
> ./arch/powerpc/platforms/Kconfig.cputype, but clearly it intends to select
> ARCH_ENABLE_SPLIT_PMD_PTLOCK here (notice the word swapping!), as this
> commit does select that for all other architectures.

Right, indeed the words here got swapped. They look very similar and also
a cross compile would not even detect the problem because the non-existent
config option would simply evaluate to 0. Thanks for catching this.

> 
> Rectify selection to ARCH_ENABLE_SPLIT_PMD_PTLOCK instead.
> 
> Fixes: 66f24fa766e3 ("mm: drop redundant ARCH_ENABLE_SPLIT_PMD_PTLOCK")
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
>  arch/powerpc/platforms/Kconfig.cputype | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
> index 6794145603de..a208997ade88 100644
> --- a/arch/powerpc/platforms/Kconfig.cputype
> +++ b/arch/powerpc/platforms/Kconfig.cputype
> @@ -98,7 +98,7 @@ config PPC_BOOK3S_64
>  	select PPC_HAVE_PMU_SUPPORT
>  	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
>  	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
> -	select ARCH_ENABLE_PMD_SPLIT_PTLOCK
> +	select ARCH_ENABLE_SPLIT_PMD_PTLOCK
>  	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
>  	select ARCH_SUPPORTS_HUGETLBFS
>  	select ARCH_SUPPORTS_NUMA_BALANCING
> 
