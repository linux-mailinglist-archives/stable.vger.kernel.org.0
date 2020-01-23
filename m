Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA59146265
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 08:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725785AbgAWHSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 02:18:06 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37871 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgAWHSF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 02:18:05 -0500
Received: by mail-lj1-f193.google.com with SMTP id o13so2062976ljg.4;
        Wed, 22 Jan 2020 23:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=CuAldGSLPgj0cZuA52UGe8E13YiFUOjfGwBDFKo2yXE=;
        b=pTJQTezq81jzUrz1athF8jHmipi5dqDAep36wvKBsnjIeRbrpHfj8r9+Tugd7Z+jqB
         A/4UqxyhMn595iUxS8UoNdZ16txu+/WpcxfLMSvRTJiXimAM8+g0U8fsf3ZalAC/yrry
         4WOeMSY7Jzi/KzA9j0Y44JInmsPOBcosbzchfoqJ5tbVrmdT6p8EgRIEBeuJCv7DLLAY
         FtzGubnd07cydZX+jS5NcJrSxNPVRLLtYr1PDGpL5VmcWEDTHXt/A5gPs+773eDfnqu0
         HPm1YLEU9wmLwWuGI0Ln34snAp4uCF3XPjxOO3+8zd/QuAIg0elGCM4YBlnwnEEPsxJ3
         NL2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=CuAldGSLPgj0cZuA52UGe8E13YiFUOjfGwBDFKo2yXE=;
        b=Gi7iC8Bai/dBYCAF6U+o6Invcivs+D6s5D6VHv6YKQ5Rrl+A1mwCyp2mA6M06qgZ6W
         QZ9NkHJ+kP4uKI3HOLpkoV5FwsNnzupNNiv+PrYaqm8Udzvj/B+FDMLpUhfpNGsydoEb
         yQRZ11j1RbgnXWL4Z1ca2sclU+jRxl0K7Q6ADIHR4yc89zVp0mUYJak4xd974NfoIUw0
         d3FNUKiUyYJ6r+HsPVgNl6D6FOCiGwnBzkCAAWcfs2G6l+0qZQ05tfzcvzggG0TmB+ZY
         3K5IPCQrmUSaKV0a5/pLcONQBYkeXTc2L4sFmJukdgg6austVr+jxl9ApE2kp4+BrD7o
         5iyQ==
X-Gm-Message-State: APjAAAXPxNLKKU8dsrTmRL/DuI/1TsPjCmtCctAGoPC/QsbBb8VhC+wj
        mfr5zghp4lxpOeBWHIYJoUnfCEcih4QMQw==
X-Google-Smtp-Source: APXvYqxFnbRaep+bCKnSDmdNWgWm4w4KYg5InBAn9aQzIdjnhM9rXicTjlaeGth6vfWzKn61B9vBlw==
X-Received: by 2002:a05:651c:204f:: with SMTP id t15mr22756637ljo.240.1579763882077;
        Wed, 22 Jan 2020 23:18:02 -0800 (PST)
Received: from saruman (88-113-215-33.elisa-laajakaista.fi. [88.113.215.33])
        by smtp.gmail.com with ESMTPSA id u23sm528003lfg.89.2020.01.22.23.18.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 Jan 2020 23:18:01 -0800 (PST)
From:   Felipe Balbi <balbi@kernel.org>
To:     John Stultz <john.stultz@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>
Cc:     John Stultz <john.stultz@linaro.org>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Yang Fei <fei.yang@intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Jack Pham <jackp@codeaurora.org>, Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/2] Avoiding DWC3 transfer stalls/hangs when using adb over f_fs
In-Reply-To: <20200122222645.38805-1-john.stultz@linaro.org>
References: <20200122222645.38805-1-john.stultz@linaro.org>
Date:   Thu, 23 Jan 2020 09:18:51 +0200
Message-ID: <87wo9i4p44.fsf@kernel.org>
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

John Stultz <john.stultz@linaro.org> writes:
> Hey all,
>   I wanted to send these out for comment and thoughts.
>
> Since ~4.20, when the functionfs gadget enabled scatter-gather
> support, we have seen problems with adb connections stalling and
> stopping to function on hardware with dwc3 usb controllers.
> Specifically, HiKey960, Dragonboard 845c, and Pixel3 devices.
>
> Initally the workaround we used was to simply disable scatter
> gather support on the dwc3 by commenting out the
> "dwc->gadget.sg_supported =3D true;" line.
>
> After working with Fei Yang, who was seeing similar trouble on
> Intel dwc3 based hardare, Thinh Nguyen mentioned that a fix had
> already been found and pointed me to one of Anurag's patches.
>
> This solved the issue on HiKey960 and I sent it out to the list
> but didn't get any feedback.
>
> Additional testing with the Dragonboard 845c found that that
> first fix was not sufficient, and so I've sat on the fix
> thinking something deeper was amiss and went back to the hack
> of disabling sg_supported on all dwc3 platforms.=20
>
> In the following months Fei's continued and repeated efforts
> didn't seem to get enough review to result in a fix, and they've
> since moved on to other work.
>
> Recently, I found that folks at qcom have seen similer issues
> and pointed me to the second patch in this series, which does
> seem to resolve the issue on the Dragonboard 845c, but not the
> HiKey960 on its own.
>
> So I wanted to send these patches out for comment. There's
> clearly a number of folks seeing broken behavior for ahwile on
> dwc3 hardware, and we're all seeemingly working around it in our
> own ways, so either those individual fixes need to get upstream
> or we need to figure out some deeper solution to the issue.
>
> So I wanted to send these two out for review and feedback.
>
> thanks
> -john
>
> Cc: Felipe Balbi <felipe.balbi@linux.intel.com>
> Cc: Yang Fei <fei.yang@intel.com>
> Cc: Thinh Nguyen <thinhn@synopsys.com>
> Cc: Tejas Joglekar <tejas.joglekar@synopsys.com>
> Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> Cc: Jack Pham <jackp@codeaurora.org>
> Cc: Todd Kjos <tkjos@google.com>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Linux USB List <linux-usb@vger.kernel.org>
> Cc: stable <stable@vger.kernel.org>
>
> Anurag Kumar Vulisha (2):
>   usb: dwc3: gadget: Check for IOC/LST bit in both event->status and
>     TRB->ctrl fields
>   usb: dwc3: gadget: Correct the logic for finding last SG entry

I remember commenting on these patches before and never getting a newer
version from Anurag.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl4pSNsACgkQzL64meEa
mQaZmQ/7BhhVxhrUcob+FDCHXKdmzKnNLEG/H/r/68jTyDwKyboVDrNkpLPsoO4k
dVEivoTB+X4V+m/G4sqt4jOeSrQs7dOzvzvBdG23yXqL+2xAP6BTVN1qcdXcCTJY
Ywf5z6tTilVutCMp+KRSHpzsNDOmJWvyn2OZsWxp7e55kOuA0svL1fRY9lRt3Lhg
FPoKXt7u8oAl1f0SGgKxZemuNROu3CGDdBc8ZpQM+t4/ac5QikfrtdIuFT1uXStz
QT2n/wg5N+juvFOzjvR9PDXzmopaI8/Toli3nkBBsujThLga3beSjBU7ZneO7MP5
j8zc7ArMBFdJ7cEBhEfMLPyvDzQL0MPPXuJcQLaMyiZzx4qyb00/jxLCOsFw2srj
UBzLwuDSJ2CbqgPnRp+WgEcDW8/j31+SI6nCcnyVgJzX6NXKVXhrZF6jPnI8J6yB
JGSDm+zkflrdwq5olLXGOhZzQ60VpVN5MH700NuP/JwBa8FX4YAVwXAH6CeVjioQ
5WbzR8Bui9aX2DaqXjBaA6tZpM9BnPVouhAUN4CzlmbOTIfxQNTzAa2K8eOIsl6d
IN/vXcCKZQu+6K9UurRXdHjIl1Lf46w2zrXmar31qZe3MGdJc6bJiXfg6RZjFoOB
GhthkcAdk84kL/5a7XEbmvhGWXC9BrALivfWdiqwAWYF+HkK61M=
=VsDB
-----END PGP SIGNATURE-----
--=-=-=--
