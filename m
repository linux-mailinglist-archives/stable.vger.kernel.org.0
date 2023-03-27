Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83076CA233
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 13:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbjC0LMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 07:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjC0LMA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 07:12:00 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A1010D0;
        Mon, 27 Mar 2023 04:11:58 -0700 (PDT)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4PlVRv3jqJz17KJF;
        Mon, 27 Mar 2023 19:08:43 +0800 (CST)
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 27 Mar 2023 19:11:55 +0800
Message-ID: <7144edc4-b771-7c92-5ec3-ac78a123d37c@huawei.com>
Date:   Mon, 27 Mar 2023 19:11:55 +0800
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
 <269d37fd-d3f2-d059-b71f-acaea2e7ce4b@huawei.com>
 <20230327093553.up7dhoyqe4ecpn7y@quack3>
From:   Baokun Li <libaokun1@huawei.com>
In-Reply-To: <20230327093553.up7dhoyqe4ecpn7y@quack3>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.174]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500021.china.huawei.com (7.185.36.21)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023/3/27 17:35, Jan Kara wrote:
> On Thu 23-03-23 22:18:53, Baokun Li wrote:
>> On 2023/3/23 19:44, Jan Kara wrote:
>>>> ---
>>>>    fs/ext4/ext4.h      |  3 ++-
>>>>    fs/ext4/ext4_jbd2.h |  9 +++++----
>>>>    fs/ext4/super.c     | 14 ++++++++++++++
>>>>    3 files changed, 21 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>>>> index 08b29c289da4..f60967fa648f 100644
>>>> --- a/fs/ext4/ext4.h
>>>> +++ b/fs/ext4/ext4.h
>>>> @@ -1703,7 +1703,8 @@ struct ext4_sb_info {
>>>>    	/*
>>>>    	 * Barrier between writepages ops and changing any inode's JOURNAL_DATA
>>>> -	 * or EXTENTS flag.
>>>> +	 * or EXTENTS flag or between changing SHOULD_DIOREAD_NOLOCK flag on
>>>> +	 * remount and writepages ops.
>>>>    	 */
>>>>    	struct percpu_rw_semaphore s_writepages_rwsem;
>>>>    	struct dax_device *s_daxdev;
>>>> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
>>>> index 0c77697d5e90..d82bfcdd56e5 100644
>>>> --- a/fs/ext4/ext4_jbd2.h
>>>> +++ b/fs/ext4/ext4_jbd2.h
>>>> @@ -488,6 +488,9 @@ static inline int ext4_free_data_revoke_credits(struct inode *inode, int blocks)
>>>>    	return blocks + 2*(EXT4_SB(inode->i_sb)->s_cluster_ratio - 1);
>>>>    }
>>>> +/* delalloc is a temporary fix to prevent generic/422 test failures*/
>>>> +#define EXT4_MOUNT_SHOULD_DIOREAD_NOLOCK (EXT4_MOUNT_DIOREAD_NOLOCK | \
>>>> +					  EXT4_MOUNT_DELALLOC)
>>>>    /*
>>>>     * This function controls whether or not we should try to go down the
>>>>     * dioread_nolock code paths, which makes it safe to avoid taking
>>>> @@ -499,7 +502,8 @@ static inline int ext4_free_data_revoke_credits(struct inode *inode, int blocks)
>>>>     */
>>>>    static inline int ext4_should_dioread_nolock(struct inode *inode)
>>>>    {
>>>> -	if (!test_opt(inode->i_sb, DIOREAD_NOLOCK))
>>>> +	if (test_opt(inode->i_sb, SHOULD_DIOREAD_NOLOCK) !=
>>>> +	    EXT4_MOUNT_SHOULD_DIOREAD_NOLOCK)
>>>>    		return 0;
>>>>    	if (!S_ISREG(inode->i_mode))
>>>>    		return 0;
>>>> @@ -507,9 +511,6 @@ static inline int ext4_should_dioread_nolock(struct inode *inode)
>>>>    		return 0;
>>>>    	if (ext4_should_journal_data(inode))
>>>>    		return 0;
>>>> -	/* temporary fix to prevent generic/422 test failures */
>>>> -	if (!test_opt(inode->i_sb, DELALLOC))
>>>> -		return 0;
>>>>    	return 1;
>>>>    }
>>> Is there a need for this SHOULD_DIOREAD_NOLOCK? When called from writeback
>>> we will be protected by s_writepages_rwsem anyway. When called from other
>>> places, we either decide to do dioread_nolock or don't but the situation
>>> can change at any instant so I don't see how unifying this check would
>>> help. And the new SHOULD_DIOREAD_NOLOCK somewhat obfuscates what's going
>>> on.
>> We're thinking that the mount-related flags in
>> ext4_should_dioread_nolock() might be modified, such as DELALLOC being
>> removed because generic/422 test failures were fixed in some other way,
>> resulting in some unnecessary locking during remount, or for whatever
>> reason a mount-related flag was added to ext4_should_dioread_nolock(),
>> and we didn't make a synchronization change in __ext4_remount() that
>> would cause the problem to recur.  So we added this flag to this function
>> (instead of in ext4.h), so that when we change the mount option in
>> ext4_should_dioread_nolock(), we directly change this flag, and we don't
>> have to consider making synchronization changes in __ext4_remount().
>>
>> We have checked where this function is called and there are two types of
>> calls to this function:
>> 1. One category is ext4_do_writepages() and mpage_map_one_extent(), which
>> are protected by s_writepages_rwsem, the location of the problem;
>> 2. The other type is in ext4_page_mkwrite(),
>> ext4_convert_inline_data_to_extent(), ext4_write_begin() to determine
>> whether to get the block using ext4_get_block_unwritten() or
>> ext4_get_block().
>>
>>      1) If we just started fetching written blocks, it looks like there is no
>> problem;
>>      2) If we start getting unwritten blocks, when DIOREAD_NOLOCK is cleared
>> by remount,
>>          we will convert the blocks to written in ext4_map_blocks(). The
>> data=ordered mode ensures that we don't see stale data.
> Yes. So do you agree that EXT4_MOUNT_SHOULD_DIOREAD_NOLOCK is not really
> needed?
>
> 								Honza
Yes, I totally agree!
If we unconditionally grabbed s_writepages_rwsem when remounting,
there would be no mount option synchronization problem, and the flag
would be completely unnecessary.

I will send a patch V2 with the changes suggested by you.
-- 
With Best Regards,
Baokun Li
.
