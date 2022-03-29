Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCD84EAAE2
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 11:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234907AbiC2KBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 06:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbiC2KBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 06:01:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEBA4B85B;
        Tue, 29 Mar 2022 02:59:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6CF8ECE1928;
        Tue, 29 Mar 2022 09:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF64C2BBE4;
        Tue, 29 Mar 2022 09:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648547974;
        bh=vzjLU8ab0grTtVHaa3X1pUiBpScWWczex6d0LCSx96o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bgu4FcQ3yRdqLKgv3jq1VSMcskv4N6rz5SNsU+Gd4DuUheCUqCR0YJv9Udcw8OTa3
         f9kwjt5kdARd8XxidgW913nsva+bmVThVlj5OIrcrGUh3BoKx0G1l7oPDfG4dg2g9W
         OOALjEEH3yByEOoxAx9pkkIPJyiaT77dMqWTH467vER+XzrZvD43FkTMnyMWmmioDf
         6aHlW6K9PPMf1HLrqClpXQ94g5vBw0Cg/NvnILR9P6x6TdcFMpLPkYunAAPIkcdf5x
         GtthBCbF090SvTpT0hHDxK6FhfGsX3bPk+TsdgBzGeEiMtPQ6cE4NelGo16X2EBbc9
         ZeC3ANeioSRxg==
Date:   Tue, 29 Mar 2022 10:59:33 +0100
From:   Filipe Manana <fdmanana@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>, clm@fb.com, jbacik@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.17 17/21] btrfs: reset last_reflink_trans after
 fsyncing inode
Message-ID: <YkLYhad7iX2Bv/j1@debian9.Home>
References: <20220328194157.1585642-1-sashal@kernel.org>
 <20220328194157.1585642-17-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328194157.1585642-17-sashal@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 28, 2022 at 03:41:52PM -0400, Sasha Levin wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> [ Upstream commit 23e3337faf73e5bb2610697977e175313d48acb0 ]
> 
> When an inode has a last_reflink_trans matching the current transaction,
> we have to take special care when logging its checksums in order to
> avoid getting checksum items with overlapping ranges in a log tree,
> which could result in missing checksums after log replay (more on that
> in the changelogs of commit 40e046acbd2f36 ("Btrfs: fix missing data
> checksums after replaying a log tree") and commit e289f03ea79bbc ("btrfs:
> fix corrupt log due to concurrent fsync of inodes with shared extents")).
> We also need to make sure a full fsync will copy all old file extent
> items it finds in modified leaves, because they might have been copied
> from some other inode.
> 
> However once we fsync an inode, we don't need to keep paying the price of
> that extra special care in future fsyncs done in the same transaction,
> unless the inode is used for another reflink operation or the full sync
> flag is set on it (truncate, failure to allocate extent maps for holes,
> and other exceptional and infrequent cases).
> 
> So after we fsync an inode reset its last_unlink_trans to zero. In case
> another reflink happens, we continue to update the last_reflink_trans of
> the inode, just as before. Also set last_reflink_trans to the generation
> of the last transaction that modified the inode whenever we need to set
> the full sync flag on the inode, just like when we need to load an inode
> from disk after eviction.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

What's the motivation to backport this to stable?

It doesn't fix a bug or any regression, as far as I know at least.
Or is it to make some other backport easier?

Thanks.

> ---
>  fs/btrfs/btrfs_inode.h | 30 ++++++++++++++++++++++++++++++
>  fs/btrfs/file.c        |  7 +++----
>  fs/btrfs/inode.c       | 12 +++++-------
>  fs/btrfs/reflink.c     |  5 ++---
>  fs/btrfs/tree-log.c    |  8 ++++++++
>  5 files changed, 48 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index b3e46aabc3d8..d0b52b106041 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -333,6 +333,36 @@ static inline void btrfs_set_inode_last_sub_trans(struct btrfs_inode *inode)
>  	spin_unlock(&inode->lock);
>  }
>  
> +/*
> + * Should be called while holding the inode's VFS lock in exclusive mode or in a
> + * context where no one else can access the inode concurrently (during inode
> + * creation or when loading an inode from disk).
> + */
> +static inline void btrfs_set_inode_full_sync(struct btrfs_inode *inode)
> +{
> +	set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &inode->runtime_flags);
> +	/*
> +	 * The inode may have been part of a reflink operation in the last
> +	 * transaction that modified it, and then a fsync has reset the
> +	 * last_reflink_trans to avoid subsequent fsyncs in the same
> +	 * transaction to do unnecessary work. So update last_reflink_trans
> +	 * to the last_trans value (we have to be pessimistic and assume a
> +	 * reflink happened).
> +	 *
> +	 * The ->last_trans is protected by the inode's spinlock and we can
> +	 * have a concurrent ordered extent completion update it. Also set
> +	 * last_reflink_trans to ->last_trans only if the former is less than
> +	 * the later, because we can be called in a context where
> +	 * last_reflink_trans was set to the current transaction generation
> +	 * while ->last_trans was not yet updated in the current transaction,
> +	 * and therefore has a lower value.
> +	 */
> +	spin_lock(&inode->lock);
> +	if (inode->last_reflink_trans < inode->last_trans)
> +		inode->last_reflink_trans = inode->last_trans;
> +	spin_unlock(&inode->lock);
> +}
> +
>  static inline bool btrfs_inode_in_log(struct btrfs_inode *inode, u64 generation)
>  {
>  	bool ret = false;
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index a0179cc62913..f38cc706a6cf 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2474,7 +2474,7 @@ static int fill_holes(struct btrfs_trans_handle *trans,
>  	hole_em = alloc_extent_map();
>  	if (!hole_em) {
>  		btrfs_drop_extent_cache(inode, offset, end - 1, 0);
> -		set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &inode->runtime_flags);
> +		btrfs_set_inode_full_sync(inode);
>  	} else {
>  		hole_em->start = offset;
>  		hole_em->len = end - offset;
> @@ -2495,8 +2495,7 @@ static int fill_holes(struct btrfs_trans_handle *trans,
>  		} while (ret == -EEXIST);
>  		free_extent_map(hole_em);
>  		if (ret)
> -			set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
> -					&inode->runtime_flags);
> +			btrfs_set_inode_full_sync(inode);
>  	}
>  
>  	return 0;
> @@ -2850,7 +2849,7 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
>  	 * maps for the replacement extents (or holes).
>  	 */
>  	if (extent_info && !extent_info->is_new_extent)
> -		set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &inode->runtime_flags);
> +		btrfs_set_inode_full_sync(inode);
>  
>  	if (ret)
>  		goto out_trans;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 5aace4c13519..3783fdf78da8 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -423,7 +423,7 @@ static noinline int cow_file_range_inline(struct btrfs_inode *inode, u64 start,
>  		goto out;
>  	}
>  
> -	set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &inode->runtime_flags);
> +	btrfs_set_inode_full_sync(inode);
>  out:
>  	/*
>  	 * Don't forget to free the reserved space, as for inlined extent
> @@ -4882,8 +4882,7 @@ int btrfs_cont_expand(struct btrfs_inode *inode, loff_t oldsize, loff_t size)
>  						cur_offset + hole_size - 1, 0);
>  			hole_em = alloc_extent_map();
>  			if (!hole_em) {
> -				set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
> -					&inode->runtime_flags);
> +				btrfs_set_inode_full_sync(inode);
>  				goto next;
>  			}
>  			hole_em->start = cur_offset;
> @@ -6146,7 +6145,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
>  	 * sync since it will be a full sync anyway and this will blow away the
>  	 * old info in the log.
>  	 */
> -	set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &BTRFS_I(inode)->runtime_flags);
> +	btrfs_set_inode_full_sync(BTRFS_I(inode));
>  
>  	key[0].objectid = objectid;
>  	key[0].type = BTRFS_INODE_ITEM_KEY;
> @@ -8740,7 +8739,7 @@ static int btrfs_truncate(struct inode *inode, bool skip_writeback)
>  	 * extents beyond i_size to drop.
>  	 */
>  	if (control.extents_found > 0)
> -		set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &BTRFS_I(inode)->runtime_flags);
> +		btrfs_set_inode_full_sync(BTRFS_I(inode));
>  
>  	return ret;
>  }
> @@ -10027,8 +10026,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
>  
>  		em = alloc_extent_map();
>  		if (!em) {
> -			set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
> -				&BTRFS_I(inode)->runtime_flags);
> +			btrfs_set_inode_full_sync(BTRFS_I(inode));
>  			goto next;
>  		}
>  
> diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> index a3930da4eb3f..e37a61ad87df 100644
> --- a/fs/btrfs/reflink.c
> +++ b/fs/btrfs/reflink.c
> @@ -277,7 +277,7 @@ static int clone_copy_inline_extent(struct inode *dst,
>  						  path->slots[0]),
>  			    size);
>  	btrfs_update_inode_bytes(BTRFS_I(dst), datal, drop_args.bytes_found);
> -	set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &BTRFS_I(dst)->runtime_flags);
> +	btrfs_set_inode_full_sync(BTRFS_I(dst));
>  	ret = btrfs_inode_set_file_extent_range(BTRFS_I(dst), 0, aligned_end);
>  out:
>  	if (!ret && !trans) {
> @@ -575,8 +575,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
>  		 * replaced file extent items.
>  		 */
>  		if (last_dest_end >= i_size_read(inode))
> -			set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
> -				&BTRFS_I(inode)->runtime_flags);
> +			btrfs_set_inode_full_sync(BTRFS_I(inode));
>  
>  		ret = btrfs_replace_file_extents(BTRFS_I(inode), path,
>  				last_dest_end, destoff + len - 1, NULL, &trans);
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 6bc8834ac8f7..607527a924c2 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -5836,6 +5836,14 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
>  	if (inode_only != LOG_INODE_EXISTS)
>  		inode->last_log_commit = inode->last_sub_trans;
>  	spin_unlock(&inode->lock);
> +
> +	/*
> +	 * Reset the last_reflink_trans so that the next fsync does not need to
> +	 * go through the slower path when logging extents and their checksums.
> +	 */
> +	if (inode_only == LOG_INODE_ALL)
> +		inode->last_reflink_trans = 0;
> +
>  out_unlock:
>  	mutex_unlock(&inode->log_mutex);
>  out:
> -- 
> 2.34.1
> 
