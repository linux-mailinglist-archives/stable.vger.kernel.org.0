Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBED2ECCE6
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 10:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbhAGJeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 04:34:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:47266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbhAGJeM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 04:34:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53B8C2333C;
        Thu,  7 Jan 2021 09:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610012011;
        bh=djgRRWiFrgVEUQUEqq1X5+FThwZdSOILNB2evgLGCCk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=gmO2J5HwzlA5NAVAmcouTJcQ2WTq4R3btq8xEerw8aXMVNWaE1SJSdrx6RzAJDMMZ
         pJw4ni9fTOTaexAaA0als1lka+ezY6U4eFirNgMeI8iQMwEssxM5vmay0gV+sedWRB
         n8HyfArDhFsKKD3QN7O5Kflsru0tF5EpJWFkPtk5rIIJatNHQD7QN9wfdlJUBi78zW
         Lvo8oGYrwvjD4FSbBM1MG7TWWz9Rw2l95MTM38PY3MQXtEHERfQPjqQF/HuTn77tg3
         RZND+C2XX6AktXZmJOOkrGBItbHmH+89mWBTnu+OVrcX0kFOi5A61+V4Oq3sOw2Ng1
         qvGTDnQQwFk9w==
From:   Felipe Balbi <balbi@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Bryan O'Donoghue <pure.logic@nexus-software.ie>
Cc:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: gadget: Init only available HW eps
In-Reply-To: <75d63bab-1cdc-737e-8ae2-64e0ddeeef75@synopsys.com>
References: <3080c0452df14d510d24471ce0f9bb7592cdfd4d.1609866964.git.Thinh.Nguyen@synopsys.com>
 <87eeiycxld.fsf@kernel.org>
 <75d63bab-1cdc-737e-8ae2-64e0ddeeef75@synopsys.com>
Date:   Thu, 07 Jan 2021 11:33:24 +0200
Message-ID: <87k0spay6z.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:
>>> @@ -3863,7 +3868,7 @@ int dwc3_gadget_init(struct dwc3 *dwc)
>>>  	 * sure we're starting from a well known location.
>>>  	 */
>>>=20=20
>>> -	ret =3D dwc3_gadget_init_endpoints(dwc, dwc->num_eps);
>>> +	ret =3D dwc3_gadget_init_endpoints(dwc);
>>>  	if (ret)
>>>  		goto err4;
>> heh, looking at original commit, we used to have num_in_eps and
>> num_out_eps. In fact, this commit will reintroduce another problem that
>> Bryan tried to solve. num_eps - num_in_eps is not necessarily
>> num_out_eps.
>>
>
> From my understanding, that's not what Bryan's saying. Here's the
> snippet of the commit message:
>
> "
> =C2=A0=C2=A0=C2=A0 It's possible to configure RTL such that DWC_USB3_NUM_=
EPS is equal to
> =C2=A0=C2=A0=C2=A0 DWC_USB3_NUM_IN_EPS.
>
> =C2=A0=C2=A0=C2=A0 dwc3-core calculates the number of OUT endpoints as DW=
C_USB3_NUM minus
> =C2=A0=C2=A0=C2=A0 DWC_USB3_NUM_IN_EPS. If RTL has been configured with D=
WC_USB3_NUM_IN_EPS
> =C2=A0=C2=A0=C2=A0 equal to DWC_USB3_NUM then dwc3-core will calculate th=
e number of OUT
> =C2=A0=C2=A0=C2=A0 endpoints as zero.
>
> =C2=A0=C2=A0=C2=A0 For example a from dwc3_core_num_eps() shows:
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0=C2=A0 1.565000]=C2=A0 /usb0@f01d0000: fo=
und 8 IN and 0 OUT endpoints
> "
>
> He just stated that you can configure to have num_eps equals to
> num_in_eps. Basically it means there's no OUT physical endpoint. Not

no, that's not what it means. I don't have access to DWC3 documentation
anymore, but from what I remember every physical endpoint _can_ be
configured as bidirectional. In other words, DWC3_USB3_NUM_EPS =3D=3D
DWC3_USB3_NUM_IN_EPS could mean that every endpoint in the system is
bidirectional.

> sure why you would ever want to do that because that will prevent any
> device from working. The reason we have DWC_USB3x_NUM_IN_EPS and
> DWC_USB3x_NUM_EPS exposed in the global HW param so that the driver know
> how many endpoints are available for each direction. If for some reason
> this mechanism fails, there's something fundamentally wrong in the HW
> configuration. We have not seen this problem, and I don't think Bryan
> did from his commit statement either.

Please confirm this internally. That was my original assumption too,
until Bryan pointed me to a particular section of the
specification. Unfortunately it's far too long ago and I can't even
verify documentation :-)

>> How have you verified this patch? Did you read Bryan's commit log? This
>> is likely to reintroduce the problem raised by Bryan.
>>
>
> We verified with our FPGA HAPS with various number of endpoints. No
> issue is seen.

That's cool. Could you please make sure our understanding of this is
sound and won't interfere with any designs? If we modify this part of
the code again, I'd like to see a clear reference to a specific section
of the databook detailing the expected behavior :-)

cheers

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAl/21WQRHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQYriQ//Qx54fZN6eU8FuWkCWoQEVNexkAlIiwdf
xXpK5EjDVEpbArqhsTvX98j34tQVzBLlTq63fpI+HC9GDi9jJLnsieOmIsA4fHwY
SJJ+auCB16kJmgfq2/ISC8j4eeHw7G7dX7U9yKTwAkFoPcYoW+aGNEmilHR1ojgO
0+RlF48k0Yt8Eg00mB1TOQ1nKcKReYG3XfDqr+0OIoTue8UnNsBafkdSy/VmqnW5
EroZWo+bDnbAmHzygdDyljTeO7HiOtVLx8lF7MQiwGcHQ0wiEMBV+/3ad1194QKr
FdCAbV7wiVeDAU8pBRY36DyfmxysifLufCDCakRJKaBisFech1NAyPyJrmZc5Foc
CUYlBmCQrDqN1GNsksKZLekKWl8LFdGy7SO4nCN31TqICV2v0ogbtcN7TQczET4d
Z7gE1G7ISLllFkQ8imuzg2lijzMqC7IVrDfGHxRZL50WZv6v7+Dsox6Eait+UKQr
68mT8rnrAS+XQfYdf78N02k+ETam7qtscYYQ8ZUAuJEzYwcmronS/uPsGIrfelxL
1CRQVU7+LMUIx6MRb50NbK5P1Knx6mvVlO7ufY5/3XRKHTFy4JuLxx83lt8rBNgE
uR7uHZ0VWLm3fTCFGZE1F7WEXk2x5A/MgoX5Yd0kOIuBm8ZpnDcfF7j/nQLtY+V4
W8/JWAAUXEc=
=e8wU
-----END PGP SIGNATURE-----
--=-=-=--
