Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49EB339373
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 17:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbhCLQc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 11:32:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230443AbhCLQc2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 11:32:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 476CC64F9E;
        Fri, 12 Mar 2021 16:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615566748;
        bh=8S4pBtJEI8wv//AkyvMcxWQoWmlh3J2vBNPJK2m0ZL4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uS4KCZ7I9zR2AvSlcR/hf9C1EsvoVNOX3iX99hfiauEtbiP3HM26Q0I52UQMtAcsP
         SzC9NrqpkntiaVM2CvtX0Ko4xHpmYZzaYUmUZdRBwZxdvkLZpYtjoH6G20CfjceGt4
         NStNfH3yUco0BNYaoHO6GCAbIfH0Ku71ohcFXXJKxfbI0g3qpI2+3BZL+hii8hRM8s
         GiKFklt9SYcERs2dTt9WZnpqvES1ky+qfo0jlXv8Ka8thbbD97sPBDoPx3I4IshAkE
         mKi5gQhDVvA+SfBAuMxHe8YK1WtyzU97ihNVnJ6yuHPXuDx8PlB/TcejBeXGB9S+66
         1olQsolYpmYrA==
Date:   Fri, 12 Mar 2021 17:32:24 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Pali =?UTF-8?B?Um9ow6Fy?= <pali@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH mvebu + mvebu/dt64 4/4] arm64: dts: marvell:
 armada-37xx: move firmware node to generic dtsi file
Message-ID: <20210312173224.1e3d6082@kernel.org>
In-Reply-To: <20210312161857.ytknen5d5zhfhtbk@pali>
References: <20210308153703.23097-1-kabel@kernel.org>
        <20210308153703.23097-4-kabel@kernel.org>
        <87czw4kath.fsf@BL-laptop>
        <20210312101027.1997ec75@kernel.org>
        <YEt/Ll08M1cwgGR/@lunn.ch>
        <20210312161704.5e575906@kernel.org>
        <YEuOfI5FKLYgdQV+@lunn.ch>
        <20210312161857.ytknen5d5zhfhtbk@pali>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 12 Mar 2021 17:18:57 +0100
Pali Roh=C3=A1r <pali@kernel.org> wrote:

> On Friday 12 March 2021 16:53:32 Andrew Lunn wrote:
> > > So theoretically the turris-mox-rwtm driver can be renamed into
> > > something else and we can add a different compatible in order not to
> > > sound so turris-mox specific. =20
> >=20
> > That would be a good idea. And if possible, try to push the hardware
> > random number code upstream in the firmware repos, so everybody gets
> > it by default, not just those using your build. Who is responsible for
> > upstream? Marvell? =20
>=20
> Hello Andrew! The issue is that upstream Marvell repository contains
> only 'fuse.bin' application which is suitable only for fuse programming.
> I think it is not correct if this Marvell fuse application start
> providing other functionality not relevant to fuse programming.

Why not? We can rename it to fuse+hwrng and implement hwrng there.
Maybe Konstantin will agree with such a change :)

> And Marvell does not provide any other application (publicly). So it would
> be needed to send it as another application, not part of 'fuse.bin'. And
> then it complicates build system and compile options, which is already
> too complicated (you need to set tons of TF-A options and prepare two
> sets of cross compile toolchains).
>=20
> But because application / firmware for MOX / Armada 3720 is actively
> developed on different place, I do not think that it make sense to send
> every change to two different locations (and wait for Marvell until
> review every change and include it into their repository). Such thing
> just increase maintenance cost at both sides.

This is a little bit  better argument than the previous one. But I
think Andrew may be right in that for end-users it just complicates
things if they have more options. Better to give them one option.

> For me it looks like a better solution to provide 'wtmi_app.bin'
> application with HW number generator from separate repository, where it
> is currently developed and where it is available for a longer time.
>=20
> We are planning to send documentation update to Trusted-Firmware project
> to specify how to build Armada 3720 firmware image with our application.
> So people who are building Armada 3720 firmware would be able to switch
> from Marvell's 'fuse.bin' application to our 'wtmi_app.bin'.

