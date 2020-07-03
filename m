Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478B8213F3D
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 20:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbgGCSV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 14:21:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:55688 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgGCSV0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jul 2020 14:21:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E3FF3AFEF;
        Fri,  3 Jul 2020 18:21:24 +0000 (UTC)
Subject: Re: FAILED: patch "[PATCH] mm, compaction: make capture control
 handling safe wrt" failed to apply to 5.4-stable tree
To:     gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        alex.shi@linux.alibaba.com, hughd@google.com, liwang@redhat.com,
        mgorman@techsingularity.net, stable@vger.kernel.org,
        torvalds@linux-foundation.org
References: <15934288599599@kroah.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <81da3715-b6f4-501f-703c-636982a9be42@suse.cz>
Date:   Fri, 3 Jul 2020 20:21:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <15934288599599@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/29/20 1:07 PM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

Hi, please simply cherrypick commit 6467552ca64c ("mm, compaction: fully assume
capture is not NULL in compact_zone_order()") first and then cherrypicking
b9e20f0da1f5c9c68689450a8cb436c9486434c8 will apply cleanly.

Thanks,
Vlastimil

> ------------------ original commit in Linus's tree ------------------
> 
> From b9e20f0da1f5c9c68689450a8cb436c9486434c8 Mon Sep 17 00:00:00 2001
> From: Vlastimil Babka <vbabka@suse.cz>
> Date: Thu, 25 Jun 2020 20:29:24 -0700
> Subject: [PATCH] mm, compaction: make capture control handling safe wrt
>  interrupts
> 
> Hugh reports:
> 
>  "While stressing compaction, one run oopsed on NULL capc->cc in
>   __free_one_page()'s task_capc(zone): compact_zone_order() had been
>   interrupted, and a page was being freed in the return from interrupt.
> 
>   Though you would not expect it from the source, both gccs I was using
>   (4.8.1 and 7.5.0) had chosen to compile compact_zone_order() with the
>   ".cc = &cc" implemented by mov %rbx,-0xb0(%rbp) immediately before
>   callq compact_zone - long after the "current->capture_control =
>   &capc". An interrupt in between those finds capc->cc NULL (zeroed by
>   an earlier rep stos).
> 
>   This could presumably be fixed by a barrier() before setting
>   current->capture_control in compact_zone_order(); but would also need
>   more care on return from compact_zone(), in order not to risk leaking
>   a page captured by interrupt just before capture_control is reset.
> 
>   Maybe that is the preferable fix, but I felt safer for task_capc() to
>   exclude the rather surprising possibility of capture at interrupt
>   time"
> 
> I have checked that gcc10 also behaves the same.
> 
> The advantage of fix in compact_zone_order() is that we don't add
> another test in the page freeing hot path, and that it might prevent
> future problems if we stop exposing pointers to uninitialized structures
> in current task.
> 
> So this patch implements the suggestion for compact_zone_order() with
> barrier() (and WRITE_ONCE() to prevent store tearing) for setting
> current->capture_control, and prevents page leaking with
> WRITE_ONCE/READ_ONCE in the proper order.
> 
> Link: http://lkml.kernel.org/r/20200616082649.27173-1-vbabka@suse.cz
> Fixes: 5e1f0f098b46 ("mm, compaction: capture a page under direct compaction")
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reported-by: Hugh Dickins <hughd@google.com>
> Suggested-by: Hugh Dickins <hughd@google.com>
> Acked-by: Hugh Dickins <hughd@google.com>
> Cc: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Li Wang <liwang@redhat.com>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: <stable@vger.kernel.org>	[5.1+]
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index fd988b7e5f2b..86375605faa9 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -2316,15 +2316,26 @@ static enum compact_result compact_zone_order(struct zone *zone, int order,
>  		.page = NULL,
>  	};
>  
> -	current->capture_control = &capc;
> +	/*
> +	 * Make sure the structs are really initialized before we expose the
> +	 * capture control, in case we are interrupted and the interrupt handler
> +	 * frees a page.
> +	 */
> +	barrier();
> +	WRITE_ONCE(current->capture_control, &capc);
>  
>  	ret = compact_zone(&cc, &capc);
>  
>  	VM_BUG_ON(!list_empty(&cc.freepages));
>  	VM_BUG_ON(!list_empty(&cc.migratepages));
>  
> -	*capture = capc.page;
> -	current->capture_control = NULL;
> +	/*
> +	 * Make sure we hide capture control first before we read the captured
> +	 * page pointer, otherwise an interrupt could free and capture a page
> +	 * and we would leak it.
> +	 */
> +	WRITE_ONCE(current->capture_control, NULL);
> +	*capture = READ_ONCE(capc.page);
>  
>  	return ret;
>  }
> 

