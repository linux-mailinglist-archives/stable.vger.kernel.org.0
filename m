Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E7748452B
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 16:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiADPsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 10:48:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46220 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiADPsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 10:48:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AADADB816F9
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 15:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDABCC36AED;
        Tue,  4 Jan 2022 15:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641311309;
        bh=JhpOCub1C8JKAe8Xx/XjYFctuvGH7dqRVs206RpUSeM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=AVqgS7EOB/Nu/S776pX8sLCCKM2DqBOroODt8HwZxIdMqJE5AXK31TMny8rdEmCNR
         /JD8lA9A3NHzkxpMLAw0GQ05aikZgfuJI0Fg9Vwi6ivp9D+bccqKX7+LDXb8XF3Wgk
         qH+mgooNs3fWKvCAgGxgpJd2vYpyWoUXCpjG5ttQjp+EOe2ew4V3Qf1KeO2eTzU+m/
         w06k39GkeUcNTcHIcRBsdVrMghg5DrmcaTi6iT7T0OFc1fTbWH1frhKmnBxd/LTV11
         KUY01e7qU8+xmAZa4hUTuo9ZGZ2bw5Ii6Y487MBT59X6uJpj1yw81/QeFL/A4CzYZI
         B+J3FgAWVmIDA==
Message-ID: <f07cbfa3-29f8-c671-98cf-45b664000f95@kernel.org>
Date:   Tue, 4 Jan 2022 23:48:25 +0800
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
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <YdRk8tXZ6PHXKLJV@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/1/4 23:17, Greg KH wrote:
> On Tue, Jan 04, 2022 at 11:05:36PM +0800, Chao Yu wrote:
>> On 2022/1/4 21:18, Greg KH wrote:
>>> On Tue, Jan 04, 2022 at 09:05:13PM +0800, Chao Yu wrote:
>>>> commit a5c0042200b28fff3bde6fa128ddeaef97990f8d upstream.
>>>>
>>>> As Yi Zhuang reported in bugzilla:
>>>>
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=214299
>>>>
>>>> There is potential deadlock during quota data flush as below:
>>>>
>>>> Thread A:			Thread B:
>>>> f2fs_dquot_acquire
>>>> down_read(&sbi->quota_sem)
>>>> 				f2fs_write_checkpoint
>>>> 				block_operations
>>>> 				f2fs_look_all
>>>> 				down_write(&sbi->cp_rwsem)
>>>> f2fs_quota_write
>>>> f2fs_write_begin
>>>> __do_map_lock
>>>> f2fs_lock_op
>>>> down_read(&sbi->cp_rwsem)
>>>> 				__need_flush_qutoa
>>>> 				down_write(&sbi->quota_sem)
>>>>
>>>> This patch changes block_operations() to use trylock, if it fails,
>>>> it means there is potential quota data updater, in this condition,
>>>> let's flush quota data first and then trylock again to check dirty
>>>> status of quota data.
>>>>
>>>> The side effect is: in heavy race condition (e.g. multi quota data
>>>> upaters vs quota data flusher), it may decrease the probability of
>>>> synchronizing quota data successfully in checkpoint() due to limited
>>>> retry time of quota flush.
>>>>
>>>> Fixes: db6ec53b7e03 ("f2fs: add a rw_sem to cover quota flag changes")
>>>> Cc: stable@vger.kernel.org # v5.3+
>>>> Reported-by: Yi Zhuang <zhuangyi1@huawei.com>
>>>> Signed-off-by: Chao Yu <chao@kernel.org>
>>>> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
>>>> ---
>>>>    fs/f2fs/checkpoint.c | 3 ++-
>>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
>>>> index 83e9bc0f91ff..7b0282724231 100644
>>>> --- a/fs/f2fs/checkpoint.c
>>>> +++ b/fs/f2fs/checkpoint.c
>>>> @@ -1162,7 +1162,8 @@ static bool __need_flush_quota(struct f2fs_sb_info *sbi)
>>>>    	if (!is_journalled_quota(sbi))
>>>>    		return false;
>>>> -	down_write(&sbi->quota_sem);
>>>> +	if (!down_write_trylock(&sbi->quota_sem))
>>>> +		return true;
>>>>    	if (is_sbi_flag_set(sbi, SBI_QUOTA_SKIP_FLUSH)) {
>>>>    		ret = false;
>>>>    	} else if (is_sbi_flag_set(sbi, SBI_QUOTA_NEED_REPAIR)) {
>>>> -- 
>>>> 2.32.0
>>>>
>>>
>>> What stable tree(s) is this for?
>>
>> Oh, please help to try applying to 5.4, 5.10, and 5.15 stable trees, thanks!
> 
> This is already in the 5.15.6 kernel release, do you need it applied
> there again?  :)

Oops, no, so 5.4 and 5.10 is enough. ;)
We can skip 5.15 since this patch was merged in 5.15-rc1 at the first time.

> 
>> Let me know if I should send patches for different trees separately.
> 
> If the same commit here works for all of the above, it's fine.  But for
> some reason I don't think it will work in 5.15.y...

Copied.

Thank you for the help!

Thanks,

> 
> thanks,
> 
> greg k-h
