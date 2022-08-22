Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14C4E59BF3F
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 14:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiHVMHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 08:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233467AbiHVMHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 08:07:46 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFE239BBC
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 05:07:45 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso13788814pjk.0
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 05:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=hVzibnCopXeSOVD5KhXgMM0roqftEojLdUhrsyWiOtY=;
        b=ozrhkAmAHz5jiuj8Mww6B9MZ2fXfc0Dtp626aZGhDOOCKJehZpejWVMbq0AVeAxdmI
         VepV0fJqAsgJzxXPSMeMf3p+HZTx+M7E+HT59hxX8A7KXYrKkf/9Cbu0ogVNdi5rj+9w
         6TX7m4TUiLyg1p+Mr4ciwdswcUmjzccjfnhoXhhYwboVC8Y8BuOIj3UyB3GicODhsiv9
         LnnU54L2gZe1V5E35y53oMbkCf9nP6YsO6ZmF4zOVlZIVZas2MR0JEzka+7SpWt+2g45
         Ohv+3oBDkn6Hmm0efUtLcpvTaxa5U8IEUBl7ZD5ZImnAF3YfSRYQLRMm/U08V5o3xAAI
         3vQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=hVzibnCopXeSOVD5KhXgMM0roqftEojLdUhrsyWiOtY=;
        b=K0K5lKPWzRZ80BWs3yCt+mKZuJ9kuFUcFHFV2Jj94queEKzl6IRAV2IXoOR00MmByC
         wgvMmHFo4+HWtbpnRJjv7PcHUVF/DxBZ7UqcrIUHKgQdi51F5muUe4UCUey0BUuAqIcM
         OW642UHLr4WFkoZHedWxiZoPRxLvPlzY5v/jIqF3djlgEEq3SKUXZxFpFZRBC0Zd7P5Q
         fUXZNzhUGLw74EGRGPDFXQlZrtFNKTe1fCXdka8AbjcF/qPqMj96yQU4RDB326MeKQ8Z
         wnQD2ONVBLtJhcFH+3Eyo1UZa+jeQjhyN8HnWMw5XIOs/aLU316mBAn/UiwUYvSGc7hX
         9idQ==
X-Gm-Message-State: ACgBeo15bTl3HYcmpc4KSFMKJS94dDtkUm2oYa5ubSP5qHT006iHqq2f
        JQqBSaRpCyWHMN5R4GCuQyFWwCYSrIZm17k7UyG2Fg==
X-Google-Smtp-Source: AA6agR7iT0bxvObjEhDfuKNtTJ0jGL8t6aUzhuExqJsaPc3FQgbP9unZa+fB5y902zreGxsO+RHIQb0RPHCkDcCVkck=
X-Received: by 2002:a17:902:d50b:b0:172:a41f:b204 with SMTP id
 b11-20020a170902d50b00b00172a41fb204mr19617232plg.70.1661170064646; Mon, 22
 Aug 2022 05:07:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220822092621.3691771-1-jens.wiklander@linaro.org>
 <YwNTdQTj8SC/wnYD@kroah.com> <YwNT8tkhHl6K5D2L@kroah.com>
In-Reply-To: <YwNT8tkhHl6K5D2L@kroah.com>
From:   Jens Wiklander <jens.wiklander@linaro.org>
Date:   Mon, 22 Aug 2022 14:07:33 +0200
Message-ID: <CAHUa44Ehnuuwpw9apQWcgyMqrgfTaGvP=g+EsH3Y-phkgj+AGA@mail.gmail.com>
Subject: Re: [PATCH] tee: add overflow check in tee_ioctl_shm_register()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Jerome Forissier <jerome.forissier@linaro.org>,
        Nimish Mishra <neelam.nimish@gmail.com>,
        Anirban Chakraborty <ch.anirban00727@gmail.com>,
        Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 22, 2022 at 12:01 PM Greg KH <gregkh@linuxfoundation.org> wrote=
:
>
> On Mon, Aug 22, 2022 at 11:59:17AM +0200, Greg KH wrote:
> > On Mon, Aug 22, 2022 at 11:26:21AM +0200, Jens Wiklander wrote:
> > > commit 573ae4f13f630d6660008f1974c0a8a29c30e18a upstream.
> > >
> > > With special lengths supplied by user space, tee_shm_register() has
> > > an integer overflow when calculating the number of pages covered by a
> > > supplied user space memory region.
> > >
> > > This may cause pin_user_pages_fast() to do a NULL pointer dereference=
.
> > >
> > > Fix this by adding an an explicit call to access_ok() in
> > > tee_ioctl_shm_register() to catch an invalid user space address early=
.
> > >
> > > Fixes: 033ddf12bcf5 ("tee: add register user memory")
> > > Cc: stable@vger.kernel.org # 5.4
> > > Reported-by: Nimish Mishra <neelam.nimish@gmail.com>
> > > Reported-by: Anirban Chakraborty <ch.anirban00727@gmail.com>
> > > Reported-by: Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>
> > > Suggested-by: Jerome Forissier <jerome.forissier@linaro.org>
> > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > [JW: backport to stable-5.4 + update commit message]
> >
> > Will this also work for 4.19?
>
> Nope, it breaks the build on 4.19.y, needs a different backport there:

Yeah, I'm just about to post a 4.19.y backport too.

Cheers,
Jens

>
>   CC [M]  drivers/tee/tee_core.o
> drivers/tee/tee_core.c: In function =E2=80=98tee_ioctl_shm_register=E2=80=
=99:
> drivers/tee/tee_core.c:178:76: error: macro "access_ok" requires 3 argume=
nts, but only 2 given
>   178 |         if (!access_ok((void __user *)(unsigned long)data.addr, d=
ata.length))
>       |                                                                  =
          ^
> In file included from ./include/linux/uaccess.h:14,
>                  from drivers/tee/tee_core.c:24:
> ./arch/x86/include/asm/uaccess.h:98: note: macro "access_ok" defined here
>    98 | #define access_ok(type, addr, size)                              =
       \
>       |
> drivers/tee/tee_core.c:178:14: error: =E2=80=98access_ok=E2=80=99 undecla=
red (first use in this function)
>   178 |         if (!access_ok((void __user *)(unsigned long)data.addr, d=
ata.length))
>       |              ^~~~~~~~~
>
>
