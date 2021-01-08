Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA632EF27A
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 13:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbhAHMYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 07:24:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:54434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbhAHMYL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Jan 2021 07:24:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F45B238E4;
        Fri,  8 Jan 2021 12:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610108609;
        bh=ZzSOhR3nBEfxPyiyHvg9czfSgN+1Vzlu8H1WwrVePj0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=NuvHD1DVqJgXPUh5jVhqL+aCPodJoG2kGqIfK2nUMLD2wnnHRwWcbdW80U73Ha/ZP
         bwiqHGYCL41EsIKYyUdoiBHr7cy8KHhThNoFqE22SzwAm8NCHm7PP64vlp1bCT0ACo
         gKia2Rz6S3z3CVqDq+/mvYF1E0tVijxCehP8aS1xfqOp44mgOiMk0kmLkwN1WPrZvB
         uhLOsqIm/kHOKRe1vnW7y+eNzyf0PcknbQFEcAxk3oeEY0kzQGoyJbVBT4zeLQq1v6
         BJlX4YOauK5S0JpYf0zuM5th+Vfy3SQV26Y8UDt/BQKvZyW81JU3MUrk3F2CMCr1+n
         k8INkluH5IWvQ==
From:   Felipe Balbi <balbi@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Bryan O'Donoghue <pure.logic@nexus-software.ie>
Cc:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: gadget: Init only available HW eps
In-Reply-To: <19b685a9-0c25-9b6c-ecaf-ffca4069182b@synopsys.com>
References: <3080c0452df14d510d24471ce0f9bb7592cdfd4d.1609866964.git.Thinh.Nguyen@synopsys.com>
 <87eeiycxld.fsf@kernel.org>
 <75d63bab-1cdc-737e-8ae2-64e0ddeeef75@synopsys.com>
 <87k0spay6z.fsf@kernel.org>
 <cacf58e7-e131-2caa-5fb3-1af7db8270b4@synopsys.com>
 <19b685a9-0c25-9b6c-ecaf-ffca4069182b@synopsys.com>
Date:   Fri, 08 Jan 2021 14:23:22 +0200
Message-ID: <87eeivwrb9.fsf@kernel.org>
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
>>>>> How have you verified this patch? Did you read Bryan's commit log? Th=
is
>>>>> is likely to reintroduce the problem raised by Bryan.
>>>>>
>>>> We verified with our FPGA HAPS with various number of endpoints. No
>>>> issue is seen.
>>> That's cool. Could you please make sure our understanding of this is
>>> sound and won't interfere with any designs? If we modify this part of
>>> the code again, I'd like to see a clear reference to a specific section
>>> of the databook detailing the expected behavior :-)
>>>
>>> cheers
>>>
>> Hm... I didn't consider bidirection endpoint other than control endpoint.
>>
>> DWC3_USB3x_NUM_EPS specifies the number of device mode for single
>> directional endpoints. A bidirectional endpoint needs 2 single
>> directional endpoints, 1 IN and 1 OUT. So, if your setup uses 3
>> bidirection endpoints and only those, DWC3_USB3x_NUM_EPS should be 6.
>> DWC3_USB3x_NUM_IN_EPS specifies the maximum number of IN endpoint active
>> at any time.
>>
>> However, I will have to double check and confirm internally regarding
>> how to determine many endpoint would be available if bidirection
>> endpoints come into play.
>>
>> Thanks for pointing this out. Will get back on this.
>>
>> Thinh
>>
>
> Ok. Just had some discussion internally. So, like you said, any endpoint
> can be configured in either direction. However, we are limited to
> configuring up to DWC_USB3x_NUM_IN_EPS because each IN endpoint has its
> own TxFIFO while for OUT, they share the same RxFIFO. So we could have
> up to DWC_USB3x_NUM_EPS number of OUT endpoints. So, the issue Bryan
> attempted to address is still there.
>
> However, the current code still has some assumption on the number of IN
> and OUT endpoints, I need to think of a better solution.

Yes, the assumption still exists because at the time there was no better
solution :-)

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAl/4TroRHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQZFmhAApbw/t3Pa+MivXGnuYovwVIBzT8NFGj0m
/1NL7rp49TnkIe/oHY0ZFiFIKBA7liwUKBIQGNOZgLG02yFaffGLRO+4RhmrydIC
AmbzzEz51xmiypiFWQ+VoF5F2Eacl2VJGKYZbL9yiTaQ/ilgIZI8tWUkBEprxpYB
Vb2aZyDgxVP1efGStMDtOlZRSgk0xqPeuCcbZmQZW4op51MkczkEjwKIc1rWBCvO
H/YRRtM5/DmIvrr8C/HEEbhJ+Y/cZS4kXygvMHf6LPbt1vVvFGEckgXVvH6gVgUv
Y6br85LsG+TI2lqy2+dKTX2uBmNuM4MQGe2oCNHdloGm2VXbVn+EczosGGvVlFQH
yUjcEgsOuChkQ9RZGh311iZwSU+9x8atg71Q9lqRhqtKva2rYQanGZlcWmmwyUkn
PFcqsRg+ZWf4azlqObvKupcW4Zz9NH+pA6lziPEycpXoAXD9rIJO+dDpzZwOgvZK
dwI0qnoXGv5pG2ol2idmFf8dNofws5P37+NIFlxCD+5v754hwWla3ko7wy76GlJY
+V8oqn2uiOiUMsx/HkLUV9+m46vGeQ5ttx7PJWag1EBtVqLpz2fbNiktbHk1b/dR
G0aKPi/zIVu8ERZSrNdWKe5GxhTW2JBvC6pGZP3j6sRki+DoXmZbRyA2WFilDYqb
MRE0hHmzsv8=
=64FX
-----END PGP SIGNATURE-----
--=-=-=--
