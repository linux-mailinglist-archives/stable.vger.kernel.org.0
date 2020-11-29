Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CC62C799B
	for <lists+stable@lfdr.de>; Sun, 29 Nov 2020 15:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbgK2Ooq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Nov 2020 09:44:46 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:41896 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725882AbgK2Ooq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Nov 2020 09:44:46 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UGswpZn_1606661010;
Received: from IT-C02W23QPG8WN.local(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UGswpZn_1606661010)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 29 Nov 2020 22:43:31 +0800
Subject: Re: [PATCH] exit: fix a race in release_task when flushing the dentry
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org
References: <20201128064722.9106-1-wenyang@linux.alibaba.com>
 <X8IFADugB450PHp8@kroah.com>
 <24bd714d-f598-c7c6-6821-38fd9c1f4d2b@linux.alibaba.com>
 <X8JZJGG67tE4jngE@kroah.com>
 <b73daaf0-bd6d-5153-9155-ef3a8568a6f2@linux.alibaba.com>
 <X8M6D7M6Rn4f0C9j@kroah.com>
From:   Wen Yang <wenyang@linux.alibaba.com>
Message-ID: <d244281b-54be-369a-727e-4436119cbd1e@linux.alibaba.com>
Date:   Sun, 29 Nov 2020 22:43:30 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <X8M6D7M6Rn4f0C9j@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



在 2020/11/29 下午2:05, Greg Kroah-Hartman 写道:
> On Sat, Nov 28, 2020 at 11:28:53PM +0800, Wen Yang wrote:
>>
>>
>> 在 2020/11/28 下午10:05, Greg Kroah-Hartman 写道:
>>> On Sat, Nov 28, 2020 at 09:59:09PM +0800, Wen Yang wrote:
>>>>
>>>>
>>>> 在 2020/11/28 下午4:06, Greg Kroah-Hartman 写道:
>>>>> On Sat, Nov 28, 2020 at 02:47:22PM +0800, Wen Yang wrote:
>>>>>> [ Upstream commit 7bc3e6e55acf065500a24621f3b313e7e5998acf ]
>>>>>
>>>>> No, that is not this commit at all.
>>>>>
>>>>> What are you wanting to have happen here?
>>>>>
>>>>> confused,
>>>>>
>>>>> greg k-h
>>>>>
>>>>
>>>> Thanks.
>>>> Let's explain it briefly:
>>>>
>>>> The dentries such as /proc/<pid>/ns/ipc have the DCACHE_OP_DELETE flag, they
>>>> should be deleted when the process exits.
>>>> Suppose the following race appears：
>>>>
>>>> release_task                dput
>>>> -> proc_flush_task
>>>>                               ->  dentry->d_op->d_delete(dentry)
>>>> -> __exit_signal
>>>>                               -> dentry->d_lockref.count--  and return.
>>>>
>>>>
>>>> In the proc_flush_task function, because another processe is using this
>>>> dentry, it cannot be deleted;
>>>> In the dput function, d_delete may be executed before __exit_signal (the pid
>>>> has not been unhashed), so that d_delete returns false and the dentry can
>>>> not be deleted.
>>>>
>>>> So this dentry is still caches (count is 0), and its parent dentries are
>>>> also caches, and those dentries can only be deleted when drop_caches is
>>>> manually triggered.
>>>>
>>>>
>>>> In the release_task function, we should move proc_flush_task after the
>>>> tasklist_lock is released（Just like the commit
>>>> 7bc3e6e55acf065500a24621f3b313e7e5998acf did).
>>>
>>> I do not understand, is this a patch being submitted for the main kernel
>>> tree, or for a stable kernel release?
>>>
>>> If stable, please read:
>>>       https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>>> for how to do this properly.
>>>
>>> If main kernel tree, you can't have the "Upstream commit" line in the
>>> changelog text as that makes no sense at all.
>>
>>
>> Hi,
>> This patch is submitted to the stable branches (from 4.9.y
>> to 5.6.y).
>>
>> This problem can also be solved if the following patch could be ported to
>> the stable branch:
>> 7bc3e6e55acf ("proc: Use a list of inodes to flush from proc")
>> 26dbc60f385f ("proc: Generalize proc_sys_prune_dcache into
>> proc_prune_siblings_dcache")
>> f90f3cafe8d5 ("proc: Use d_invalidate in proc_prune_siblings_dcache")
>>
>> However, the above-mentioned patches modify too much code (more than 100
>> lines), and there may also be some undiscovered bugs.
>>
>> So the safer method may be to apply this small patch（also ported from the
>> equivalent fix already exist in Linus’ tree）.
>>
>> We will reformat the patch later.
> 
> We always prefer to take the original, upstream patches, instead of
> one-off changes as almost always, those one-off changes end up being
> wrong and hard to work with over time.
> 
> So if we need more than one patch to solve this reported problem, that's
> fine, can you test the above series of patches and provide a backported
> set of them that we can use for this?
> 

Ok, we will follow your suggestions.
Thanks.

--
Best wishes,
Wen

