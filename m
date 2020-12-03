Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085802CD49C
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 12:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbgLCLbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 06:31:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:58280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728782AbgLCLbI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 06:31:08 -0500
Date:   Thu, 3 Dec 2020 11:30:21 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Miles Chen <miles.chen@mediatek.com>
Cc:     Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
        Andrey Konovalov <andreyknvl@google.com>,
        Alexander Potapenko <glider@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>, Will Deacon <will@kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Song Bao Hua <song.bao.hua@hisilicon.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] proc: use untagged_addr() for pagemap_read addresses
Message-ID: <20201203113020.GE2224@gaia>
References: <20201127050738.14440-1-miles.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127050738.14440-1-miles.chen@mediatek.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 27, 2020 at 01:07:38PM +0800, Miles Chen wrote:
> Cc: Will Deacon <will.deacon@arm.com>

That should be will@kernel.org.

> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 217aa2705d5d..92b277388f05 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1599,11 +1599,15 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
>  
>  	src = *ppos;
>  	svpfn = src / PM_ENTRY_BYTES;
> -	start_vaddr = svpfn << PAGE_SHIFT;
>  	end_vaddr = mm->task_size;
>  
>  	/* watch out for wraparound */
> -	if (svpfn > mm->task_size >> PAGE_SHIFT)
> +	start_vaddr = end_vaddr;
> +	if (svpfn < (ULONG_MAX >> PAGE_SHIFT))

Does this need to be strict less-than? I think a less-than or equal
would work better.

> +		start_vaddr = untagged_addr(svpfn << PAGE_SHIFT);
> +
> +	/* Ensure the address is inside the task */
> +	if (start_vaddr > mm->task_size)
>  		start_vaddr = end_vaddr;

Otherwise the logic looks fine to me. With the above:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
