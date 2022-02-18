Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0D34BAF25
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 02:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbiBRB2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 20:28:10 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:36370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbiBRB2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 20:28:09 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7887C2BB09;
        Thu, 17 Feb 2022 17:27:52 -0800 (PST)
Received: from dggpeml500020.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4K0DYH5GNrz9sm9;
        Fri, 18 Feb 2022 09:26:11 +0800 (CST)
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500020.china.huawei.com (7.185.36.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Feb 2022 09:27:50 +0800
Subject: Re: [PATCH 5.10] fget: clarify and improve __fget_files()
 implementation
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <oliver.sang@intel.com>, <beibei.si@intel.com>, <jannh@google.com>,
        <mszeredi@redhat.com>, <torvalds@linux-foundation.org>,
        <yukuai3@huawei.com>, Baokun Li <libaokun1@huawei.com>
References: <20220215065107.3045023-1-libaokun1@huawei.com>
 <Yg6aLQCR3zxn5XoW@kroah.com>
From:   "libaokun (A)" <libaokun1@huawei.com>
Message-ID: <f39e907b-203b-ded4-e0e5-0d89cd7eb3f6@huawei.com>
Date:   Fri, 18 Feb 2022 09:27:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <Yg6aLQCR3zxn5XoW@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.174]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

在 2022/2/18 2:55, Greg KH 写道:
> On Tue, Feb 15, 2022 at 02:51:07PM +0800, Baokun Li wrote:
>> From: Linus Torvalds <torvalds@linux-foundation.org>
>>
>> commit e386dfc56f837da66d00a078e5314bc8382fab83 upstream.
>>
>> Commit 054aa8d439b9 ("fget: check that the fd still exists after getting
>> a ref to it") fixed a race with getting a reference to a file just as it
>> was being closed.  It was a fairly minimal patch, and I didn't think
>> re-checking the file pointer lookup would be a measurable overhead,
>> since it was all right there and cached.
>>
>> But I was wrong, as pointed out by the kernel test robot.
>>
>> The 'poll2' case of the will-it-scale.per_thread_ops benchmark regressed
>> quite noticeably.  Admittedly it seems to be a very artificial test:
>> doing "poll()" system calls on regular files in a very tight loop in
>> multiple threads.
>>
>> That means that basically all the time is spent just looking up file
>> descriptors without ever doing anything useful with them (not that doing
>> 'poll()' on a regular file is useful to begin with).  And as a result it
>> shows the extra "re-check fd" cost as a sore thumb.
>>
>> Happily, the regression is fixable by just writing the code to loook up
>> the fd to be better and clearer.  There's still a cost to verify the
>> file pointer, but now it's basically in the noise even for that
>> benchmark that does nothing else - and the code is more understandable
>> and has better comments too.
>>
>> [ Side note: this patch is also a classic case of one that looks very
>>    messy with the default greedy Myers diff - it's much more legible with
>>    either the patience of histogram diff algorithm ]
>>
>> Link: https://lore.kernel.org/lkml/20211210053743.GA36420@xsang-OptiPlex-9020/
>> Link: https://lore.kernel.org/lkml/20211213083154.GA20853@linux.intel.com/
>> Reported-by: kernel test robot <oliver.sang@intel.com>
>> Tested-by: Carel Si <beibei.si@intel.com>
>> Cc: Jann Horn <jannh@google.com>
>> Cc: Miklos Szeredi <mszeredi@redhat.com>
>> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>> Signed-off-by: Baokun Li <libaokun1@huawei.com>
>> ---
>>   fs/file.c | 72 ++++++++++++++++++++++++++++++++++++++++++-------------
>>   1 file changed, 56 insertions(+), 16 deletions(-)
> Now queued up, thanks.
Thanks!
>
> Any chance you can do this for 5.4 and older kernels too?
It's my pleasure. I'll sync this patch to 5.4, 4.19, 4.14, 4.9, 4.4.
>
> greg k-h
> .

-- 
With Best Regards,
Baokun Li

.

