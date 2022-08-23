Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B5859D1AA
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 09:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240214AbiHWHA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 03:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240805AbiHWHA4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 03:00:56 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E010461B04
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 00:00:55 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id s3-20020a17090a2f0300b001facfc6fdbcso13027623pjd.1
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 00:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=ERdLQBB5rdVufIOCky9n/iOBBoNT1Gyy6OUXD7n8kvU=;
        b=gz0F+meb1/oWxi6gjALI2tzx11WQpxrqNqBlbE0LgNwZVMvwhfknsWkOj61lvX6fuf
         ciioGaGUOaYHVChmkXACPXlTubu2hhOH0jgS7OLJhoHH7QzwUd6TEGX8AAxGoUjZ/rCU
         tIdBOpw0xd24PuVhD8b20z9m0P/+OW4sbWC22oGTkVC8U4m+j4kQP3RgIVMgz3+QfqbD
         ID7D1PyMwYbyOLFaZbjcKeKqJRPCoZ87aXGwCWdWJT041+MhrQbWJYJCjZUxC0BGZGCC
         7VTfoSGs+XkCsb0cp/64OlAvd1uhVomiJa0vPY3ZS/HbpXE+22dgRdrwgwxKcHt0g2h9
         PQvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ERdLQBB5rdVufIOCky9n/iOBBoNT1Gyy6OUXD7n8kvU=;
        b=6PfXP2289LJSBHChFPd0WYGf4P2+K3sATCU9ICk+2Jidm7VkHbXjAo4HRZJpTI7+tt
         FTsnc4ZQsFdsS7zIbdfxwqVQAeQ3cAwb7QDn6rzxHu75sRBYgoe+zFRA3aUjy9pmtZQk
         Dot2GWH2C9HSkAJVInx9n6yTSzpKUltRJODR3jB++Vy8PP8u190pT5k2NILoilaoVYr3
         wp39F182JUJK4p6eWr/3NQTxf8G7h/4AsOXkH1sKgF+ZODYd8aHteCm4VqhT6fEnhje4
         xje+iqqvep1oh8bx6nPPF/x98II7WuG+vRYa7t5z1GsVwdhanzAMzB8RDNnZO1DIXpHI
         6kCQ==
X-Gm-Message-State: ACgBeo3aZ2uI2zxuUzX7Vr3RAoNtUz3CcWKLSLVDqY/r2v8AyLiWafWD
        CWUdMML8CL139dJRTSoX8LxImP3fw3OJgSn11BtFpQ==
X-Google-Smtp-Source: AA6agR4H653kK0mfcPZgOtyeqWGqxuPFySZidYH+rEBZZBwZHt2RQ4jGh7zZaQKrRkImBMd10bH+RbLP2Y2s0OXzlm0=
X-Received: by 2002:a17:902:f684:b0:172:d54d:6f9e with SMTP id
 l4-20020a170902f68400b00172d54d6f9emr13464944plg.174.1661238054934; Tue, 23
 Aug 2022 00:00:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220822131227.3865684-1-jens.wiklander@linaro.org>
 <YwOFX8eXYmZrsl/n@kroah.com> <CAHUa44Ein2WMDtBeBHU+MQULFBonQ1LYXCuQTCO+rrmfxunbNw@mail.gmail.com>
 <YwOZYRYSke8N1Tpr@kroah.com>
In-Reply-To: <YwOZYRYSke8N1Tpr@kroah.com>
From:   Jens Wiklander <jens.wiklander@linaro.org>
Date:   Tue, 23 Aug 2022 09:00:43 +0200
Message-ID: <CAHUa44GdJQDmAtSyM5uYSoc4JX_EfrG9zSHCJgx4Jf+qU6LS_g@mail.gmail.com>
Subject: Re: [PATCH] tee: add overflow check in tee_ioctl_shm_register()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Jerome Forissier <jerome.forissier@linaro.org>,
        Nimish Mishra <neelam.nimish@gmail.com>,
        Anirban Chakraborty <ch.anirban00727@gmail.com>,
        Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@denx.de>
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

On Mon, Aug 22, 2022 at 4:57 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Aug 22, 2022 at 04:29:05PM +0200, Jens Wiklander wrote:
> > On Mon, Aug 22, 2022 at 3:32 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Mon, Aug 22, 2022 at 03:12:27PM +0200, Jens Wiklander wrote:
> > > > commit 573ae4f13f630d6660008f1974c0a8a29c30e18a upstream.
> > > >
> > > > With special lengths supplied by user space, tee_shm_register() has
> > > > an integer overflow when calculating the number of pages covered by a
> > > > supplied user space memory region.
> > > >
> > > > This may cause pin_user_pages_fast() to do a NULL pointer dereference.
> > > >
> > > > Fix this by adding an an explicit call to access_ok() in
> > > > tee_ioctl_shm_register() to catch an invalid user space address early.
> > > >
> > > > Fixes: 033ddf12bcf5 ("tee: add register user memory")
> > > > Cc: stable@vger.kernel.org # 5.4
> > > > Cc: stable@vger.kernel.org # 5.10
> > > > Reported-by: Nimish Mishra <neelam.nimish@gmail.com>
> > > > Reported-by: Anirban Chakraborty <ch.anirban00727@gmail.com>
> > > > Reported-by: Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>
> > > > Suggested-by: Jerome Forissier <jerome.forissier@linaro.org>
> > > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > > [JW: backport to stable 5.4 and 5.10 + update commit message]
> > >
> > > You already sent me a 5.4 version here:
> > >         https://lore.kernel.org/r/20220822092621.3691771-1-jens.wiklander@linaro.org
> > >
> > > And I applied that.
> > >
> > > And for 5.10, it's already in the tree as commit 578c349570d2 ("tee: add
> > > overflow check in register_shm_helper()") and was in the 5.10.137
> > > release.
> > >
> > > > Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> > > > ---
> > > >  drivers/tee/tee_core.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > >
> > > > diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
> > > > index a7ccd4d2bd10..2db144d2d26f 100644
> > > > --- a/drivers/tee/tee_core.c
> > > > +++ b/drivers/tee/tee_core.c
> > > > @@ -182,6 +182,9 @@ tee_ioctl_shm_register(struct tee_context *ctx,
> > > >       if (data.flags)
> > > >               return -EINVAL;
> > > >
> > > > +     if (!access_ok((void __user *)(unsigned long)data.addr, data.length))
> > > > +             return -EFAULT;
> > >
> > > What I took in 5.10.137 was:
> > >
> > > +       if (!access_ok((void __user *)addr, length))
> > > +               return ERR_PTR(-EFAULT);
> > >
> > > Should I fix it up to look like what you sent here instead?
> >
> > Yes, please.
>
> Ok, no, that does not work on 5.10.y at all, it blows up with the
> obvious issue that there is no data pointer in this function.  It's also
> in a different file, drivers/tee/tee_shm.c
>
> So I'm going to leave 5.10.y alone for now, I think it's fixed.

It works somewhat, but there's the potential memory leak that Pavel
Machek pointed out,
https://lore.kernel.org/lkml/20220822111546.GA7795@duo.ucw.cz/ .

The 5.4 patch has a better approach since it verifies the supplied
address range early before we do anything that must be undone on
error.
The 5.4 patch changes  tee_ioctl_shm_register() instead, which is the
function one step up in the call chain. This approach should be taken
for all kernels before 53e16519c2ec ("tee: replace
tee_shm_register()"), that is, before v5.18 if I'm reading the git log
correctly.

access_ok() went from taking three arguments to two sometime after
v4.19, why that patch is slightly different.

>
> I've taken your 5.4 patch that you sent previously, and still need a
> 4.19.y change (and any older kernels that are also vulnerable.)

The oldest vulnerable kernel is v4.16.

Thanks,
Jens

>
> thanks,
>
> greg k-h
