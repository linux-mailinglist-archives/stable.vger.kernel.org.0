Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6B21F5070
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 10:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgFJImH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 04:42:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726424AbgFJImG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jun 2020 04:42:06 -0400
Received: from kernel.org (unknown [87.70.26.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52E042072F;
        Wed, 10 Jun 2020 08:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591778525;
        bh=Xd4NCZa4cCz6RXlrATFmqgdarSt3kMdLGUn2RmONCKM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lbBi3mjDCC498mM5bsMiBGomHUpFjlnKHqvGsh5l/8pi5QpZSA0h6lHll+o2mqo7q
         0PDuQN4SFPVqDuJ+fx5zVSRR/Kti2sAMawu3iippmja6PAgiVta/MJbzBMv5n2Lezp
         acr1SD/B3d0OmY2CUEro6Oin20SLQYFeRI5HIHj4=
Date:   Wed, 10 Jun 2020 11:41:57 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Tony Luck <tony.luck@intel.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCHv2 1/2] x86/mm: Fix boot with some memory above MAXMEM
Message-ID: <20200610084157.GD1151302@kernel.org>
References: <20200608125424.70198-1-kirill.shutemov@linux.intel.com>
 <20200608125424.70198-2-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608125424.70198-2-kirill.shutemov@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 08, 2020 at 03:54:23PM +0300, Kirill A. Shutemov wrote:
> A 5-level paging capable machine can have memory above 46-bit in the
> physical address space. This memory is only addressable in the 5-level
> paging mode: we don't have enough virtual address space to create direct
> mapping for such memory in the 4-level paging mode.
> 
> Currently, we fail boot completely: NULL pointer dereference in
> subsection_map_init().
> 
> Skip creating a memblock for such memory instead and notify user that
> some memory is not addressable.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Reviewed-by: Dave Hansen <dave.hansen@intel.com>
> Cc: stable@vger.kernel.org # v4.14

Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>

> ---
>  arch/x86/kernel/e820.c | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index c5399e80c59c..c10bab121916 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -16,6 +16,7 @@
>  #include <linux/firmware-map.h>
>  #include <linux/sort.h>
>  #include <linux/memory_hotplug.h>
> +#include <linux/string_helpers.h>
>  
>  #include <asm/e820/api.h>
>  #include <asm/setup.h>
> @@ -1280,8 +1281,8 @@ void __init e820__memory_setup(void)
>  
>  void __init e820__memblock_setup(void)
>  {
> +	u64 size, end, not_addressable = 0;
>  	int i;
> -	u64 end;
>  
>  	/*
>  	 * The bootstrap memblock region count maximum is 128 entries
> @@ -1307,7 +1308,26 @@ void __init e820__memblock_setup(void)
>  		if (entry->type != E820_TYPE_RAM && entry->type != E820_TYPE_RESERVED_KERN)
>  			continue;
>  
> -		memblock_add(entry->addr, entry->size);
> +		if (entry->addr >= MAXMEM) {
> +			not_addressable += entry->size;
> +			continue;
> +		}
> +
> +		end = min_t(u64, end, MAXMEM - 1);
> +		size = end - entry->addr;
> +		not_addressable += entry->size - size;
> +		memblock_add(entry->addr, size);
> +	}
> +
> +	if (not_addressable) {
> +		char tmp[10];
> +
> +		string_get_size(not_addressable, 1, STRING_UNITS_2, tmp, sizeof(tmp));
> +		pr_err("%s of physical memory is not addressable in the %s paging mode\n",
> +		       tmp, pgtable_l5_enabled() ? "5-level" : "4-level");
> +
> +		if (!pgtable_l5_enabled())
> +			pr_err("Consider enabling 5-level paging\n");
>  	}
>  
>  	/* Throw away partial pages: */
> -- 
> 2.26.2
> 
> 

-- 
Sincerely yours,
Mike.
