Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E2C6C6A99
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 15:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjCWOTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 10:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbjCWOTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 10:19:00 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD96E18A;
        Thu, 23 Mar 2023 07:18:56 -0700 (PDT)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Pj6pW6xL6zLPXT;
        Thu, 23 Mar 2023 22:16:35 +0800 (CST)
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 22:18:53 +0800
Message-ID: <269d37fd-d3f2-d059-b71f-acaea2e7ce4b@huawei.com>
Date:   Thu, 23 Mar 2023 22:18:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH 3/3] ext4: fix race between writepages and remount
Content-Language: en-US
To:     Jan Kara <jack@suse.cz>
CC:     <linux-ext4@vger.kernel.org>, <tytso@mit.edu>,
        <adilger.kernel@dilger.ca>, <ritesh.list@gmail.com>,
        <linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>,
        <yangerkun@huawei.com>, <yukuai3@huawei.com>,
        <stable@vger.kernel.org>, Baokun Li <libaokun1@huawei.com>
References: <20230316112832.2711783-1-libaokun1@huawei.com>
 <20230316112832.2711783-4-libaokun1@huawei.com>
 <20230323114407.xenntblzv4ewfqkk@quack3>
From:   Baokun Li <libaokun1@huawei.com>
In-Reply-To: <20230323114407.xenntblzv4ewfqkk@quack3>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.174]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500021.china.huawei.com (7.185.36.21)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023/3/23 19:44, Jan Kara wrote:
> On Thu 16-03-23 19:28:32, Baokun Li wrote:
>> Above issue may happen as follows:
>>             cpu1                           cpu2
>> ______________________________|_____________________________
>> mount -o dioread_lock
>> ext4_writepages
>>   ext4_do_writepages
>>    *if (ext4_should_dioread_nolock(inode))*
>>      // rsv_blocks is not assigned here
>>                                   mount -o remount,dioread_nolock
>>    ext4_journal_start_with_reserve
>>     __ext4_journal_start
>>      __ext4_journal_start_sb
>>       jbd2__journal_start
>>        *if (rsv_blocks)*
>>          // h_rsv_handle is not initialized here
>>    mpage_map_and_submit_extent
>>      mpage_map_one_extent
>>        dioread_nolock = ext4_should_dioread_nolock(inode)
>>        if (dioread_nolock && (map->m_flags & EXT4_MAP_UNWRITTEN))
>>          mpd->io_submit.io_end->handle = handle->h_rsv_handle
>>          ext4_set_io_unwritten_flag
>>            io_end->flag |= EXT4_IO_END_UNWRITTEN
>>        // now io_end->handle is NULL but has EXT4_IO_END_UNWRITTEN flag
>>
>> scsi_finish_command
>>   scsi_io_completion
>>    scsi_io_completion_action
>>     scsi_end_request
>>      blk_update_request
>>       req_bio_endio
>>        bio_endio
>>         bio->bi_end_io  > ext4_end_bio
>>          ext4_put_io_end_defer
>> 	 ext4_add_complete_io
>> 	  // trigger WARN_ON(!io_end->handle && sbi->s_journal);
>>
>> The immediate cause of this problem is that ext4_should_dioread_nolock()
>> function returns inconsistent values in the ext4_do_writepages() and
>> mpage_map_one_extent(). There are four conditions in this function that
>> can be changed at mount time to cause this problem. These four conditions
>> can be divided into two categories:
>>      (1) journal_data and EXT4_EXTENTS_FL, which can be changed by ioctl
>>      (2) DELALLOC and DIOREAD_NOLOCK, which can be changed by remount
>> The two in the first category have been fixed by commit c8585c6fcaf2
>> ("ext4: fix races between changing inode journal mode and ext4_writepages")
>> and commit cb85f4d23f79 ("ext4: fix race between writepages and enabling
>> EXT4_EXTENTS_FL") respectively.
>> Two cases in the other category have not yet been fixed, and the above
>> issue is caused by this situation. We refer to the fix for the first
>> category, When DELALLOC or DIOREAD_NOLOCK is detected to be changed
>> during remount, we hold the s_writepages_rwsem lock to avoid racing with
>> ext4_writepages to trigger the problem.
>> Moreover, we add an EXT4_MOUNT_SHOULD_DIOREAD_NOLOCK macro to ensure that
>> the mount options used by ext4_should_dioread_nolock() and __ext4_remount()
>> are always consistent.
>>
>> Fixes: 6b523df4fb5a ("ext4: use transaction reservation for extent conversion in ext4_end_io")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Nice catch! One comment below:
Thank you very much for your review!
>> ---
>>   fs/ext4/ext4.h      |  3 ++-
>>   fs/ext4/ext4_jbd2.h |  9 +++++----
>>   fs/ext4/super.c     | 14 ++++++++++++++
>>   3 files changed, 21 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 08b29c289da4..f60967fa648f 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -1703,7 +1703,8 @@ struct ext4_sb_info {
>>   
>>   	/*
>>   	 * Barrier between writepages ops and changing any inode's JOURNAL_DATA
>> -	 * or EXTENTS flag.
>> +	 * or EXTENTS flag or between changing SHOULD_DIOREAD_NOLOCK flag on
>> +	 * remount and writepages ops.
>>   	 */
>>   	struct percpu_rw_semaphore s_writepages_rwsem;
>>   	struct dax_device *s_daxdev;
>> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
>> index 0c77697d5e90..d82bfcdd56e5 100644
>> --- a/fs/ext4/ext4_jbd2.h
>> +++ b/fs/ext4/ext4_jbd2.h
>> @@ -488,6 +488,9 @@ static inline int ext4_free_data_revoke_credits(struct inode *inode, int blocks)
>>   	return blocks + 2*(EXT4_SB(inode->i_sb)->s_cluster_ratio - 1);
>>   }
>>   
>> +/* delalloc is a temporary fix to prevent generic/422 test failures*/
>> +#define EXT4_MOUNT_SHOULD_DIOREAD_NOLOCK (EXT4_MOUNT_DIOREAD_NOLOCK | \
>> +					  EXT4_MOUNT_DELALLOC)
>>   /*
>>    * This function controls whether or not we should try to go down the
>>    * dioread_nolock code paths, which makes it safe to avoid taking
>> @@ -499,7 +502,8 @@ static inline int ext4_free_data_revoke_credits(struct inode *inode, int blocks)
>>    */
>>   static inline int ext4_should_dioread_nolock(struct inode *inode)
>>   {
>> -	if (!test_opt(inode->i_sb, DIOREAD_NOLOCK))
>> +	if (test_opt(inode->i_sb, SHOULD_DIOREAD_NOLOCK) !=
>> +	    EXT4_MOUNT_SHOULD_DIOREAD_NOLOCK)
>>   		return 0;
>>   	if (!S_ISREG(inode->i_mode))
>>   		return 0;
>> @@ -507,9 +511,6 @@ static inline int ext4_should_dioread_nolock(struct inode *inode)
>>   		return 0;
>>   	if (ext4_should_journal_data(inode))
>>   		return 0;
>> -	/* temporary fix to prevent generic/422 test failures */
>> -	if (!test_opt(inode->i_sb, DELALLOC))
>> -		return 0;
>>   	return 1;
>>   }
> Is there a need for this SHOULD_DIOREAD_NOLOCK? When called from writeback
> we will be protected by s_writepages_rwsem anyway. When called from other
> places, we either decide to do dioread_nolock or don't but the situation
> can change at any instant so I don't see how unifying this check would
> help. And the new SHOULD_DIOREAD_NOLOCK somewhat obfuscates what's going
> on.
We're thinking that the mount-related flags in 
ext4_should_dioread_nolock() might
be modified, such as DELALLOC being removed because generic/422 test 
failures
were fixed in some other way, resulting in some unnecessary locking 
during remount,
or for whatever reason a mount-related flag was added to 
ext4_should_dioread_nolock(),
and we didn't make a synchronization change in __ext4_remount() that 
would cause
the problem to recur.  So we added this flag to this function (instead 
of in ext4.h), so that
when we change the mount option in ext4_should_dioread_nolock(), we 
directly change
this flag, and we don't have to consider making synchronization changes 
in __ext4_remount().

We have checked where this function is called and there are two types of 
calls to this function:
1. One category is ext4_do_writepages() and mpage_map_one_extent(), 
which are protected
     by s_writepages_rwsem, the location of the problem;
2. The other type is in ext4_page_mkwrite(), 
ext4_convert_inline_data_to_extent(),ext4_write_begin()
     to determine whether to get the block using 
ext4_get_block_unwritten() or ext4_get_ block().
     1) If we just started fetching written blocks, it looks like there 
is no problem;
     2) If we start getting unwritten blocks, when DIOREAD_NOLOCK is 
cleared by remount,
         we will convert the blocks to written in ext4_map_blocks(). The 
data=ordered mode
         ensures that we don't see stale data.
>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index fefcd42f34ea..bdf6b288aeff 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -6403,8 +6403,22 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
>>   
>>   	}
>>   
>> +	/* Get the flag we really need to set/clear. */
>> +	ctx->mask_s_mount_opt &= sbi->s_mount_opt;
>> +	ctx->vals_s_mount_opt &= ~sbi->s_mount_opt;
>> +
>> +	/*
>> +	 * If EXT4_MOUNT_SHOULD_DIOREAD_NOLOCK change on remount, we need
>> +	 * to hold s_writepages_rwsem to avoid racing with writepages ops.
>> +	 */
>> +	if (ctx_changed_mount_opt(ctx, EXT4_MOUNT_SHOULD_DIOREAD_NOLOCK))
>> +		percpu_down_write(&sbi->s_writepages_rwsem);
>> +
> Honestly, I'd be inclined to grab s_writepages_rwsem unconditionally during
> remount. Remount is not a fast path operation and waiting for writepages
> isn't too bad. Also it's easier for testing :).
>
> 								Honza
Initially I was concerned that adding this lock to remount would cause 
users to
wait too long when remounting, so I added the lock only when the **actual**
mount flags being modified **contained** DIOREAD_NOLOCK or DELALLOC.

But now that I think about it, if there is no better way to do it, it 
seems to be
acceptable to add the lock unconditionally, so that the code looks cleaner.

Thanks again!
Any comments are welcome!
-- 
With Best Regards,
Baokun Li
.
