Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261DC6C3F53
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 01:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjCVAuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 20:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjCVAuX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 20:50:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66793136D3;
        Tue, 21 Mar 2023 17:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F32EC61EE6;
        Wed, 22 Mar 2023 00:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5406AC433A0;
        Wed, 22 Mar 2023 00:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679446221;
        bh=SJKVK6p4AtYmszF8lugRN21TQIYOoR26Llx9z3PyX8k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tth7EvCATjE3kn4C1Rk1Iw+REgcwOr5xpsQTu7pKPyrEGTwSZAjerPMCqRUAvl8AA
         f+Gn8BQhqKIEKvpi5JwPHnN0F56beQ8Hff/aaOgOXoRCMV8X+oG0320J+4Z6v2/O2r
         T/iDIVyXakS0g7zA4oI4bdM6gLGiynzNiT1HMHNN/fcgSxTUxtHkvLwbBssy1hnKfx
         1nnRaLBAnLl5M3J+HE3j0d/LxwtqIEvSG+m/4/DrECN5iDeAT6JxglUULIgtK6WHKt
         G7Jpba+BAR3RGIUM5XiwGFKocPJbSPN/2Tacs8uUReSAxXIUFSwCSpTeLdmu058Eht
         fVUxzlH5JRb8Q==
Received: by mail-ed1-f43.google.com with SMTP id r11so66677024edd.5;
        Tue, 21 Mar 2023 17:50:21 -0700 (PDT)
X-Gm-Message-State: AO0yUKU597s3ADXr57RgG3f5jRPbaJJgAveXbVV174NC8JEtj50XnO5/
        MjU02p0+RK+vA2kUO2Mbog4cxjWCQzsiYw/Y2Xs=
X-Google-Smtp-Source: AK7set/zpKc1XeHOstNzTgHRX4aMPo7mIR05JSNxH7VOuJCZyVvpSh/MGnVJcHRxpHLWGq/bW6cm20mvQIFwEMVw0UQ=
X-Received: by 2002:a50:9ea8:0:b0:4fb:f19:883 with SMTP id a37-20020a509ea8000000b004fb0f190883mr2702940edf.1.1679446219443;
 Tue, 21 Mar 2023 17:50:19 -0700 (PDT)
MIME-Version: 1.0
References: <1679380154-20308-1-git-send-email-yangtiezhu@loongson.cn>
 <253a5dfcb7e41e44d15232e1891e7ea9d39dc953.camel@xry111.site> <f61ac027-0068-40f0-87bd-17f916141884@roeck-us.net>
In-Reply-To: <f61ac027-0068-40f0-87bd-17f916141884@roeck-us.net>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Wed, 22 Mar 2023 08:50:07 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5kFRt9z0U_TqSQeqX9WuUJ2cg0LOboUXHp-fLR0PoTJg@mail.gmail.com>
Message-ID: <CAAhV-H5kFRt9z0U_TqSQeqX9WuUJ2cg0LOboUXHp-fLR0PoTJg@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: Check unwind_error() in arch_stack_walk()
To:     Guenter Roeck <linux@roeck-us.net>, stable <stable@vger.kernel.org>
Cc:     Xi Ruoyao <xry111@xry111.site>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev,
        linux-kernel@vger.kernel.org, loongson-kernel@lists.loongnix.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 21, 2023 at 10:25=E2=80=AFPM Guenter Roeck <linux@roeck-us.net>=
 wrote:
>
> On Tue, Mar 21, 2023 at 08:35:34PM +0800, Xi Ruoyao wrote:
> > On Tue, 2023-03-21 at 14:29 +0800, Tiezhu Yang wrote:
> > > We can see the following messages with CONFIG_PROVE_LOCKING=3Dy on
> > > LoongArch:
> > >
> > >   BUG: MAX_STACK_TRACE_ENTRIES too low!
> > >   turning off the locking correctness validator.
> > >
> > > This is because stack_trace_save() returns a big value after call
> > > arch_stack_walk(), here is the call trace:
> > >
> > >   save_trace()
> > >     stack_trace_save()
> > >       arch_stack_walk()
> > >         stack_trace_consume_entry()
> > >
> > > arch_stack_walk() should return immediately if unwind_next_frame()
> > > failed, no need to do the useless loops to increase the value of
> > > c->len in stack_trace_consume_entry(), then we can fix the above
> > > problem.
> > >
> > > Reported-by: Guenter Roeck <linux@roeck-us.net>
> > > Link: https://lore.kernel.org/all/8a44ad71-68d2-4926-892f-72bfc7a67e2=
a@roeck-us.net/
> > > Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> >
> > The fix makes sense, but I'm asking the same question again (sorry if
> > it's noisy): should we Cc stable@vger.kernel.org and/or make a PR for
> > 6.3?
> >
> > To me a bug fixes should be backported into all stable branches affecte=
d
> > by the bug, unless there is some serious difficulty.  As 6.3 release
> > will work on launched 3A5000 boards out-of-box, people may want to stop
> > staying on the leading edge and use a LTS/stable release series. We
> > can't just say (or behave like) "we don't backport, please use latest
> > mainline" IMO :).
>
> It is a bug fix, isn't it ? It should be backported to v6.1+. Otherwise,
> if your policy is to not backport bug fixes, I might as well stop testing
> loongarch on all but the most recent kernel branch. Let me know if this i=
s
> what you want. If so, I think you should let all other regression testers
> know that they should only test loongarch on mainline and possibly on
> linux-next.
This is of course a bug fix, but should Tiezhu resend this patch? Or
just replying to this message with CC stable@vger.kernel.org is
enough?

Huacai
>
> Thanks,
> Guenter
