Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8AE36024D
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 08:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhDOGXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 02:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230153AbhDOGXd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 02:23:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16C24613EA;
        Thu, 15 Apr 2021 06:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618467790;
        bh=bpB2yLiQrzGFsKM+eo/ypGx7SupGM7k+ia8NJDQZCtc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Q81HnOvcWh+TBSwe3AUKUAT71RaHUFFlorFeabOtgp58PT1uFd1N7TxdsURbj5geY
         3pbTurDemr6XmtHMDrGLyeugjOXpuh7Mq2eZoHh5n8g/78cqrlWAWHdb0jNs7wAwSa
         +SmDB+xtMrel0e+jiSniqvbl/2vYT0KOkDTTgNfJqCGxwa/ibZssuSjpGb6eVt0G06
         UyZ4cEj2K7Av34IwouddhH5ivcpjJmm0OuxIFy4Gr81NsBsS0o3QQqeMXZpQ2v6/tW
         YihdJy0UHaVcbWholJzwWYkVxVOsfJdEJ0cjcyV4av2VU9+la0dMhMfY0c9Gc45YpP
         ASG8ixAqetRng==
From:   Felipe Balbi <balbi@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Roger Quadros <rogerq@ti.com>
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Ferry Toth <fntoth@gmail.com>, Yu Chen <chenyu56@huawei.com>
Subject: Re: [PATCH] usb: dwc3: core: Do core softreset when switch mode
In-Reply-To: <96c64e6a788552371081f37f544041b7ee046ef5.1618452732.git.Thinh.Nguyen@synopsys.com>
References: <96c64e6a788552371081f37f544041b7ee046ef5.1618452732.git.Thinh.Nguyen@synopsys.com>
Date:   Thu, 15 Apr 2021 09:23:02 +0300
Message-ID: <87sg3snk1l.fsf@kernel.org>
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

we're not really missing, it was a deliberate choice :-) The only reason
why we need the soft reset is because host and gadget registers map to
the same physical space within dwc3 core. If we cache and restore the
affected registers, we're good ;-)

IMHO, that's a better compromise than doing a full soft reset.

> @@ -40,6 +41,8 @@
>=20=20
>  #define DWC3_DEFAULT_AUTOSUSPEND_DELAY	5000 /* ms */
>=20=20
> +static DEFINE_MUTEX(mode_switch_lock);

there are several platforms which more than one DWC3 instance. Sure this
won't break on such systems?

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAmB328YRHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQZ4+g//c5uwBk5kslonIgrE4VJKSsLwdqg7dbfP
A1r3+I8tczg/2dC7UVizMlPPgccoHVyaw6ShQUdNIffaC+KS1ODZF1XXnSpY+L6e
FNvYSOgtkw4mQXBuctsLGt2ZeIeso1JOlq7rSNOnBwBsSyffF17OX77ax+cqV1yc
WqdV6vrL7Cy2SHIMoBIuo5pedqo1fJiQNWsFFFaMIu7bAnMF87ZMkvZBII/WjpjE
qF3iQgAeTCUtRglAmNcobgwtl/2fE8LmVn0rSkBv+FZFlj65tk9cEeSUWqzL/F6R
6nloNGCFUa/8DwQYvwNG1OBfObytvH2KQO1PvZLG1fThgRAQNri1YTqqCfj0T5vE
JlrruYQv5m/G0+WxOguXQglaxfYtRiwp1IPgpst5D94iDyEswJKrnC4CNols7GbY
q7obMXaUl+JNoiO+XaIZHRAMpB633aQi+QFanrKtLb9JJVZqzR/hSWbH2z5D8bQk
D8gt4w30AfY5g3hvpw/zuBl8od8bz8fMWjE6A+eNUHU1rszF8T7nzdf+Eh/5eJ10
Ivre+FYnDcrGKfVX8qll4f+wgq/fuqgUgJJeQwrBxtDKIiTcyNuVjCzZPjizd5Jf
Jx/VsIHkzH/bf/wFt//3GUscbV5LiX/IaBFPROsd9k+DmiEkPXe4KG1x0nq6QE/E
7EYeW1dGLHQ=
=VhMh
-----END PGP SIGNATURE-----
--=-=-=--
