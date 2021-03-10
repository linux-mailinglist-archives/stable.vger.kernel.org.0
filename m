Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA443346AF
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 19:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhCJS1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 13:27:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:38748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233514AbhCJS1c (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 13:27:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9064F64F9A;
        Wed, 10 Mar 2021 18:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615400852;
        bh=aEh3imEtTS6FERscWfpt/m6v5j+dyVcy0L7xTjrmVuM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y2mQPlSUo7YdAGlWHzqn0bPetOcSuDG4fijvR6g3XbDdTy739GeJ2g1UpNk3rPPYI
         kBnHVk5PGafPh+rLOCmgxZPfCOHGaOIyCS+gSykUsrQaQPEJsv7oFLdZC4LQI/xJgj
         vEbEpyPZ7KJ1EUH0fCMJAsHhRiggiQPhJlazQ/sU=
Date:   Wed, 10 Mar 2021 19:27:30 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Alex Elder <elder@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.10 14/49] net: ipa: ignore CHANNEL_NOT_RUNNING errors
Message-ID: <YEkPkgYAe7Xmb6Wo@kroah.com>
References: <20210310132321.948258062@linuxfoundation.org>
 <20210310132322.413240905@linuxfoundation.org>
 <CA+G9fYthEr7TtFBpAXxQfDtwxCe+qg=bbE74nPQ+mpGmSSJ2dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYthEr7TtFBpAXxQfDtwxCe+qg=bbE74nPQ+mpGmSSJ2dw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 11:06:09PM +0530, Naresh Kamboju wrote:
> On Wed, 10 Mar 2021 at 18:56, <gregkh@linuxfoundation.org> wrote:
> >
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > From: Alex Elder <elder@linaro.org>
> >
> > [ Upstream commit f849afcc8c3b27d7b50827e95b60557f24184df0 ]
> >
> > IPA v4.2 has a hardware quirk that requires the AP to allocate GSI
> > channels for the modem to use.  It is recommended that these modem
> > channels get stopped (with a HALT generic command) by the AP when
> > its IPA driver gets removed.
> >
> > The AP has no way of knowing the current state of a modem channel.
> > So when the IPA driver issues a HALT command it's possible the
> > channel is not running, and in that case we get an error indication.
> > This error simply means we didn't need to stop the channel, so we
> > can ignore it.
> >
> > This patch adds an explanation for this situation, and arranges for
> > this condition to *not* report an error message.
> >
> > Signed-off-by: Alex Elder <elder@linaro.org>
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/net/ipa/gsi.c | 24 +++++++++++++++++++++++-
> >  1 file changed, 23 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
> > index 2a65efd3e8da..48ee43b89fec 100644
> > --- a/drivers/net/ipa/gsi.c
> > +++ b/drivers/net/ipa/gsi.c
> > @@ -1052,10 +1052,32 @@ static void gsi_isr_gp_int1(struct gsi *gsi)
> >         u32 result;
> >         u32 val;
> >
> > +       /* This interrupt is used to handle completions of the two GENERIC
> > +        * GSI commands.  We use these to allocate and halt channels on
> > +        * the modem's behalf due to a hardware quirk on IPA v4.2.  Once
> > +        * allocated, the modem "owns" these channels, and as a result we
> > +        * have no way of knowing the channel's state at any given time.
> > +        *
> > +        * It is recommended that we halt the modem channels we allocated
> > +        * when shutting down, but it's possible the channel isn't running
> > +        * at the time we issue the HALT command.  We'll get an error in
> > +        * that case, but it's harmless (the channel is already halted).
> > +        *
> > +        * For this reason, we silently ignore a CHANNEL_NOT_RUNNING error
> > +        * if we receive it.
> > +        */
> >         val = ioread32(gsi->virt + GSI_CNTXT_SCRATCH_0_OFFSET);
> >         result = u32_get_bits(val, GENERIC_EE_RESULT_FMASK);
> > -       if (result != GENERIC_EE_SUCCESS_FVAL)
> > +
> > +       switch (result) {
> > +       case GENERIC_EE_SUCCESS_FVAL:
> > +       case GENERIC_EE_CHANNEL_NOT_RUNNING_FVAL:
> 
> 
> While building stable rc 5.10 for arm64 the build failed due to
> the following errors / warnings.
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=arm64
> CROSS_COMPILE=aarch64-linux-gnu- 'HOSTCC=sccache clang' 'CC=sccache
> clang'
> drivers/net/ipa/gsi.c:1074:7: error: use of undeclared identifier
> 'GENERIC_EE_CHANNEL_NOT_RUNNING_FVAL'
>         case GENERIC_EE_CHANNEL_NOT_RUNNING_FVAL:
>              ^
> 1 error generated.
> make[4]: *** [scripts/Makefile.build:279: drivers/net/ipa/gsi.o] Error 1
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Build log link,
> https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1086862412#L210

I'll go drop this and push out a -rc2 now, thanks.

greg k-h
