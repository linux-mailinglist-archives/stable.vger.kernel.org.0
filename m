Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DDC4098E1
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 18:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236979AbhIMQYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 12:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbhIMQYB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 12:24:01 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A462C061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 09:22:45 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id 6so14751482oiy.8
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 09:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4/ivNU19vgx8JM95ZcxudD+bsQ3V+RD7J/J7pfkup6o=;
        b=a1kK2KQfiezpSLJ2ORWWym+07BdpzPI+E6gijxIsvsZQamk6qGrPWV/3o5PSSAsuOr
         3A+MsrvZXXq9ScwMKCl3Jz2clIb3a9oB5bXugBk+kOyvRJegjV57DmSz9AEz+Aiqslf4
         f2GQ5sqhzgkHTI6wJ91yabyDkmYOQg8mXmjBD+qTZMOjHWiJBQ8Gd8OudErVWiWm8LHb
         lk10kSue7CYfSDDIbp9h7Exl94gah9Qbuk/PN03BVfiJen1pSrRstSprN2S/H6L53YyI
         OLZf5bwowa9GyrvGQXd4LoQ77XiiZutJzeceFf6JdIjod/XQ4gvqgZZ8HO4sZR7oIDRm
         RMNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4/ivNU19vgx8JM95ZcxudD+bsQ3V+RD7J/J7pfkup6o=;
        b=hV+aQTHZPstO9FA4ZpGcVcX5wGQVAhg4KtzIZLpiBAxuqbPGLbEUXYZZkjUKgeNDsa
         KYivUmyjsZ9Mls7Ep6thTKNgWWu6OlVBLj9RpJS+/aOL/Eiqj8XgSVAIfS/cCS/ASbS7
         NPDsiZGxXmJHPHuN4QTgbsIZN8fjzsRh1+Rvi9hvU3SBFxknQOcJ5pISXtAWylvNurAV
         4hzPaIm//aFbXO06FKv+oys1gsINOxnW8k+YICmK6Z07Wg/kwvHIEqTX0wQOVmEACPbT
         /JeL7MHy+7lm/7NI05H+Zr8W2ryP1Puv/y/93kd8d/OdM0R/JDmaoRXP3VDIFHjkfBbi
         hRTA==
X-Gm-Message-State: AOAM530BVXZV4NB9u1IVEMHn/2GhCDIjuC1Oz58kYvBP0C5i0Vk27lmw
        ijJ+TIIo/XzJ1TWl+JI+r2udw8fs9paeA/Cs9fhkkA==
X-Google-Smtp-Source: ABdhPJwBHMz+LzOFUiQTIwbzPzdvrXtTVwYQpG2iiSp91TzBtWRskcUIoeGW7uJi+Qpxvni4TX/PSl9W+KQ5xZ2gyXg=
X-Received: by 2002:a05:6808:118:: with SMTP id b24mr8614615oie.0.1631550164556;
 Mon, 13 Sep 2021 09:22:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210913131113.390368911@linuxfoundation.org> <20210913131114.028340332@linuxfoundation.org>
In-Reply-To: <20210913131114.028340332@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 13 Sep 2021 21:52:33 +0530
Message-ID: <CA+G9fYtdPnwf+fi4Oyxng65pWjW9ujZ7dd2Z-EEEHyJimNHN6g@mail.gmail.com>
Subject: Re: [PATCH 5.14 018/334] nbd: add the check to prevent overflow in __nbd_ioctl()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Baokun Li <libaokun1@huawei.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        lkft-triage@lists.linaro.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 13 Sept 2021 at 19:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Baokun Li <libaokun1@huawei.com>
>
> [ Upstream commit fad7cd3310db3099f95dd34312c77740fbc455e5 ]
>
> If user specify a large enough value of NBD blocks option, it may trigger
> signed integer overflow which may lead to nbd->config->bytesize becomes a
> large or small value, zero in particular.
>
> UBSAN: Undefined behaviour in drivers/block/nbd.c:325:31
> signed integer overflow:
> 1024 * 4611686155866341414 cannot be represented in type 'long long int'
> [...]
> Call trace:
> [...]
>  handle_overflow+0x188/0x1dc lib/ubsan.c:192
>  __ubsan_handle_mul_overflow+0x34/0x44 lib/ubsan.c:213
>  nbd_size_set drivers/block/nbd.c:325 [inline]
>  __nbd_ioctl drivers/block/nbd.c:1342 [inline]
>  nbd_ioctl+0x998/0xa10 drivers/block/nbd.c:1395
>  __blkdev_driver_ioctl block/ioctl.c:311 [inline]
> [...]
>
> Although it is not a big deal, still silence the UBSAN by limit
> the input value.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
> Link: https://lore.kernel.org/r/20210804021212.990223-1-libaokun1@huawei.com
> [axboe: dropped unlikely()]
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/block/nbd.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index 19f5d5a8b16a..acf3f85bf3c7 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -1388,6 +1388,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
>                        unsigned int cmd, unsigned long arg)
>  {
>         struct nbd_config *config = nbd->config;
> +       loff_t bytesize;
>
>         switch (cmd) {
>         case NBD_DISCONNECT:
> @@ -1402,8 +1403,9 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
>         case NBD_SET_SIZE:
>                 return nbd_set_size(nbd, arg, config->blksize);
>         case NBD_SET_SIZE_BLOCKS:
> -               return nbd_set_size(nbd, arg * config->blksize,
> -                                   config->blksize);
> +               if (check_mul_overflow((loff_t)arg, config->blksize, &bytesize))
> +                       return -EINVAL;
> +               return nbd_set_size(nbd, bytesize, config->blksize);
>         case NBD_SET_TIMEOUT:
>                 nbd_set_cmd_timeout(nbd, arg);
>                 return 0;

arm clang-10, clang-11, clang-12 and clang-13 builds failed.
due to this commit on 5.14 and 5.13 on following configs,
  - footbridge_defconfig
  - mini2440_defconfig
  - s3c2410_defconfig

This was already reported on the mailing list.

ERROR: modpost: "__mulodi4" [drivers/block/nbd.ko] undefined! #1438
https://github.com/ClangBuiltLinux/linux/issues/1438

[PATCH 00/10] raise minimum GCC version to 5.1
https://lore.kernel.org/lkml/20210910234047.1019925-1-ndesaulniers@google.com/

linux-next: build failure while building Linus' tree
https://lore.kernel.org/all/20210909182525.372ee687@canb.auug.org.au/

Full build log,
https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1585407346#L1111


--
Linaro LKFT
https://lkft.linaro.org
