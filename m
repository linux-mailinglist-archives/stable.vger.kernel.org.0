Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86F1B146FF7
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 18:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgAWRqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 12:46:06 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41733 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbgAWRqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 12:46:06 -0500
Received: by mail-lf1-f67.google.com with SMTP id m30so2958559lfp.8;
        Thu, 23 Jan 2020 09:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=9SUGR8QdPMNh7QLWat7AGgDe3jaF2rbpW1KxZ9s3AOs=;
        b=sbFxacSfBCAGBU7s2TQJY0DzNNQymStUoOtlfwJBSEBZcT6Z/Mj9byWnE1Za5HXWkB
         HHwxRj5HnyQLx0JTKC4L1ghcKf8AgKcqkc0Mu1b3SgdH3LMU04PsjcLonuH3Zfl5M3G9
         6NQIneG0d0c6MgKlDpopQtJsg1qegmt59z8gBdm9BZpq1CaZNJoXQwCBrmGd8Fe15rxu
         D2YrNynapEEOiHCGsaeWp/u0+6G+N/JmhB9+x1g0kzrNyYxKT11DedfTf4m+q4oSgv+t
         KPkmLkX+JhNE+2xMdYCHXC+g2G5NN+FZJTf5cmsBCMXqE2RXSYPnWNeh5xQf+pmZJ5zT
         6s6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=9SUGR8QdPMNh7QLWat7AGgDe3jaF2rbpW1KxZ9s3AOs=;
        b=acUccFWUpfaY+2pX5apMWCetRGDrBrGKyZd440RRxbLbGGAC+qh1T12R2T678qHkPH
         vsyx7n/CMw7C/lyGpDzUFeXKDkiEm+ZHGKnt2isGLbDhjcmXTolQyss3BNqWSkp/lu56
         EhoT3fDZia8+Nap48+AFGlV8vDPG+81hkVP23myBnHGBv9KL/HQsds9loBMp9TEEANPz
         kIy2WerDSgDgwEDZs7wPflxZhIONlNr0YultupEGBKfg0e6WWnKmO/BSpa/J4jgDPcpx
         /vODQO1IFdtaSOrUj6enwE/blg2SMnWBSpUiaFXKsG+dXuAdYw26dUqhjnAJTMk7skrL
         vO+g==
X-Gm-Message-State: APjAAAXpqRJpW6mw3xr2kzQHTwYx1xPcjQh5ALL42Lqv1X7nMTV2OWGG
        UhBTHYZXaiDTOqYWqAobmRls03iykySScw==
X-Google-Smtp-Source: APXvYqx1D1Oq970OIGQK6so+TTaZuGf+dWk0DQrGNPBalH7w5tCE1RWZJXmyIiFu0n1PWuhk49C2MQ==
X-Received: by 2002:ac2:4a91:: with SMTP id l17mr5353742lfp.75.1579801563345;
        Thu, 23 Jan 2020 09:46:03 -0800 (PST)
Received: from saruman (88-113-215-33.elisa-laajakaista.fi. [88.113.215.33])
        by smtp.gmail.com with ESMTPSA id r2sm1668668lff.63.2020.01.23.09.46.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 Jan 2020 09:46:02 -0800 (PST)
From:   Felipe Balbi <balbi@kernel.org>
To:     "Yang\, Fei" <fei.yang@intel.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        John Stultz <john.stultz@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>
Cc:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        Jack Pham <jackp@codeaurora.org>, Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: RE: [RFC][PATCH 0/2] Avoiding DWC3 transfer stalls/hangs when using adb over f_fs
In-Reply-To: <02E7334B1630744CBDC55DA8586225837F9EE335@ORSMSX102.amr.corp.intel.com>
References: <20200122222645.38805-1-john.stultz@linaro.org> <ef64036f-7621-50d9-0e23-0f7141a40d7a@collabora.com> <02E7334B1630744CBDC55DA8586225837F9EE280@ORSMSX102.amr.corp.intel.com> <87o8uu3wqd.fsf@kernel.org> <02E7334B1630744CBDC55DA8586225837F9EE335@ORSMSX102.amr.corp.intel.com>
Date:   Thu, 23 Jan 2020 19:46:51 +0200
Message-ID: <87lfpy3w1g.fsf@kernel.org>
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


Hi,

"Yang, Fei" <fei.yang@intel.com> writes:
>>>>> Hey all,
>>>>>    I wanted to send these out for comment and thoughts.
>>>>>=20
>>>>> Since ~4.20, when the functionfs gadget enabled scatter-gather=20
>>>>> support, we have seen problems with adb connections stalling and=20
>>>>> stopping to function on hardware with dwc3 usb controllers.
>>>>> Specifically, HiKey960, Dragonboard 845c, and Pixel3 devices.
>>>>
>>>> Any chance this:
>>>>=20
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git/commit/
>>>> ?h=3Dtesting/next&id=3Df63333e8e4fd63d8d8ae83b89d2c38cf21d64801
>>> This is a different issue. I have tried initializing num_sgs when debug=
ging this adb stall problem, but it didn't help.
>>
>> So multiple folks have run through this problem, but not *one* has trace=
points collected from the issue? C'mon guys. Can someone, please, collect t=
racepoints so we can figure out what's actually going on?
>>
>> I'm pretty sure this should be solved at the DMA API level, just want to=
 confirm.
>
> I have sent you the tracepoints long time ago. Also my analysis of the
> problem (BTW, I don't think the tracepoints helped much). It's
> basically a logic problem in function dwc3_gadget_ep_reclaim_trb_sg().

AFAICT, this is caused by DMA API merging pages together when map an
sglist for DMA. While doing that, it does *not* move the SG_END flag
which sg_is_last() checks.

I consider that an overlook on the DMA API, wouldn't you? Why should DMA
API users care if pages were merged or not while mapping the sglist? We
have for_each_sg() and sg_is_last() for a reason.

> I can try dig into my old emails and resend, but that is a bit hard to fi=
nd.

Don't bother, I'm still not convinced we should fix at the driver level
when sg_is_last() should be working here, unless we should iterate over
num_sgs instead of num_mapped_sgs, though I don't think that's the case
since in that case we would have to chain buffers of size zero.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl4p3AsACgkQzL64meEa
mQaTdA/+PpmXuec0fjzp1yy6MejaVnnPEOFDVaOYvpaYkbH9C/UhwT42e5ZuaVg1
abC2wFsKPer2Xbtb9rmJflvqiD+smblgDpkLyFHEwZRC0a7o+c6CkFYMPNNM9+w/
sNWVwM3sfLGQ9Wcx0hQueLmhksBbvGcAqnph/MwFJcz81k77/BEYFqo/8n7c6o7K
YBJrySxFqi6y/jCv0u+FDG449XOdh2Udydp/7UPCXrOZis6D2nxiiU8H7taKGZuO
jluTVDFsFQK9CA8GVLMocciLUPSQlSDlac3cUH4lQnVqDGNGfjSN37AkFzeUKSNL
HgOJA0E4ewtZFe3EM1JKQU968a3OrPYkdzZi0pvwnDxfJ8pyo1/jqQInz518etwq
SHqM2r/Pwwtem+wwbi6Z+WKmfwHI445Jht3DoC1dSnREXSG5VzXJzyIWVrAvtexN
kWDaqp4tBVQqVbsmOIQVBio46kBe/yNlhFgycnaXGSlz7JLJXvfMqhA4xSAbr6Vt
rob9DoX879dS0JS3YN6tOHQeP0eVZjq/xUwTjhVDA1l/XNb7WM4lx//5o8hqn1VW
XMP9VBC4W0NZoRmhi4pcp7zXHxTal68rLJkYL78yi8R9N3ERuo3XylA40jAOaR0E
najiMxtEwxPalArWq9qbWI/EcMEMMiom03pZnFnHAiTsj7alMhE=
=ZK9D
-----END PGP SIGNATURE-----
--=-=-=--
