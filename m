Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9DD3349410
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 15:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhCYOas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 10:30:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:42524 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231330AbhCYOaW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 10:30:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E6237AD80;
        Thu, 25 Mar 2021 14:30:20 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id AB62F1E4415; Thu, 25 Mar 2021 15:30:20 +0100 (CET)
Date:   Thu, 25 Mar 2021 15:30:20 +0100
From:   Jan Kara <jack@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.11 03/44] ext4: add reclaim checks to xattr code
Message-ID: <20210325143020.GC13673@quack2.suse.cz>
References: <20210325112459.1926846-1-sashal@kernel.org>
 <20210325112459.1926846-3-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325112459.1926846-3-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha, just be aware that this commit was added to help tracking down a
particular syzbot report. As such there's no point in carrying it in
-stable but there's no big harm either... Just one patch more.

								Honza

On Thu 25-03-21 07:24:18, Sasha Levin wrote:
> From: Jan Kara <jack@suse.cz>
> 
> [ Upstream commit 163f0ec1df33cf468509ff38cbcbb5eb0d7fac60 ]
> 
> Syzbot is reporting that ext4 can enter fs reclaim from kvmalloc() while
> the transaction is started like:
> 
>   fs_reclaim_acquire+0x117/0x150 mm/page_alloc.c:4340
>   might_alloc include/linux/sched/mm.h:193 [inline]
>   slab_pre_alloc_hook mm/slab.h:493 [inline]
>   slab_alloc_node mm/slub.c:2817 [inline]
>   __kmalloc_node+0x5f/0x430 mm/slub.c:4015
>   kmalloc_node include/linux/slab.h:575 [inline]
>   kvmalloc_node+0x61/0xf0 mm/util.c:587
>   kvmalloc include/linux/mm.h:781 [inline]
>   ext4_xattr_inode_cache_find fs/ext4/xattr.c:1465 [inline]
>   ext4_xattr_inode_lookup_create fs/ext4/xattr.c:1508 [inline]
>   ext4_xattr_set_entry+0x1ce6/0x3780 fs/ext4/xattr.c:1649
>   ext4_xattr_ibody_set+0x78/0x2b0 fs/ext4/xattr.c:2224
>   ext4_xattr_set_handle+0x8f4/0x13e0 fs/ext4/xattr.c:2380
>   ext4_xattr_set+0x13a/0x340 fs/ext4/xattr.c:2493
> 
> This should be impossible since transaction start sets PF_MEMALLOC_NOFS.
> Add some assertions to the code to catch if something isn't working as
> expected early.
> 
> Link: https://lore.kernel.org/linux-ext4/000000000000563a0205bafb7970@google.com/
> Signed-off-by: Jan Kara <jack@suse.cz>
> Link: https://lore.kernel.org/r/20210222171626.21884-1-jack@suse.cz
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/ext4/xattr.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 372208500f4e..083c95126781 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -1462,6 +1462,9 @@ ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
>  	if (!ce)
>  		return NULL;
>  
> +	WARN_ON_ONCE(ext4_handle_valid(journal_current_handle()) &&
> +		     !(current->flags & PF_MEMALLOC_NOFS));
> +
>  	ea_data = kvmalloc(value_len, GFP_KERNEL);
>  	if (!ea_data) {
>  		mb_cache_entry_put(ea_inode_cache, ce);
> @@ -2327,6 +2330,7 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
>  			error = -ENOSPC;
>  			goto cleanup;
>  		}
> +		WARN_ON_ONCE(!(current->flags & PF_MEMALLOC_NOFS));
>  	}
>  
>  	error = ext4_reserve_inode_write(handle, inode, &is.iloc);
> -- 
> 2.30.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
