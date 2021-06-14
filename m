Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BED13A5FE2
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbhFNKWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:22:04 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:56758 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232767AbhFNKWE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 06:22:04 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E296B2197F;
        Mon, 14 Jun 2021 10:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1623666000; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p90Rw1lQUgsGAYyIhBKdRAA+nYXDEQr9r0ffM1jJGRY=;
        b=tGNP2VSuYWLuQWrH1xORcefdhL3mmtO1wfRPmy59IOMRJra0MYXl4kPeg6+UyItFYLji2L
        qhvyReXEaYRI+FA8gXylPQkbXKHOT2BfJttzOmN39IBn9na9m9DiBcKwC5zFqpn6adCLhZ
        hngk+C3P+a07a6n/tVWNO/5bHKdr+c8=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id A0B1C118DD;
        Mon, 14 Jun 2021 10:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1623666000; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p90Rw1lQUgsGAYyIhBKdRAA+nYXDEQr9r0ffM1jJGRY=;
        b=tGNP2VSuYWLuQWrH1xORcefdhL3mmtO1wfRPmy59IOMRJra0MYXl4kPeg6+UyItFYLji2L
        qhvyReXEaYRI+FA8gXylPQkbXKHOT2BfJttzOmN39IBn9na9m9DiBcKwC5zFqpn6adCLhZ
        hngk+C3P+a07a6n/tVWNO/5bHKdr+c8=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id EFrXJFAtx2BdaAAALh3uQQ
        (envelope-from <nborisov@suse.com>); Mon, 14 Jun 2021 10:20:00 +0000
Subject: Re: [PATCH 2/4] btrfs: wake up async_delalloc_pages waiters after
 submit
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Cc:     stable@vger.kernel.org
References: <cover.1623419155.git.josef@toxicpanda.com>
 <d1802ad325a04d3640b85e4c928b91dd9316252c.1623419155.git.josef@toxicpanda.com>
From:   Nikolay Borisov <nborisov@suse.com>
Message-ID: <17c2f625-e31c-40a9-279a-dee3dc9cfb07@suse.com>
Date:   Mon, 14 Jun 2021 13:20:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <d1802ad325a04d3640b85e4c928b91dd9316252c.1623419155.git.josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11.06.21 г. 16:53, Josef Bacik wrote:
> We use the async_delalloc_pages mechanism to make sure that we've
> completed our async work before trying to continue our delalloc
> flushing.  The reason for this is we need to see any ordered extents
> that were created by our delalloc flushing.  However we're waking up
> before we do the submit work, which is before we create the ordered
> extents.  This is a pretty wide race window where we could potentially
> think there are no ordered extents and thus exit shrink_delalloc
> prematurely.  Fix this by waking us up after we've done the work to
> create ordered extents.
> 
> cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/inode.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 6cb73ff59c7c..c37271df2c6d 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1271,11 +1271,6 @@ static noinline void async_cow_submit(struct btrfs_work *work)
>  	nr_pages = (async_chunk->end - async_chunk->start + PAGE_SIZE) >>
>  		PAGE_SHIFT;
>  
> -	/* atomic_sub_return implies a barrier */
> -	if (atomic_sub_return(nr_pages, &fs_info->async_delalloc_pages) <
> -	    5 * SZ_1M)
> -		cond_wake_up_nomb(&fs_info->async_submit_wait);
> -
>  	/*
>  	 * ->inode could be NULL if async_chunk_start has failed to compress,
>  	 * in which case we don't have anything to submit, yet we need to
> @@ -1284,6 +1279,11 @@ static noinline void async_cow_submit(struct btrfs_work *work)
>  	 */
>  	if (async_chunk->inode)
>  		submit_compressed_extents(async_chunk);
> +
> +	/* atomic_sub_return implies a barrier */
> +	if (atomic_sub_return(nr_pages, &fs_info->async_delalloc_pages) <
> +	    5 * SZ_1M)
> +		cond_wake_up_nomb(&fs_info->async_submit_wait);
>  }
>  
>  static noinline void async_cow_free(struct btrfs_work *work)
> 
