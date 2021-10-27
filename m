Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B686143D32E
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 22:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240637AbhJ0UyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 16:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238909AbhJ0UyF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 16:54:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0D2C061570;
        Wed, 27 Oct 2021 13:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FiTQfhf7kiYlnEK4FiYcuF1761gX6clAJ3pCzbAqESo=; b=pRkShx82edBCcyAY0tSmONxeVF
        Yjat2g8mUysN0x/aiN19JVZTmGGS7XUAu5auXz6P1Kd3G9nYYNaUSekcE5j/FqUry52AWdkkVFZCJ
        7ndc2IkBv+THL6+/F/tj1HnmTtnUxI9euPMNvh0KNVGxk/D03Wp5xjuXIYBhYEW0XycwzlvEdLuGd
        Z+c9jbOsYMnxJaXwq5ZBjb3byZgDSHmniLFp6RAH86+WivU6qE81GKgo+6jgXW8W8OnwLuU8JiPL7
        +MO4Vx7nKCmmKzIchnsDLBZutElvckNaFNg+Fr77Z0CGlhAkgGSYYNiLRgpuS5hN42ILNtReC7qhl
        19BwW3Ag==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mfpsO-000JRN-Nm; Wed, 27 Oct 2021 20:50:30 +0000
Date:   Wed, 27 Oct 2021 21:50:24 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Yang Shi <shy828301@gmail.com>
Cc:     hughd@google.com, sunhao.th@gmail.com,
        kirill.shutemov@linux.intel.com, songliubraving@fb.com,
        andrea.righi@canonical.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm: khugepaged: skip huge page collapse for special files
Message-ID: <YXm7kHy8uTN1+RRc@casper.infradead.org>
References: <20211027195221.3825-1-shy828301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027195221.3825-1-shy828301@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 27, 2021 at 12:52:21PM -0700, Yang Shi wrote:
> +++ b/mm/khugepaged.c
> @@ -445,22 +445,25 @@ static bool hugepage_vma_check(struct vm_area_struct *vma,
>  	if (!transhuge_vma_enabled(vma, vm_flags))
>  		return false;
>  
> -	/* Enabled via shmem mount options or sysfs settings. */
> -	if (shmem_file(vma->vm_file) && shmem_huge_enabled(vma)) {
> +	if (vma->vm_file)
>  		return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
>  				HPAGE_PMD_NR);
> -	}
> +
> +	/* Enabled via shmem mount options or sysfs settings. */
> +	if (shmem_file(vma->vm_file))
> +		return shmem_huge_enabled(vma);

This doesn't make sense to me.  if vma->vm_file, we already returned,
so this is dead code.

>  	/* THP settings require madvise. */
>  	if (!(vm_flags & VM_HUGEPAGE) && !khugepaged_always())
>  		return false;
>  
> -	/* Read-only file mappings need to be aligned for THP to work. */
> +	/* Only regular file is valid */
>  	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && vma->vm_file &&
> -	    !inode_is_open_for_write(vma->vm_file->f_inode) &&
>  	    (vm_flags & VM_EXEC)) {
> -		return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
> -				HPAGE_PMD_NR);
> +		struct inode *inode = vma->vm_file->f_inode;
> +
> +		return !inode_is_open_for_write(inode) &&
> +			S_ISREG(inode->i_mode);
>  	}
>  
>  	if (!vma->anon_vma || vma->vm_ops)
> -- 
> 2.26.2
> 
