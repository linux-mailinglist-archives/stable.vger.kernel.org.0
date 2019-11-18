Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3C6F100957
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 17:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfKRQkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 11:40:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:50856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbfKRQkn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Nov 2019 11:40:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E97A2186D;
        Mon, 18 Nov 2019 16:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574095240;
        bh=z+llrBfbS6so+yWoDIokMdQHZF8u2QLsvAVAeu9Wib8=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=Qv+wTThLhZ/Ne98rZ1myLbK9X9kYU7LoNOIH4dGUYcFEgbFAxzIj40TF9zfW/uWkP
         jPSg+GCYbCdeEKEhKGl0z9bVDsjrp2tRaDzItIfirtySd5AJidLFiDcUA0TCZjFynI
         WXm0o2nrXxZKE8aBhZsUVVcg/J6so0S9jtPyDyWY=
Date:   Mon, 18 Nov 2019 17:40:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     vinmenon@codeaurora.org, akpm@linux-foundation.org,
        hughd@google.com, mhocko@suse.com, minchan@google.com,
        minchan@kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] mm/page_io.c: do not free shared swap
 slots" failed to apply to 4.19-stable tree
Message-ID: <20191118164038.GA595410@kroah.com>
References: <1574095036140231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1574095036140231@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 18, 2019 at 05:37:16PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Note, this applies, but just breaks the build, so it needs a backport
for 4.19 if people want to see it there.

thanks,

greg k-h

> ------------------ original commit in Linus's tree ------------------
> 
> >From 5df373e95689b9519b8557da7c5bd0db0856d776 Mon Sep 17 00:00:00 2001
> From: Vinayak Menon <vinmenon@codeaurora.org>
> Date: Fri, 15 Nov 2019 17:35:00 -0800
> Subject: [PATCH] mm/page_io.c: do not free shared swap slots
> 
> The following race is observed due to which a processes faulting on a
> swap entry, finds the page neither in swapcache nor swap.  This causes
> zram to give a zero filled page that gets mapped to the process,
> resulting in a user space crash later.
> 
> Consider parent and child processes Pa and Pb sharing the same swap slot
> with swap_count 2.  Swap is on zram with SWP_SYNCHRONOUS_IO set.
> Virtual address 'VA' of Pa and Pb points to the shared swap entry.
> 
> Pa                                       Pb
> 
> fault on VA                              fault on VA
> do_swap_page                             do_swap_page
> lookup_swap_cache fails                  lookup_swap_cache fails
>                                          Pb scheduled out
> swapin_readahead (deletes zram entry)
> swap_free (makes swap_count 1)
>                                          Pb scheduled in
>                                          swap_readpage (swap_count == 1)
>                                          Takes SWP_SYNCHRONOUS_IO path
>                                          zram enrty absent
>                                          zram gives a zero filled page
> 
> Fix this by making sure that swap slot is freed only when swap count
> drops down to one.
> 
> Link: http://lkml.kernel.org/r/1571743294-14285-1-git-send-email-vinmenon@codeaurora.org
> Fixes: aa8d22a11da9 ("mm: swap: SWP_SYNCHRONOUS_IO: skip swapcache only if swapped page has no other reference")
> Signed-off-by: Vinayak Menon <vinmenon@codeaurora.org>
> Suggested-by: Minchan Kim <minchan@google.com>
> Acked-by: Minchan Kim <minchan@kernel.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 24ee600f9131..60a66a58b9bf 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -73,6 +73,7 @@ static void swap_slot_free_notify(struct page *page)
>  {
>  	struct swap_info_struct *sis;
>  	struct gendisk *disk;
> +	swp_entry_t entry;
>  
>  	/*
>  	 * There is no guarantee that the page is in swap cache - the software
> @@ -104,11 +105,10 @@ static void swap_slot_free_notify(struct page *page)
>  	 * we again wish to reclaim it.
>  	 */
>  	disk = sis->bdev->bd_disk;
> -	if (disk->fops->swap_slot_free_notify) {
> -		swp_entry_t entry;
> +	entry.val = page_private(page);
> +	if (disk->fops->swap_slot_free_notify && __swap_count(entry) == 1) {
>  		unsigned long offset;
>  
> -		entry.val = page_private(page);
>  		offset = swp_offset(entry);
>  
>  		SetPageDirty(page);
> 
