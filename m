Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97A9620964
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 07:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiKHGMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 01:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiKHGMO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 01:12:14 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0522A3FBA4
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 22:12:14 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 6so4407256pgm.6
        for <stable@vger.kernel.org>; Mon, 07 Nov 2022 22:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rrhlKpiPfR5EYKkIu4Rgxx3hdXSEND+CICgdRqZPSKY=;
        b=sJv+Hm9CFOT4Ovo+Um5IhOpOWRTS6nzFEtBXL9DHZf1y5QSFYmMLxSnsrZeqtRodNf
         8hJMQcD9gM9FJ8zPDsbD8guUER9Qvk8ajT0dyg2b1NBX2N5pZDicQvaEaMVhYBZookg6
         yw/9mkh8sNnSACD73tYqPp5vFz8hTVwNNGHX/WusW9UfsAjF70pKN6YcNh2MTz7zZNaW
         pDxkArMFZnCA3ebWOiU6CVp32sKBexy74af1eiQndtcpaOLoK0KhtDuWVKSYz/jHlydk
         aE5UNTfwQsHppv/08kSxLW/5qSzKE7vPIqgn1sCu+4vlGAHuZ2zYhfIHkq+YpzyZIGZs
         xJgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rrhlKpiPfR5EYKkIu4Rgxx3hdXSEND+CICgdRqZPSKY=;
        b=6fLoX+Yb1FbfbkKP0JslCljDiDKCjs5VE8X1FlrmcqiCpC+L+2INARatxjgx77iWHx
         Q+2sGjHCJHhSeZzS+O4xrShNBSigPqScv1Yd2ztAm88wCphFD0YGEU6cndbDfW23fIaD
         hb9+LMhektR6dl4aV8eu2hRnWtw4oUdymcNP5ucFxXn2Ys3JIV6xGvmJYpjwTJVPSC0R
         3wN/PB1quRjJtzFHLdrbTCrYDu/4gCbg+I2ordEuMYtNSd8CpcugWrnCKiuAzQGWWmn1
         C1rK4A3ilqyJnxy0PJCtrPz9+YhaQWZjDzaCtwPco9+AtuQqNo/d3x1kjO/UshjqkVcv
         l0Pg==
X-Gm-Message-State: ACrzQf3i8MrskwQf92+Z2jK3fgOOZnRGCbRC2igpLPwnAZ/oxTGEoJyu
        x1/3pZP56FwKYnfENznYO1fVTjUSbf5RNzOen62ZqA==
X-Google-Smtp-Source: AMsMyM4Hks0fafiofZPYgodcZA6CdJjUMrfn55SMITmLu7pKSkytoHYPhxbwIi/s2bnMb726iyDs+/AmwbwkgkdD7So=
X-Received: by 2002:a63:db42:0:b0:45c:9c73:d72e with SMTP id
 x2-20020a63db42000000b0045c9c73d72emr45129001pgi.181.1667887933402; Mon, 07
 Nov 2022 22:12:13 -0800 (PST)
MIME-Version: 1.0
References: <20220822131227.3865684-1-jens.wiklander@linaro.org>
In-Reply-To: <20220822131227.3865684-1-jens.wiklander@linaro.org>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Tue, 8 Nov 2022 11:42:01 +0530
Message-ID: <CAFA6WYNwk+dT_Kb3xsUQ1u5KvX+RpLwXtom6fruBbTe9W56s8Q@mail.gmail.com>
Subject: Re: [PATCH] tee: add overflow check in tee_ioctl_shm_register()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Jens Wiklander <jens.wiklander@linaro.org>,
        Jerome Forissier <jerome.forissier@linaro.org>,
        Nimish Mishra <neelam.nimish@gmail.com>,
        Anirban Chakraborty <ch.anirban00727@gmail.com>,
        Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        sahil.malhotra@nxp.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, 22 Aug 2022 at 18:42, Jens Wiklander <jens.wiklander@linaro.org> wrote:
>
> commit 573ae4f13f630d6660008f1974c0a8a29c30e18a upstream.
>
> With special lengths supplied by user space, tee_shm_register() has
> an integer overflow when calculating the number of pages covered by a
> supplied user space memory region.
>
> This may cause pin_user_pages_fast() to do a NULL pointer dereference.
>
> Fix this by adding an an explicit call to access_ok() in
> tee_ioctl_shm_register() to catch an invalid user space address early.
>
> Fixes: 033ddf12bcf5 ("tee: add register user memory")
> Cc: stable@vger.kernel.org # 5.4
> Cc: stable@vger.kernel.org # 5.10
> Reported-by: Nimish Mishra <neelam.nimish@gmail.com>
> Reported-by: Anirban Chakraborty <ch.anirban00727@gmail.com>
> Reported-by: Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>
> Suggested-by: Jerome Forissier <jerome.forissier@linaro.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> [JW: backport to stable 5.4 and 5.10 + update commit message]
> Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> ---
>  drivers/tee/tee_core.c | 3 +++
>  1 file changed, 3 insertions(+)
>

The v5.15 backport [1] for this fix has broken the kernel consumers
for tee_shm_register(), the trusted keys driver is one of them
reported here [2]. We need to fix that up with the following change
[3]. Would you like to revert the backport and apply the correct one
or should I prepare a fix patch for the following [3]?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.15.y&id=c12f0e6126ad223806a365084e86370511654bf1

[2] https://github.com/OP-TEE/optee_os/issues/5624

[3]

diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
index 3fc426dad2df..d5c4fcd8733d 100644
--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -334,6 +334,9 @@ tee_ioctl_shm_register(struct tee_context *ctx,
        if (data.flags)
                return -EINVAL;

+       if (!access_ok((void __user *)data.addr, data.length))
+               return ERR_PTR(-EFAULT);
+
        shm = tee_shm_register(ctx, data.addr, data.length,
                               TEE_SHM_DMA_BUF | TEE_SHM_USER_MAPPED);
        if (IS_ERR(shm))
diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
index bd96ebb82c8e..6fb4400333fb 100644
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -223,9 +223,6 @@ struct tee_shm *tee_shm_register(struct
tee_context *ctx, unsigned long addr,
                goto err;
        }

-       if (!access_ok((void __user *)addr, length))
-               return ERR_PTR(-EFAULT);
-
        mutex_lock(&teedev->mutex);
        shm->id = idr_alloc(&teedev->idr, shm, 1, 0, GFP_KERNEL);
        mutex_unlock(&teedev->mutex);

-Sumit

> diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
> index a7ccd4d2bd10..2db144d2d26f 100644
> --- a/drivers/tee/tee_core.c
> +++ b/drivers/tee/tee_core.c
> @@ -182,6 +182,9 @@ tee_ioctl_shm_register(struct tee_context *ctx,
>         if (data.flags)
>                 return -EINVAL;
>
> +       if (!access_ok((void __user *)(unsigned long)data.addr, data.length))
> +               return -EFAULT;
> +
>         shm = tee_shm_register(ctx, data.addr, data.length,
>                                TEE_SHM_DMA_BUF | TEE_SHM_USER_MAPPED);
>         if (IS_ERR(shm))
> --
> 2.31.1
>
