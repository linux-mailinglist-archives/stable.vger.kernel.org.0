Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75A532DF29
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 02:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhCEBhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 20:37:35 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:13433 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhCEBhf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 20:37:35 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Ds9LJ4wR4zjVb1;
        Fri,  5 Mar 2021 09:36:08 +0800 (CST)
Received: from [10.136.110.154] (10.136.110.154) by smtp.huawei.com
 (10.3.19.204) with Microsoft SMTP Server (TLS) id 14.3.498.0; Fri, 5 Mar 2021
 09:37:27 +0800
Subject: Re: [f2fs-dev] [PATCH 2/2] f2fs: fix error handling in
 f2fs_end_enable_verity()
To:     Eric Biggers <ebiggers@kernel.org>, <linux-ext4@vger.kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>
CC:     <linux-fscrypt@vger.kernel.org>, <stable@vger.kernel.org>
References: <20210302200420.137977-1-ebiggers@kernel.org>
 <20210302200420.137977-3-ebiggers@kernel.org>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <9980e263-aa25-cf50-5a94-9f63a5ae667e@huawei.com>
Date:   Fri, 5 Mar 2021 09:37:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20210302200420.137977-3-ebiggers@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.136.110.154]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/3/3 4:04, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> f2fs didn't properly clean up if verity failed to be enabled on a file:
> 
> - It left verity metadata (pages past EOF) in the page cache, which
>    would be exposed to userspace if the file was later extended.
> 
> - It didn't truncate the verity metadata at all (either from cache or
>    from disk) if an error occurred while setting the verity bit.
> 
> Fix these bugs by adding a call to truncate_inode_pages() and ensuring
> that we truncate the verity metadata (both from cache and from disk) in
> all error paths.  Also rework the code to cleanly separate the success
> path from the error paths, which makes it much easier to understand.
> 
> Reported-by: Yunlei He <heyunlei@hihonor.com>
> Fixes: 95ae251fe828 ("f2fs: add fs-verity support")
> Cc: <stable@vger.kernel.org> # v5.4+
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>   fs/f2fs/verity.c | 61 ++++++++++++++++++++++++++++++++----------------
>   1 file changed, 41 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
> index 054ec852b5ea4..2db89967fde37 100644
> --- a/fs/f2fs/verity.c
> +++ b/fs/f2fs/verity.c
> @@ -160,31 +160,52 @@ static int f2fs_end_enable_verity(struct file *filp, const void *desc,
>   	};
>   	int err = 0;
>   
> -	if (desc != NULL) {
> -		/* Succeeded; write the verity descriptor. */
> -		err = pagecache_write(inode, desc, desc_size, desc_pos);
> +	/*
> +	 * If an error already occurred (which fs/verity/ signals by passing
> +	 * desc == NULL), then only clean-up is needed.
> +	 */
> +	if (desc == NULL)
> +		goto cleanup;
>   
> -		/* Write all pages before clearing FI_VERITY_IN_PROGRESS. */
> -		if (!err)
> -			err = filemap_write_and_wait(inode->i_mapping);
> -	}
> +	/* Append the verity descriptor. */
> +	err = pagecache_write(inode, desc, desc_size, desc_pos);
> +	if (err)
> +		goto cleanup;
>   
> -	/* If we failed, truncate anything we wrote past i_size. */
> -	if (desc == NULL || err)
> -		f2fs_truncate(inode);
> +	/*
> +	 * Write all pages (both data and verity metadata).  Note that this must
> +	 * happen before clearing FI_VERITY_IN_PROGRESS; otherwise pages beyond
> +	 * i_size won't be written properly.  For crash consistency, this also
> +	 * must happen before the verity inode flag gets persisted.
> +	 */
> +	err = filemap_write_and_wait(inode->i_mapping);
> +	if (err)
> +		goto cleanup;
> +
> +	/* Set the verity xattr. */
> +	err = f2fs_setxattr(inode, F2FS_XATTR_INDEX_VERITY,
> +			    F2FS_XATTR_NAME_VERITY, &dloc, sizeof(dloc),
> +			    NULL, XATTR_CREATE);
> +	if (err)
> +		goto cleanup;
> +
> +	/* Finally, set the verity inode flag. */
> +	file_set_verity(inode);
> +	f2fs_set_inode_flags(inode);
> +	f2fs_mark_inode_dirty_sync(inode, true);
>   
>   	clear_inode_flag(inode, FI_VERITY_IN_PROGRESS);
> +	return 0;
>   
> -	if (desc != NULL && !err) {
> -		err = f2fs_setxattr(inode, F2FS_XATTR_INDEX_VERITY,
> -				    F2FS_XATTR_NAME_VERITY, &dloc, sizeof(dloc),
> -				    NULL, XATTR_CREATE);
> -		if (!err) {
> -			file_set_verity(inode);
> -			f2fs_set_inode_flags(inode);
> -			f2fs_mark_inode_dirty_sync(inode, true);
> -		}
> -	}
> +cleanup:
> +	/*
> +	 * Verity failed to be enabled, so clean up by truncating any verity
> +	 * metadata that was written beyond i_size (both from cache and from
> +	 * disk) and clearing FI_VERITY_IN_PROGRESS.
> +	 */
> +	truncate_inode_pages(inode->i_mapping, inode->i_size);
> +	f2fs_truncate(inode);

Eric,

Truncation can fail due to a lot of reasons, if we fail in f2fs_truncate(),
do we need to at least print a message here? or it allows to keep those
meta/data silently.

One other concern is that how do you think of covering truncate_inode_pages &
f2fs_truncate with F2FS_I(inode)->i_gc_rwsem[WRITE] lock to avoid racing with
GC, so that page cache won't be revalidated after truncate_inode_pages().

Thanks,

> +	clear_inode_flag(inode, FI_VERITY_IN_PROGRESS); >   	return err;
>   }
>   
> 
