Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0C2483736
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 19:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbiACSxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 13:53:08 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:33004 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235519AbiACSxH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 13:53:07 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id C47691F38A;
        Mon,  3 Jan 2022 18:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1641235986;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=27xedfSx+nlFjeg7q+sNf0ilC7EOyBKGkhbJOzJzQ6I=;
        b=hWkr5+Gkjp30k0b7bYeyp57uRT/GLH0uxwEO8qFy3z3L8Tn1GEvr1cyy1Z6nBYQqlIoe3P
        40JlEunY7pHsFOo5+S10laVvSN4TwrjmTdfOIyQ5/lgu2ixhT9OgOA2HP63+5PQPxfyhp4
        2ln6ENm8ruzcAdemuqV9O/LHcTzmK2I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1641235986;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=27xedfSx+nlFjeg7q+sNf0ilC7EOyBKGkhbJOzJzQ6I=;
        b=PNnHXngdhC3Mm+U8T9TPQVSObHVlMV/QY2/GcpqAVHI5t1CsQu99TT/mOSR/8qRstbRGBa
        rxvgrPxau1i9W5AQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id BD5CCA3B81;
        Mon,  3 Jan 2022 18:53:06 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CCB3DDA729; Mon,  3 Jan 2022 19:52:37 +0100 (CET)
Date:   Mon, 3 Jan 2022 19:52:37 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: don't start transaction for scrub if the fs
 is mounted read-only
Message-ID: <20220103185237.GQ28560@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <20211216114736.69757-1-wqu@suse.com>
 <20211216114736.69757-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216114736.69757-2-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 16, 2021 at 07:47:35PM +0800, Qu Wenruo wrote:
> [BUG]
> The following super simple script would crash btrfs at unmount time, if
> CONFIG_BTRFS_ASSERT() is set.
> 
>  mkfs.btrfs -f $dev
>  mount $dev $mnt
>  xfs_io -f -c "pwrite 0 4k" $mnt/file
>  umount $mnt
>  mount -r ro $dev $mnt
>  btrfs scrub start -Br $mnt
>  umount $mnt
> 
> This will trigger the following ASSERT() introduced by commit
> 0a31daa4b602 ("btrfs: add assertion for empty list of transactions at
> late stage of umount").
> 
> That patch is deifnitely not the cause, it just makes enough noise for
> us developer.
> 
> [CAUSE]
> We will start transaction for the following call chain during scrub:
> 
>   scrub_enumerate_chunks()
>   |- btrfs_inc_block_group_ro()
>      |- btrfs_join_transaction()
> 
> However for RO mount, there is no running transaction at all, thus
> btrfs_join_transaction() will start a new transaction.
> 
> Furthermore, since it's read-only mount, btrfs_sync_fs() will not call
> btrfs_commit_super() to commit the new but empty transaction.
> 
> And lead to the ASSERT() being triggered.
> 
> The bug should be there for a long time. Only the new ASSERT() makes it
> noisy enough to be noticed.
> 
> [FIX]
> For read-only scrub on read-only mount, there is no need to start a
> transaction nor to allocate new chunks in btrfs_inc_block_group_ro().
> 
> Just do extra read-only mount check in btrfs_inc_block_group_ro(), and
> if it's read-only, skip all chunk allocation and go inc_block_group_ro()
> directly.
> 
> Since we're here, also add extra debug message at unmount for
> btrfs_fs_info::trans_list.
> Sometimes just knowing that there is no dirty metadata bytes for a
> uncommitted transaction can tell us a lot of things.
> 
> Cc: stable@vger.kernel.org # 5.4+
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/block-group.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index 1db24e6d6d90..702219361b12 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -2544,6 +2544,19 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
>  	int ret;
>  	bool dirty_bg_running;
>  
> +	/*
> +	 * This can only happen when we are doing read-only scrub on read-only
> +	 * mount.
> +	 * In that case we should not start a new transaction on read-only fs.
> +	 * Thus here we skip all chunk allocation.
> +	 */
> +	if (sb_rdonly(fs_info->sb)) {

Should this also verify or at least assert that do_chunk_alloc is not
set? The scrub code is used for replace that can set the parameter to
true.

> +		mutex_lock(&fs_info->ro_block_group_mutex);
> +		ret = inc_block_group_ro(cache, 0);
> +		mutex_unlock(&fs_info->ro_block_group_mutex);
> +		return ret;

So this is taking a shortcut and skips a few things done in the function
that use the transaction. I'm not sure how safe this is, it depends on
the read-only status of superblock, that can chage any time, so what are
further calls to btrfs_inc_block_group_ro going to do regaring the
transaction?

> +	}
> +
>  	do {
>  		trans = btrfs_join_transaction(root);
>  		if (IS_ERR(trans))
> -- 
> 2.34.1
