Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA44146FBB
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 18:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgAWRbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 12:31:09 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39592 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbgAWRbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 12:31:08 -0500
Received: by mail-lj1-f195.google.com with SMTP id o11so4442736ljc.6;
        Thu, 23 Jan 2020 09:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=WXt6gjVeJUrJUf0Y8CoxViixubZMsgMLgh4C2DTnN/E=;
        b=ZkoM6bm9rqVUryU3KuPKM2e1ASmf3iXmLMikC8uiwKbZc+to5Ti/LUf/W1ra8/YH8/
         8+Mu64j7IjMlGWMLz9KU+SuoN6wjWgRATchCgOEsl/E+NYRmLPktBUv470JC7enrc3Tb
         rfaGavemN525QjTmS1IODBl+jk6xpAM3y3zMc5pHFDUZ0Aam1KmlMn+fZPw+uAt4C2wg
         B0zFPhbE5aRAPU/CKNzihEjHDzeqr/sLSBD02oMi+Jxt/e6+qNJxKlXxZEOg6vz9lJR4
         SFBWtL2oW1+fL8bmKbfsY2OR3TyF6hjR136dWDL97pEJuTwTl6k7d1sYkXIvLrJt0gmY
         HO2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=WXt6gjVeJUrJUf0Y8CoxViixubZMsgMLgh4C2DTnN/E=;
        b=lrRLAqUST95RXeW4uqjICw6VXC52nMA17fVAf6aq69A5xPnTE66sNj4HZf+TUui0fi
         HWb7OPjprw6oPQ6+hzaiXFMEoP9y144AIxdJHWOhPu4JQUNMB0wYk+FejDzS6qPO/3c0
         9tzO5o9fS77c3aTrhLHRqhEPMcE3sqxcfmRqDbzurckApo7N9PxwkgQTf59DoxSaGobo
         pWLdhEqjJCowRcbDdKVATpzE7gmEH1EmNxGP+OLAvNGTXT2VO4IE1pBJIxr6sT2Vl5Rd
         fEsLGn308zP4Ww98cOt+xkSKH8LepxSD5Xe4atmsvyouu+ujxrAGr+xHtKQ6iD2YhpAS
         /r2Q==
X-Gm-Message-State: APjAAAWQn21s4ZNYcI6ikZaMCChpxZsdFAeUdxF/zmmbo6KYIcnbkDAz
        BKUoTAqU+HA7oP4fNTvHkU1PcyqMk9Bs4A==
X-Google-Smtp-Source: APXvYqxP65y863qzNHh2Rf4zVXSCMzske7Raq7CwMthG1FBfKdyGZE6fQP/py86vfgtJ/LJefJK4CQ==
X-Received: by 2002:a2e:85cd:: with SMTP id h13mr23752271ljj.191.1579800666387;
        Thu, 23 Jan 2020 09:31:06 -0800 (PST)
Received: from saruman (88-113-215-33.elisa-laajakaista.fi. [88.113.215.33])
        by smtp.gmail.com with ESMTPSA id s18sm1932660ljj.36.2020.01.23.09.31.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 Jan 2020 09:31:05 -0800 (PST)
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
In-Reply-To: <02E7334B1630744CBDC55DA8586225837F9EE280@ORSMSX102.amr.corp.intel.com>
References: <20200122222645.38805-1-john.stultz@linaro.org> <ef64036f-7621-50d9-0e23-0f7141a40d7a@collabora.com> <02E7334B1630744CBDC55DA8586225837F9EE280@ORSMSX102.amr.corp.intel.com>
Date:   Thu, 23 Jan 2020 19:31:54 +0200
Message-ID: <87o8uu3wqd.fsf@kernel.org>
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
>>> Hey all,
>>>    I wanted to send these out for comment and thoughts.
>>>=20
>>> Since ~4.20, when the functionfs gadget enabled scatter-gather=20
>>> support, we have seen problems with adb connections stalling and=20
>>> stopping to function on hardware with dwc3 usb controllers.
>>> Specifically, HiKey960, Dragonboard 845c, and Pixel3 devices.
>>
>> Any chance this:
>>=20
>> https://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git/commit/?h=
=3Dtesting/next&id=3Df63333e8e4fd63d8d8ae83b89d2c38cf21d64801
> This is a different issue. I have tried initializing num_sgs when debuggi=
ng this adb stall problem, but it didn't help.

So multiple folks have run through this problem, but not *one* has
tracepoints collected from the issue? C'mon guys. Can someone, please,
collect tracepoints so we can figure out what's actually going on?

I'm pretty sure this should be solved at the DMA API level, just want to
confirm.

cheers

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl4p2IoACgkQzL64meEa
mQZbPRAAnbPf/J/ta6ffA1BbOyMUF8EnrASllIGEfba7lkJ06oM9KbYAWojsxv1z
pi3ch1+GVa0S5rCjwQItnCTUwMPqucLLFh9lzy6ubUL5oxTVa9nA6GhMmFTpomfY
jIQyhafsiW78+srmozJX5ibHpYQJpfSN/63t5XS26vxqTRcIf7AiOe4ZgpNAp/7w
AH2VAELrlgF7mIIMIwpozTvFXqxKd+QwrCVwAnz6fL/CW5/0y7V+VdgKbSgpI409
ycIRPGFt7vUCFuT+nfZXEB3pZIQ8urObdEeE9Bq+Tb7I5jGmqxngLcSxsiu97S0y
zPIn+nPmgOPyt1rOLrpw3VJtSdRmdz3Lnx/i5iwFXcXGGHvV18fQEznHMDz55wzf
N/umXnh/7mck9dMqcRDJCCw9Oq/PPA1twzCZ39Ne/Wom5Q+voHL0/liMTgIkXUhV
sf7tuaks+bKKTCYSOR6yIZKmkL1RIYt209wt9tigDBSj/gDJDdGtNX7rtCBYAd5I
mmKOxImp1hkwyOKPGN3UKSzOKLduajOkvac6fv1lh7kKWQjIAcx4e00cAGCmtRim
GD4Et1fYhI2/9c6qd96Z9U3YkdQ/O3cMQ9njYTRq/Ihm7Tohd+gdTSIt/Qu6m73Y
EPwPjgtecfvnV4lYmW0pt3PbDZBrBz4qYjlCF/PmaU35YJERd6E=
=H9Ta
-----END PGP SIGNATURE-----
--=-=-=--
