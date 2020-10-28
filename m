Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8206629D6F2
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731856AbgJ1WTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:19:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731742AbgJ1WRo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:44 -0400
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47F50246B0;
        Wed, 28 Oct 2020 10:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603880117;
        bh=E57TRRP55Kk9vg5tur1KhYG5qx7b3ky4jZL+p+sXuoY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MrdU+GtBcZwjT+vZ+g8Hw6gZHvwWzT4GZ+SrmHeBOThKai89DQFRg3IRa6i/wLsbi
         9oXfv2GsWan0iTEVWd6s8Uc7GCICsJ7Vb4CS+WAncE8FpLa9n0f9+F/iZgTmtEHQim
         Sc2XD/nbGU1AmKMLAuCRjVRBJorO4jHJsQVP7IqU=
Received: by mail-ed1-f44.google.com with SMTP id x1so4523300eds.1;
        Wed, 28 Oct 2020 03:15:17 -0700 (PDT)
X-Gm-Message-State: AOAM532qAFPQWwXKiy51ycWtsZvHgS1ewyTUIiBpduGY/UUKlO4W5CHD
        4gNHuMLG0UkgcDWsp0LIV8MrkxtUQkpcia5swfY=
X-Google-Smtp-Source: ABdhPJz4yllQgyYZ8Tamki1QBJ8R6wNyadcvzqNfdvF4QwTASSCCiWTVEZ36r/fo7dWTUfe04TsIynmfdLIh/mOJ5uk=
X-Received: by 2002:a05:6402:cf:: with SMTP id i15mr2651762edu.246.1603880115644;
 Wed, 28 Oct 2020 03:15:15 -0700 (PDT)
MIME-Version: 1.0
References: <20201028091947.93097-1-krzk@kernel.org> <MWHPR11MB0046B799E9AD3648C6F67BFE87170@MWHPR11MB0046.namprd11.prod.outlook.com>
 <CAJKOXPePfsRNZkY+L1XM3_iz6dMYFNZAJgrcut9JriuwYkKWsw@mail.gmail.com>
 <CAJKOXPf6zhpu_3oQZ2bL_FnkBx7-NwH65N_OzVkH=Nh1bYkHxw@mail.gmail.com> <20201028100311.GF26150@paasikivi.fi.intel.com>
In-Reply-To: <20201028100311.GF26150@paasikivi.fi.intel.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Wed, 28 Oct 2020 11:15:01 +0100
X-Gmail-Original-Message-ID: <CAJKOXPcjtZidY1prH1ZCj+i-SM1mhABGbS_6_g1cH5WSGVhOAA@mail.gmail.com>
Message-ID: <CAJKOXPcjtZidY1prH1ZCj+i-SM1mhABGbS_6_g1cH5WSGVhOAA@mail.gmail.com>
Subject: Re: [PATCH] media: i2c: imx258: correct mode to GBGB/RGRG
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     "Yeh, Andy" <andy.yeh@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Jason Chen <jasonx.z.chen@intel.com>,
        Alan Chiang <alanx.chiang@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 28 Oct 2020 at 11:03, Sakari Ailus <sakari.ailus@linux.intel.com> wrote:
>
> On Wed, Oct 28, 2020 at 10:56:55AM +0100, Krzysztof Kozlowski wrote:
> > On Wed, 28 Oct 2020 at 10:45, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > >
> > > On Wed, 28 Oct 2020 at 10:43, Yeh, Andy <andy.yeh@intel.com> wrote:
> > > >
> > > > But the sensor settings for the original submission is to output GRBG Bayer RAW.
> > > >
> > > > Regards, Andy
> > >
> > > No, not to my knowledge. There are no settings for color output
> > > because it is fixed to GBGB/RGRG. I was looking a lot into this driver
> > > (I have few other problems with it, already few other patches posted)
> > > and I could not find a setting for this in datasheet. If you know the
> > > setting for the other color - can you point me to it?
> >
> > And except the datasheet which mentions the specific format, the
> > testing confirms it. With original color the pictures are pink/purple.
> > With proper color, the pictures are correct (with more green color as
> > expected for bayer).
>
> Quoting the driver's start_streaming function:
>
>         /* Set Orientation be 180 degree */
>         ret = imx258_write_reg(imx258, REG_MIRROR_FLIP_CONTROL,
>                                IMX258_REG_VALUE_08BIT, REG_CONFIG_MIRROR_FLIP);

I understand that you think it will replace the lines and columns and
the first line will be RG, instead of GB.... or actually BG because it
flips horizontal and vertical? So why does it not work?

BTW, this nicely points that the comment around
device_property_read_u32() for rotation is a little bit misleading :)

>         if (ret) {
>                 dev_err(&client->dev, "%s failed to set orientation\n",
>                         __func__);
>                 return ret;
>         }
>
> Could it be you're taking pictures of pink objects? ;-)

I can send a few sample pictures taken with GStreamer (RAW8, not
original RAW10)...

Best regards,
Krzysztof
