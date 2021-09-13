Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D11409B60
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 19:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343745AbhIMR7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 13:59:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239541AbhIMR7T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 13:59:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4789B60F25;
        Mon, 13 Sep 2021 17:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631555883;
        bh=wKCgWwoggfMMEuOXBW33VvCRW6LZGGnafN7FiiDq0po=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GVc7OI7qomibj+raAPEjY0UE8y/XsG3CJBeVKxT/5I+pml7HfSZatFAoBHdmO8hMf
         B4sF/hEfbMZvKo0GdiqrKxq/puFzbu+1iClo7Rim1tTKQyW4lCLGYZiPPs3o8aeLRB
         4i776bLcYny/wE3eRkpN79oS/jmeNQpx24V+/hvQ=
Date:   Mon, 13 Sep 2021 19:58:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Baokun Li <libaokun1@huawei.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        lkft-triage@lists.linaro.org, llvm@lists.linux.dev
Subject: Re: [PATCH 5.14 018/334] nbd: add the check to prevent overflow in
 __nbd_ioctl()
Message-ID: <YT+RKemKfg6GFq0S@kroah.com>
References: <20210913131113.390368911@linuxfoundation.org>
 <20210913131114.028340332@linuxfoundation.org>
 <CA+G9fYtdPnwf+fi4Oyxng65pWjW9ujZ7dd2Z-EEEHyJimNHN6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtdPnwf+fi4Oyxng65pWjW9ujZ7dd2Z-EEEHyJimNHN6g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 13, 2021 at 09:52:33PM +0530, Naresh Kamboju wrote:
> On Mon, 13 Sept 2021 at 19:51, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Baokun Li <libaokun1@huawei.com>
> >
> > [ Upstream commit fad7cd3310db3099f95dd34312c77740fbc455e5 ]
> >
> > If user specify a large enough value of NBD blocks option, it may trigger
> > signed integer overflow which may lead to nbd->config->bytesize becomes a
> > large or small value, zero in particular.
> >
> > UBSAN: Undefined behaviour in drivers/block/nbd.c:325:31
> > signed integer overflow:
> > 1024 * 4611686155866341414 cannot be represented in type 'long long int'
> > [...]
> > Call trace:
> > [...]
> >  handle_overflow+0x188/0x1dc lib/ubsan.c:192
> >  __ubsan_handle_mul_overflow+0x34/0x44 lib/ubsan.c:213
> >  nbd_size_set drivers/block/nbd.c:325 [inline]
> >  __nbd_ioctl drivers/block/nbd.c:1342 [inline]
> >  nbd_ioctl+0x998/0xa10 drivers/block/nbd.c:1395
> >  __blkdev_driver_ioctl block/ioctl.c:311 [inline]
> > [...]
> >
> > Although it is not a big deal, still silence the UBSAN by limit
> > the input value.
> >
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Baokun Li <libaokun1@huawei.com>
> > Reviewed-by: Josef Bacik <josef@toxicpanda.com>
> > Link: https://lore.kernel.org/r/20210804021212.990223-1-libaokun1@huawei.com
> > [axboe: dropped unlikely()]
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/block/nbd.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> > index 19f5d5a8b16a..acf3f85bf3c7 100644
> > --- a/drivers/block/nbd.c
> > +++ b/drivers/block/nbd.c
> > @@ -1388,6 +1388,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
> >                        unsigned int cmd, unsigned long arg)
> >  {
> >         struct nbd_config *config = nbd->config;
> > +       loff_t bytesize;
> >
> >         switch (cmd) {
> >         case NBD_DISCONNECT:
> > @@ -1402,8 +1403,9 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
> >         case NBD_SET_SIZE:
> >                 return nbd_set_size(nbd, arg, config->blksize);
> >         case NBD_SET_SIZE_BLOCKS:
> > -               return nbd_set_size(nbd, arg * config->blksize,
> > -                                   config->blksize);
> > +               if (check_mul_overflow((loff_t)arg, config->blksize, &bytesize))
> > +                       return -EINVAL;
> > +               return nbd_set_size(nbd, bytesize, config->blksize);
> >         case NBD_SET_TIMEOUT:
> >                 nbd_set_cmd_timeout(nbd, arg);
> >                 return 0;
> 
> arm clang-10, clang-11, clang-12 and clang-13 builds failed.
> due to this commit on 5.14 and 5.13 on following configs,
>   - footbridge_defconfig
>   - mini2440_defconfig
>   - s3c2410_defconfig
> 
> This was already reported on the mailing list.
> 
> ERROR: modpost: "__mulodi4" [drivers/block/nbd.ko] undefined! #1438
> https://github.com/ClangBuiltLinux/linux/issues/1438
> 
> [PATCH 00/10] raise minimum GCC version to 5.1
> https://lore.kernel.org/lkml/20210910234047.1019925-1-ndesaulniers@google.com/
> 
> linux-next: build failure while building Linus' tree
> https://lore.kernel.org/all/20210909182525.372ee687@canb.auug.org.au/
> 
> Full build log,
> https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1585407346#L1111

Has anyone submitted a fix for this upstream yet?  I can't seem to find
one :(
