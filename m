Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 104FD17F731
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgCJMOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:14:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgCJMOX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:14:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00EC02468C;
        Tue, 10 Mar 2020 12:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583842462;
        bh=bEhWoDM7ps0zyNDOlrnx2a1ZEwiVCTIx3byAPh8nRh0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IoZsxsSaTjPdCjnPxr5oeJz7uBoT4nMSuMA7d7llQlDCFBw1FL4Oh+ZJu6oRNNDL4
         3B+3uAMbcSWsPqcQNFsLs18Ms4O2v3Mdltiyvd+boWpscLgBlSpWYAB8X/I0rPL7MH
         IGvbMI+CCFoi56mhDdL5Ipujjp0x2r01HQvzKdcc=
Date:   Tue, 10 Mar 2020 13:14:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     yangerkun <yangerkun@huawei.com>
Cc:     Sasha Levin <sashal@kernel.org>, herbert@gondor.apana.org.au,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 4.4.y v2] crypto: algif_skcipher - use ZERO_OR_NULL_PTR
 in skcipher_recvmsg_async
Message-ID: <20200310121420.GG3106483@kroah.com>
References: <20200305085755.22730-1-yangerkun@huawei.com>
 <20200306133941.GQ21491@sasha-vm>
 <8bb5b0d7-4232-14cb-49c7-a3cc348645ae@huawei.com>
 <20200308001945.GT21491@sasha-vm>
 <f7baf844-f171-adcc-6ad9-70d631cb5f4b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f7baf844-f171-adcc-6ad9-70d631cb5f4b@huawei.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 09, 2020 at 09:27:16AM +0800, yangerkun wrote:
> 
> 
> On 2020/3/8 8:19, Sasha Levin wrote:
> > On Sat, Mar 07, 2020 at 09:49:25AM +0800, yangerkun wrote:
> > > 
> > > 
> > > On 2020/3/6 21:39, Sasha Levin wrote:
> > > > On Thu, Mar 05, 2020 at 04:57:55PM +0800, yangerkun wrote:
> > > > > Nowdays, we trigger a oops:
> > > > > ...
> > > > > kasan: GPF could be caused by NULL-ptr deref or user memory
> > > > > accessgeneral protection fault: 0000 [#1] SMP KASAN
> > > > > ...
> > > > > Call Trace:
> > > > > [<ffffffff81a26fb1>] skcipher_recvmsg_async+0x3f1/0x1400
> > > > > x86/../crypto/algif_skcipher.c:543
> > > > > [<ffffffff81a28053>] skcipher_recvmsg+0x93/0x7f0
> > > > > x86/../crypto/algif_skcipher.c:723
> > > > > [<ffffffff823e43a4>] sock_recvmsg_nosec
> > > > > x86/../net/socket.c:702 [inline]
> > > > > [<ffffffff823e43a4>] sock_recvmsg x86/../net/socket.c:710 [inline]
> > > > > [<ffffffff823e43a4>] sock_recvmsg+0x94/0xc0 x86/../net/socket.c:705
> > > > > [<ffffffff823e464b>] sock_read_iter+0x27b/0x3a0 x86/../net/socket.c:787
> > > > > [<ffffffff817f479b>] aio_run_iocb+0x21b/0x7a0 x86/../fs/aio.c:1520
> > > > > [<ffffffff817f57c9>] io_submit_one x86/../fs/aio.c:1630 [inline]
> > > > > [<ffffffff817f57c9>] do_io_submit+0x6b9/0x10b0 x86/../fs/aio.c:1688
> > > > > [<ffffffff817f902d>] SYSC_io_submit x86/../fs/aio.c:1713 [inline]
> > > > > [<ffffffff817f902d>] SyS_io_submit+0x2d/0x40 x86/../fs/aio.c:1710
> > > > > [<ffffffff828b33c3>] tracesys_phase2+0x90/0x95
> > > > > 
> > > > > In skcipher_recvmsg_async, we use '!sreq->tsg' to determine does we
> > > > > calloc fail. However, kcalloc may return ZERO_SIZE_PTR, and with this,
> > > > > the latter sg_init_table will trigger the bug. Fix it be use
> > > > > ZERO_OF_NULL_PTR.
> > > > > 
> > > > > This function was introduced with ' commit a596999b7ddf ("crypto:
> > > > > algif - change algif_skcipher to be asynchronous")', and has
> > > > > been removed
> > > > > with 'commit e870456d8e7c ("crypto: algif_skcipher - overhaul memory
> > > > > management")'.
> > > > > 
> > > > > Reported-by: Hulk Robot <hulkci@huawei.com>
> > > > > Signed-off-by: yangerkun <yangerkun@huawei.com>
> > > > > ---
> > > > > crypto/algif_skcipher.c | 2 +-
> > > > > 1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > 
> > > > > v1->v2:
> > > > > update the commit message
> > > > > 
> > > > > diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> > > > > index d12782dc9683..9bd4691cc5c5 100644
> > > > > --- a/crypto/algif_skcipher.c
> > > > > +++ b/crypto/algif_skcipher.c
> > > > > @@ -538,7 +538,7 @@ static int skcipher_recvmsg_async(struct
> > > > > socket *sock, struct msghdr *msg,
> > > > >     lock_sock(sk);
> > > > >     tx_nents = skcipher_all_sg_nents(ctx);
> > > > >     sreq->tsg = kcalloc(tx_nents, sizeof(*sg), GFP_KERNEL);
> > > > > -    if (unlikely(!sreq->tsg))
> > > > > +    if (unlikely(ZERO_OR_NULL_PTR(sreq->tsg)))
> > > > 
> > > > I'm a bit confused: kcalloc() will return ZERO_SIZE_PTR for allocations
> > > > that ask for 0 bytes, but here we ask for "sizeof(*sg)" bytes, which is
> > > > guaranteed to be more than 0, no?
> > > 
> > > Actually, the size need to calloc is (tx_nents * sizeof(*sg)), and
> > > tx_nents is 0.
> > 
> > Makes sense. This is also needed on 4.9, right?
> 
> Yes! Thanks for checking it!

Now queued up,t hanks.

greg k-h
