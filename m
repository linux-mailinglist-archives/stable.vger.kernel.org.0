Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299E54855CC
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 16:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241447AbiAEPZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 10:25:09 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37006 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241445AbiAEPZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 10:25:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07C7EB81C13
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 15:25:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB15C36AE0;
        Wed,  5 Jan 2022 15:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641396306;
        bh=7IRCBNKcL49AqRYaI5yKFyEz106szci1ajHNd3Ts1WI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=fmTqMnAnhE9MOQVMZGc6GAWJwWjXK6gBcrGIx41yQkcCHPnRXov3BlnBkRPb2SylN
         ejkqoamBQ9/bhx0/0UlAt5D6prU8gPF1YKkf+Olqh3INdN5V7v7vbs7beX3oXWsaiI
         P/5RU//VTFaaou6jv15Kvoi4rsP5DeW4aPLJAgPEGJfLMKXjiiOhkqb/E5BNtldwT5
         rY6xeVAnVAOF4O8TknBX+WGmNT90q/38MylReFStbNQWnwZr18q/rf68hEf18MhW6L
         iYPNXtgSBBYh4i3IgTIoRRvoDLo+QsqoUQZFz598kLj/oGPUqDT20XuYmTcLLgvdsy
         KvpCJTAWzZ03w==
Message-ID: <1995ce75-68d9-6205-6e8a-ca7c089a93fd@kernel.org>
Date:   Wed, 5 Jan 2022 23:25:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] f2fs: quota: fix potential deadlock
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, jaegeuk@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Yi Zhuang <zhuangyi1@huawei.com>
References: <20220104130513.3077-1-chao@kernel.org>
 <YdRJEBhSg8vlD6cP@kroah.com>
 <53d75d26-2289-a66a-a7fa-62593bad81c8@kernel.org>
 <YdRk8tXZ6PHXKLJV@kroah.com>
 <f07cbfa3-29f8-c671-98cf-45b664000f95@kernel.org>
 <YdWy1I7pFrnV4NTa@kroah.com>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <YdWy1I7pFrnV4NTa@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/1/5 23:01, Greg KH wrote:
> On Tue, Jan 04, 2022 at 11:48:25PM +0800, Chao Yu wrote:
>> On 2022/1/4 23:17, Greg KH wrote:
>>> On Tue, Jan 04, 2022 at 11:05:36PM +0800, Chao Yu wrote:
>>>> On 2022/1/4 21:18, Greg KH wrote:
>>>>> On Tue, Jan 04, 2022 at 09:05:13PM +0800, Chao Yu wrote:
>>>>>> commit a5c0042200b28fff3bde6fa128ddeaef97990f8d upstream.
>>>>>>
>>>>>> As Yi Zhuang reported in bugzilla:
>>>>>>
>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=214299
>>>>>>
>>>>>> There is potential deadlock during quota data flush as below:
>>>>>>
>>>>>> Thread A:			Thread B:
>>>>>> f2fs_dquot_acquire
>>>>>> down_read(&sbi->quota_sem)
>>>>>> 				f2fs_write_checkpoint
>>>>>> 				block_operations
>>>>>> 				f2fs_look_all
>>>>>> 				down_write(&sbi->cp_rwsem)
>>>>>> f2fs_quota_write
>>>>>> f2fs_write_begin
>>>>>> __do_map_lock
>>>>>> f2fs_lock_op
>>>>>> down_read(&sbi->cp_rwsem)
>>>>>> 				__need_flush_qutoa
>>>>>> 				down_write(&sbi->quota_sem)
>>>>>>
>>>>>> This patch changes block_operations() to use trylock, if it fails,
>>>>>> it means there is potential quota data updater, in this condition,
>>>>>> let's flush quota data first and then trylock again to check dirty
>>>>>> status of quota data.
>>>>>>
>>>>>> The side effect is: in heavy race condition (e.g. multi quota data
>>>>>> upaters vs quota data flusher), it may decrease the probability of
>>>>>> synchronizing quota data successfully in checkpoint() due to limited
>>>>>> retry time of quota flush.
>>>>>>
>>>>>> Fixes: db6ec53b7e03 ("f2fs: add a rw_sem to cover quota flag changes")
>>>>>> Cc: stable@vger.kernel.org # v5.3+
>>>>>> Reported-by: Yi Zhuang <zhuangyi1@huawei.com>
>>>>>> Signed-off-by: Chao Yu <chao@kernel.org>
>>>>>> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
>>>>>> ---
>>>>>>     fs/f2fs/checkpoint.c | 3 ++-
>>>>>>     1 file changed, 2 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
>>>>>> index 83e9bc0f91ff..7b0282724231 100644
>>>>>> --- a/fs/f2fs/checkpoint.c
>>>>>> +++ b/fs/f2fs/checkpoint.c
>>>>>> @@ -1162,7 +1162,8 @@ static bool __need_flush_quota(struct f2fs_sb_info *sbi)
>>>>>>     	if (!is_journalled_quota(sbi))
>>>>>>     		return false;
>>>>>> -	down_write(&sbi->quota_sem);
>>>>>> +	if (!down_write_trylock(&sbi->quota_sem))
>>>>>> +		return true;
>>>>>>     	if (is_sbi_flag_set(sbi, SBI_QUOTA_SKIP_FLUSH)) {
>>>>>>     		ret = false;
>>>>>>     	} else if (is_sbi_flag_set(sbi, SBI_QUOTA_NEED_REPAIR)) {
>>>>>> -- 
>>>>>> 2.32.0
>>>>>>
>>>>>
>>>>> What stable tree(s) is this for?
>>>>
>>>> Oh, please help to try applying to 5.4, 5.10, and 5.15 stable trees, thanks!
>>>
>>> This is already in the 5.15.6 kernel release, do you need it applied
>>> there again?  :)
>>
>> Oops, no, so 5.4 and 5.10 is enough. ;)
>> We can skip 5.15 since this patch was merged in 5.15-rc1 at the first time.
> 
> It was merged in 5.16-rc1, and then backported to 5.15.6.  You might
> want to check your git scripts.

Oh, yes, you're right, it looks we merged patches with same title in both 5.15-rc1
and 5.16-rc1, that won't happen usually... so I positioning the wrong merge time
only based on patch title...

https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git/commit/?h=dev&id=a5c0042200b28fff3bde6fa128ddeaef97990f8d

https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git/commit/?h=dev&id=9de71ede81e6d1a111fdd868b2d78d459fa77f80

> 
> Anyway, now queued up, thanks.

Thank you!

Thanks,

> 
> greg k-h
