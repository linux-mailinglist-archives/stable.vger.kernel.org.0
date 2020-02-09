Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42E93156AC2
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgBINuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:50:14 -0500
Received: from luna.lichtvoll.de ([194.150.191.11]:54877 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727631AbgBINuO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:50:14 -0500
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Feb 2020 08:50:13 EST
Received: from 127.0.0.1 (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.lichtvoll.de (Postfix) with ESMTPSA id C74BDAFAB4;
        Sun,  9 Feb 2020 14:43:12 +0100 (CET)
From:   Martin Steigerwald <martin@lichtvoll.de>
To:     gregkh@linuxfoundation.org
Cc:     josef@toxicpanda.com, dsterba@suse.com, wqu@suse.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: do not zero f_bavail if we have available space" failed to apply to 5.5-stable tree
Date:   Sun, 09 Feb 2020 14:43:11 +0100
Message-ID: <6540456.ZgMnpaWDUL@merkaba>
In-Reply-To: <158124801131151@kroah.com>
References: <158124801131151@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Authentication-Results: mail.lichtvoll.de;
        auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Greg,

gregkh@linuxfoundation.org - 09.02.20, 12:33:31 CET:
> The patch below does not apply to the 5.5-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git
> commit id to <stable@vger.kernel.org>.

I believe you tried to apply it twice, since it is already in 5.5.2.

Best,
Martin

> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From d55966c4279bfc6a0cf0b32bf13f5df228a1eeb6 Mon Sep 17 00:00:00 2001
> From: Josef Bacik <josef@toxicpanda.com>
> Date: Fri, 31 Jan 2020 09:31:05 -0500
> Subject: [PATCH] btrfs: do not zero f_bavail if we have available
> space
> 
> There was some logic added a while ago to clear out f_bavail in
> statfs() if we did not have enough free metadata space to satisfy our
> global reserve.  This was incorrect at the time, however didn't
> really pose a problem for normal file systems because we would often
> allocate chunks if we got this low on free metadata space, and thus
> wouldn't really hit this case unless we were actually full.
> 
> Fast forward to today and now we are much better about not allocating
> metadata chunks all of the time.  Couple this with d792b0f19711
> ("btrfs: always reserve our entire size for the global reserve")
> which now means we'll easily have a larger global reserve than our
> free space, we are now more likely to trip over this while still
> having plenty of space.
> 
> Fix this by skipping this logic if the global rsv's space_info is not
> full.  space_info->full is 0 unless we've attempted to allocate a
> chunk for that space_info and that has failed.  If this happens then
> the space for the global reserve is definitely sacred and we need to
> report b_avail == 0, but before then we can just use our calculated
> b_avail.
> 
> Reported-by: Martin Steigerwald <martin@lichtvoll.de>
> Fixes: ca8a51b3a979 ("btrfs: statfs: report zero available if metadata
> are exhausted") CC: stable@vger.kernel.org # 4.5+
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> Tested-By: Martin Steigerwald <martin@lichtvoll.de>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: David Sterba <dsterba@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index a906315efd19..0616a5434793 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2135,7 +2135,15 @@ static int btrfs_statfs(struct dentry *dentry,
> struct kstatfs *buf) */
>  	thresh = SZ_4M;
> 
> -	if (!mixed && total_free_meta - thresh < block_rsv->size)
> +	/*
> +	 * We only want to claim there's no available space if we can no
> longer +	 * allocate chunks for our metadata profile and our 
global
> reserve will +	 * not fit in the free metadata space.  If we aren't
> ->full then we +	 * still can allocate chunks and thus are fine using
> the currently +	 * calculated f_bavail.
> +	 */
> +	if (!mixed && block_rsv->space_info->full &&
> +	    total_free_meta - thresh < block_rsv->size)
>  		buf->f_bavail = 0;
> 
>  	buf->f_type = BTRFS_SUPER_MAGIC;


-- 
Martin


