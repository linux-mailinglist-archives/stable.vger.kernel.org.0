Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8182AA21D
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 02:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgKGB7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 20:59:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727368AbgKGB7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Nov 2020 20:59:37 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C134620728;
        Sat,  7 Nov 2020 01:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604714374;
        bh=hjJdees09QwhFJXkhd/LQI1Mn641FEuA/5prkGwY71M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D8u/Atf1yRzb2uxVYQ/AZQn28SKhJ9I0V95GyqHIBDS8gl35ZKt6WDelVOAAV3LlM
         0bqGg1JDWTUTAag0pDOuLggPjwcGsPxdnfEX6/9tYOpqiemlSv9lc85fJ1H5YrY/Hl
         RrRmr/JBdDIcgXWQ8U5ppV0izv2rrBgcSzZAvfjA=
Date:   Fri, 6 Nov 2020 17:59:33 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Minchan Kim <minchan@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Harish Sriram <harish@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] Revert
 "mm/vunmap: add cond_resched() in vunmap_pmd_range"
Message-Id: <20201106175933.90e4c8851010c9ce4dd732b6@linux-foundation.org>
In-Reply-To: <20201105170249.387069-1-minchan@kernel.org>
References: <20201105170249.387069-1-minchan@kernel.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu,  5 Nov 2020 09:02:49 -0800 Minchan Kim <minchan@kernel.org> wrote:

> This reverts commit e47110e90584a22e9980510b00d0dfad3a83354e.
> 
> While I was doing zram testing, I found sometimes decompression failed
> since the compression buffer was corrupted. With investigation,
> I found below commit calls cond_resched unconditionally so it could
> make a problem in atomic context if the task is reschedule.
> 
> Revert the original commit for now.
> 
> [   55.109012] BUG: sleeping function called from invalid context at mm/vmalloc.c:108
> [   55.110774] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 946, name: memhog
> [   55.111973] 3 locks held by memhog/946:
> [   55.112807]  #0: ffff9d01d4b193e8 (&mm->mmap_lock#2){++++}-{4:4}, at: __mm_populate+0x103/0x160
> [   55.114151]  #1: ffffffffa3d53de0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0xa98/0x1160
> [   55.115848]  #2: ffff9d01d56b8110 (&zspage->lock){.+.+}-{3:3}, at: zs_map_object+0x8e/0x1f0
> [   55.118947] CPU: 0 PID: 946 Comm: memhog Not tainted 5.9.3-00011-gc5bfc0287345-dirty #316
> [   55.121265] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
> [   55.122540] Call Trace:
> [   55.122974]  dump_stack+0x8b/0xb8
> [   55.123588]  ___might_sleep.cold+0xb6/0xc6
> [   55.124328]  unmap_kernel_range_noflush+0x2eb/0x350
> [   55.125198]  unmap_kernel_range+0x14/0x30
> [   55.125920]  zs_unmap_object+0xd5/0xe0
> [   55.126604]  zram_bvec_rw.isra.0+0x38c/0x8e0
> [   55.127462]  zram_rw_page+0x90/0x101
> [   55.128199]  bdev_write_page+0x92/0xe0
> [   55.128957]  ? swap_slot_free_notify+0xb0/0xb0
> [   55.129841]  __swap_writepage+0x94/0x4a0
> [   55.130636]  ? do_raw_spin_unlock+0x4b/0xa0
> [   55.131462]  ? _raw_spin_unlock+0x1f/0x30
> [   55.132261]  ? page_swapcount+0x6c/0x90
> [   55.133038]  pageout+0xe3/0x3a0
> [   55.133702]  shrink_page_list+0xb94/0xd60
> [   55.134626]  shrink_inactive_list+0x158/0x460
>
> ...
>
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -102,8 +102,6 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
>  		if (pmd_none_or_clear_bad(pmd))
>  			continue;
>  		vunmap_pte_range(pmd, addr, next, mask);
> -
> -		cond_resched();
>  	} while (pmd++, addr = next, addr != end);
>  }

If this is triggering a warning then why isn't the might_sleep() in
remove_vm_area() also triggering?

Sigh.  I also cannot remember why these vfree() functions have to be so
awkward.  The mutex_trylock(&vmap_purge_lock) isn't permitted in
interrupt context because mutex_trylock() is stupid, but what was the
issue with non-interrupt atomic code?


