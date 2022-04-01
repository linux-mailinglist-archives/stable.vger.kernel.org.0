Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDD24EF861
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 18:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236060AbiDAQxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 12:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350410AbiDAQwz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 12:52:55 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B1E1DA7B;
        Fri,  1 Apr 2022 09:43:55 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id C3CA61FCFF;
        Fri,  1 Apr 2022 16:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1648831433;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MJQXBhA8DEsiGNLDWAwYQb8IVjVtQYbS9VBKu2hldUw=;
        b=NT7drDEuutoleYlZIcmVBJzyKKvzGQRh8trnP00IeVEl9hRDej+L1txR0RvLVUNT4e8BLG
        fEyThvKlsmLa1h31dE6N0Nk1JaMspSogBSBZW2UQuo7N1eGkubSAy/pZhF/iNsWeK1hd52
        CW1qeIYI+Y9z4AhqEBnoPX/nfaJxtdc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1648831433;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MJQXBhA8DEsiGNLDWAwYQb8IVjVtQYbS9VBKu2hldUw=;
        b=nMCuqJBHwx0XZ8KNdPPflaxExBjw0cjN/f7ckBqa8MWE/N0aSOLSfpncGbu3mttAmx6Mk3
        9sN2OAOnl7SSYKBw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id B99EEA3B82;
        Fri,  1 Apr 2022 16:43:53 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 97693DA7F3; Fri,  1 Apr 2022 18:39:54 +0200 (CEST)
Date:   Fri, 1 Apr 2022 18:39:54 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Matt Corallo <blnxfsl@bluematt.me>,
        stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: force v2 space cache usage for subpage mount
Message-ID: <20220401163954.GM15609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Matt Corallo <blnxfsl@bluematt.me>,
        stable@vger.kernel.org
References: <1f622305ee7ecb3b6ec09f878c26ad0446e18311.1648798164.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f622305ee7ecb3b6ec09f878c26ad0446e18311.1648798164.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 01, 2022 at 03:29:37PM +0800, Qu Wenruo wrote:
> [BUG]
> For a 4K sector sized btrfs with v1 cache enabled and only mounted on
> systems with 4K page size, if it's mounted on subpage (64K page size)
> systems, it can cause the following warning on v1 space cache:
> 
>  BTRFS error (device dm-1): csum mismatch on free space cache
>  BTRFS warning (device dm-1): failed to load free space cache for block group 84082688, rebuilding it now
> 
> Although not a big deal, as kernel can rebuild it without problem, such
> warning will bother end users, especially if they want to switch the
> same btrfs seamlessly between different page sized systems.
> 
> [CAUSE]
> V1 free space cache is still using fixed PAGE_SIZE for various bitmap,
> like BITS_PER_BITMAP.
> 
> Such hard-coded PAGE_SIZE usage will cause various mismatch, from v1
> cache size to checksum.
> 
> Thus kernel will always reject v1 cache with a different PAGE_SIZE with
> csum mismatch.
> 
> [FIX]
> Although we should fix v1 cache, it's already going to be marked
> deprecated soon.
> 
> And we have v2 cache based on metadata (which is already fully subpage
> compatible), and it has almost everything superior than v1 cache.
> 
> So just force subpage mount to use v2 cache on mount.
> 
> Reported-by: Matt Corallo <blnxfsl@bluematt.me>
> CC: stable@vger.kernel.org # 5.15+
> Link: https://lore.kernel.org/linux-btrfs/61aa27d1-30fc-c1a9-f0f4-9df544395ec3@bluematt.me/
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index d456f426924c..34eb6d4b904a 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3675,6 +3675,17 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
>  	if (sectorsize < PAGE_SIZE) {
>  		struct btrfs_subpage_info *subpage_info;
>  
> +		/*
> +		 * V1 space cache has some hardcoded PAGE_SIZE usage, and is
> +		 * going to be deprecated.
> +		 *
> +		 * Force to use v2 cache for subpage case.
> +		 */
> +		btrfs_clear_opt(fs_info->mount_opt, SPACE_CACHE);
> +		btrfs_set_and_info(fs_info, FREE_SPACE_TREE,
> +			"forcing free space tree for sector size %u with page size %lu",
> +			sectorsize, PAGE_SIZE);

I'm not sure this is implemented the right way. Why is it unconditional?
Does any subsequent mount have to clear and set the bits after it has
been already? Or what if the free space tree is set at mkfs time, which
is now the default.

Next, remounting v1->v2 does more things, like removing the v1 tree if
it exists. And due to some bugs there are more bits for free space tree
to be set like FREE_SPACE_TREE_VALID.  So I don't thing this patch
covers all cases for the v2.
