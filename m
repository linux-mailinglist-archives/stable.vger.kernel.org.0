Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F22D359C19D
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 16:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiHVO3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 10:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiHVO3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 10:29:18 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729531839E
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 07:29:17 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id c16-20020a17090aa61000b001fb3286d9f7so1897345pjq.1
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 07:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=XM1/iuKHg5TinvHwwaat1vz+EFyHG4LNECcKaRmEIx0=;
        b=G1ibMTDZ7bT6HBa479G6Fmc6EaC47ZOHzStl/WI+3J3U4ryHe70KboFUjkiUhgM194
         2qyaqSMTcd2+zMIXAJv6c0/Jxro4+mw/OT7NMt5cQQYJXE/N5D3aox7QbyvjURHYyDsZ
         mwWvrxet8Jy3q1ekyQjdmhCnOoVhcIJsWM+evf6wqzSIyUFhTR5b7dhS0A/GPy8G9ire
         purIivEKBFQpjo8OHLkgsR3mdL0ghmBpdEGTHBTwlijb2oy3SdJo/G00MVf/bhqvEUYc
         5GVBrMVV53X23mJRqIKnFTS4ECmF0LV1nhvkRXjDjdrUit5l08k/geWjy1rAfZSXlhb1
         +nFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=XM1/iuKHg5TinvHwwaat1vz+EFyHG4LNECcKaRmEIx0=;
        b=NPB/aKbnHV22b863Ug8UINGkhCLXF99YLcouXvvYQL6wDHTQm8ymJbIN8SmyhWfFPd
         0nB8UFI+DwpVLK56PK3RwMeOo08N2Szifcf1rh+h738IueXUcXRQNVNdXIdniipKxRjP
         kY8CXvFqqDy459eT55NtRg8GIDRKsVVa0J/mSRoti7WGsp7dCaqKA2BSgSsx7WBFZ1Jn
         pNw+sajlP4MaQMeYBkqOIe0Ei4oudQihJcckX6/zshdXtelQ+h3FH4N9GT1HK+k5Uvnm
         CZo6EYN2Zikpg8dM4aqjD3gb6watnwNDx+TcN1qkxqb15yHosVHcq1WN3IPl6ibx0lr4
         N54Q==
X-Gm-Message-State: ACgBeo1evtk8i7nDdYbHzCYunjyvlxZ48PaCKnYJlG6RKKetdgBXQy4z
        5vdXQjWEgCSB01QIH62B5hdNoJ268cA8rolaQeU6Tg==
X-Google-Smtp-Source: AA6agR4PohNLyviLGt6xFWNBSoq3NIRpYenUzZ4CiylBIB2eANp8Bj5sAuXAqWALlRYFEwTtBTofMOUHoZssA08q+hw=
X-Received: by 2002:a17:902:d50b:b0:172:a41f:b204 with SMTP id
 b11-20020a170902d50b00b00172a41fb204mr20154451plg.70.1661178556880; Mon, 22
 Aug 2022 07:29:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220822131227.3865684-1-jens.wiklander@linaro.org> <YwOFX8eXYmZrsl/n@kroah.com>
In-Reply-To: <YwOFX8eXYmZrsl/n@kroah.com>
From:   Jens Wiklander <jens.wiklander@linaro.org>
Date:   Mon, 22 Aug 2022 16:29:05 +0200
Message-ID: <CAHUa44Ein2WMDtBeBHU+MQULFBonQ1LYXCuQTCO+rrmfxunbNw@mail.gmail.com>
Subject: Re: [PATCH] tee: add overflow check in tee_ioctl_shm_register()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Jerome Forissier <jerome.forissier@linaro.org>,
        Nimish Mishra <neelam.nimish@gmail.com>,
        Anirban Chakraborty <ch.anirban00727@gmail.com>,
        Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 22, 2022 at 3:32 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Aug 22, 2022 at 03:12:27PM +0200, Jens Wiklander wrote:
> > commit 573ae4f13f630d6660008f1974c0a8a29c30e18a upstream.
> >
> > With special lengths supplied by user space, tee_shm_register() has
> > an integer overflow when calculating the number of pages covered by a
> > supplied user space memory region.
> >
> > This may cause pin_user_pages_fast() to do a NULL pointer dereference.
> >
> > Fix this by adding an an explicit call to access_ok() in
> > tee_ioctl_shm_register() to catch an invalid user space address early.
> >
> > Fixes: 033ddf12bcf5 ("tee: add register user memory")
> > Cc: stable@vger.kernel.org # 5.4
> > Cc: stable@vger.kernel.org # 5.10
> > Reported-by: Nimish Mishra <neelam.nimish@gmail.com>
> > Reported-by: Anirban Chakraborty <ch.anirban00727@gmail.com>
> > Reported-by: Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>
> > Suggested-by: Jerome Forissier <jerome.forissier@linaro.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > [JW: backport to stable 5.4 and 5.10 + update commit message]
>
> You already sent me a 5.4 version here:
>         https://lore.kernel.org/r/20220822092621.3691771-1-jens.wiklander@linaro.org
>
> And I applied that.
>
> And for 5.10, it's already in the tree as commit 578c349570d2 ("tee: add
> overflow check in register_shm_helper()") and was in the 5.10.137
> release.
>
> > Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> > ---
> >  drivers/tee/tee_core.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
> > index a7ccd4d2bd10..2db144d2d26f 100644
> > --- a/drivers/tee/tee_core.c
> > +++ b/drivers/tee/tee_core.c
> > @@ -182,6 +182,9 @@ tee_ioctl_shm_register(struct tee_context *ctx,
> >       if (data.flags)
> >               return -EINVAL;
> >
> > +     if (!access_ok((void __user *)(unsigned long)data.addr, data.length))
> > +             return -EFAULT;
>
> What I took in 5.10.137 was:
>
> +       if (!access_ok((void __user *)addr, length))
> +               return ERR_PTR(-EFAULT);
>
> Should I fix it up to look like what you sent here instead?

Yes, please.

>
> confused,

I'm sorry for the confusion.

Thanks,
Jens

>
> greg k-h
