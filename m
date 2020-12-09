Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198622D4596
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgLIPjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:39:06 -0500
Received: from mail-40135.protonmail.ch ([185.70.40.135]:61052 "EHLO
        mail-40135.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbgLIPjG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:39:06 -0500
Date:   Wed, 09 Dec 2020 15:38:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1607528297;
        bh=wdJCyYk1f38GX5JvsezuTqDeFPgJXHx/BdZltjPklBA=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=ZzIQYxx70gKFm2N/jzgQd3dZxYzeo+dyYLsbsRTILwu3UiKgA9juRLSpncZiWsDMB
         P2ul/Csk1luCpRbSfHaXglKka7qPcm5NY72u5vCNJFxw+g5PJxPCgwYGZ+72l41m00
         4UNU+Brvu31D/+9aO4IyT/TlSjMDdmbHXTrCAenQ=
To:     Greg KH <gregkh@linuxfoundation.org>
From:   =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Cc:     Coiby Xu <coiby.xu@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Helmut Stult <helmut.stult@schinfo.de>,
        Baq Domalaq <domalak@gmail.com>,
        Pedro Ribeiro <pedrib@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Reply-To: =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Subject: Re: [PATCH v4] HID: i2c-hid: add polling mode based on connected GPIO chip's pin status
Message-ID: <CHTa60htGkyHzaM2En-TPXqyk1v3jVJUolGOMfHphEr_mMG5Z5f2K4mHTFilYR73bgpGEKNcGM1LFstJ7UhvbuJrgqr1-J2-YTZJenhK83Q=@protonmail.com>
In-Reply-To: <X9B2B6KuzbP8Is+W@kroah.com>
References: <20201125141022.321643-1-coiby.xu@gmail.com> <X75zL12q+FF6KBHi@kroah.com> <B3Hx1v5x_ZWS8XSi8-0vZov1KLuINEHyS5yDUGBaoBN4d9wTi9OlCoFX1h6sqYG8dCZr_OKcKeImWX9eyKh8X4X3ZMdAUQ-KVwmG5e9LJeI=@protonmail.com> <X9B2B6KuzbP8Is+W@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2020. december 9., szerda 8:00 keltez=C3=A9ssel, Greg KH =C3=ADrta:

> On Tue, Dec 08, 2020 at 09:59:20PM +0000, Barnab=C3=A1s P=C5=91cze wrote:
>
> > 2020.  november 25., szerda 16:07 keltez=C3=A9ssel, Greg KH =C3=ADrta:
> >
> > > [...]
> > >
> > > > +static u8 polling_mode;
> > > > +module_param(polling_mode, byte, 0444);
> > > > +MODULE_PARM_DESC(polling_mode, "How to poll (default=3D0) - 0 disa=
bled; 1 based on GPIO pin's status");
> > >
> > > Module parameters are for the 1990's, they are global and horrible to
> > > try to work with. You should provide something on a per-device basis,
> > > as what happens if your system requires different things here for
> > > different devices? You set this for all devices :(
> > > [...]
> >
> > Hi
> > do you think something like what the usbcore has would be better?
> > A module parameter like "quirks=3D<vendor-id>:<product-id>:<flags>[,<ve=
ndor-id>:<product-id>:<flags>]*"?
>
> Not really, that's just for debugging, and asking users to test
> something, not for a final solution to anything.

My understanding is that this polling mode option is by no means intended
as a final solution, it's purely for debugging/fallback:

"Polling mode could be a fallback solution for enthusiastic Linux users
when they have a new laptop. It also acts like a debugging feature. If
polling mode works for a broken touchpad, we can almost be certain
the root cause is related to the interrupt or power setting."

What would you suggest instead of the module parameter?


Regards,
Barnab=C3=A1s P=C5=91cze
