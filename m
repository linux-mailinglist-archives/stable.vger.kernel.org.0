Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73BB65EEC0
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 15:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjAEO37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 09:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbjAEO35 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 09:29:57 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3634C50054
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 06:29:56 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8D600171A8;
        Thu,  5 Jan 2023 14:29:51 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 81872138DF;
        Thu,  5 Jan 2023 14:29:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ya2VH9/etmN3DQAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 05 Jan 2023 14:29:51 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 0737BA0742; Thu,  5 Jan 2023 15:29:51 +0100 (CET)
Date:   Thu, 5 Jan 2023 15:29:50 +0100
From:   Jan Kara <jack@suse.cz>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc:     stable@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
        Thilo Fromm <t-lo@linux.microsoft.com>,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5.15] ext4: fix deadlock due to mbcache entry corruption
Message-ID: <20230105142950.ecwzsh4c3sxib575@quack3>
References: <1672927319-22912-1-git-send-email-jpiotrowski@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1672927319-22912-1-git-send-email-jpiotrowski@linux.microsoft.com>
Authentication-Results: smtp-out1.suse.de;
        none
X-Spam-Level: 
X-Spam-Score: 0.40
X-Spamd-Result: default: False [0.40 / 50.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         MID_RHS_NOT_FQDN(0.50)[];
         RCVD_COUNT_TWO(0.00)[2];
         RCPT_COUNT_FIVE(0.00)[6];
         RCVD_TLS_ALL(0.00)[]
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 05-01-23 06:01:59, Jeremi Piotrowski wrote:
> From: Jan Kara <jack@suse.cz>
> 
> commit a44e84a9b7764c72896f7241a0ec9ac7e7ef38dd upstream.
> 
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
> This bug has been around for many years, but it became *much* easier
> to hit after commit 65f8b80053a1 ("ext4: fix race when reusing xattr
> blocks").
> 
> A special backport to 5.15 was necessary due to changes to reference counting.
> 
> Cc: stable@vger.kernel.org # 5.15
> Fixes: 6048c64b2609 ("mbcache: add reusable flag to cache entries")
> Fixes: 65f8b80053a1 ("ext4: fix race when reusing xattr blocks")
> Reported-and-tested-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
> Reported-by: Thilo Fromm <t-lo@linux.microsoft.com>
> Link: https://lore.kernel.org/r/c77bf00f-4618-7149-56f1-b8d1664b9d07@linux.microsoft.com/
> Signed-off-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> Link: https://lore.kernel.org/r/20221123193950.16758-1-jack@suse.cz
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>

The backport looks good to me. Not sure if Greg tracks acks for stable
trees but anyway Greg, feel free to consider this:

Acked-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/xattr.c         |  4 ++--
>  fs/mbcache.c            | 14 ++++++++------
>  include/linux/mbcache.h |  9 +++++++--
>  3 files changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 533216e80fa2..22700812a4d3 100644
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
> index 2010bc80a3f2..ac07b50ea3df 100644
> --- a/fs/mbcache.c
> +++ b/fs/mbcache.c
> @@ -94,8 +94,9 @@ int mb_cache_entry_create(struct mb_cache *cache, gfp_t mask, u32 key,
>  	atomic_set(&entry->e_refcnt, 1);
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
> @@ -155,7 +156,8 @@ static struct mb_cache_entry *__entry_find(struct mb_cache *cache,
>  	while (node) {
>  		entry = hlist_bl_entry(node, struct mb_cache_entry,
>  				       e_hash_list);
> -		if (entry->e_key == key && entry->e_reusable) {
> +		if (entry->e_key == key &&
> +		    test_bit(MBE_REUSABLE_B, &entry->e_flags)) {
>  			atomic_inc(&entry->e_refcnt);
>  			goto out;
>  		}
> @@ -325,7 +327,7 @@ EXPORT_SYMBOL(mb_cache_entry_delete_or_get);
>  void mb_cache_entry_touch(struct mb_cache *cache,
>  			  struct mb_cache_entry *entry)
>  {
> -	entry->e_referenced = 1;
> +	set_bit(MBE_REFERENCED_B, &entry->e_flags);
>  }
>  EXPORT_SYMBOL(mb_cache_entry_touch);
>  
> @@ -350,8 +352,8 @@ static unsigned long mb_cache_shrink(struct mb_cache *cache,
>  	while (nr_to_scan-- && !list_empty(&cache->c_list)) {
>  		entry = list_first_entry(&cache->c_list,
>  					 struct mb_cache_entry, e_list);
> -		if (entry->e_referenced || atomic_read(&entry->e_refcnt) > 2) {
> -			entry->e_referenced = 0;
> +		if (test_bit(MBE_REFERENCED_B, &entry->e_flags) || atomic_read(&entry->e_refcnt) > 2) {
> +			clear_bit(MBE_REFERENCED_B, &entry->e_flags);
>  			list_move_tail(&entry->e_list, &cache->c_list);
>  			continue;
>  		}
> diff --git a/include/linux/mbcache.h b/include/linux/mbcache.h
> index 8eca7f25c432..62927f7e2588 100644
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
> @@ -18,8 +24,7 @@ struct mb_cache_entry {
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
> 2.25.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
