Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F039434B49
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 14:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhJTMlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 08:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhJTMlI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 08:41:08 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1164C06161C
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 05:38:53 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id o26so12333885ljj.2
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 05:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NmmFZyRq/JdWkpIAyRw3awuGWVvypBTiWbajiWB6AqE=;
        b=V19U88kn4OIHGmbTKoXtE20IRN1Nk76nUdG2ICoolaGpiNyoWcVh1/40ItaHwcC5Ws
         g1Ne8Bl531ur5qyp/P5ofJKapzUZPPlJCHTiNQhpvaRsSQ4Tdls1V1AKEso3rNb1O9ZB
         jGEm2xdO3GVttR7jazj8v7IdrllRgUpIEVwg0OV0q8UJ95BqoyX74Zct0BD6AM/QSHgo
         /CMqdwHFNU/bhWYKV3fcry3Hba3w4HPrQnBNJkv0c09UATW6MA7I3n0i/okhJewrhp7k
         n7aQ7hpZTbS+AM57MGZkizd7tynAFoUjPeVrJbcudsBF56abDsj3pKGTN0rudwGHt+E3
         QrwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NmmFZyRq/JdWkpIAyRw3awuGWVvypBTiWbajiWB6AqE=;
        b=Yb+HP8EKt5mKb0V3semvNNFkx5SxfrPC/yiznfEWNwrnanMUjkbGLZLKFbj4Ic2QkY
         uH6b8HNwql2ZCShICHQB4a3OeDqr7AScwXwXkfUyR5lhz2LNhJMpeXo4L5ikMzVsVPXe
         vpWdiceAUHC8t3mWOyBP6G9CE7MqtBbVFrI1sf3GWU9TaQx9Ym9XpqV5bHYelD5hGtpL
         /p4p57YjvRsNSZqQpzCWICnesxkvwKmyobkJ4FEaRwkLQLxuiQ2Dyry0yXe3vBGe4Vnp
         +p8AqT/Zn5FF7l7BDzG3PofmFGS7Qo8a1u08wlpkLCi4QfafpWWnedI2NT0lVBzEd+J6
         5SRg==
X-Gm-Message-State: AOAM532mpJi8uej1oIkb4XikSMs4Grlw+AfADRnZuayWSP0/a0188DqC
        3tFwfa2sFH2e7rDmuxWj2Q4KVcrmQ7HzHhCmxc0cXIRlHpkoiA==
X-Google-Smtp-Source: ABdhPJyHVvQat4LtC0UBPWdbQz/f1w8CoUNe2aG3exWZEdGWk8V1T3ybxnmKKGrqB1HmAkPiLMs3AkOb1Aq+BlhQUSE=
X-Received: by 2002:a2e:7816:: with SMTP id t22mr14299512ljc.133.1634733531976;
 Wed, 20 Oct 2021 05:38:51 -0700 (PDT)
MIME-Version: 1.0
References: <20211019094532.470845-1-sumit.garg@linaro.org>
 <YXAM1xA86BWW6jKu@kroah.com> <YXANfcekdo+gdkjh@kroah.com>
In-Reply-To: <YXANfcekdo+gdkjh@kroah.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Wed, 20 Oct 2021 18:08:40 +0530
Message-ID: <CAFA6WYOKpxbUNhdyCSDFb=zcj4RXV9mV3NG22FSdpfC+Jm7qyA@mail.gmail.com>
Subject: Re: [PATCH backport for 5.4] tee: optee: Fix missing devices
 unregister during optee_remove
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 20 Oct 2021 at 18:07, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Oct 20, 2021 at 02:34:31PM +0200, Greg KH wrote:
> > On Tue, Oct 19, 2021 at 03:15:32PM +0530, Sumit Garg wrote:
> > > upstream commit 7f565d0ead26
> > >
> > > When OP-TEE driver is built as a module, OP-TEE client devices
> > > registered on TEE bus during probe should be unregistered during
> > > optee_remove. So implement optee_unregister_devices() accordingly.
> > >
> > > Fixes: c3fa24af9244 ("tee: optee: add TEE bus device enumeration support")
> > > Reported-by: Sudeep Holla <sudeep.holla@arm.com>
> > > Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> > > Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> > > [SG: backport to 5.4, dev name s/optee-ta/optee-clnt/]
> > > Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> > > ---
> > >  drivers/tee/optee/core.c          |  3 +++
> > >  drivers/tee/optee/device.c        | 22 ++++++++++++++++++++++
> > >  drivers/tee/optee/optee_private.h |  1 +
> > >  3 files changed, 26 insertions(+)
> >
> > Doesn't this also need to go into 5.10 and 5.14?  We can not have people
> > upgrading and having regressions.
> >
> > Can you provide backports for those trees too?  I can not take just this
> > one, sorry.
>
> Nevermind, it's already there, sorry for the noise, I'll go queue this
> up right now...
>

Thanks

-Sumit

> greg k-h
