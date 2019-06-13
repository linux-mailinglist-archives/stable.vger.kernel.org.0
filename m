Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62CF843EB8
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389765AbfFMPwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:52:24 -0400
Received: from relay.sw.ru ([185.231.240.75]:35994 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731641AbfFMJKM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 05:10:12 -0400
Received: from [172.16.25.12]
        by relay.sw.ru with esmtp (Exim 4.92)
        (envelope-from <aryabinin@virtuozzo.com>)
        id 1hbLkG-0008MK-5e; Thu, 13 Jun 2019 12:10:08 +0300
Subject: Re: [PATCH v2 1/3] fs/fuse, splice_write: Don't access pipe->buffers
 without pipe_lock()
To:     Vlastimil Babka <vbabka@suse.cz>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <CAJfpegvAAQTAjxLcQLefvFOQDJ6ug_G8Jggt=UZci+YnNP741A@mail.gmail.com>
 <20180717160035.9422-1-aryabinin@virtuozzo.com>
 <b7aceb99-9631-cbcf-fdec-3abef72c949d@suse.cz>
From:   Andrey Ryabinin <aryabinin@virtuozzo.com>
Message-ID: <3fcf7f4f-a9c0-f9c8-f526-ab12e283cd43@virtuozzo.com>
Date:   Thu, 13 Jun 2019 12:10:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <b7aceb99-9631-cbcf-fdec-3abef72c949d@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/12/19 11:57 AM, Vlastimil Babka wrote:
> On 7/17/18 6:00 PM, Andrey Ryabinin wrote:
>> fuse_dev_splice_write() reads pipe->buffers to determine the size of
>> 'bufs' array before taking the pipe_lock(). This is not safe as
>> another thread might change the 'pipe->buffers' between the allocation
>> and taking the pipe_lock(). So we end up with too small 'bufs' array.
>>
>> Move the bufs allocations inside pipe_lock()/pipe_unlock() to fix this.
>>
>> Fixes: dd3bb14f44a6 ("fuse: support splice() writing to fuse device")
>> Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
>> Cc: <stable@vger.kernel.org>
> 
> BTW, why don't we need to do the same in fuse_dev_splice_read()?
> 

do_splice() already takes the pipe_lock() before calling ->splice_read()

> Thanks,
> Vlastimil
> 
>> ---
>>  fs/fuse/dev.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
>> index c6b88fa85e2e..702592cce546 100644
>> --- a/fs/fuse/dev.c
>> +++ b/fs/fuse/dev.c
>> @@ -1944,12 +1944,15 @@ static ssize_t fuse_dev_splice_write(struct pipe_inode_info *pipe,
>>  	if (!fud)
>>  		return -EPERM;
>>  
>> +	pipe_lock(pipe);
>> +
>>  	bufs = kmalloc_array(pipe->buffers, sizeof(struct pipe_buffer),
>>  			     GFP_KERNEL);
>> -	if (!bufs)
>> +	if (!bufs) {
>> +		pipe_unlock(pipe);
>>  		return -ENOMEM;
>> +	}
>>  
>> -	pipe_lock(pipe);
>>  	nbuf = 0;
>>  	rem = 0;
>>  	for (idx = 0; idx < pipe->nrbufs && rem < len; idx++)
>>
> 
