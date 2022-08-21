Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 827C459B589
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 18:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiHUQ4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 12:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiHUQzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 12:55:50 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD1D1D31C
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 09:55:49 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id q2so9036058edb.6
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 09:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=lNWfa2sX8vnt5lSJ692rCk7pVfqhgMg2NYeRxVqUOuY=;
        b=O4JxdtOsriCaxkU0Ddyp6gtM+P090AjJwy3irdB1q5Sfg0MfMwHWDqrNkWSGy8cC6p
         dfAJuYcNgG0jnyHdrU6RqPcJ1OkJ0+WK2vw//eRkXsUXJUNmbjxbqBfpyFx+ny8I230f
         gZ6xVyxQPqJ5NHCAs7OS0shcK301Aewe7xwKw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=lNWfa2sX8vnt5lSJ692rCk7pVfqhgMg2NYeRxVqUOuY=;
        b=fBWq7t7QGaoCr4XMEf1Fkt/ET0qRE3tGVB5olyOREzO2y87KrfCTFCB1gKEP1eSPhV
         HPHtFXwilFt03duh0FkVJpXMalRy8fUnBW2LTnyF6dASRd9rz1kWD7dCFGxY8iKNnPeq
         3Yhs0/6626Bn4PTMGgrvIBBgAsq72rG6UWRmqgOM9Jyg7VkCw84ISGt5JPhltbHTcri9
         Z86Oco3N1ofnGk9VZNA2k1vgfDnCQUmpOps7G00ZKQ/joC0pqKcmQYCw9QwHPtaR8Urh
         L3IS53DgnMs2c3yzkIAB+fWZruJsI9VvNGkdY77ohl5Lmxh5biuaVe6cjENRRyvDRPnn
         HHqQ==
X-Gm-Message-State: ACgBeo2CmOzOyY3AXAT1zEW3i1VBaj45NOo5ebAK/BIxgEFxYVoczb5B
        /xDE29S3jbnsBOp7M3gczOzNidkH0qOhybn/
X-Google-Smtp-Source: AA6agR5g+LcN3oQy5RK91W2g0TgVzrqqmuA/rjP7JzK1oxAwxRQLEbHlvkOto+5o+uDbCxFhqS4Z6w==
X-Received: by 2002:a05:6402:2381:b0:446:7a73:e704 with SMTP id j1-20020a056402238100b004467a73e704mr5542878eda.244.1661100948120;
        Sun, 21 Aug 2022 09:55:48 -0700 (PDT)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com. [209.85.128.45])
        by smtp.gmail.com with ESMTPSA id d6-20020a1709063ec600b007389c5a45f0sm1612378ejj.148.2022.08.21.09.55.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Aug 2022 09:55:47 -0700 (PDT)
Received: by mail-wm1-f45.google.com with SMTP id v7-20020a1cac07000000b003a6062a4f81so6574633wme.1
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 09:55:47 -0700 (PDT)
X-Received: by 2002:a05:600c:4ece:b0:3a6:28:bc59 with SMTP id
 g14-20020a05600c4ece00b003a60028bc59mr13151022wmq.154.1661100946855; Sun, 21
 Aug 2022 09:55:46 -0700 (PDT)
MIME-Version: 1.0
References: <1661019430216134@kroah.com>
In-Reply-To: <1661019430216134@kroah.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 21 Aug 2022 09:55:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiCbKaAhzhkSg1Y8DW-WZTkAdQJzXmRpnRBBC1stvKdkA@mail.gmail.com>
Message-ID: <CAHk-=wiCbKaAhzhkSg1Y8DW-WZTkAdQJzXmRpnRBBC1stvKdkA@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] tee: add overflow check in
 register_shm_helper()" failed to apply to 5.4-stable tree
To:     gregkh@linuxfoundation.org
Cc:     jens.wiklander@linaro.org, ch.anirban00727@gmail.com,
        debdeep.mukhopadhyay@gmail.com, jerome.forissier@linaro.org,
        neelam.nimish@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 21, 2022 at 12:00 AM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 5.4-stable tree.

Yeah, there's some major re-org made by commit 53e16519c2ec ("tee:
replace tee_shm_register()") and related in this area in v5.18.

I think you need to just add that

        if (!access_ok((void __user *)data.addr, data.length))
                return -EFAULT;

to tee_ioctl_shm_register() just before the call to tee_shm_register().

It's where it checks "data.flags" too:

        /* Currently no input flags are supported */
        if (data.flags)
                return -EINVAL;

so it lines up with that whole "check ioctl arguments in the memory
block we just copied".

But Jens should probably double-check that.

                Linus
