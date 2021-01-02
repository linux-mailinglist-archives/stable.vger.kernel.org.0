Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173EC2E8740
	for <lists+stable@lfdr.de>; Sat,  2 Jan 2021 13:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbhABMUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Jan 2021 07:20:30 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:10675 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbhABMU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Jan 2021 07:20:29 -0500
Date:   Sat, 02 Jan 2021 12:19:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1609589986;
        bh=xeKFx/zvJeF3EOI2JHzXBLYuaUj021bIJFzj5apYGzs=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=WmZmcyfRLRh7AKjO6USItaXwQjM4X6UUHS7RNYtEfmVWCDBe2oCwPtGNMgVVYk01P
         HUs3p+rvZTmN1AGfTd8bKs7TJIuMzUMVmqMSSmaeb0ThSAsyRpJF+XFyYZh2mPHI0K
         w5XxToiGjdnQONeNbC1Dww4MJrpSqj5G/9tQgoS8=
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
From:   =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Cc:     "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ike Panhc <ike.pan@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-To: =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Subject: Re: [PATCH] platform/x86: ideapad-laptop: Add has_touchpad_switch
Message-ID: <D2lfUAOv4FVNsPPkc_6KIGFGu1WZEj2JAt2pN2L03sIHxB6qxSwKM85gyKfhE11eEM4wcVYhMmRTC4zoOeaADbu0ueQXtRzxyoy-K2j9Y1Y=@protonmail.com>
In-Reply-To: <063eb02d-a699-3f6c-fd1b-721e9d195e82@flygoat.com>
References: <20210101061140.27547-1-jiaxun.yang@flygoat.com> <_kQDaYPt7vh_mQfPr1tLJV2IP-p40OBPcU5zk-1xHhF9XJsm8Y-efANBgiRdWU-J2QTtOjmrfE0Tw6UrZpm6uG-zZGlfpaVOp9FuoKAbjzA=@protonmail.com> <bcb3bc76-da83-4ee1-8c2d-0453d359ae37@www.fastmail.com> <XVSpzJf9TdCi-rg53vfxB7yLg8VJQsQVbqoC1Fu1L7tL5mPKCpMABkedQNatITMiUy7pvBC7g0Cqd30-zqc0bCsSSoy5YXp_gJLTLM0odTg=@protonmail.com> <063eb02d-a699-3f6c-fd1b-721e9d195e82@flygoat.com>
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

2021. janu=C3=A1r 2., szombat 3:36 keltez=C3=A9ssel, Jiaxun Yang =C3=ADrta:

> =E5=9C=A8 2021/1/2 =E4=B8=8A=E5=8D=881:09, Barnab=C3=A1s P=C5=91cze =
=E5=86=99=E9=81=93:
> > Hi
> >
> >
> > 2021. janu=C3=A1r 1., p=C3=A9ntek 17:08 keltez=C3=A9ssel, Jiaxun Yang =
=C3=ADrta:
> >
> >> [...]
> >>>> @@ -1006,6 +1018,10 @@ static int ideapad_acpi_add(struct platform_d=
evice *pdev)
> >>>>   =09if (!priv->has_hw_rfkill_switch)
> >>>>   =09=09write_ec_cmd(priv->adev->handle, VPCCMD_W_RF, 1);
> >>>>
> >>>> +=09/* The same for Touchpad */
> >>>> +=09if (!priv->has_touchpad_switch)
> >>>> +=09=09write_ec_cmd(priv->adev->handle, VPCCMD_W_TOUCHPAD, 1);
> >>>> +
> >>> Shouldn't it be the other way around: `if (priv->has_touchpad_switch)=
`?
> >> It is to prevent accidentally disable touchpad on machines that do hav=
e EC switch,
> >> so it's intentional.
> >> [...]
> > Sorry, but the explanation not fully clear to me. The commit message se=
ems to
> > indicate that some models "do not use EC to switch touchpad", and I tak=
e that
> > means that reading from VPCCMD_R_TOUCHPAD will not reflect the actual s=
tate of the
> > touchpad and writing to VPCCMD_W_TOUCHPAD will not change the state of =
the touchpad.
>
> I'm just trying to prevent removing functionality on machines that
> touchpad can be controlled
> by EC but also equipped I2C HID touchpad. At least users will have a
> functional touchpad
> after that.
>

Thanks for the clarification.


> >
> > But then why do you still write to VPCCMD_W_TOUCHPAD on devices where s=
upposedly
> > this does not have any effect (at least not the desired one)? And the p=
art of the
> > code I made my comment about only runs on machines on which the touchpa=
d supposedly
> > cannot be controlled by the EC. What am I missing?
> >
> > And there is the other problem: on some machines, this patch removes wo=
rking
> > functionality.
> Yeah that's a problem. I just don't want to repeat the story of rfkill
> whitelist, it ends up with
> countless machine to be added.
>
> Maybe I should specify HID of touchpad as well. Two machines that known
> to be problematic
> all have ELAN0634 touchpad.

I think that would be better since the Lenovo Yoga 520-14IKB 80X8 device
I'm concerned about has a SYNA2B2C touchpad device, so at least that wouldn=
't be
affected.


Regards,
Barnab=C3=A1s P=C5=91cze
