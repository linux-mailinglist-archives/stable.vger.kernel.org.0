Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBAF36A032
	for <lists+stable@lfdr.de>; Sat, 24 Apr 2021 10:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhDXIh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Apr 2021 04:37:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:32870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233650AbhDXIhX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 24 Apr 2021 04:37:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CF3161422;
        Sat, 24 Apr 2021 08:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619251548;
        bh=MoNCCUDokCP4DrrurD5djErNGwjYf26nE/vGHTxqckU=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=rakhRDD8XUxtxXgyEmPUGuoHiRaU0tf7No16u4r/+Dqka0g0CSgobQYoWVdDme5yF
         avVNa6k0yUlPjB3U0F9o5mEEp/Iz/GJbKMjWqkHT4+/4A3QEUl24DJJVlPOmHBfQyy
         krmTkf3d2gNnmvzVgJTiCDDEJz0SVvjohJO6ImQzhJNJYe/oM4PaLccl91VUgfKnTB
         VmhBppiWqxJaHXBwgk8SuiA+FAkpXH2eXQsbjxo+RAv3wQntveY0orOcTwoHVtQ+C4
         CVWL4hW53GYGAx+hyOuR3BPBN2364mxtQbvTDqHIjiQfTacG+1y6BSId9H67lnTTq7
         MHKyJ2cjT9OMA==
From:   Felipe Balbi <balbi@kernel.org>
To:     Wesley Cheng <wcheng@codeaurora.org>, gregkh@linuxfoundation.org,
        peter.chen@kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hemant Kumar <hemantk@codeaurora.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: gadget: Fix double free of device descriptor
 pointers
In-Reply-To: <69253e54-771b-3b1c-1765-77bfb6288715@codeaurora.org>
References: <1619034452-17334-1-git-send-email-wcheng@codeaurora.org>
 <87lf9amvl5.fsf@kernel.org>
 <c5599433-3eb0-3918-d93b-6860f7951e92@codeaurora.org>
 <69253e54-771b-3b1c-1765-77bfb6288715@codeaurora.org>
Date:   Sat, 24 Apr 2021 11:05:41 +0300
Message-ID: <87sg3gksyy.fsf@kernel.org>
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
>>>> From: Hemant Kumar <hemantk@codeaurora.org>
>>>>
>>>> Upon driver unbind usb_free_all_descriptors() function frees all
>>>> speed descriptor pointers without setting them to NULL. In case
>>>> gadget speed changes (i.e from super speed plus to super speed)
>>>> after driver unbind only upto super speed descriptor pointers get
>>>> populated. Super speed plus desc still holds the stale (already
>>>> freed) pointer. Fix this issue by setting all descriptor pointers
>>>> to NULL after freeing them in usb_free_all_descriptors().
>>>
>>> could you describe this a little better? How can one trigger this case?
>>> Is the speed demotion happening after unbinding? It's not clear how to
>>> cause this bug.
>>>
>> Hi Felipe,
>>=20
>> Internally, we have a mechanism to switch the DWC3 core maximum speed
>> parameter dynamically for displayport use cases.  This issue happens
>> whenever we have a maximum speed change occur on the USB gadget, which
>> for DWC3 happens whenever we call gadget init.  When we switch in and
>> out of host mode, gadget init is being executed, leading to the change
>> in the USB gadget max speed parameter:
>>=20
>> dwc->gadget->max_speed		=3D dwc->maximum_speed;
>>=20
>> I know that configFS gadget has the max_speed sysfs file, which is a
>> similar mechanism, but I haven't tried to see if we can reproduce the
>> same issue with it.  Let me see if we can reproduce this with that
>> configfs speed setting.
>>=20
>> Thanks
>> Wesley Cheng
>>=20
>
> Hi Felipe,
>
> So I tried with doing it through the configFS max_speed, but it doesn't
> have the same effect, as the setting done in dwc3_gadget_init() will
> still be assigning the composite/UDC device's maximum speed to SSP/SS.
> This is what the usb_assign_descriptor() uses to determine whether or
> not to copy the SSP and SS descriptors.
>
> So in summary, at least for a DWC3 based subsystem, the only way to
> reproduce it is if there is a way to dynamically switch the DWC3 core
> max speed parameter.

Could it be that you have a bug in your out-of-tree changes? Perhaps
there's some assumption which your changes aren't guaranteeing.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAmCD0VURHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQakZBAAgV+eQhx7ryPt0UO+KPkmowTjxDWbIW1M
TYhaZFRXMO1adEkgJ5b7/MehTApckTLCdKePZbIr0tRYJiIl3nanEdwoYMXFu6gp
77hb7BS44+uLUdzLwcMih0GM1YXc9pfW+KoJQgfr3WaMYARwBBfFFR6p/7a5xHiP
B8SJQj01URImpDjHY4MVd3p2YXtAoDEtnnmOGO69CeRUoBodDKIC+VwqRIA7drzR
+fUUOenSj5/5PGm0UMwlcKfOoqToAbbaEEYFWCWBHQOgPuEbUUEAq+y3dfYIM50v
SItQAtURt/e47kUlSKylIhzEdBc66//SlysCDMdY8aHcF+IxBiQU0R0ObCE1XUFD
kLKzol/0VshvbmsSYkk8xgxiXUrNlRbpeY30dr68GhW6pcWO36mC45UgZfh+3RrE
Lk4/SN8WTqECtED4Bh1XY62ChIMTUrF/VnGHxsrloonsUW5BYx+uV0OKmHj9dsWD
SjBRyakSRs030doET/eOrN03XudPlTcDUFRL7wXSAg3//MHCffJdWGlzwRHF5NmV
0Op+Y6xgFrxDFetHJvJ4nV4bXp2FypkaqUxFafRAvA/vK6OVZEI3SvPNyF5jMzbH
/17YNJ71W89CMdftoJmGoxQFwa5EnoJrMG8NaNPXUGABBwagUULKAvz3IBMadtbC
NgreGiruzI8=
=un7W
-----END PGP SIGNATURE-----
--=-=-=--
