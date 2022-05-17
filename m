Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0CC5529939
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 08:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbiEQGBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 02:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbiEQGBU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 02:01:20 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C09B7E8;
        Mon, 16 May 2022 23:01:18 -0700 (PDT)
Received: from dggpeml500020.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4L2QT86wC9zhZG4;
        Tue, 17 May 2022 14:00:28 +0800 (CST)
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500020.china.huawei.com (7.185.36.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 17 May 2022 14:01:16 +0800
Message-ID: <297c1735-fb99-57be-addb-2bad7ef94bf1@huawei.com>
Date:   Tue, 17 May 2022 14:01:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v3] ext4: fix race condition between ext4_write and
 ext4_convert_inline_data
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.cz>,
        <linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>,
        <yebin10@huawei.com>, <yukuai3@huawei.com>,
        <stable@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>,
        Baokun Li <libaokun1@huawei.com>
References: <20220428134031.4153381-1-libaokun1@huawei.com>
From:   "libaokun (A)" <libaokun1@huawei.com>
In-Reply-To: <20220428134031.4153381-1-libaokun1@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.174]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ping.

在 2022/4/28 21:40, Baokun Li 写道:
> Hulk Robot reported a BUG_ON:
>   ==================================================================
>   EXT4-fs error (device loop3): ext4_mb_generate_buddy:805: group 0,
>   block bitmap and bg descriptor inconsistent: 25 vs 31513 free clusters
>   kernel BUG at fs/ext4/ext4_jbd2.c:53!
>   invalid opcode: 0000 [#1] SMP KASAN PTI
>   CPU: 0 PID: 25371 Comm: syz-executor.3 Not tainted 5.10.0+ #1
>   RIP: 0010:ext4_put_nojournal fs/ext4/ext4_jbd2.c:53 [inline]
>   RIP: 0010:__ext4_journal_stop+0x10e/0x110 fs/ext4/ext4_jbd2.c:116
>   [...]
>   Call Trace:
>    ext4_write_inline_data_end+0x59a/0x730 fs/ext4/inline.c:795
>    generic_perform_write+0x279/0x3c0 mm/filemap.c:3344
>    ext4_buffered_write_iter+0x2e3/0x3d0 fs/ext4/file.c:270
>    ext4_file_write_iter+0x30a/0x11c0 fs/ext4/file.c:520
>    do_iter_readv_writev+0x339/0x3c0 fs/read_write.c:732
>    do_iter_write+0x107/0x430 fs/read_write.c:861
>    vfs_writev fs/read_write.c:934 [inline]
>    do_pwritev+0x1e5/0x380 fs/read_write.c:1031
>   [...]
>   ==================================================================
>
> Above issue may happen as follows:
>             cpu1                     cpu2
> __________________________|__________________________
> do_pwritev
>   vfs_writev
>    do_iter_write
>     ext4_file_write_iter
>      ext4_buffered_write_iter
>       generic_perform_write
>        ext4_da_write_begin
>                             vfs_fallocate
>                              ext4_fallocate
>                               ext4_convert_inline_data
>                                ext4_convert_inline_data_nolock
>                                 ext4_destroy_inline_data_nolock
>                                  clear EXT4_STATE_MAY_INLINE_DATA
>                                 ext4_map_blocks
>                                  ext4_ext_map_blocks
>                                   ext4_mb_new_blocks
>                                    ext4_mb_regular_allocator
>                                     ext4_mb_good_group_nolock
>                                      ext4_mb_init_group
>                                       ext4_mb_init_cache
>                                        ext4_mb_generate_buddy  --> error
>         ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)
>                                  ext4_restore_inline_data
>                                   set EXT4_STATE_MAY_INLINE_DATA
>         ext4_block_write_begin
>        ext4_da_write_end
>         ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)
>         ext4_write_inline_data_end
>          handle=NULL
>          ext4_journal_stop(handle)
>           __ext4_journal_stop
>            ext4_put_nojournal(handle)
>             ref_cnt = (unsigned long)handle
>             BUG_ON(ref_cnt == 0)  ---> BUG_ON
>
> The lock held by ext4_convert_inline_data is xattr_sem, but the lock
> held by generic_perform_write is i_rwsem. Therefore, the two locks can
> be concurrent.
>
> To solve above issue, we add inode_lock() for ext4_convert_inline_data().
> At the same time, move ext4_convert_inline_data() in front of
> ext4_punch_hole(), remove similar handling from ext4_punch_hole().
>
> Fixes: 0c8d414f163f ("ext4: let fallocate handle inline data correctly")
> Cc: stable@vger.kernel.org
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> ---
> V1->V2:
> 	Increase the range of the inode_lock.
> V2->V3:
> 	Move the lock outside the ext4_convert_inline_data().
> 	And reorganize ext4_fallocate().
>
>   fs/ext4/extents.c | 10 ++++++----
>   fs/ext4/inode.c   |  9 ---------
>   2 files changed, 6 insertions(+), 13 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index e473fde6b64b..474479ce76e0 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4693,15 +4693,17 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>   		     FALLOC_FL_INSERT_RANGE))
>   		return -EOPNOTSUPP;
>   
> +	inode_lock(inode);
> +	ret = ext4_convert_inline_data(inode);
> +	inode_unlock(inode);
> +	if (ret)
> +		goto exit;
> +
>   	if (mode & FALLOC_FL_PUNCH_HOLE) {
>   		ret = ext4_punch_hole(file, offset, len);
>   		goto exit;
>   	}
>   
> -	ret = ext4_convert_inline_data(inode);
> -	if (ret)
> -		goto exit;
> -
>   	if (mode & FALLOC_FL_COLLAPSE_RANGE) {
>   		ret = ext4_collapse_range(file, offset, len);
>   		goto exit;
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 646ece9b3455..4779673d733e 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3967,15 +3967,6 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
>   
>   	trace_ext4_punch_hole(inode, offset, length, 0);
>   
> -	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
> -	if (ext4_has_inline_data(inode)) {
> -		filemap_invalidate_lock(mapping);
> -		ret = ext4_convert_inline_data(inode);
> -		filemap_invalidate_unlock(mapping);
> -		if (ret)
> -			return ret;
> -	}
> -
>   	/*
>   	 * Write out all dirty pages to avoid race conditions
>   	 * Then release them.


