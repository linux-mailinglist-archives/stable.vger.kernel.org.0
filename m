Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAB814B4CD
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 14:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgA1NXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 08:23:04 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:35783 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgA1NXE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 08:23:04 -0500
Received: by mail-lf1-f67.google.com with SMTP id z18so9062999lfe.2;
        Tue, 28 Jan 2020 05:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=LhZkJsFAE45iuiXTZCAvO5GLd86KmfP3egSUUi14+ew=;
        b=WAAukqEtRflwe2nAyxTDtZ8BvTlqv0XesJsLDApUAqFN6wh2+bdZYiJMfr1aPn/cnq
         Idg4/AUj6U4zWnZgKHTwHc9tUVmqFI8lZ2yKR3JT9pM2ymjOylx7PDbC0tTQCaxM+yEm
         6YjJdSTQE/E5JhDs+BR8QmqXQvWgAUx8uyviwaewVbq/DQYoPdZTLwd181pmoOtNGc+r
         cUXBndaafq15ZILKbcCmUx/AIArUScQ5CjfkXEQWjYwBHI704AceUmxzAZcESD4ppqLE
         qCFIDFbUnVTKNUbkPXY99tWqHredyYRuwBw3kr0NOgkEwfrxz29DR1vxuwWQFg43w3rv
         X98A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=LhZkJsFAE45iuiXTZCAvO5GLd86KmfP3egSUUi14+ew=;
        b=I20j7BTxLDLNbm/JRCbs3LnPe9oj1qsXmDRjZiMUVBzouAq8cNqns6+s01MZdoMgiN
         jvTTA1/i23tfxSzB6kmhDaYBhu/GSqIObf4d/nVA0oBgPrsjrWYli5hDerO6ISEUQI6e
         LQJzPzQJE+v0sJzunwhQGxGDl+Ntc4QhDrDSLFaJ1Kp5aEGIKpHNx0SBnPXHGamPjgjV
         U/nrfX4+8DwGnSiD9KOm+ildaYJl3c0efVpzA953oTq/MzmZKwiixlBEVVh1RXhB5nGC
         lHWG4XKkQKMdzyD6shWPErmmQ2C7GWHogDDmiLT8vxMXaQWpJzvH+8TYxVhcVhKd/zx2
         NMiQ==
X-Gm-Message-State: APjAAAWpvEdcwuZ/nVNf7kf0VfqErFrBa4VET/0EZXp25YOhr8IYeOD1
        daMXYsnl8R8+hi7/ka+zsLk=
X-Google-Smtp-Source: APXvYqwybebkDe4WYK0TuVcF2LZXt0ZhsZwyc/V5TizRmzdPUM4k6OE2Hnzaz3ET8TPtyzgMQMd+DA==
X-Received: by 2002:ac2:5964:: with SMTP id h4mr605146lfp.213.1580217780667;
        Tue, 28 Jan 2020 05:23:00 -0800 (PST)
Received: from saruman (88-113-215-33.elisa-laajakaista.fi. [88.113.215.33])
        by smtp.gmail.com with ESMTPSA id a9sm9875977lfk.23.2020.01.28.05.22.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Jan 2020 05:22:59 -0800 (PST)
From:   Felipe Balbi <balbi@kernel.org>
To:     John Stultz <john.stultz@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>
Cc:     Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>,
        Yang Fei <fei.yang@intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Jack Pham <jackp@codeaurora.org>, Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH v2] usb: dwc3: gadget: Check for IOC/LST bit in TRB->ctrl fields
In-Reply-To: <20200127193046.110258-1-john.stultz@linaro.org>
References: <20200127193046.110258-1-john.stultz@linaro.org>
Date:   Tue, 28 Jan 2020 15:22:54 +0200
Message-ID: <87sgjz90lt.fsf@kernel.org>
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

> From: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
>
> The current code in dwc3_gadget_ep_reclaim_completed_trb() will
> check for IOC/LST bit in the event->status and returns if
> IOC/LST bit is set. This logic doesn't work if multiple TRBs
> are queued per request and the IOC/LST bit is set on the last
> TRB of that request.
>
> Consider an example where a queued request has multiple queued
> TRBs and IOC/LST bit is set only for the last TRB. In this case,
> the core generates XferComplete/XferInProgress events only for
> the last TRB (since IOC/LST are set only for the last TRB). As
> per the logic in dwc3_gadget_ep_reclaim_completed_trb()
> event->status is checked for IOC/LST bit and returns on the
> first TRB. This leaves the remaining TRBs left unhandled.
>
> Similarly, if the gadget function enqueues an unaligned request
> with sglist already in it, it should fail the same way, since we
> will append another TRB to something that already uses more than
> one TRB.
>
> To aviod this, this patch changes the code to check for IOC/LST
> bits in TRB->ctrl instead.
>
> At a practical level, this patch resolves USB transfer stalls seen
> with adb on dwc3 based HiKey960 after functionfs gadget added
> scatter-gather support around v4.20.
>
> Cc: Felipe Balbi <balbi@kernel.org>
> Cc: Yang Fei <fei.yang@intel.com>
> Cc: Thinh Nguyen <thinhn@synopsys.com>
> Cc: Tejas Joglekar <tejas.joglekar@synopsys.com>
> Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> Cc: Jack Pham <jackp@codeaurora.org>
> Cc: Todd Kjos <tkjos@google.com>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Linux USB List <linux-usb@vger.kernel.org>
> Cc: stable <stable@vger.kernel.org>
> Tested-by: Tejas Joglekar <tejas.joglekar@synopsys.com>
> Reviewed-by: Thinh Nguyen <thinhn@synopsys.com>
> Signed-off-by: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
> [jstultz: forward ported to mainline, reworded commit log, reworked
>  to only check trb->ctrl as suggested by Felipe]
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
> v2:
> * Rework to only check trb->ctrl as suggested by Felipe
> * Reword the commit message to include more of Felipe's assessment
> ---
>  drivers/usb/dwc3/gadget.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 154f3f3e8cff..9a085eee1ae3 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -2420,7 +2420,8 @@ static int dwc3_gadget_ep_reclaim_completed_trb(str=
uct dwc3_ep *dep,
>  	if (event->status & DEPEVT_STATUS_SHORT && !chain)
>  		return 1;
>=20=20
> -	if (event->status & DEPEVT_STATUS_IOC)
> +	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
> +	    (trb->ctrl & DWC3_TRB_CTRL_LST))

why the LST bit here? It wasn't there before. In fact, we never set LST
in dwc3 anymore :-)

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl4wNa8ACgkQzL64meEa
mQZb7BAAmXPf4dz4rgNSd6F7EskOWnPTDig96416cMT8toKMH+wN+Gz/Dkjfl0/r
Ll4+mU5DozR0pBQ7GMiqiyCNVZDkf+yXB4zSrmuHBY6mUGGu+MRmcOQ06dk85XFp
Jv26A3gJyKmjx1YcORZCLlIgmuBQ9PSbPRaiOYA1JxRwmLW5vyxUdrqSN83/6Znb
wiw2fHxOQqCQloiM611DuxvkoyV1JTDd3FQOwObBsMRqDORydRWHA1rWGAsE1DUP
nCeG4aF0mtVKE2+GmP+ih6eDTsX9cFzJ9bqCJNqp3SpQFv67nse8v+vnZ+wARvAw
8GxLLHW6SiCodmWMilWJT8ugFTdLLnJJMU1qFVvCSvCaXYbWwTUbpCAlGFbZJ5FA
Nfm4Nv3ra/KXHwZxNqZxqBJXki80rAwaCAUjVPYwr9X0u2dWMzP4bg+YzFrzt5lK
3SFZsy7OLUvDa3uAAdK6u/3Ra349G9nmgyicbArC0pRIAdqNIgXUqt25WC6fEFtU
Q4YeykstP/A5u7TEFKnWeKEvH3VxgGW4J1QtQ+xerufv8H10SBFYjTCK58bNnHPa
P6mrfLZairsbN0s4GDa0/6RCTJ9U9fXmo56eDfvYKcoKNbMcsb5rboX6kbscvVAP
wU93kBdVCqVE1ab2dIwixEEDhO0QP491X75DU08adsibffcc/4U=
=TNFV
-----END PGP SIGNATURE-----
--=-=-=--
