Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E216410304
	for <lists+stable@lfdr.de>; Sat, 18 Sep 2021 04:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbhIRCd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 22:33:59 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:48633 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231364AbhIRCd5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Sep 2021 22:33:57 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Uojp8IE_1631932351;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0Uojp8IE_1631932351)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 18 Sep 2021 10:32:32 +0800
Subject: Re: [PATCH] dm thin metadata: Fix use-after-free in
 dm_bm_set_read_only
To:     gregkh@linuxfoundation.or, snitzer@redhat.com
Cc:     yebin10@huawei.com, stable@vger.kernel.org,
        xiejingfeng@linux.alibaba.com, joseph.qi@linux.alibaba.com
References: <20210918022650.84678-1-jefflexu@linux.alibaba.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <1d77bd91-6cd8-e149-83c5-d64c274b67cc@linux.alibaba.com>
Date:   Sat, 18 Sep 2021 10:32:31 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210918022650.84678-1-jefflexu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry, I misspelled the email address of Greg, please omit this email,
and I had sent a new one.

On 9/18/21 10:26 AM, Jeffle Xu wrote:
> From: Ye Bin <yebin10@huawei.com>
> 
> Hi Greg,
> 
> Ye Bin had ever fixed a use-after-free of dm-thin in v5.9, and the
> complete patchset contains three patches:
> 
> [1/3] d16ff19e69ab  dm cache metadata: Avoid returning cmd->bm wild pointer on error
> [2/3] 219403d7e56f dm thin metadata:  Avoid returning cmd->bm wild pointer on error
> [3/3] 3a653b205f29 dm thin metadata: Fix use-after-free in dm_bm_set_read_only
> 
> However, 4.19.y stable only picks the former two patches [1]:
> [1/3] 67f03c3d6829 dm cache metadata: Avoid returning cmd->bm wild pointer on error
> [2/3] 2c00ee626ed4 dm thin metadata: Avoid returning cmd->bm wild pointer on error
> 
> We encountered a NULL crash and xiejingfeng found that the omitted patch 3 can
> fix that. I'm not sure why patch 3 is not picked then, and we need this patch
> to fix this issue.
> 
> [32402.449200] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> [32402.459553] Oops: 0002 [#1] SMP NOPTI
> [32402.483982] RIP: 0010:dm_bm_set_read_only+0x5/0x10 [dm_persistent_data]
> [32402.588073] Call Trace:
> [32402.590522] dm_pool_metadata_read_only+0x22/0x30 [dm_thin_pool]
> [32402.596526] set_pool_mode+0x209/0x2e0 [dm_thin_pool]
> [32402.601579] metadata_operation_failed+0xd5/0xf0 [dm_thin_pool]
> [32402.607499] commit+0x91/0xf0 [dm_thin_pool]
> [32402.611771] pool_status+0x28a/0x700 [dm_thin_pool]
> [32402.616652] retrieve_status+0xa1/0x1c0 [dm_mod]
> [32402.627794] table_status+0x61/0xa0 [dm_mod]
> [32402.632068] ctl_ioctl+0x1b3/0x480 [dm_mod]
> [32402.636253] dm_ctl_ioctl+0xa/0x10 [dm_mod]
> [32402.640440] do_vfs_ioctl+0x9f/0x610
> [32402.653081] ksys_ioctl+0x70/0x80
> [32402.656393] __x64_sys_ioctl+0x16/0x20
> [32402.660145] do_syscall_64+0x7b/0x200
> [32402.663813] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> [1] https://lore.kernel.org/lkml/20200908152225.086536876@linuxfoundation.org/
> 
> ---
> commit 3a653b205f29b3f9827a01a0c88bfbcb0d169494 upstream.
> 
> The following error ocurred when testing disk online/offline:
> 
> [  301.798344] device-mapper: thin: 253:5: aborting current metadata transaction
> [  301.848441] device-mapper: thin: 253:5: failed to abort metadata transaction
> [  301.849206] Aborting journal on device dm-26-8.
> [  301.850489] EXT4-fs error (device dm-26) in __ext4_new_inode:943: Journal has aborted
> [  301.851095] EXT4-fs (dm-26): Delayed block allocation failed for inode 398742 at logical offset 181 with max blocks 19 with error 30
> [  301.854476] BUG: KASAN: use-after-free in dm_bm_set_read_only+0x3a/0x40 [dm_persistent_data]
> 
> Reason is:
> 
>  metadata_operation_failed
>     abort_transaction
>         dm_pool_abort_metadata
> 	    __create_persistent_data_objects
> 	        r = __open_or_format_metadata
> 	        if (r) --> If failed will free pmd->bm but pmd->bm not set NULL
> 		    dm_block_manager_destroy(pmd->bm);
>     set_pool_mode
> 	dm_pool_metadata_read_only(pool->pmd);
> 	dm_bm_set_read_only(pmd->bm);  --> use-after-free
> 
> Add checks to see if pmd->bm is NULL in dm_bm_set_read_only and
> dm_bm_set_read_write functions.  If bm is NULL it means creating the
> bm failed and so dm_bm_is_read_only must return true.
> 
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: xiejingfeng <xiejingfeng@linux.alibaba.com>
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  drivers/md/dm-thin-metadata.c                 |  2 +-
>  drivers/md/persistent-data/dm-block-manager.c | 14 ++++++++------
>  2 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
> index 85077f4d257a..a6a5cee6b943 100644
> --- a/drivers/md/dm-thin-metadata.c
> +++ b/drivers/md/dm-thin-metadata.c
> @@ -901,7 +901,7 @@ int dm_pool_metadata_close(struct dm_pool_metadata *pmd)
>  		return -EBUSY;
>  	}
>  
> -	if (!dm_bm_is_read_only(pmd->bm) && !pmd->fail_io) {
> +	if (!pmd->fail_io && !dm_bm_is_read_only(pmd->bm)) {
>  		r = __commit_transaction(pmd);
>  		if (r < 0)
>  			DMWARN("%s: __commit_transaction() failed, error = %d",
> diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
> index 492a3f8ac119..0401daa0f7fb 100644
> --- a/drivers/md/persistent-data/dm-block-manager.c
> +++ b/drivers/md/persistent-data/dm-block-manager.c
> @@ -494,7 +494,7 @@ int dm_bm_write_lock(struct dm_block_manager *bm,
>  	void *p;
>  	int r;
>  
> -	if (bm->read_only)
> +	if (dm_bm_is_read_only(bm))
>  		return -EPERM;
>  
>  	p = dm_bufio_read(bm->bufio, b, (struct dm_buffer **) result);
> @@ -563,7 +563,7 @@ int dm_bm_write_lock_zero(struct dm_block_manager *bm,
>  	struct buffer_aux *aux;
>  	void *p;
>  
> -	if (bm->read_only)
> +	if (dm_bm_is_read_only(bm))
>  		return -EPERM;
>  
>  	p = dm_bufio_new(bm->bufio, b, (struct dm_buffer **) result);
> @@ -603,7 +603,7 @@ EXPORT_SYMBOL_GPL(dm_bm_unlock);
>  
>  int dm_bm_flush(struct dm_block_manager *bm)
>  {
> -	if (bm->read_only)
> +	if (dm_bm_is_read_only(bm))
>  		return -EPERM;
>  
>  	return dm_bufio_write_dirty_buffers(bm->bufio);
> @@ -617,19 +617,21 @@ void dm_bm_prefetch(struct dm_block_manager *bm, dm_block_t b)
>  
>  bool dm_bm_is_read_only(struct dm_block_manager *bm)
>  {
> -	return bm->read_only;
> +	return (bm ? bm->read_only : true);
>  }
>  EXPORT_SYMBOL_GPL(dm_bm_is_read_only);
>  
>  void dm_bm_set_read_only(struct dm_block_manager *bm)
>  {
> -	bm->read_only = true;
> +	if (bm)
> +		bm->read_only = true;
>  }
>  EXPORT_SYMBOL_GPL(dm_bm_set_read_only);
>  
>  void dm_bm_set_read_write(struct dm_block_manager *bm)
>  {
> -	bm->read_only = false;
> +	if (bm)
> +		bm->read_only = false;
>  }
>  EXPORT_SYMBOL_GPL(dm_bm_set_read_write);
>  
> 

-- 
Thanks,
Jeffle
