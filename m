Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B34AE576B5D
	for <lists+stable@lfdr.de>; Sat, 16 Jul 2022 05:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbiGPDAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 23:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiGPDAv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 23:00:51 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A847D4A81F;
        Fri, 15 Jul 2022 20:00:49 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LlCcG26dCzlVm9;
        Sat, 16 Jul 2022 10:59:10 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (7.193.23.68) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 16 Jul 2022 11:00:47 +0800
Received: from [10.174.178.46] (10.174.178.46) by
 kwepemm600013.china.huawei.com (7.193.23.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 16 Jul 2022 11:00:47 +0800
Subject: Re: [PATCH 05/10] ext4: Fix race when reusing xattr blocks
To:     Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>
CC:     <linux-ext4@vger.kernel.org>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        <stable@vger.kernel.org>
References: <20220712104519.29887-1-jack@suse.cz>
 <20220712105436.32204-5-jack@suse.cz>
From:   Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <0556811b-29f7-799b-66fc-87e4127cb714@huawei.com>
Date:   Sat, 16 Jul 2022 11:00:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20220712105436.32204-5-jack@suse.cz>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.46]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ÔÚ 2022/7/12 18:54, Jan Kara Ð´µÀ:
Hi Jan, one little question confuses me:
> When ext4_xattr_block_set() decides to remove xattr block the following
> race can happen:
> 
> CPU1                                    CPU2
> ext4_xattr_block_set()                  ext4_xattr_release_block()
>    new_bh = ext4_xattr_block_cache_find()
> 
>                                            lock_buffer(bh);
>                                            ref = le32_to_cpu(BHDR(bh)->h_refcount);
>                                            if (ref == 1) {
>                                              ...
>                                              mb_cache_entry_delete();
>                                              unlock_buffer(bh);
>                                              ext4_free_blocks();
>                                                ...
>                                                ext4_forget(..., bh, ...);
>                                                  jbd2_journal_revoke(..., bh);
> 
>    ext4_journal_get_write_access(..., new_bh, ...)
>      do_get_write_access()
>        jbd2_journal_cancel_revoke(..., new_bh);
> 
> Later the code in ext4_xattr_block_set() finds out the block got freed
> and cancels reusal of the block but the revoke stays canceled and so in
> case of block reuse and journal replay the filesystem can get corrupted.
> If the race works out slightly differently, we can also hit assertions
> in the jbd2 code.
> 
> Fix the problem by making sure that once matching mbcache entry is
> found, code dropping the last xattr block reference (or trying to modify
> xattr block in place) waits until the mbcache entry reference is
> dropped. This way code trying to reuse xattr block is protected from
> someone trying to drop the last reference to xattr block.
> 
> Reported-and-tested-by: Ritesh Harjani <ritesh.list@gmail.com>
> CC: stable@vger.kernel.org
> Fixes: 82939d7999df ("ext4: convert to mbcache2")
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>   fs/ext4/xattr.c | 67 +++++++++++++++++++++++++++++++++----------------
>   1 file changed, 45 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index aadfae53d055..3a0928c8720e 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -439,9 +439,16 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
>   /* Remove entry from mbcache when EA inode is getting evicted */
>   void ext4_evict_ea_inode(struct inode *inode)
>   {
> -	if (EA_INODE_CACHE(inode))
> -		mb_cache_entry_delete(EA_INODE_CACHE(inode),
> -			ext4_xattr_inode_get_hash(inode), inode->i_ino);
> +	struct mb_cache_entry *oe;
> +
> +	if (!EA_INODE_CACHE(inode))
> +		return;
> +	/* Wait for entry to get unused so that we can remove it */
> +	while ((oe = mb_cache_entry_delete_or_get(EA_INODE_CACHE(inode),
> +			ext4_xattr_inode_get_hash(inode), inode->i_ino))) {
> +		mb_cache_entry_wait_unused(oe);
> +		mb_cache_entry_put(EA_INODE_CACHE(inode), oe);
> +	}
>   }
>   
>   static int
> @@ -1229,6 +1236,7 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
>   	if (error)
>   		goto out;
>   
> +retry_ref:
>   	lock_buffer(bh);
>   	hash = le32_to_cpu(BHDR(bh)->h_hash);
>   	ref = le32_to_cpu(BHDR(bh)->h_refcount);
> @@ -1238,9 +1246,18 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
>   		 * This must happen under buffer lock for
>   		 * ext4_xattr_block_set() to reliably detect freed block
>   		 */
> -		if (ea_block_cache)
> -			mb_cache_entry_delete(ea_block_cache, hash,
> -					      bh->b_blocknr);
> +		if (ea_block_cache) {
> +			struct mb_cache_entry *oe;
> +
> +			oe = mb_cache_entry_delete_or_get(ea_block_cache, hash,
> +							  bh->b_blocknr);
> +			if (oe) {
> +				unlock_buffer(bh);
> +				mb_cache_entry_wait_unused(oe);
> +				mb_cache_entry_put(ea_block_cache, oe);
> +				goto retry_ref;
> +			}
> +		}
>   		get_bh(bh);
>   		unlock_buffer(bh);
>   
> @@ -1867,9 +1884,20 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>   			 * ext4_xattr_block_set() to reliably detect modified
>   			 * block
>   			 */
> -			if (ea_block_cache)
> -				mb_cache_entry_delete(ea_block_cache, hash,
> -						      bs->bh->b_blocknr);
> +			if (ea_block_cache) {
> +				struct mb_cache_entry *oe;
> +
> +				oe = mb_cache_entry_delete_or_get(ea_block_cache,
> +					hash, bs->bh->b_blocknr);
> +				if (oe) {
> +					/*
> +					 * Xattr block is getting reused. Leave
> +					 * it alone.
> +					 */
> +					mb_cache_entry_put(ea_block_cache, oe);
> +					goto clone_block;
> +				}
> +			}
>   			ea_bdebug(bs->bh, "modifying in-place");
>   			error = ext4_xattr_set_entry(i, s, handle, inode,
>   						     true /* is_block */);
> @@ -1885,6 +1913,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>   				goto cleanup;
>   			goto inserted;
>   		}
> +clone_block:
>   		unlock_buffer(bs->bh);
>   		ea_bdebug(bs->bh, "cloning");
>   		s->base = kmalloc(bs->bh->b_size, GFP_NOFS);
> @@ -1991,18 +2020,13 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>   				lock_buffer(new_bh);
>   				/*
>   				 * We have to be careful about races with
> -				 * freeing, rehashing or adding references to
> -				 * xattr block. Once we hold buffer lock xattr
> -				 * block's state is stable so we can check
> -				 * whether the block got freed / rehashed or
> -				 * not.  Since we unhash mbcache entry under
> -				 * buffer lock when freeing / rehashing xattr
> -				 * block, checking whether entry is still
> -				 * hashed is reliable. Same rules hold for
> -				 * e_reusable handling.
> +				 * adding references to xattr block. Once we
> +				 * hold buffer lock xattr block's state is
> +				 * stable so we can check the additional
> +				 * reference fits.
>   				 */
> -				if (hlist_bl_unhashed(&ce->e_hash_list) ||
> -				    !ce->e_reusable) {
> +				ref = le32_to_cpu(BHDR(new_bh)->h_refcount) + 1;
> +				if (ref > EXT4_XATTR_REFCOUNT_MAX) {

So far, we have mb_cache_entry_delete_or_get() and 
mb_cache_entry_wait_unused(), so used cache entry cannot be concurrently 
removed. Removing check 'hlist_bl_unhashed(&ce->e_hash_list)' is okay.

What's affect of changing the other two checks 'ref >= 
EXT4_XATTR_REFCOUNT_MAX' and '!ce->e_reusable'? To make code more 
obvious? eg. To point out the condition of 'ref <= 
EXT4_XATTR_REFCOUNT_MAX' rather than 'ce->e_reusable', we have checked 
'ce->e_reusable' in ext4_xattr_block_cache_find() before?
>   					/*
>   					 * Undo everything and check mbcache
>   					 * again.
> @@ -2017,9 +2041,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>   					new_bh = NULL;
>   					goto inserted;
>   				}
> -				ref = le32_to_cpu(BHDR(new_bh)->h_refcount) + 1;
>   				BHDR(new_bh)->h_refcount = cpu_to_le32(ref);
> -				if (ref >= EXT4_XATTR_REFCOUNT_MAX)
> +				if (ref == EXT4_XATTR_REFCOUNT_MAX)
>   					ce->e_reusable = 0;
>   				ea_bdebug(new_bh, "reusing; refcount now=%d",
>   					  ref);
> 

