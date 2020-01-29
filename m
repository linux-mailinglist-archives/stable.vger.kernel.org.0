Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06CE114C6CF
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 08:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgA2HXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 02:23:14 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35813 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgA2HXO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 02:23:14 -0500
Received: by mail-lj1-f195.google.com with SMTP id q8so13195288ljb.2;
        Tue, 28 Jan 2020 23:23:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=ajTpJw8s/37Cus5fl/uIutwpXiwHjopTPE9k9TATV7c=;
        b=WdjdY9WL1OKraIcN0u0FHgoCUazSAXAn4pAa/CUOms5Ky2mhZDfSqqYMWfjTe/3Srt
         Ycwe2H3S3x8WdcdCz5DOiFEaDaKgArqOjdlU9f0ZvOsBbHnA6OB411z1Ky+b+ebJShA1
         faHHoGkhDwiWTpLbWRPiOgRaAs0OTdMz+plY5t3c1HmEzVDJDyWu+hiwoNLIMoc+iMCk
         OmUfyos4Q25+xKB8qL+mXSgmKfHGFfNKTeuZUTQgybK32PcQCjMmQlvCR4ax7+W1XmVf
         o2cPu5Aw5K8SlmQgNxzgGNJDvvufOF5+sfW8dlUoVZcnktEDeUS5Rfcp9K57r9td32YE
         RisA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=ajTpJw8s/37Cus5fl/uIutwpXiwHjopTPE9k9TATV7c=;
        b=RJ7ZkzxablKbtMsu16jIrQ9/XPw0a1eNygqFYdUY3AtVucPIi9c4bDmV5XOLqGiedT
         DFMigyOrgut4lwVuYKGBvA2iAh6BbOQHlfK4AWNuvnRlC/t1VmG+RgGZ+UlxkxeVTf4e
         QF4R8XeCVt3G54QIBbt4khLZ6mBQeC5GqjQFS3yqQUb9aO6v660ZxBsbbn2kNNRcW0M6
         ADi2aMfL5+W7Ab7WgXafJ6MvzQISMv63cOUy4hg1FkjiQAWmPD1b6puo9/EmA2Qp2cb+
         7doCSvY95qL0eL9fzoPtAj5YyH1ooXOrISEeEmTN7QmY1+uOyRAooLHmsaRwgtHxwksZ
         gfBQ==
X-Gm-Message-State: APjAAAWUQj/ibysMjizBB3NbEjIAa14AMrOegX4QH6/Sfht6tLaEP/kZ
        Mf1QwXoqxZ0z3Sxk7eeC8qE=
X-Google-Smtp-Source: APXvYqyfQYCOJXPWx/EvBSsGy6PMLwVhkeOmmrWvy4VJR+Ogg/O1s31zNwexHaI5e+dTUHGY/53udQ==
X-Received: by 2002:a2e:3619:: with SMTP id d25mr15123834lja.231.1580282591487;
        Tue, 28 Jan 2020 23:23:11 -0800 (PST)
Received: from saruman (88-113-215-33.elisa-laajakaista.fi. [88.113.215.33])
        by smtp.gmail.com with ESMTPSA id a22sm403225ljp.96.2020.01.28.23.23.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Jan 2020 23:23:10 -0800 (PST)
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
Date:   Wed, 29 Jan 2020 09:23:06 +0200
Message-ID: <87lfpq915x.fsf@kernel.org>
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

since v5.5 is already merged, I'll send this to Greg once -rc1 is
tagged. It's already in my testing/fixes branch waiting for a pull
request.

cheers

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl4xMtoACgkQzL64meEa
mQa/nA//VGdZMiehyCvAAfGLm+MKvptDhZ8CkqSLlyLBsHceA5FNizlO80iJPgEX
cYG7EefYWfUU7JPhIvlHWm0BbZ6gfj3raCqsbjdSdidy0rpCsjxEpaiDpmDrjeIw
jzwz5s/GdQF2xUXTEuH4Tw0XraYZaI0YWzAyVxnzeQzXQxXw0Oy+odD87QVjm40u
t2JPNyC8si26lGGtBBnx4ZK3HsV+bXEtLgaeW5Xdei8sFpOuVqXDCDKEhBwu+YMh
7XkKPlWUuuRBv4fWDivR6RkTkShvtLqQCz9Pu80qwIHRKjoowm1ELRA1u/DL1NIa
sSQB35txyJJ7YW5xAizOyrpMJytZ2qULPlhYlUncBfxTx+twoeDMskT+JEw1+q0B
mL2F+bmx3HwSzDaOPDGjEMd2dPrDMuliteTCcnsAUi48TjMNFv4f19PB5PlGJQEh
9r49ZBCuYCGnfmpOdRzaDeP5ytJ4MFRzlv/uuVqM/W4TlnLxqIwqol0u5ukCQylI
0UIjbL6RRLIDGV4gY7MBclmkMIqFoDxmPMWh7oXHmgmTjxVHIegqvHzWoxiMXayD
wQh0SZKuzMA5uf1bvFilmoaKHgZqSJzgwyVbyCk4V1XvrTC858+T7yzXt5OOWJ0c
sPPaiGmcNsDL2cfZPy7AC2gtxxpi7KH9pUqK4Dhw0xwaOCYR1aA=
=JwUK
-----END PGP SIGNATURE-----
--=-=-=--
