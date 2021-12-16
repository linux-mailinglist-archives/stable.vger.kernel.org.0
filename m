Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACD3477512
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 15:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238041AbhLPO4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 09:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238053AbhLPO4N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 09:56:13 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87383C061574
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 06:56:13 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id a18so44718593wrn.6
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 06:56:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lEKwqd+P6M5z2q9L1KzIcsLzPQ6E9+XoNcECGYamWLU=;
        b=l0GxtIkjdm8Ww9Au3npk9ADCgQCkTpDdNjUNvvwMhOBP3W61Qbpa+bpRwt0OO6vvLD
         nH5Vz8FyWxoq5wLhAEFoi7Flg+92JwZi6ogYgTRz2pn00nkAPF/Pbj1p2CT1DkIFg63v
         q+FTIFzEb74PGNBO0EyOE2Bxu/ECO9OqUOECI7pNecTZHZ81pJlqVm6UWpwYFdJlMrOd
         OzM24zvzj83ODO/xwJQz6hJJmgdFxSDKDry6rcMd1jkzwr6zPlp+lUUMzjC68bdSNm/B
         Tg8Y0so7bAG0XsV3i5O0ODU81S/tu8hfNma88XG/bKSIzd0sexWo8h7njdtGIEO141jH
         OqMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lEKwqd+P6M5z2q9L1KzIcsLzPQ6E9+XoNcECGYamWLU=;
        b=0EoJEo41PdczhtL+dYGguCCUqlOOrw8Qc5h0PlLL8+B/kLIPVGSNNIvZNt0Ptd0ckH
         y5wPzBKK8QMF3ENdpNBPmW7VKG9WQkET3ouVOz0GulbayOnBcig/5RItbxoo5KR2g+iZ
         s0eY0aLxm8lkZORofeCP/glEyfsgC8rv0mkBUO6oycUKd7156cSPbOH6e5vKMGbuyyAZ
         8NVvzQ6VYR6X722aINF7hVohP+RNlo3g8CDAv8jCwBhyZEkwsUmZ+ReoY0OW81scFS/v
         nbxCj3YY/DfSX8Q12H1Z2CM6Qt4YwTFpCcjM0wNLSxLaSZNs0gu1jI5Z3j3/yYmjCz4R
         93Fg==
X-Gm-Message-State: AOAM530ehJCCXD2h1VyoIvG7RnLZzRpI7CPDRItggSFBly7FKMXntGr/
        xiL++XQK/Wb6zQgHRhcHXTiJe04a0MBp6H9qQd63ZA==
X-Google-Smtp-Source: ABdhPJwz5SQ8BFTI+xqrVpJmwSx1HU86pipbexlpLTz/OYDV3a3xu9NfnWVMyoXgs9gzyFp3NsO83Z2Odfe4yokpKsE=
X-Received: by 2002:a5d:4acb:: with SMTP id y11mr9448459wrs.64.1639666572079;
 Thu, 16 Dec 2021 06:56:12 -0800 (PST)
MIME-Version: 1.0
References: <20211215092501.1861229-1-jens.wiklander@linaro.org> <YbnlFf8930RuLkU8@kroah.com>
In-Reply-To: <YbnlFf8930RuLkU8@kroah.com>
From:   Jens Wiklander <jens.wiklander@linaro.org>
Date:   Thu, 16 Dec 2021 15:56:01 +0100
Message-ID: <CAHUa44GqvZS1AY-C45K7kvHxryUu-hUEuCnR3z14BKE0iu34Qw@mail.gmail.com>
Subject: Re: [PATCH v2] tee: handle lookup of shm with reference count 0
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, op-tee@lists.trustedfirmware.org,
        Sumit Garg <sumit.garg@linaro.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        stable@vger.kernel.org, Lars Persson <larper@axis.com>,
        Patrik Lantz <Patrik.Lantz@axis.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 15, 2021 at 1:52 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Dec 15, 2021 at 10:25:01AM +0100, Jens Wiklander wrote:
> > Since the tee subsystem does not keep a strong reference to its idle
> > shared memory buffers, it races with other threads that try to destroy a
> > shared memory through a close of its dma-buf fd or by unmapping the
> > memory.
> >
> > In tee_shm_get_from_id() when a lookup in teedev->idr has been
> > successful, it is possible that the tee_shm is in the dma-buf teardown
> > path, but that path is blocked by the teedev mutex. Since we don't have
> > an API to tell if the tee_shm is in the dma-buf teardown path or not we
> > must find another way of detecting this condition.
> >
> > Fix this by doing the reference counting directly on the tee_shm using a
> > new refcount_t refcount field. dma-buf is replaced by using
> > anon_inode_getfd() instead, this separates the life-cycle of the
> > underlying file from the tee_shm. tee_shm_put() is updated to hold the
> > mutex when decreasing the refcount to 0 and then remove the tee_shm from
> > teedev->idr before releasing the mutex. This means that the tee_shm can
> > never be found unless it has a refcount larger than 0.
> >
> > Fixes: 967c9cca2cc5 ("tee: generic TEE subsystem")
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Lars Persson <larper@axis.com>
> > Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
> > Reported-by: Patrik Lantz <patrik.lantz@axis.com>
> > Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> > ---
> > v1->v2
> > * fix copyright years in drivers/tee/tee_shm.c
> > * update kerneldoc comment for struct tee_shm with the reference counter
>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I'm picking up this now.

Thanks for reviewing,
Jens
