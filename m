Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C017317CA8F
	for <lists+stable@lfdr.de>; Sat,  7 Mar 2020 02:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgCGBth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 20:49:37 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11193 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726237AbgCGBth (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Mar 2020 20:49:37 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E87C7C3E6D00EC160187;
        Sat,  7 Mar 2020 09:49:34 +0800 (CST)
Received: from [127.0.0.1] (10.133.210.141) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Sat, 7 Mar 2020
 09:49:26 +0800
Subject: Re: [PATCH 4.4.y v2] crypto: algif_skcipher - use ZERO_OR_NULL_PTR in
 skcipher_recvmsg_async
To:     Sasha Levin <sashal@kernel.org>
CC:     <gregkh@linuxfoundation.org>, <herbert@gondor.apana.org.au>,
        <stable@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <yangerkun@huawei.com>
References: <20200305085755.22730-1-yangerkun@huawei.com>
 <20200306133941.GQ21491@sasha-vm>
From:   yangerkun <yangerkun@huawei.com>
Message-ID: <8bb5b0d7-4232-14cb-49c7-a3cc348645ae@huawei.com>
Date:   Sat, 7 Mar 2020 09:49:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200306133941.GQ21491@sasha-vm>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.133.210.141]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2020/3/6 21:39, Sasha Levin wrote:
> On Thu, Mar 05, 2020 at 04:57:55PM +0800, yangerkun wrote:
>> Nowdays, we trigger a oops:
>> ...
>> kasan: GPF could be caused by NULL-ptr deref or user memory 
>> accessgeneral protection fault: 0000 [#1] SMP KASAN
>> ...
>> Call Trace:
>> [<ffffffff81a26fb1>] skcipher_recvmsg_async+0x3f1/0x1400 
>> x86/../crypto/algif_skcipher.c:543
>> [<ffffffff81a28053>] skcipher_recvmsg+0x93/0x7f0 
>> x86/../crypto/algif_skcipher.c:723
>> [<ffffffff823e43a4>] sock_recvmsg_nosec x86/../net/socket.c:702 [inline]
>> [<ffffffff823e43a4>] sock_recvmsg x86/../net/socket.c:710 [inline]
>> [<ffffffff823e43a4>] sock_recvmsg+0x94/0xc0 x86/../net/socket.c:705
>> [<ffffffff823e464b>] sock_read_iter+0x27b/0x3a0 x86/../net/socket.c:787
>> [<ffffffff817f479b>] aio_run_iocb+0x21b/0x7a0 x86/../fs/aio.c:1520
>> [<ffffffff817f57c9>] io_submit_one x86/../fs/aio.c:1630 [inline]
>> [<ffffffff817f57c9>] do_io_submit+0x6b9/0x10b0 x86/../fs/aio.c:1688
>> [<ffffffff817f902d>] SYSC_io_submit x86/../fs/aio.c:1713 [inline]
>> [<ffffffff817f902d>] SyS_io_submit+0x2d/0x40 x86/../fs/aio.c:1710
>> [<ffffffff828b33c3>] tracesys_phase2+0x90/0x95
>>
>> In skcipher_recvmsg_async, we use '!sreq->tsg' to determine does we
>> calloc fail. However, kcalloc may return ZERO_SIZE_PTR, and with this,
>> the latter sg_init_table will trigger the bug. Fix it be use 
>> ZERO_OF_NULL_PTR.
>>
>> This function was introduced with ' commit a596999b7ddf ("crypto:
>> algif - change algif_skcipher to be asynchronous")', and has been removed
>> with 'commit e870456d8e7c ("crypto: algif_skcipher - overhaul memory
>> management")'.
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: yangerkun <yangerkun@huawei.com>
>> ---
>> crypto/algif_skcipher.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> v1->v2:
>> update the commit message
>>
>> diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
>> index d12782dc9683..9bd4691cc5c5 100644
>> --- a/crypto/algif_skcipher.c
>> +++ b/crypto/algif_skcipher.c
>> @@ -538,7 +538,7 @@ static int skcipher_recvmsg_async(struct socket 
>> *sock, struct msghdr *msg,
>>     lock_sock(sk);
>>     tx_nents = skcipher_all_sg_nents(ctx);
>>     sreq->tsg = kcalloc(tx_nents, sizeof(*sg), GFP_KERNEL);
>> -    if (unlikely(!sreq->tsg))
>> +    if (unlikely(ZERO_OR_NULL_PTR(sreq->tsg)))
> 
> I'm a bit confused: kcalloc() will return ZERO_SIZE_PTR for allocations
> that ask for 0 bytes, but here we ask for "sizeof(*sg)" bytes, which is
> guaranteed to be more than 0, no?

Actually, the size need to calloc is (tx_nents * sizeof(*sg)), and 
tx_nents is 0.

> 

