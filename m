Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80B1913551B
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 10:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgAIJEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 04:04:40 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40096 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728593AbgAIJEk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jan 2020 04:04:40 -0500
Received: by mail-lj1-f196.google.com with SMTP id u1so6364111ljk.7;
        Thu, 09 Jan 2020 01:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=1wEOto74WtWWVBt7hzzCLvY/HjBRw+30JpsajXmQoEk=;
        b=VotdQx0hBmaNiqYwnMQi/EoFgHh8UCayXB4uXSKGMi1WrsslgqIiMk59yLYmePW/jr
         UX4X7OlHN1wka3AG+U7v53aOSLZrO6JLZiCfDYCucZVVijrOdaq/sx+VIYgYXuTddXKh
         HErVa3kc1zbVXwjCK9ABRN80F+eWwLWplp5TcBYnDlfVdQcGmyMocfoTCSD++pWq9rZT
         8+b4E9RJdzBq2saGIqWgAiuKRKAkLFCN22MLVOGvl564Rd6NiZXie7FPJw5lDC/L9f7E
         ujtVV/TvXH9WuNheVFI0GN72woG0jjR6C2kwmb4Hpk6bH2UzgNZAE9Pa9zVuAB+4wwsx
         Jn4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=1wEOto74WtWWVBt7hzzCLvY/HjBRw+30JpsajXmQoEk=;
        b=YfAj7FduZ+lHwQ87EolwzgfeM7wDTHHpjco/5P2oQKeo7z+ER5MykxV6PgnTSUDyuZ
         DRU9qeE73dBFb84jtuenHIO/54rTfXeid6jqRnuvj71nkQyApQ1xKCg7DOEVnQh3nyCn
         dL7uWM9wn5axhJpauqSQuBQhMHBUSIBuOSWDMu9tMTVdyRzY7KfX0XFjhIa8QRMB5Dx1
         gH6swkRSvbUHav2GcLbZnuO/A47vOinGMQaRMCFD1vufgiy+Q77no6WvnUbkc1s4ohnc
         lBnJqQyyMAzdeB4CmnJ0VSwHfojOfq6NtF+07HwMYK2fU0ldMKZq6LvhxsXpJo1EIrCy
         bwQw==
X-Gm-Message-State: APjAAAVR2Kiek7kx2337kzuGVQ8AFjtn9N/YKjIfIJAvuc72XocicaeC
        xB8uFlMwGMc2p0XJEytV+oUHR25Ztnw=
X-Google-Smtp-Source: APXvYqzlF6/2MuHY8a8TVJoWkGCaL58M640PRwVGM5HPTEGrm05lpplLJqVg2vc2CwGADNtR1gTPSQ==
X-Received: by 2002:a2e:804c:: with SMTP id p12mr5681606ljg.31.1578560677836;
        Thu, 09 Jan 2020 01:04:37 -0800 (PST)
Received: from saruman (88-113-215-33.elisa-laajakaista.fi. [88.113.215.33])
        by smtp.gmail.com with ESMTPSA id u66sm2615261lje.7.2020.01.09.01.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 01:04:37 -0800 (PST)
From:   Felipe Balbi <balbi@kernel.org>
To:     Tejas Joglekar <Tejas.Joglekar@synopsys.com>,
        Ran Wang <ran.wang_1@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejas Joglekar <Tejas.Joglekar@synopsys.com>,
        Jun Li <jun.li@nxp.com>, Peter Chen <peter.chen@nxp.com>
Cc:     "linux-usb\@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: Re: [PATCH] usb: dwc3: gadget: Fix controller get stuck when kicking extra transfer in wrong case
In-Reply-To: <9f9d0193-8fe6-33b3-4f5c-95a1181e6681@synopsys.com>
References: <20200107071441.480-1-ran.wang_1@nxp.com> <9f9d0193-8fe6-33b3-4f5c-95a1181e6681@synopsys.com>
Date:   Thu, 09 Jan 2020 11:05:30 +0200
Message-ID: <87woa1rodh.fsf@kernel.org>
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

(Tejas, please break your lines at 80-columns. You shouldn't have to be
reminded of this)

Tejas Joglekar <Tejas.Joglekar@synopsys.com> writes:

> Hi,
> On 1/7/2020 12:44 PM, Ran Wang wrote:
>> According to original commit c96e6725db9d6a ("usb: dwc3: gadget: Correct=
 the
>> logic for queuing sgs"), we would only kick off another transfer in case=
 of
>> req->num_pending_sgs > 0.
>>=20
> The commit 8c7d4b7b3d43 ("usb: dwc3: gadget: Fix logical condition")
> fixes the commit f38e35dd84e2 (usb: dwc3: gadget: split
> dwc3_gadget_ep_cleanup_completed_requests()).
>
>> However, current logic will do this as long as req->remaining > 0, this =
will
>> include the case of non-sgs (both dwc3_gadget_ep_request_completed(req) =
and
>> req->num_pending_sgs are 0) that we did not want to.
>>=20
>> Without this fix, we observed dwc3 got stuck on Layerscape plaftorms (su=
ch as
>> LS1088ARDB) when enabling gadget (mass storage function) as below:
>>
> Similar issue was reported by Thinh after my fix, and he has submitted
> a patch for the same. You can refer the discussion
> https://patchwork.kernel.org/patch/11292087/.

Based on this, I'm assuming we don't need this patch.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl4W7NoACgkQzL64meEa
mQZPbBAAglbugDsFjPT9ikTC9/5AsAxJ+HS5SorFeA9dP3g1FIQ/m+ktbTeSnVlJ
j4dMLFA/6URa7v+Tsfq9U8lM2BJfHOoyE89lQwTZ45emLwdt10YdOTcN6LwbC9KB
YRsR7ezdI78Nwaq0tIIinJMefjgEtQZWXfNGAkgKCAG7j9SKgRSJYd9J7sck5+FD
w26iKRioC/ZTcnX8XLiDDbE2s9hpshCxWmH7XiZ93+b8pPkdada+/alFDFIDbrr+
kYsyFtFSL5w+WiNp+Ls4FSHddmF0iHs+E0Jeft7uSnPTRRcg5Ns4YcjmQgh+Bxkz
jJwp+LnYOI3wPjpK5JiG6BuZVqOB0hzWF0Xzb/Uz57Mx3fIKpx1bvJsuH9zZMAKX
4Qn6kmsxHs2vhuX+YJwzdMQLvF/M6Jg9+CwckLcE2TZJ7hKW26bgyfkiJG7EID7D
E+y2MBc3MtRO5p0kO6fGpJmbWLw7y46gnu8DgRWmdcEZr7BDzx4JTeZ7pHSP0UMn
ulJGntcsYKX2FighVVMjJCLRYjQOVfzzeh76kIoEJSMlW8qAKdVPgZp530LFWB6c
Ak84Nxf6jhcVnj7GofYZwPUXvpedHCDQqXK+ZB5aj228ypSiVnD8yRp5/Xh0sdJD
67ZBtVd0/rzn8Iez4RnR/psGJUNDt50tQVW9xasGn5Rjd+IywOg=
=Q3Sj
-----END PGP SIGNATURE-----
--=-=-=--
