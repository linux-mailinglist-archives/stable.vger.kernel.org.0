Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F28117A136
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 09:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgCEI0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 03:26:07 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11168 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725866AbgCEI0H (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 03:26:07 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8D501D23B73DC7F8D8D6;
        Thu,  5 Mar 2020 16:26:03 +0800 (CST)
Received: from [127.0.0.1] (10.133.210.141) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Thu, 5 Mar 2020
 16:25:55 +0800
Subject: Re: [PATCH 4.4.y] crypto: algif_skcipher - use ZERO_OR_NULL_PTR in
 skcipher_recvmsg_async
To:     <gregkh@linuxfoundation.org>, <herbert@gondor.apana.org.au>
CC:     <stable@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <yangerkun@huawei.com>
References: <20200305085040.21551-1-yangerkun@huawei.com>
From:   yangerkun <yangerkun@huawei.com>
Message-ID: <9f3c49d6-9a12-7cec-feea-0e7b88d981b3@huawei.com>
Date:   Thu, 5 Mar 2020 16:25:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200305085040.21551-1-yangerkun@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.133.210.141]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Drop this, the attach call trace is wrong...

I am so sorry for this. Will send v2.

On 2020/3/5 16:50, yangerkun wrote:
> Nowdays, we trigger a oops:
> ...
> kasan: GPF could be caused by NULL-ptr deref or user memory accessgeneral protection fault: 0000
> ...
>   [<ffffffff8114ab47>] do_async_page_fault+0x37/0xb0 x86/../arch/x86/kernel/kvm.c:266
>   [<ffffffff828b4a48>] async_page_fault+0x28/0x30 x86/../arch/x86/entry/entry_64.S:1043
>   [<ffffffff81b47c2a>] iov_iter_zero+0x15a/0x850 x86/../lib/iov_iter.c:445
>   [<ffffffff81e8ca2f>] read_iter_zero+0xcf/0x1b0 x86/../drivers/char/mem.c:708
>   [<ffffffff816ea7c8>] do_iter_readv_writev x86/../fs/read_write.c:679 [inline]
>   [<ffffffff816ea7c8>] do_readv_writev+0x448/0x8e0 x86/../fs/read_write.c:823
>   [<ffffffff816eacdf>] vfs_readv+0x7f/0xb0 x86/../fs/read_write.c:849
>   [<ffffffff816edac3>] SYSC_preadv x86/../fs/read_write.c:927 [inline]
>   [<ffffffff816edac3>] SyS_preadv+0x193/0x240 x86/../fs/read_write.c:913
>   [<ffffffff828b3261>] entry_SYSCALL_64_fastpath+0x1e/0x9a
>
> In skcipher_recvmsg_async, we use '!sreq->tsg' to determine does we
> calloc fail. However, kcalloc may return ZERO_SIZE_PTR, and with this,
> the latter sg_init_table will trigger the bug. Fix it be use ZERO_OF_NULL_PTR.
>
> This function was introduced with ' commit a596999b7ddf ("crypto:
> algif - change algif_skcipher to be asynchronous")', and has been removed
> with 'commit e870456d8e7c ("crypto: algif_skcipher - overhaul memory
> management")'.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: yangerkun <yangerkun@huawei.com>
> ---
>   crypto/algif_skcipher.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> index d12782dc9683..9bd4691cc5c5 100644
> --- a/crypto/algif_skcipher.c
> +++ b/crypto/algif_skcipher.c
> @@ -538,7 +538,7 @@ static int skcipher_recvmsg_async(struct socket *sock, struct msghdr *msg,
>   	lock_sock(sk);
>   	tx_nents = skcipher_all_sg_nents(ctx);
>   	sreq->tsg = kcalloc(tx_nents, sizeof(*sg), GFP_KERNEL);
> -	if (unlikely(!sreq->tsg))
> +	if (unlikely(ZERO_OR_NULL_PTR(sreq->tsg)))
>   		goto unlock;
>   	sg_init_table(sreq->tsg, tx_nents);
>   	memcpy(iv, ctx->iv, ivsize);

