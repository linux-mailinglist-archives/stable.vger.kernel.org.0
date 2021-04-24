Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B6036A15F
	for <lists+stable@lfdr.de>; Sat, 24 Apr 2021 15:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbhDXNcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Apr 2021 09:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230432AbhDXNcT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 24 Apr 2021 09:32:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1321C61104;
        Sat, 24 Apr 2021 13:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619271101;
        bh=I446yZOnIq364ltuGB3wOU7AYStXxZ5BclBF7288t34=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ay7yxmR4mlLnyloZ1hGCNz6WHfQ/AmCm/iuttCKljWAcUijsBoziRPLc7QaS5TKuU
         k3JSp5FI0pAdOQz4B03h5kXSYuxOr8sRfEirjXcGmolDuiUBdZ1po/4Jsk9RUvSBWk
         YYLUYx+DiwRdIwPPlG4sKQorS279eXmzaS4mIVc1awcv3tYc7MUkZ8H+jSYqaUpBEX
         Pj3CcPyx5JFjYTQzobEMln5ILyVGxCrRHJuy5gjyXQn7uy9DqhOgBc1r9iRyx56eob
         SaE/+dRm1VxxVHLVCtW3kJqSBhhCPEE33akbFCZbXIk1IieYqJm2GCF10G1DXiZTNZ
         vrunLAVx5YUMQ==
From:   Felipe Balbi <balbi@kernel.org>
To:     Wesley Cheng <wcheng@codeaurora.org>, gregkh@linuxfoundation.org,
        peter.chen@kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hemant Kumar <hemantk@codeaurora.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: gadget: Fix double free of device descriptor
 pointers
In-Reply-To: <029267dd-69fb-1f07-b6ff-3384d56c9f89@codeaurora.org>
References: <1619034452-17334-1-git-send-email-wcheng@codeaurora.org>
 <87lf9amvl5.fsf@kernel.org>
 <c5599433-3eb0-3918-d93b-6860f7951e92@codeaurora.org>
 <69253e54-771b-3b1c-1765-77bfb6288715@codeaurora.org>
 <87sg3gksyy.fsf@kernel.org>
 <029267dd-69fb-1f07-b6ff-3384d56c9f89@codeaurora.org>
Date:   Sat, 24 Apr 2021 16:31:34 +0300
Message-ID: <87h7jvlsg9.fsf@kernel.org>
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

Wesley Cheng <wcheng@codeaurora.org> writes:
> On 4/24/2021 1:05 AM, Felipe Balbi wrote:
>>=20
>> Hi,
>>=20
>> Wesley Cheng <wcheng@codeaurora.org> writes:
>>>>>> From: Hemant Kumar <hemantk@codeaurora.org>
>>>>>>
>>>>>> Upon driver unbind usb_free_all_descriptors() function frees all
>>>>>> speed descriptor pointers without setting them to NULL. In case
>>>>>> gadget speed changes (i.e from super speed plus to super speed)
>>>>>> after driver unbind only upto super speed descriptor pointers get
>>>>>> populated. Super speed plus desc still holds the stale (already
>>>>>> freed) pointer. Fix this issue by setting all descriptor pointers
>>>>>> to NULL after freeing them in usb_free_all_descriptors().
>>>>>
>>>>> could you describe this a little better? How can one trigger this cas=
e?
>>>>> Is the speed demotion happening after unbinding? It's not clear how to
>>>>> cause this bug.
>>>>>
>>>> Hi Felipe,
>>>>
>>>> Internally, we have a mechanism to switch the DWC3 core maximum speed
>>>> parameter dynamically for displayport use cases.  This issue happens
>>>> whenever we have a maximum speed change occur on the USB gadget, which
>>>> for DWC3 happens whenever we call gadget init.  When we switch in and
>>>> out of host mode, gadget init is being executed, leading to the change
>>>> in the USB gadget max speed parameter:
>>>>
>>>> dwc->gadget->max_speed		=3D dwc->maximum_speed;
>>>>
>>>> I know that configFS gadget has the max_speed sysfs file, which is a
>>>> similar mechanism, but I haven't tried to see if we can reproduce the
>>>> same issue with it.  Let me see if we can reproduce this with that
>>>> configfs speed setting.
>>>>
>>>> Thanks
>>>> Wesley Cheng
>>>>
>>>
>>> Hi Felipe,
>>>
>>> So I tried with doing it through the configFS max_speed, but it doesn't
>>> have the same effect, as the setting done in dwc3_gadget_init() will
>>> still be assigning the composite/UDC device's maximum speed to SSP/SS.
>>> This is what the usb_assign_descriptor() uses to determine whether or
>>> not to copy the SSP and SS descriptors.
>>>
>>> So in summary, at least for a DWC3 based subsystem, the only way to
>>> reproduce it is if there is a way to dynamically switch the DWC3 core
>>> max speed parameter.
>>=20
>> Could it be that you have a bug in your out-of-tree changes? Perhaps
>> there's some assumption which your changes aren't guaranteeing.
>>=20
> Hi Felipe,
>
> Unless there is a limitation on how the USB gadget max speed can be
> used, i.e. the USB gadget max speed MUST stay the same throughout a
> device's boot period, then our out of tree changes may have the wrong

no, not throughout boot, but it can't change while the device is
enumerated.

> assumptions.  However, I don't see that stated anywhere, and I still
> feel the current usb_assign_descriptors() and usb_free_all_descriptors()
> aren't aligned with one another.  One API decides which descriptors to
> copy based on a parameter, whereas the other just frees all of them
> irrespective.

that's a valid point.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAmCEHbYRHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQaSEg//anWuUMj6UYccl1huFtKwsPXKsLWLDWsY
+a8nlIFoHLDgeACdhF7tqTV1aAIevLOJ229KP9gcsgJJ8ZY983jZPGdvywZlgzvl
ScgV6pWyUikNhTvXutvln/Nubfwqai4xa2TNxR5kYyraasqMnC0j36cg6LU3+nlO
GWktcUIEPocF3P9o/tXry6pPFiWylLj0nFmKHjof94n6CWACORXbJe9z7J/ROGGt
vGf5wfrUSDXpt3W7lnRyYuKMC7DDMkh+Tq9ziiNj3hsqU1w/dR+eUgWT2CfTlZ4q
PFcpiWduJHqK3ZCsdSGKT0sBwcAEVqKBDKSmdAVGlq2EYqpit/8Yf0A612XQaL6+
yv/ZzXtBxOvkmKCx0mWyfGVII0LrMTraCgXq2S/Bb3M44cU3wNSDwedDpipje5ZM
jUdigryF/sYbXE6W4JgOWX3X1yT7xpl/RXEeb1jiCIwym6Pj9bN+ahOnaykUwCLt
mx9kBfdTzotvAAQmDbo3BbINLR4MYRG2bkKGewpUo1VusV12ruUuy85Pp19dC/kx
+nKbNrRHpvP0W3jJHtE5xhuGEb8jx/Ut2L9t0Su9bUKebflB8jm1lMIKw7YJ9ipN
/LPMQUbQ7KGsQyYiKHNWWhZfI5wl1VP6514a6xUaVoGcnsk/e7Ns1z0dE4r1BR70
j/3Aub/XoVo=
=Y1gf
-----END PGP SIGNATURE-----
--=-=-=--
