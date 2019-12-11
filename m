Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A62111AA9A
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 13:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbfLKMTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 07:19:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:34874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727365AbfLKMTt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 07:19:49 -0500
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE25D214D8
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 12:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576066789;
        bh=iUFhXuJqEXdM7iMJ99jebuqjwRWrpm8Pifh/3QOj3oI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kIzbyf3uNEgulvHWgMgDZSqPh5E4M8BK/2o+pKdQOyDPu1wEjTU7Xdm6j0zA+8kmG
         r/JRgzw8peiWcDNNdOWKNHH5lFXDshsLd/j0SApQQ/Htj1TgOik5TwF89q4wi1+640
         yArBNVyQ8bwKcKenB+Qw9wRnEcLNsfSatFqi/FCc=
Received: by mail-wr1-f49.google.com with SMTP id y11so23778817wrt.6
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 04:19:48 -0800 (PST)
X-Gm-Message-State: APjAAAVZdDZSeII1OuUr2i7C/0Xj0sld+VBrW1DDgHKfr4WQ1qs3468d
        RCOoRTbKntP0ive3zDCI+IkTL5rIo9gIg/PXNMA=
X-Google-Smtp-Source: APXvYqzXWQULa8j7GpBaBpQ7Cd20aMHoijBM0inYfLAQUL5euAAxcU7Nom7R8iIrqJjmZpbOtAvwcflT4+BuWtH6cPw=
X-Received: by 2002:adf:cf12:: with SMTP id o18mr3572428wrj.361.1576066786247;
 Wed, 11 Dec 2019 04:19:46 -0800 (PST)
MIME-Version: 1.0
References: <TYAPR01MB228505DBC22568339F914C15B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191209173637.GF1290729@kroah.com> <TYAPR01MB2285135B15E6A152163E1A1AB7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191210073514.GB3077639@kroah.com> <TYAPR01MB2285B5834B1FBA71F8DA512BB75B0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191210145528.GA4012363@kroah.com> <TYAPR01MB2285433EA1E6DF9EC621E31AB75B0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191210205951.GA4081499@kroah.com> <TYAPR01MB22852454802BAB486871D944B75A0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
In-Reply-To: <TYAPR01MB22852454802BAB486871D944B75A0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
From:   Chen-Yu Tsai <wens@kernel.org>
Date:   Wed, 11 Dec 2019 20:19:36 +0800
X-Gmail-Original-Message-ID: <CAGb2v66mXBtyypam9iPbT_=cpm-ZYSpFqDBA9f3mxM9ME8q-ug@mail.gmail.com>
Message-ID: <CAGb2v66mXBtyypam9iPbT_=cpm-ZYSpFqDBA9f3mxM9ME8q-ug@mail.gmail.com>
Subject: Re: Linux 4.19.89-rc1 5944fcdd errors
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "cip-dev@lists.cip-project.org" <cip-dev@lists.cip-project.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 6:52 PM Chris Paterson
<Chris.Paterson2@renesas.com> wrote:
>
> Hello Greg,
>
> [...]
>
> > > > That's a lot, are these all new?
> > >
> > > I've only just started building with this config in our CI setup, but
> > > building the dtbs locally with v4.19.88 didn't produce these results
> > > for me (and building locally with v4.19.89-rc1 does result in the
> > > above issues).
> >
> > Any chance you can run 'git bisect' to track down the offending patch?
>
> The two dtbs that fail to build are fixed by reverting by the patches below:
>
> > allwinner/sun50i-a64-pinebook.dtb
> ea03518a3123 ("arm64: dts: allwinner: a64: enable sound on Pinebook")

I suggest dropping this if possible. It depends on another dtsi patch,

    ec4a95409d5c arm64: dts: allwinner: a64: add nodes necessary for
analog sound support

and multiple driver patches

    55b407f6468c ASoC: sun8i-codec-analog: split regmap code into
separate driver
    42371f327df0 ASoC: sunxi: Add new driver for Allwinner A64 codec's
analog path controls
    7e95aac96b55 ASoC: sunxi: allow the sun8i-codec driver to be built on ARM64
    66ecce332538 ASoC: sun4i-i2s: Add compatibility with A64 codec I2S
    ... (there quite a few more)

to actually work. Quite sure those aren't backportable since one is over
four hundred lines.

Regards
ChenYu
