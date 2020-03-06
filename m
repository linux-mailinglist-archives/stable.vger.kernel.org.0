Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E320217BF39
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 14:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgCFNjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 08:39:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:57336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgCFNjn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Mar 2020 08:39:43 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E6CA2072D;
        Fri,  6 Mar 2020 13:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583501982;
        bh=DSzVN77wc9UBW6xxS8MhVz43+mLB9HuADYFSIrfj9Pc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XDUlPD2INaUHFrx3pmh15B0gffkx5LXpn2S/2JXylCnTFn3ivok8nDnfCJlfWRG4W
         YHN1MxbjA6sYgczgs/YS2hsXiSnM9WN93iCpx1WBBgdfjJ0W6jnXGrH9vwXBzrQUsQ
         e4kgTUfIcOSKxg8dRiqG94jIrqtcRUI16Ep37lvk=
Date:   Fri, 6 Mar 2020 08:39:41 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     yangerkun <yangerkun@huawei.com>
Cc:     gregkh@linuxfoundation.org, herbert@gondor.apana.org.au,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 4.4.y v2] crypto: algif_skcipher - use ZERO_OR_NULL_PTR
 in skcipher_recvmsg_async
Message-ID: <20200306133941.GQ21491@sasha-vm>
References: <20200305085755.22730-1-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200305085755.22730-1-yangerkun@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 05, 2020 at 04:57:55PM +0800, yangerkun wrote:
>Nowdays, we trigger a oops:
>...
>kasan: GPF could be caused by NULL-ptr deref or user memory accessgeneral protection fault: 0000 [#1] SMP KASAN
>...
>Call Trace:
> [<ffffffff81a26fb1>] skcipher_recvmsg_async+0x3f1/0x1400 x86/../crypto/algif_skcipher.c:543
> [<ffffffff81a28053>] skcipher_recvmsg+0x93/0x7f0 x86/../crypto/algif_skcipher.c:723
> [<ffffffff823e43a4>] sock_recvmsg_nosec x86/../net/socket.c:702 [inline]
> [<ffffffff823e43a4>] sock_recvmsg x86/../net/socket.c:710 [inline]
> [<ffffffff823e43a4>] sock_recvmsg+0x94/0xc0 x86/../net/socket.c:705
> [<ffffffff823e464b>] sock_read_iter+0x27b/0x3a0 x86/../net/socket.c:787
> [<ffffffff817f479b>] aio_run_iocb+0x21b/0x7a0 x86/../fs/aio.c:1520
> [<ffffffff817f57c9>] io_submit_one x86/../fs/aio.c:1630 [inline]
> [<ffffffff817f57c9>] do_io_submit+0x6b9/0x10b0 x86/../fs/aio.c:1688
> [<ffffffff817f902d>] SYSC_io_submit x86/../fs/aio.c:1713 [inline]
> [<ffffffff817f902d>] SyS_io_submit+0x2d/0x40 x86/../fs/aio.c:1710
> [<ffffffff828b33c3>] tracesys_phase2+0x90/0x95
>
>In skcipher_recvmsg_async, we use '!sreq->tsg' to determine does we
>calloc fail. However, kcalloc may return ZERO_SIZE_PTR, and with this,
>the latter sg_init_table will trigger the bug. Fix it be use ZERO_OF_NULL_PTR.
>
>This function was introduced with ' commit a596999b7ddf ("crypto:
>algif - change algif_skcipher to be asynchronous")', and has been removed
>with 'commit e870456d8e7c ("crypto: algif_skcipher - overhaul memory
>management")'.
>
>Reported-by: Hulk Robot <hulkci@huawei.com>
>Signed-off-by: yangerkun <yangerkun@huawei.com>
>---
> crypto/algif_skcipher.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>v1->v2:
>update the commit message
>
>diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
>index d12782dc9683..9bd4691cc5c5 100644
>--- a/crypto/algif_skcipher.c
>+++ b/crypto/algif_skcipher.c
>@@ -538,7 +538,7 @@ static int skcipher_recvmsg_async(struct socket *sock, struct msghdr *msg,
> 	lock_sock(sk);
> 	tx_nents = skcipher_all_sg_nents(ctx);
> 	sreq->tsg = kcalloc(tx_nents, sizeof(*sg), GFP_KERNEL);
>-	if (unlikely(!sreq->tsg))
>+	if (unlikely(ZERO_OR_NULL_PTR(sreq->tsg)))

I'm a bit confused: kcalloc() will return ZERO_SIZE_PTR for allocations
that ask for 0 bytes, but here we ask for "sizeof(*sg)" bytes, which is
guaranteed to be more than 0, no?

-- 
Thanks,
Sasha
