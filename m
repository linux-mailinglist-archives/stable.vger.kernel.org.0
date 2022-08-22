Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B602059C00B
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 15:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbiHVNEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 09:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234738AbiHVND5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 09:03:57 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019F065E7
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 06:03:55 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so11187394pjf.2
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 06:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=xCwRRSOAI8NTFENMJB9POgmpe2aeGgmWc81Fota2RZQ=;
        b=cQprBtTZHQFpLzv2+41gOj70u6H6qx39V2iiBysGguJzbcAK9u8lwqU0xB6DzqE3xN
         fgEK4NxxA8iavdul3svoFSE1oDymCtPWrQLtjaSpUOO4qHul+975UZelVwslwFAUTvbb
         kjezuMksPNHCa0LcbTDQPU9SAI3KSTFdLMFWByj6mXrbrKkyN2/JNBofNvXey5f+EuPN
         r/jpj/9NeBbgtBM2Go0Z48MFSCADhMSvsxYoWemYk4L4Miobnjq9KIo7DrlEX5KS3HMa
         qFkyLB5B5hv3gD/JWKy9obUYrPG3pPEMCT/f/lRBiE6IenAREJEaxsUDx99Ni4MGxDK0
         QL3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=xCwRRSOAI8NTFENMJB9POgmpe2aeGgmWc81Fota2RZQ=;
        b=LapMFDSfxrP8WLNL3TKdmxzAeEDfQVSg693659JxaikGJ4JNmptuRriQMHkHOQT0rX
         IIzS2NdTClhMxSPJmZ2yu63MWGhED3e1azui/qLpbxbxZi5oCSScsJM7DAQXFaU58+Bn
         eC0yN3BvQqwKGSe82NxZGKUqySMYJZy4tqrl2HerjWEExt50NTWKGpyctuVoDl3TpU3A
         Zj0PRJafxHtZP6BDRbEbQbgFVNFhflxfz9eUbYIyLFvlbSoscd+u8LLyzM+lO1sbhVC0
         OLuBBKD7/NOqb5O5iPxOvC4wGVfvYobNOK3RkF5ZHCZnqKNat1XQryxDuSs8S5j52Bjm
         JSEw==
X-Gm-Message-State: ACgBeo05KON0sRlYV7RDwUSFjEBCaqav1ah5u1DqPa6YX5wxyn6pnROB
        KY7XHZ+WaS9hF6uR6MPtAqK2GTlLb3/psH/p4frp2Q==
X-Google-Smtp-Source: AA6agR5eL07OPXjLdDZdPY4zqYAKnvhGdzM/+MIxIyIqRKU6U3n7CoCKAbzZBxprdaqHJo9ki2OFdh+xc5qR2NH+PUw=
X-Received: by 2002:a17:902:c411:b0:170:91ff:884b with SMTP id
 k17-20020a170902c41100b0017091ff884bmr20195671plk.58.1661173434289; Mon, 22
 Aug 2022 06:03:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220819153829.135562864@linuxfoundation.org> <20220819153853.762825860@linuxfoundation.org>
 <20220822111546.GA7795@duo.ucw.cz>
In-Reply-To: <20220822111546.GA7795@duo.ucw.cz>
From:   Jens Wiklander <jens.wiklander@linaro.org>
Date:   Mon, 22 Aug 2022 15:03:43 +0200
Message-ID: <CAHUa44HBBgMtT=xAJYmNPkwZntLt=cNCmE8eb29DWm2+1PxF-g@mail.gmail.com>
Subject: Re: [PATCH 5.10 540/545] tee: add overflow check in register_shm_helper()
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nimish Mishra <neelam.nimish@gmail.com>,
        Anirban Chakraborty <ch.anirban00727@gmail.com>,
        Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>,
        Jerome Forissier <jerome.forissier@linaro.org>,
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

Hi,

On Mon, Aug 22, 2022 at 1:15 PM Pavel Machek <pavel@denx.de> wrote:
>
> Hi!
>
> > From: Jens Wiklander <jens.wiklander@linaro.org>
> >
> > commit 573ae4f13f630d6660008f1974c0a8a29c30e18a upstream.
> >
> > With special lengths supplied by user space, register_shm_helper() has
> > an integer overflow when calculating the number of pages covered by a
> > supplied user space memory region.
> >
> > This causes internal_get_user_pages_fast() a helper function of
> > pin_user_pages_fast() to do a NULL pointer dereference:
>
> Maybe this needs fixing, but this fix adds a memory leak or two. Note
> the goto err, that needs to be done.

Thanks for bringing this up. I believe the best option is to take the
backport I just did for 5.4, it should apply cleanly on the 5.10
stable kernel too.

Greg,  can you cherry-pick the 5.4 backport patch, or would you rather
have an explicit backport for this stable kernel?

Cheers,
Jens

>
> Best regards,
>                                                                 Pavel
>
> Signed-off-by: Pavel Machek <pavel@denx.de>
>
> > +++ b/drivers/tee/tee_shm.c
> > @@ -222,6 +222,9 @@ struct tee_shm *tee_shm_register(struct
> >               goto err;
> >       }
> >
> > +     if (!access_ok((void __user *)addr, length))
> > +             return ERR_PTR(-EFAULT);
> > +
> >       mutex_lock(&teedev->mutex);
> >       shm->id = idr_alloc(&teedev->idr, shm, 1, 0, GFP_KERNEL);
> >       mutex_unlock(&teedev->mutex);
> >
>
>
> diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
> index 6e662fb131d5..283fa50676a2 100644
> --- a/drivers/tee/tee_shm.c
> +++ b/drivers/tee/tee_shm.c
> @@ -222,8 +222,10 @@ struct tee_shm *tee_shm_register(struct tee_context *ctx, unsigned long addr,
>                 goto err;
>         }
>
> -       if (!access_ok((void __user *)addr, length))
> -               return ERR_PTR(-EFAULT);
> +       if (!access_ok((void __user *)addr, length)) {
> +               ret = ERR_PTR(-EFAULT);
> +               goto err;
> +       }
>
>         mutex_lock(&teedev->mutex);
>         shm->id = idr_alloc(&teedev->idr, shm, 1, 0, GFP_KERNEL);
>
> --
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
