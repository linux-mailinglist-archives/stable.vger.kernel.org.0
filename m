Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833C21AD6EB
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 09:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgDQHGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 03:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728338AbgDQHGi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Apr 2020 03:06:38 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14561C061A0C;
        Fri, 17 Apr 2020 00:06:37 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id u15so939609ljd.3;
        Fri, 17 Apr 2020 00:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=fGQzwyFoGGaL1dX6Nzoo0EvKYXbaPj6p3weXm+OGjx0=;
        b=UysaFs+AQ31lBJ73Ap2WhLwj5xPh7rdmRYMteYX6CIUEuHHrrLio690vky9pOabo2b
         UWD+feZBp4FxVReNa33Aq6ktZkhBZNpYdFFmHaKfrnezsDzKJRH8YyHilehYP9xAkXdZ
         B3CPMdvWYVDn8H9EeNg7ipZx0FNmbI2YcVlgAC7i7nEP/U4yk2KPGKwwn3uDEGNXt0PF
         TyV6riNyww8/vpOxoQ1pjZkpLV+3vJ//DRNukpUSWcbY5DShyvxw2epPdb319Y2tmtOB
         MMMIMY+mN/yelabBg4a6CRrMiwX5WwYbkq6y7FG8qODk8V4olPLRxDboY91uDiWwj02X
         3flQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=fGQzwyFoGGaL1dX6Nzoo0EvKYXbaPj6p3weXm+OGjx0=;
        b=HlO3qQQ8id5z4gE43Q2xyOIRDAQ3xGG+Rkr90JocpkAsSk1mJpgfwFzgqr5GziFLYr
         IDb3Vlr6Sl5gZWEyqMwEvb+ca0ZqRUkhfptPqAOAf6mrzIBjRRR1MMfY7UrAsIFTOa4z
         39JC0GTmB4lezmnW59zaQw2KzVNdOiiy0EKnyr4ZKNztlxcBdg9wyof5S8zVivbcwCYz
         2jd4LW4VVVhdofommYnRACaajCPqcLopQB2dWFvw2vmZpYbBFDIDRXd3BajGwcGPXVz+
         +ud4bjp75oTaxOS1C/ZGFw/kORDXIiYb1pGoAftnvjTvGqmFuZBpjxV0x3fjXgMUKQUW
         MrHg==
X-Gm-Message-State: AGi0PuZYA8pwV3BRPWSom38dHuRzLYEkV44OuIv9ldAAXUYC3ZvWV6rB
        WR0Za8PnjIKvrwnUFfKTjFqD4SkTLU3RnA==
X-Google-Smtp-Source: APiQypK5/vPrxxRj4RPnWtOoi8a9uCdTop+h90ccE6pgqILqkyYYO9m7+RdjEgXDSjpEhKfwpvGNsg==
X-Received: by 2002:a05:651c:3ce:: with SMTP id f14mr1236697ljp.98.1587107195235;
        Fri, 17 Apr 2020 00:06:35 -0700 (PDT)
Received: from saruman (91-155-214-58.elisa-laajakaista.fi. [91.155.214.58])
        by smtp.gmail.com with ESMTPSA id v9sm15591097ljj.31.2020.04.17.00.06.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 Apr 2020 00:06:34 -0700 (PDT)
From:   Felipe Balbi <balbi@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb\@vger.kernel.org" <linux-usb@vger.kernel.org>
Cc:     John Youn <John.Youn@synopsys.com>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] usb: dwc3: gadget: Fix request completion check
In-Reply-To: <5cdcb770-fb6a-14fe-e652-857234c9f69c@synopsys.com>
References: <bed19f474892bb74be92b762c6727a6a7d0106e4.1585643834.git.thinhn@synopsys.com> <5cdcb770-fb6a-14fe-e652-857234c9f69c@synopsys.com>
Date:   Fri, 17 Apr 2020 10:06:24 +0300
Message-ID: <87k12ed21b.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi Thinh,

Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:
> Hi Felipe,
>
> Thinh Nguyen wrote:
>> A request may not be completed because not all the TRBs are prepared for
>> it. This happens when we run out of available TRBs. When some TRBs are
>> completed, the driver needs to prepare the rest of the TRBs for the
>> request. The check dwc3_gadget_ep_request_completed() shouldn't be
>> checking the amount of data received but rather the number of pending
>> TRBs. Revise this request completion check.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: e0c42ce590fe ("usb: dwc3: gadget: simplify IOC handling")
>> Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
>> ---
>> Changes in v2:
>>   - Add Cc: stable tag
>>
>>   drivers/usb/dwc3/gadget.c | 12 ++----------
>>   1 file changed, 2 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
>> index 1a4fc03742aa..c45853b14cff 100644
>> --- a/drivers/usb/dwc3/gadget.c
>> +++ b/drivers/usb/dwc3/gadget.c
>> @@ -2550,14 +2550,7 @@ static int dwc3_gadget_ep_reclaim_trb_linear(stru=
ct dwc3_ep *dep,
>>=20=20=20
>>   static bool dwc3_gadget_ep_request_completed(struct dwc3_request *req)
>>   {
>> -	/*
>> -	 * For OUT direction, host may send less than the setup
>> -	 * length. Return true for all OUT requests.
>> -	 */
>> -	if (!req->direction)
>> -		return true;
>> -
>> -	return req->request.actual =3D=3D req->request.length;
>> +	return req->num_pending_sgs =3D=3D 0;
>>   }
>>=20=20=20
>>   static int dwc3_gadget_ep_cleanup_completed_request(struct dwc3_ep *de=
p,
>> @@ -2581,8 +2574,7 @@ static int dwc3_gadget_ep_cleanup_completed_reques=
t(struct dwc3_ep *dep,
>>=20=20=20
>>   	req->request.actual =3D req->request.length - req->remaining;
>>=20=20=20
>> -	if (!dwc3_gadget_ep_request_completed(req) ||
>> -			req->num_pending_sgs) {
>> +	if (!dwc3_gadget_ep_request_completed(req)) {
>>   		__dwc3_gadget_kick_transfer(dep);
>>   		goto out;
>>   	}
>
> Since you'll be picking this up for the rc cycle for your fix patches,=20
> should I split this series to resend and wait for this patch to be=20
> merged first before I resend the patch 2/2?
> Let me know how you'd like to proceed.

That's okay. Usually it's better to have the series split, but since
it's only two patches, I can manage :-) I'll just leave patch 2 unread
:-)

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl6ZVXIACgkQzL64meEa
mQZQKRAAxdoO+6RUfZJyQqS5ZzF/466fG1t53GS9Ps98u6M3aJuUVYtpJnNz6LAU
lr/i7s8OCQVQEnNWMSYUHUpsDvQPyf42RCooaJbstcaXrWglW1FmY5nRF9j8JPeV
AjhANXL5TnEeVNkKpbdCzhRzByk9GaozzXi1Fz3icEnorBWX0xq0Z702UAAaGNte
7QBMosSIGCMr3b+cqWo/jnGRjqaxVRjiEB/heguCkZHG/8Pkjpa6Cx5lrMntGGgS
LHslgIe1PemhFfA5N6Q7Wm3m6E+Gw+yudpxlKZRqR1UCGBX6jYPl5WR/bcD2fdCA
eYIT/SK1iGf0Cy+KzvtsVvt+1b1mEpzGzS/jfdtRP7i4M2Pgaq/WOUwVziQFkaY+
MX2IFRqgnNCutixEvgkL3K5r0Ge9ZZSXf3WW6/5bofmTtMS4bLM8evR7fnjLYx8f
dOQ/hE9Zg1GCMfhtBh/G7E1anNd4d68Hzoe+g2xRp42TckyaQtsYK8L7B/OGKk+Q
2e+WIdvPTyKHYkK8XIaalqEAL7x+7gBbMUQHKXTqq6NCYcH5Eb5flnyFa/ByI9CQ
kwZnUbNgKGqdJ1i9OqFLTVO1gHcQ+pcjbkKo9QZihr5wKQto9bWlQxfw6C4gi7Nd
szoktu6RYNNzYWqEhMOReG+AzRSi5//bVb1O6cJYmQbTM7hK8F8=
=RGrp
-----END PGP SIGNATURE-----
--=-=-=--
