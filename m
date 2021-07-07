Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D073BE6A1
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 12:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhGGKxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 06:53:20 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:36556 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbhGGKxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Jul 2021 06:53:20 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 30A292005A;
        Wed,  7 Jul 2021 10:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625655039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uWoR3FoyGI7rH3OY5tSJHu7Bc1s/FjZYrQjLjY+V0ms=;
        b=K04zw0i+jWWXENX6yAV3qwGUQavmtKmmtOqy79nz/EiiRwkjsogHbljVJ8Ls5Q0jQQVzBA
        Gc4noxx/gYZV9Vpqse427RFT+0R5wqbbDsqzFSQntAnMXHNne2bzg2bivEFMv3ZhNlsExg
        cBgV9RahtHv3+kf0Xhx6NZfuOwj4G3w=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id D468413966;
        Wed,  7 Jul 2021 10:50:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id D2r7MP6G5WCGWgAAGKfGzw
        (envelope-from <nborisov@suse.com>); Wed, 07 Jul 2021 10:50:38 +0000
Subject: Re: [PATCH v2 2/8] btrfs: handle shrink_delalloc pages calculation
 differently
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, linux-fsdevel@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <cover.1624974951.git.josef@toxicpanda.com>
 <670bdb9693668dd0662a3c3db8a954df1aa966e4.1624974951.git.josef@toxicpanda.com>
From:   Nikolay Borisov <nborisov@suse.com>
Message-ID: <adfeec00-538f-8497-e21e-0112d49256ae@suse.com>
Date:   Wed, 7 Jul 2021 13:50:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <670bdb9693668dd0662a3c3db8a954df1aa966e4.1624974951.git.josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 29.06.21 г. 16:59, Josef Bacik wrote:
> We have been hitting some early ENOSPC issues in production with more
> recent kernels, and I tracked it down to us simply not flushing delalloc
> as aggressively as we should be.  With tracing I was seeing us failing
> all tickets with all of the block rsvs at or around 0, with very little
> pinned space, but still around 120MiB of outstanding bytes_may_used.
> Upon further investigation I saw that we were flushing around 14 pages
> per shrink call for delalloc, despite having around 2GiB of delalloc
> outstanding.
> 
> Consider the example of a 8 way machine, all CPUs trying to create a
> file in parallel, which at the time of this commit requires 5 items to
> do.  Assuming a 16k leaf size, we have 10MiB of total metadata reclaim
> size waiting on reservations.  Now assume we have 128MiB of delalloc
> outstanding.  With our current math we would set items to 20, and then
> set to_reclaim to 20 * 256k, or 5MiB.
> 
> Assuming that we went through this loop all 3 times, for both
> FLUSH_DELALLOC and FLUSH_DELALLOC_WAIT, and then did the full loop
> twice, we'd only flush 60MiB of the 128MiB delalloc space.  This could
> leave a fair bit of delalloc reservations still hanging around by the
> time we go to ENOSPC out all the remaining tickets.
> 
> Fix this two ways.  First, change the calculations to be a fraction of
> the total delalloc bytes on the system.  Prior to this change we were
> calculating based on dirty inodes so our math made more sense, now it's
> just completely unrelated to what we're actually doing.
> 
> Second add a FLUSH_DELALLOC_FULL state, that we hold off until we've
> gone through the flush states at least once.  This will empty the system
> of all delalloc so we're sure to be truly out of space when we start
> failing tickets.
> 
> I'm tagging stable 5.10 and forward, because this is where we started
> using the page stuff heavily again.  This affects earlier kernel
> versions as well, but would be a pain to backport to them as the
> flushing mechanisms aren't the same.
> 
> CC: stable@vger.kernel.org # 5.10+
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/ctree.h             |  9 +++++----
>  fs/btrfs/space-info.c        | 35 ++++++++++++++++++++++++++---------
>  include/trace/events/btrfs.h |  1 +
>  3 files changed, 32 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index d7ef4d7d2c1a..232ff1a49ca6 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2783,10 +2783,11 @@ enum btrfs_flush_state {
>  	FLUSH_DELAYED_REFS	=	4,
>  	FLUSH_DELALLOC		=	5,
>  	FLUSH_DELALLOC_WAIT	=	6,
> -	ALLOC_CHUNK		=	7,
> -	ALLOC_CHUNK_FORCE	=	8,
> -	RUN_DELAYED_IPUTS	=	9,
> -	COMMIT_TRANS		=	10,
> +	FLUSH_DELALLOC_FULL	=	7,
> +	ALLOC_CHUNK		=	8,
> +	ALLOC_CHUNK_FORCE	=	9,
> +	RUN_DELAYED_IPUTS	=	10,
> +	COMMIT_TRANS		=	11,
>  };
>  
>  int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> index af161eb808a2..0c539a94c6d9 100644
> --- a/fs/btrfs/space-info.c
> +++ b/fs/btrfs/space-info.c
> @@ -494,6 +494,9 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info,
>  	long time_left;
>  	int loops;
>  
> +	delalloc_bytes = percpu_counter_sum_positive(&fs_info->delalloc_bytes);
> +	ordered_bytes = percpu_counter_sum_positive(&fs_info->ordered_bytes);
> +
>  	/* Calc the number of the pages we need flush for space reservation */
>  	if (to_reclaim == U64_MAX) {
>  		items = U64_MAX;
> @@ -501,19 +504,21 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info,
>  		/*
>  		 * to_reclaim is set to however much metadata we need to
>  		 * reclaim, but reclaiming that much data doesn't really track
> -		 * exactly, so increase the amount to reclaim by 2x in order to
> -		 * make sure we're flushing enough delalloc to hopefully reclaim
> -		 * some metadata reservations.
> +		 * exactly.  What we really want to do is reclaim full inode's
> +		 * worth of reservations, however that's not available to us
> +		 * here.  We will take a fraction of the delalloc bytes for our
> +		 * flushing loops and hope for the best.  Delalloc will expand
> +		 * the amount we write to cover an entire dirty extent, which
> +		 * will reclaim the metadata reservation for that range.  If
> +		 * it's not enough subsequent flush stages will be more
> +		 * aggressive.
>  		 */
> +		to_reclaim = max(to_reclaim, delalloc_bytes >> 3);
>  		items = calc_reclaim_items_nr(fs_info, to_reclaim) * 2;
> -		to_reclaim = items * EXTENT_SIZE_PER_ITEM;
>  	}
>  
>  	trans = (struct btrfs_trans_handle *)current->journal_info;
>  
> -	delalloc_bytes = percpu_counter_sum_positive(
> -						&fs_info->delalloc_bytes);
> -	ordered_bytes = percpu_counter_sum_positive(&fs_info->ordered_bytes);
>  	if (delalloc_bytes == 0 && ordered_bytes == 0)
>  		return;

nit: That check should also be moved alongside delalloc/ordered _bytes
read out.

<snip>
