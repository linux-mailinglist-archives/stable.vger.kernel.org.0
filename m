Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B169463F357
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 16:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbiLAPKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 10:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbiLAPKW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 10:10:22 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D7DB64AF36;
        Thu,  1 Dec 2022 07:10:21 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1112)
        id A26E620B83C2; Thu,  1 Dec 2022 07:10:21 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A26E620B83C2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1669907421;
        bh=maFYL7cyZxlxfLpUgiy/yjCpc5B3NqziJG6bC+0IrIw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fp91l4yHXQcGzBLEnbJye9jkRJdsi18FHM0+PV2h/HuKpJpnMTg45upKwvga1Gn6L
         uSrPjrfAuvS4hI1kTHPvWW4E6ziKiPkU0OnCsu1LM2eZ88HM0m24/4HGuXkOA3w1pl
         9PVnbmSLN8/BefvnaJ0Wzzzc/KFPhBTzXy2tGCyw=
Date:   Thu, 1 Dec 2022 07:10:21 -0800
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
To:     Ted Tso <tytso@mit.edu>
Cc:     Jan Kara <jack@suse.cz>, Andreas Gruenbacher <agruenba@redhat.com>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org,
        Thilo Fromm <t-lo@linux.microsoft.com>
Subject: Re: [PATCH] ext4: Fix deadlock due to mbcache entry corruption
Message-ID: <20221201151021.GA18380@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20221123193950.16758-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123193950.16758-1-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 23, 2022 at 08:39:50PM +0100, Jan Kara wrote:
> When manipulating xattr blocks, we can deadlock infinitely looping
> inside ext4_xattr_block_set() where we constantly keep finding xattr
> block for reuse in mbcache but we are unable to reuse it because its
> reference count is too big. This happens because cache entry for the
> xattr block is marked as reusable (e_reusable set) although its
> reference count is too big. When this inconsistency happens, this
> inconsistent state is kept indefinitely and so ext4_xattr_block_set()
> keeps retrying indefinitely.
> 
> The inconsistent state is caused by non-atomic update of e_reusable bit.
> e_reusable is part of a bitfield and e_reusable update can race with
> update of e_referenced bit in the same bitfield resulting in loss of one
> of the updates. Fix the problem by using atomic bitops instead.
> 
> CC: stable@vger.kernel.org
> Fixes: 6048c64b2609 ("mbcache: add reusable flag to cache entries")
> Reported-and-tested-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
> Reported-by: Thilo Fromm <t-lo@linux.microsoft.com>
> Link: https://lore.kernel.org/r/c77bf00f-4618-7149-56f1-b8d1664b9d07@linux.microsoft.com/
> Signed-off-by: Jan Kara <jack@suse.cz>

Hi Ted,

Could it be that you didn't see this email? We have users who are hitting this
and are very eager to see this bugfix get merged and backported to stable. 

Thanks,
Jeremi

> ---
>  fs/ext4/xattr.c         |  4 ++--
>  fs/mbcache.c            | 14 ++++++++------
>  include/linux/mbcache.h |  9 +++++++--
>  3 files changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 800ce5cdb9d2..08043aa72cf1 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -1281,7 +1281,7 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
>  				ce = mb_cache_entry_get(ea_block_cache, hash,
>  							bh->b_blocknr);
>  				if (ce) {
> -					ce->e_reusable = 1;
> +					set_bit(MBE_REUSABLE_B, &ce->e_flags);
>  					mb_cache_entry_put(ea_block_cache, ce);
>  				}
>  			}
> @@ -2042,7 +2042,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  				}
>  				BHDR(new_bh)->h_refcount = cpu_to_le32(ref);
>  				if (ref == EXT4_XATTR_REFCOUNT_MAX)
> -					ce->e_reusable = 0;
> +					clear_bit(MBE_REUSABLE_B, &ce->e_flags);
>  				ea_bdebug(new_bh, "reusing; refcount now=%d",
>  					  ref);
>  				ext4_xattr_block_csum_set(inode, new_bh);
> diff --git a/fs/mbcache.c b/fs/mbcache.c
> index e272ad738faf..2a4b8b549e93 100644
> --- a/fs/mbcache.c
> +++ b/fs/mbcache.c
> @@ -100,8 +100,9 @@ int mb_cache_entry_create(struct mb_cache *cache, gfp_t mask, u32 key,
>  	atomic_set(&entry->e_refcnt, 2);
>  	entry->e_key = key;
>  	entry->e_value = value;
> -	entry->e_reusable = reusable;
> -	entry->e_referenced = 0;
> +	entry->e_flags = 0;
> +	if (reusable)
> +		set_bit(MBE_REUSABLE_B, &entry->e_flags);
>  	head = mb_cache_entry_head(cache, key);
>  	hlist_bl_lock(head);
>  	hlist_bl_for_each_entry(dup, dup_node, head, e_hash_list) {
> @@ -165,7 +166,8 @@ static struct mb_cache_entry *__entry_find(struct mb_cache *cache,
>  	while (node) {
>  		entry = hlist_bl_entry(node, struct mb_cache_entry,
>  				       e_hash_list);
> -		if (entry->e_key == key && entry->e_reusable &&
> +		if (entry->e_key == key &&
> +		    test_bit(MBE_REUSABLE_B, &entry->e_flags) &&
>  		    atomic_inc_not_zero(&entry->e_refcnt))
>  			goto out;
>  		node = node->next;
> @@ -284,7 +286,7 @@ EXPORT_SYMBOL(mb_cache_entry_delete_or_get);
>  void mb_cache_entry_touch(struct mb_cache *cache,
>  			  struct mb_cache_entry *entry)
>  {
> -	entry->e_referenced = 1;
> +	set_bit(MBE_REFERENCED_B, &entry->e_flags);
>  }
>  EXPORT_SYMBOL(mb_cache_entry_touch);
>  
> @@ -309,9 +311,9 @@ static unsigned long mb_cache_shrink(struct mb_cache *cache,
>  		entry = list_first_entry(&cache->c_list,
>  					 struct mb_cache_entry, e_list);
>  		/* Drop initial hash reference if there is no user */
> -		if (entry->e_referenced ||
> +		if (test_bit(MBE_REFERENCED_B, &entry->e_flags) ||
>  		    atomic_cmpxchg(&entry->e_refcnt, 1, 0) != 1) {
> -			entry->e_referenced = 0;
> +			clear_bit(MBE_REFERENCED_B, &entry->e_flags);
>  			list_move_tail(&entry->e_list, &cache->c_list);
>  			continue;
>  		}
> diff --git a/include/linux/mbcache.h b/include/linux/mbcache.h
> index 2da63fd7b98f..97e64184767d 100644
> --- a/include/linux/mbcache.h
> +++ b/include/linux/mbcache.h
> @@ -10,6 +10,12 @@
>  
>  struct mb_cache;
>  
> +/* Cache entry flags */
> +enum {
> +	MBE_REFERENCED_B = 0,
> +	MBE_REUSABLE_B
> +};
> +
>  struct mb_cache_entry {
>  	/* List of entries in cache - protected by cache->c_list_lock */
>  	struct list_head	e_list;
> @@ -26,8 +32,7 @@ struct mb_cache_entry {
>  	atomic_t		e_refcnt;
>  	/* Key in hash - stable during lifetime of the entry */
>  	u32			e_key;
> -	u32			e_referenced:1;
> -	u32			e_reusable:1;
> +	unsigned long		e_flags;
>  	/* User provided value - stable during lifetime of the entry */
>  	u64			e_value;
>  };
> -- 
> 2.35.3
