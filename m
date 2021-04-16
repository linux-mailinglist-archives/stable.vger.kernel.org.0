Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79387361E35
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 12:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242104AbhDPKrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 06:47:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242101AbhDPKry (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 06:47:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33DE961103;
        Fri, 16 Apr 2021 10:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618570050;
        bh=od1tl7oKpVX/MGO4p0AhDkV0ESsHKL9wHzJMSSEZtLk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=TItS6HfKYpavIh/cZNuV/Cf9SdibI9PL9tlvdaoCRdMFXMY9n4xZTu57TiOmJr89c
         FhgQeGvmikXT/ycxdqfPCpNXgPAleEioIS9EdiWEWduMRjnqMaQKevA/oKnacAE3vX
         3LqqzpFvQr31YeYNFerYEkId3nVMY8XfMng0I0K+blKFjelq1HStEHrBhceE3wWNAK
         ppD/CuGxwdgsg4k+ltLTyZDpBoEAkvDYBOjk++xKxXJzA8Z2f8bKOIQcoErGNzZn82
         79JquGXDOgnK0OXdclEmdw9AVUu5MwWv1vtT8gXnYDc89c8aXtZbdem1lhVgbBoYtG
         Y5lVQEOAsvzwQ==
From:   Felipe Balbi <balbi@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Ferry Toth <fntoth@gmail.com>, Yu Chen <chenyu56@huawei.com>
Subject: Re: [PATCH v3] usb: dwc3: core: Do core softreset when switch mode
In-Reply-To: <374440f8dcd4f06c02c2caf4b1efde86774e02d9.1618521663.git.Thinh.Nguyen@synopsys.com>
References: <2cb4e704b059a8cc91f37081c8ceb95c6492e416.1618503587.git.Thinh.Nguyen@synopsys.com>
 <374440f8dcd4f06c02c2caf4b1efde86774e02d9.1618521663.git.Thinh.Nguyen@synopsys.com>
Date:   Fri, 16 Apr 2021 13:47:22 +0300
Message-ID: <87zgxymrph.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:

> From: Yu Chen <chenyu56@huawei.com>
> From: John Stultz <john.stultz@linaro.org>
>
> According to the programming guide, to switch mode for DRD controller,
> the driver needs to do the following.
>
> To switch from device to host:
> 1. Reset controller with GCTL.CoreSoftReset
> 2. Set GCTL.PrtCapDir(host mode)
> 3. Reset the host with USBCMD.HCRESET
> 4. Then follow up with the initializing host registers sequence
>
> To switch from host to device:
> 1. Reset controller with GCTL.CoreSoftReset
> 2. Set GCTL.PrtCapDir(device mode)
> 3. Reset the device with DCTL.CSftRst
> 4. Then follow up with the initializing registers sequence
>
> Currently we're missing step 1) to do GCTL.CoreSoftReset and step 3) of
> switching from host to device. John Stult reported a lockup issue seen
> with HiKey960 platform without these steps[1]. Similar issue is observed
> with Ferry's testing platform[2].
>
> So, apply the required steps along with some fixes to Yu Chen's and John
> Stultz's version. The main fixes to their versions are the missing wait
> for clocks synchronization before clearing GCTL.CoreSoftReset and only
> apply DCTL.CSftRst when switching from host to device.
>
> [1] https://lore.kernel.org/linux-usb/20210108015115.27920-1-john.stultz@=
linaro.org/
> [2] https://lore.kernel.org/linux-usb/0ba7a6ba-e6a7-9cd4-0695-64fc927e01f=
1@gmail.com/
>
> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Ferry Toth <fntoth@gmail.com>
> Cc: Wesley Cheng <wcheng@codeaurora.org>
> Cc: <stable@vger.kernel.org>
> Fixes: 41ce1456e1db ("usb: dwc3: core: make dwc3_set_mode() work properly=
")
> Signed-off-by: Yu Chen <chenyu56@huawei.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

I still have concerns about the soft reset, but I won't block you guys
from fixing Hikey's problem :-)

The only thing I would like to confirm is that this has been verified
with hundreds of swaps happening as quickly as possible. DWC3 should
still be functional after several hundred swaps.

Can someone confirm this is the case? (I'm assuming this can be
scripted)

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAmB5azoRHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQbTqBAAwJa0+SiYQL4Cbfy6TY99murao5mbPn/A
bI+Ufn/HmXT/FrpwmVeFGb0xeKg+EjXsdyp1QGKKNMqHQ0vwCDxEDeIAazh/2+3f
x1XeNTBwSAd6KgdUwqaIDQtUhHoZKP8TSRSL0zokZamYDkpUbv84A2w+fUQuDToP
tTecb+i9iS0bs5NEgF9e/GvDBWHF2i087tn0BDcm9LCqd34yDGOaLfySBMhBuG3h
N+q+xVo1zAALHwqGFxYvGqUzybMt2U9YEE3CaN8DHZPOQs/2UFdvlg6Hi/RdrOb+
4bH1PzcjJIQ9lFF/0i8zJCVBK8LW5wElSN/g05wja2RyioqTnrEwvob/3yesjl5J
TRR8VZZIPShgRZFtoWSTvLRL86bKJoXCaKVh41sXkbIPhyNzZTf2T06NjvERNwYY
AK7y9M3cZm44IDytI8WPcWZx5io6aoEw8VqQbYor7GTecdE9vKteBVaxwlBVDIzZ
K1GoPEJfy8oU8Akr5jS/p8la+di/wjHGplv/hTuOHXwkSz6WJzE5HQw0jzK5PDk6
kUhfEKo/BokRWIIFbTqjxU5MUla4UcyFo3hfgFYBOGM0QGOlHSJgJW3wcxuXpKwO
+2X1a+0L/wY0pt2d4NbEYaezqGeFyY6nPRZJSDBUWchdxmeFQj1NXe4x5UYrMlb8
w0/4kYvWosw=
=33Vg
-----END PGP SIGNATURE-----
--=-=-=--
