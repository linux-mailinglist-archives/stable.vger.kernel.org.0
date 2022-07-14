Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9C6574D6D
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 14:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238153AbiGNM0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 08:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238050AbiGNM0J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 08:26:09 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB05629802;
        Thu, 14 Jul 2022 05:26:05 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 72so1437445pge.0;
        Thu, 14 Jul 2022 05:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I79IiuSyTbScxKDE1oBqlgf6Ta92KMgwmf6OvnrVqKw=;
        b=ZkEhYC5KR2v0+mDjrV7aFvuzBowxxNtaROOhM0mmQ+bgMfnRvnBdn9SEXiX59Kp8wV
         1RY6dk3feK2vLuRmrGJbBvaPTXpTD1JcYwJPXDfNaimaTcj/el7/QBMDjxE2iE7BBu9E
         4gBkiO/OLKuHAHhoRIO/2Y/CxQ8q9Tiz5jyGsUwBoG/LF6fHHnSEQygnvcJMGavXKJSK
         V5DmbtwYsOeXfPA6Nket8TAUgog1qCePVFnpXH3TWHKtJE86Qrcv1sfyTHt6SaSGKoCh
         0Dw/qS94cu1ZjG2gzg46Bm9BDHo+7P5YnfenJCjUj7n7dnbuYJs5B3uzd9Mkdx8N0jCf
         Yi2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I79IiuSyTbScxKDE1oBqlgf6Ta92KMgwmf6OvnrVqKw=;
        b=74Wd3PQ4qW/6+4sZNOVC25s6Kxrgng84057tHYIAQIzG7MZktPwDKAlQ7n20AtHZ5m
         +mL1C1g2tLeJOS6Dr8NJi6BMqmLbiTuK9jhSVE3IIDoSf0Az7bmJvkYoYDgErwwZXsmk
         F9h7JBpPYYvZeEHeWolLoSOyqlIBYvQU3mvIdXxmrEy7Z16zxKbbZSw6DOSY30S8u2yC
         Mu05U4AMrCS2z0l7OGSIh6PuUADSUCU1Yc+aSXMsmSBsVfmI2voVlguE/i/EHQioJIMG
         VOIL/fnAky5OFWM19WEEnNUFKEOKs5mVHPD0BUjbeAP6S8fgi9obFkw+KWkpjtUHVi6S
         h2aQ==
X-Gm-Message-State: AJIora+/e4vWN6kSGFQvOn4uJWtZkTOcDlDthMwU/FX8NJA+z56ML7mG
        aOvU2nGYmqpnLnknooulMS/9FDThrgE=
X-Google-Smtp-Source: AGRyM1s0cd5Jp4JYsusASH8XmcHHxYZfpQ0f/B7c7xV9cJ0dRs+YoHCuRLpDZlmVhN1IbyEBYoB0FA==
X-Received: by 2002:a05:6a00:993:b0:52a:dd93:f02d with SMTP id u19-20020a056a00099300b0052add93f02dmr8454931pfg.12.1657801565182;
        Thu, 14 Jul 2022 05:26:05 -0700 (PDT)
Received: from localhost ([2406:7400:63:cb1d:811:33e9:9bc2:d40])
        by smtp.gmail.com with ESMTPSA id x128-20020a633186000000b00408a9264b36sm1246877pgx.3.2022.07.14.05.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 05:26:04 -0700 (PDT)
Date:   Thu, 14 Jul 2022 17:56:00 +0530
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 05/10] ext4: Fix race when reusing xattr blocks
Message-ID: <20220714122600.56fqg63ztlrmkn4n@riteshh-domain>
References: <20220712104519.29887-1-jack@suse.cz>
 <20220712105436.32204-5-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712105436.32204-5-jack@suse.cz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22/07/12 12:54PM, Jan Kara wrote:
> When ext4_xattr_block_set() decides to remove xattr block the following
> race can happen:
>
> CPU1                                    CPU2
> ext4_xattr_block_set()                  ext4_xattr_release_block()
>   new_bh = ext4_xattr_block_cache_find()
>
>                                           lock_buffer(bh);
>                                           ref = le32_to_cpu(BHDR(bh)->h_refcount);
>                                           if (ref == 1) {
>                                             ...
>                                             mb_cache_entry_delete();
>                                             unlock_buffer(bh);
>                                             ext4_free_blocks();
>                                               ...
>                                               ext4_forget(..., bh, ...);
>                                                 jbd2_journal_revoke(..., bh);
>
>   ext4_journal_get_write_access(..., new_bh, ...)
>     do_get_write_access()
>       jbd2_journal_cancel_revoke(..., new_bh);
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

Thanks Jan,
Just a note - I retested the patches only till here (marked stable) with
stress-ng --xattr 16.
And I didn't find any issues so far for ext2, ext3, ext4 default mkfs options.

Also I re-ran full v3 patch series with the same test case on all 3 filesystem,
and I didn't find any failures of the same test case.

-ritesh




> ---
>  fs/ext4/xattr.c | 67 +++++++++++++++++++++++++++++++++----------------
>  1 file changed, 45 insertions(+), 22 deletions(-)
>
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index aadfae53d055..3a0928c8720e 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -439,9 +439,16 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
>  /* Remove entry from mbcache when EA inode is getting evicted */
>  void ext4_evict_ea_inode(struct inode *inode)
>  {
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
>  }
>
>  static int
> @@ -1229,6 +1236,7 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
>  	if (error)
>  		goto out;
>
> +retry_ref:
>  	lock_buffer(bh);
>  	hash = le32_to_cpu(BHDR(bh)->h_hash);
>  	ref = le32_to_cpu(BHDR(bh)->h_refcount);
> @@ -1238,9 +1246,18 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
>  		 * This must happen under buffer lock for
>  		 * ext4_xattr_block_set() to reliably detect freed block
>  		 */
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
>  		get_bh(bh);
>  		unlock_buffer(bh);
>
> @@ -1867,9 +1884,20 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  			 * ext4_xattr_block_set() to reliably detect modified
>  			 * block
>  			 */
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
>  			ea_bdebug(bs->bh, "modifying in-place");
>  			error = ext4_xattr_set_entry(i, s, handle, inode,
>  						     true /* is_block */);
> @@ -1885,6 +1913,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  				goto cleanup;
>  			goto inserted;
>  		}
> +clone_block:
>  		unlock_buffer(bs->bh);
>  		ea_bdebug(bs->bh, "cloning");
>  		s->base = kmalloc(bs->bh->b_size, GFP_NOFS);
> @@ -1991,18 +2020,13 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  				lock_buffer(new_bh);
>  				/*
>  				 * We have to be careful about races with
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
>  				 */
> -				if (hlist_bl_unhashed(&ce->e_hash_list) ||
> -				    !ce->e_reusable) {
> +				ref = le32_to_cpu(BHDR(new_bh)->h_refcount) + 1;
> +				if (ref > EXT4_XATTR_REFCOUNT_MAX) {
>  					/*
>  					 * Undo everything and check mbcache
>  					 * again.
> @@ -2017,9 +2041,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  					new_bh = NULL;
>  					goto inserted;
>  				}
> -				ref = le32_to_cpu(BHDR(new_bh)->h_refcount) + 1;
>  				BHDR(new_bh)->h_refcount = cpu_to_le32(ref);
> -				if (ref >= EXT4_XATTR_REFCOUNT_MAX)
> +				if (ref == EXT4_XATTR_REFCOUNT_MAX)
>  					ce->e_reusable = 0;
>  				ea_bdebug(new_bh, "reusing; refcount now=%d",
>  					  ref);
> --
> 2.35.3
>
