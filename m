Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89B2C17F762
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgCJM1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:27:10 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11204 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726331AbgCJM1J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:27:09 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7A3BD3BB2DAC6FBEA945;
        Tue, 10 Mar 2020 20:27:07 +0800 (CST)
Received: from [127.0.0.1] (10.133.210.141) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Tue, 10 Mar 2020
 20:27:05 +0800
Subject: Re: [PATCH 4.4.y/4.9.y] NFS: fix highmem leak exist in
 nfs_readdir_xdr_to_array
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <sashal@kernel.org>, <stable@vger.kernel.org>
References: <20200310100219.5421-1-yangerkun@huawei.com>
 <20200310113753.GA3106483@kroah.com>
From:   yangerkun <yangerkun@huawei.com>
Message-ID: <82acf5d1-d7d8-65c8-f616-37ccb36f4abd@huawei.com>
Date:   Tue, 10 Mar 2020 20:27:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200310113753.GA3106483@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.210.141]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2020/3/10 19:37, Greg KH wrote:
> On Tue, Mar 10, 2020 at 06:02:19PM +0800, yangerkun wrote:
>> The patch 'e22dea67d2f7 ("NFS: Fix memory leaks and corruption in
>> readdir")' in 4.4.y/4.9.y will introduce a highmem leak.
>> Actually, nfs_readdir_get_array has did what we want to do. No need to
>> call kmap again.
>>
>> Signed-off-by: yangerkun <yangerkun@huawei.com>
>> ---
>>   fs/nfs/dir.c | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
>> index c2665d920cf8..2517fcd423b6 100644
>> --- a/fs/nfs/dir.c
>> +++ b/fs/nfs/dir.c
>> @@ -678,8 +678,6 @@ int nfs_readdir_xdr_to_array(nfs_readdir_descriptor_t *desc, struct page *page,
>>   		goto out_label_free;
>>   	}
>>   
>> -	array = kmap(page);
>> -
>>   	status = nfs_readdir_alloc_pages(pages, array_size);
>>   	if (status < 0)
>>   		goto out_release_array;
>> -- 
>> 2.17.2
>>
> 
> Can you resend and cc: the NFS developers and maintainers on this
> change?  I need their ack to be able to apply it.

Okay, will do it right now.

Thanks,
Kun.

> 
> thanks,
> 
> greg k-h
> 
> 
> .
> 

