Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15641192F3
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfEITcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 15:32:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:57250 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726710AbfEITcY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 15:32:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A7E6BAE16;
        Thu,  9 May 2019 19:32:22 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id ED4D81E3C7F; Thu,  9 May 2019 21:32:19 +0200 (CEST)
Date:   Thu, 9 May 2019 21:32:19 +0200
From:   Jan Kara <jack@suse.cz>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     akpm@linux-foundation.org, stable@vger.kernel.org,
        Piotr Balcer <piotr.balcer@intel.com>,
        Yan Ma <yan.ma@intel.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Chandan Rajendra <chandan@linux.ibm.com>,
        Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>,
        Souptick Joarder <jrdr.linux@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: Fix vmf_insert_pfn_{pmd, pud}() crash,
 handle unaligned addresses
Message-ID: <20190509193219.GH23589@quack2.suse.cz>
References: <155741946350.372037.11148198430068238140.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155741946350.372037.11148198430068238140.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 09-05-19 09:31:41, Dan Williams wrote:
> Starting with commit c6f3c5ee40c1 "mm/huge_memory.c: fix modifying of
> page protection by insert_pfn_pmd()" vmf_insert_pfn_pmd() internally
> calls pmdp_set_access_flags(). That helper enforces a pmd aligned
> @address argument via VM_BUG_ON() assertion.
> 
> Update the implementation to take a 'struct vm_fault' argument directly
> and apply the address alignment fixup internally to fix crash signatures
> like:
> 
>     kernel BUG at arch/x86/mm/pgtable.c:515!
>     invalid opcode: 0000 [#1] SMP NOPTI
>     CPU: 51 PID: 43713 Comm: java Tainted: G           OE     4.19.35 #1
>     [..]
>     RIP: 0010:pmdp_set_access_flags+0x48/0x50
>     [..]
>     Call Trace:
>      vmf_insert_pfn_pmd+0x198/0x350
>      dax_iomap_fault+0xe82/0x1190
>      ext4_dax_huge_fault+0x103/0x1f0
>      ? __switch_to_asm+0x40/0x70
>      __handle_mm_fault+0x3f6/0x1370
>      ? __switch_to_asm+0x34/0x70
>      ? __switch_to_asm+0x40/0x70
>      handle_mm_fault+0xda/0x200
>      __do_page_fault+0x249/0x4f0
>      do_page_fault+0x32/0x110
>      ? page_fault+0x8/0x30
>      page_fault+0x1e/0x30
> 
> Cc: <stable@vger.kernel.org>
> Fixes: c6f3c5ee40c1 ("mm/huge_memory.c: fix modifying of page protection by insert_pfn_pmd()")
> Reported-by: Piotr Balcer <piotr.balcer@intel.com>
> Tested-by: Yan Ma <yan.ma@intel.com>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> Cc: Chandan Rajendra <chandan@linux.ibm.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Souptick Joarder <jrdr.linux@gmail.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> 
>  drivers/dax/device.c    |    6 ++----
>  fs/dax.c                |    6 ++----
>  include/linux/huge_mm.h |    6 ++----
>  mm/huge_memory.c        |   16 ++++++++++------
>  4 files changed, 16 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index e428468ab661..996d68ff992a 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -184,8 +184,7 @@ static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
>  
>  	*pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
>  
> -	return vmf_insert_pfn_pmd(vmf->vma, vmf->address, vmf->pmd, *pfn,
> -			vmf->flags & FAULT_FLAG_WRITE);
> +	return vmf_insert_pfn_pmd(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
>  }
>  
>  #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> @@ -235,8 +234,7 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
>  
>  	*pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
>  
> -	return vmf_insert_pfn_pud(vmf->vma, vmf->address, vmf->pud, *pfn,
> -			vmf->flags & FAULT_FLAG_WRITE);
> +	return vmf_insert_pfn_pud(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
>  }
>  #else
>  static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
> diff --git a/fs/dax.c b/fs/dax.c
> index e5e54da1715f..83009875308c 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1575,8 +1575,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  		}
>  
>  		trace_dax_pmd_insert_mapping(inode, vmf, PMD_SIZE, pfn, entry);
> -		result = vmf_insert_pfn_pmd(vma, vmf->address, vmf->pmd, pfn,
> -					    write);
> +		result = vmf_insert_pfn_pmd(vmf, pfn, write);
>  		break;
>  	case IOMAP_UNWRITTEN:
>  	case IOMAP_HOLE:
> @@ -1686,8 +1685,7 @@ dax_insert_pfn_mkwrite(struct vm_fault *vmf, pfn_t pfn, unsigned int order)
>  		ret = vmf_insert_mixed_mkwrite(vmf->vma, vmf->address, pfn);
>  #ifdef CONFIG_FS_DAX_PMD
>  	else if (order == PMD_ORDER)
> -		ret = vmf_insert_pfn_pmd(vmf->vma, vmf->address, vmf->pmd,
> -			pfn, true);
> +		ret = vmf_insert_pfn_pmd(vmf, pfn, FAULT_FLAG_WRITE);
>  #endif
>  	else
>  		ret = VM_FAULT_FALLBACK;
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 381e872bfde0..7cd5c150c21d 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -47,10 +47,8 @@ extern bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
>  extern int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>  			unsigned long addr, pgprot_t newprot,
>  			int prot_numa);
> -vm_fault_t vmf_insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
> -			pmd_t *pmd, pfn_t pfn, bool write);
> -vm_fault_t vmf_insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
> -			pud_t *pud, pfn_t pfn, bool write);
> +vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write);
> +vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write);
>  enum transparent_hugepage_flag {
>  	TRANSPARENT_HUGEPAGE_FLAG,
>  	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 165ea46bf149..4310c6e9e5a3 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -793,11 +793,13 @@ static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
>  		pte_free(mm, pgtable);
>  }
>  
> -vm_fault_t vmf_insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
> -			pmd_t *pmd, pfn_t pfn, bool write)
> +vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write)
>  {
> +	unsigned long addr = vmf->address & PMD_MASK;
> +	struct vm_area_struct *vma = vmf->vma;
>  	pgprot_t pgprot = vma->vm_page_prot;
>  	pgtable_t pgtable = NULL;
> +
>  	/*
>  	 * If we had pmd_special, we could avoid all these restrictions,
>  	 * but we need to be consistent with PTEs and architectures that
> @@ -820,7 +822,7 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
>  
>  	track_pfn_insert(vma, &pgprot, pfn);
>  
> -	insert_pfn_pmd(vma, addr, pmd, pfn, pgprot, write, pgtable);
> +	insert_pfn_pmd(vma, addr, vmf->pmd, pfn, pgprot, write, pgtable);
>  	return VM_FAULT_NOPAGE;
>  }
>  EXPORT_SYMBOL_GPL(vmf_insert_pfn_pmd);
> @@ -869,10 +871,12 @@ static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
>  	spin_unlock(ptl);
>  }
>  
> -vm_fault_t vmf_insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
> -			pud_t *pud, pfn_t pfn, bool write)
> +vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write)
>  {
> +	unsigned long addr = vmf->address & PUD_MASK;
> +	struct vm_area_struct *vma = vmf->vma;
>  	pgprot_t pgprot = vma->vm_page_prot;
> +
>  	/*
>  	 * If we had pud_special, we could avoid all these restrictions,
>  	 * but we need to be consistent with PTEs and architectures that
> @@ -889,7 +893,7 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
>  
>  	track_pfn_insert(vma, &pgprot, pfn);
>  
> -	insert_pfn_pud(vma, addr, pud, pfn, pgprot, write);
> +	insert_pfn_pud(vma, addr, vmf->pud, pfn, pgprot, write);
>  	return VM_FAULT_NOPAGE;
>  }
>  EXPORT_SYMBOL_GPL(vmf_insert_pfn_pud);
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
