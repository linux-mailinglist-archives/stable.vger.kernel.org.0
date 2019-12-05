Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA6AA113966
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 02:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfLEBlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 20:41:50 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7635 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728098AbfLEBlu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 20:41:50 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 48486CF4FF2D5B678D2E;
        Thu,  5 Dec 2019 09:41:47 +0800 (CST)
Received: from [127.0.0.1] (10.173.220.96) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 5 Dec 2019
 09:41:39 +0800
Subject: Re: [4.19.y PATCH] tmpfs: fix unable to remount nr_inodes from
 limited to unlimited
To:     Hugh Dickins <hughd@google.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
        <yi.zhang@huawei.com>, <zhengbin13@huawei.com>,
        <houtao1@huawei.com>
References: <20191204131137.10388-1-yukuai3@huawei.com>
 <20191204173334.GB3630950@kroah.com>
 <alpine.LSU.2.11.1912041142060.1591@eggly.anvils>
From:   "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <264fe57a-5b6b-cade-f31f-bb4861668d18@huawei.com>
Date:   Thu, 5 Dec 2019 09:41:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.11.1912041142060.1591@eggly.anvils>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.220.96]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2019/12/5 4:13, Hugh Dickins wrote:
> On Wed, 4 Dec 2019, Greg KH wrote:
>> On Wed, Dec 04, 2019 at 09:11:37PM +0800, yu kuai wrote:
>>> tmpfs support 'size', 'nr_blocks' and 'nr_inodes' mount options. mount or
>>> remount them to zero means unlimited. 'size' and 'br_blocks' can remount
>>> from limited to unlimited, while 'nr_inodes' can't.
>>>
>>> The problem is fixed since upstream commit 0b5071dd323d ("
>>> shmem_parse_options(): use a separate structure to keep the results"). But
>>> in order to backport it, the amount of related patches need to backport is
>>> huge.
>>>
>>> So, I made some local changes to fix the problem.
>>>
>>> Signed-off-by: yu kuai <yukuai3@huawei.com>
>>> ---
>>>   mm/shmem.c | 7 +++++--
>>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index 3c8742655756..966fc69ee8fb 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -3444,7 +3444,7 @@ static int shmem_remount_fs(struct super_block *sb, int *flags, char *data)
>>>   	inodes = sbinfo->max_inodes - sbinfo->free_inodes;
>>>   	if (percpu_counter_compare(&sbinfo->used_blocks, config.max_blocks) > 0)
>>>   		goto out;
>>> -	if (config.max_inodes < inodes)
>>> +	if (config.max_inodes && config.max_inodes < inodes)
>>>   		goto out;
>>>   	/*
>>>   	 * Those tests disallow limited->unlimited while any are in use;
>>> @@ -3460,7 +3460,10 @@ static int shmem_remount_fs(struct super_block *sb, int *flags, char *data)
>>>   	sbinfo->huge = config.huge;
>>>   	sbinfo->max_blocks  = config.max_blocks;
>>>   	sbinfo->max_inodes  = config.max_inodes;
>>> -	sbinfo->free_inodes = config.max_inodes - inodes;
>>> +	if (!config.max_inodes)
>>> +		sbinfo->free_inodes = 0;
>>> +	else
>>> +		sbinfo->free_inodes = config.max_inodes - inodes;
>>>   
>>>   	/*
>>>   	 * Preserve previous mempolicy unless mpol remount option was specified.
>>> -- 
>>> 2.17.2
>>>
>>
>> Hm, sorry about my bot, this looked like an odd one-off patch.
>>
>> What about 5.3.y, should this patch also go there as well?
>>
>> But is it really an issue as this is a new "feature" that 5.4 now has,
>> can't you just use 5.4.y if you need this type of thing?  It's never
>> worked in the past, right?
> 
> Yes, please ignore this for stable, Greg: it appears to be a new feature
> in 5.4: one that I should have noticed when testing, but failed to do so
> (and it may even be something that I foisted unthinkingly on Al when
> suggesting mods to his and David's originals).
> 
> Yu Kuai: many thanks for noticing and reporting this, I was unconscious
> of changing behavior here.  Notice how the 5.4 shmem_reconfigure() still
> has a comment above it saying "we disallow change from limited->unlimited
> blocks/inodes while any are in use" - and root inode is always in use.
> Notice how your 4.19 patch does nothing for max_blocks, so remounting
> with nr_blocks=0 will still fail, once a non-empty file has been created.
Thank you for your response, I missed that in my test.
> 
> I agree that it's not obvious why limited->unlimited needs to fail,
> and perhaps a nice (worthwhile?) little enhancement to allow that;
> but it was unintentional, and now (but not today) I have to go back
> to remind myself why 2.6.13 implemented it with that restriction,
> and whether there are any fixes needed to the new behavior in 5.4
> (at the least, we ought to fix that comment in 5.5).

I was confused about the comment in 5.5: "we disallow change from 
limited->unlimited blocks/inodes while any are in use", it seems change 
from limited to unlimited will always succed. Maybe this is
more appropriate: "Note that we allow change from limited to unlimited 
blocks/inodes. But we disallow change from unlimited->limited, because 
in that case we have no record of how much is already in use. And we 
disallow change blocks/inodes to less than the amount that is aready in use"

Thanks
Yu Kuai

