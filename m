Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FC0360765
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 12:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhDOKpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 06:45:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230118AbhDOKpk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 06:45:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C7C260C41;
        Thu, 15 Apr 2021 10:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618483517;
        bh=kSJhd4a9ywlN2MZ0jFppDTbI31NYieBko4U9vKVjKqA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Y9LUECKmgVO35MCbvO2aLEibltRdpMeBIUEztY/PUCmpD3pEa1CcJLCWSjU0IwptC
         PrOrZJG79DbpB+DI0osjJ4LfONSx+fwHaMzBOIN4lySq57wRZ7eaLyPZOv38bQ/PE3
         gfuoglYjm8vKcjUuuJePPSRopejn+f0Nk0gD6mhhqBZtUOwEv9FC2sW5tdlbW+JJfc
         GlVcBS/HR2ROmkVq1pFvPA/miNLTlIeng/no2CoHGXzDC+Iipqos//duI/eef5SxpC
         tYqACEKDe4NPTnu0AWz162Fu6hiVL2km2HCEm9ACFMr8xhYdzO8VHzELom+OJ5UdgF
         5+j16UeA61I0A==
From:   Felipe Balbi <balbi@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Cc:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Ferry Toth <fntoth@gmail.com>, Yu Chen <chenyu56@huawei.com>
Subject: Re: [PATCH] usb: dwc3: core: Do core softreset when switch mode
In-Reply-To: <c125a30b-edde-8fe5-3370-d9e62a24f7e9@synopsys.com>
References: <96c64e6a788552371081f37f544041b7ee046ef5.1618452732.git.Thinh.Nguyen@synopsys.com>
 <87sg3snk1l.fsf@kernel.org>
 <c125a30b-edde-8fe5-3370-d9e62a24f7e9@synopsys.com>
Date:   Thu, 15 Apr 2021 13:45:10 +0300
Message-ID: <87h7k7omh5.fsf@kernel.org>
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
>> Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:
>>> From: Yu Chen <chenyu56@huawei.com>
>>> From: John Stultz <john.stultz@linaro.org>
>>>
>>> According to the programming guide, to switch mode for DRD controller,
>>> the driver needs to do the following.
>>>
>>> To switch from device to host:
>>> 1. Reset controller with GCTL.CoreSoftReset
>>> 2. Set GCTL.PrtCapDir(host mode)
>>> 3. Reset the host with USBCMD.HCRESET
>>> 4. Then follow up with the initializing host registers sequence
>>>
>>> To switch from host to device:
>>> 1. Reset controller with GCTL.CoreSoftReset
>>> 2. Set GCTL.PrtCapDir(device mode)
>>> 3. Reset the device with DCTL.CSftRst
>>> 4. Then follow up with the initializing registers sequence
>>>
>>> Currently we're missing step 1) to do GCTL.CoreSoftReset and step 3) of
>>=20
>> we're not really missing, it was a deliberate choice :-) The only reason
>> why we need the soft reset is because host and gadget registers map to
>> the same physical space within dwc3 core. If we cache and restore the
>> affected registers, we're good ;-)
>
> It's part of the programming model. I've already discussed with internal
> RTL designers. This is needed, and I've provided the discussion we had
> prior also. We have several different devices in the wild that need
> this. What is the concern?

Timing :-) If anyone wants to support OTG spec, it'll be super hard to
guarantee the timing mandated by the spec if we have to go through full
reset.

>> IMHO, that's a better compromise than doing a full soft reset.
>>=20
>>> @@ -40,6 +41,8 @@
>>>=20=20
>>>  #define DWC3_DEFAULT_AUTOSUSPEND_DELAY	5000 /* ms */
>>>=20=20
>>> +static DEFINE_MUTEX(mode_switch_lock);
>>=20
>> there are several platforms which more than one DWC3 instance. Sure this
>> won't break on such systems?
>>=20
>
> How? Am I missing something? Please let me know so I can make the change.

Again timing :-)

Instance 0 swaps role and instance 1 swaps right after. Instance 1 will
be waiting for the mutex held by instance 0.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAmB4GTYRHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQaFIw//Sy7JZt/BHUt52FNv0M60aKbmmOxOzZg2
EPFUsbLdPCpnCg0YhyvJ+itXdYuGfC0rmBlWjIM51kNA0hHpOodD9aRrWHPmeTpa
s/397koHt+EE6kNWhJGlrYpbaH+Q5Mgl1PXbC0Tn+3YejMj9kO8Os0X3c52vltVR
gT7hJPBAV80+42E+Cwhscj9M0VtMYvzvasnxP3bzau3QZzZ+1G7f50J2uOJZNHWh
iVpaUdXHKdxz18jdalKFcBc49qZCmNEturI+30C+EOBTmNXmzNzQ+hg1ab9pYo4v
oNPrvOpoRdWX2f6PHOZhDRqae7tokGWbQaPWO6is7xG1jgFQKUjpQWY1Kgd94928
WCovnBDVV3HyKR94TAAyriMFK2Fk+saVAb5jCWxBGbyFdMzaheDRlTSO0UCC4vj+
RsuTd21Dt/BG+Un1CqLEFe1ENpowaHICFk739EPAS1vrSDH1xKQpAAMcmj7WBJaa
CYkhQLUEKmrtMsug+I9LLQOHKDm/2kqjKs54q497orXkx+60b4+ESti60EXbBINI
Vv9tyFWb0GP1TJZIRkf6Bgq1TuWc8FIB7VqTXyV5AlgtxSDVIAmGBhWqUu90ph2t
JY1V7lsc9j2VFegIPe0vcclnvmm2+4sCBpmnyqlZZiKAEaxSjBqF4GYWV/HKyopk
ZJ5fTGdOvY0=
=jD1N
-----END PGP SIGNATURE-----
--=-=-=--
