Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287FC380427
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 09:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbhENH2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 03:28:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230326AbhENH2C (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 03:28:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB045610A7;
        Fri, 14 May 2021 07:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620977211;
        bh=9jpMY2J8KOmOqqhBNxJH1weZb9RhnwZTWAA6rqCLgiE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=o0KY2kAd/TvmUGvwrzvBgY/i0Xy/nV8Iw03RwMa0RyeU2nJsME/QnW6d7uMLUyAlQ
         n7R7go0A4jzNzUXDx9pUbGJ2QDFZ1WfHVu6CpVKAw6Cdt4fIUdvWNtig6r2GcFZST3
         sIpD7UWEtr4dfbMBcYpOTnRFdAI6htmciOPwhedBpe8qRLcHA2GepK5YonZEdVKpdy
         +DO+moNEjQsTjbx56WzeKHDGEbOUC59xUH29cyw+n0k1pYLyLC56ObmP3sNrpRezPR
         F76NdMFHiL9UYwNEkR9AGwrlc1QqtyT+SSNfi6ogga81UVaLjoBsMeQTnOwleEAxz0
         a5F+R/t2TffuA==
From:   Felipe Balbi <balbi@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH] usb: dwc3: gadget: Properly track pending and queued SG
In-Reply-To: <ba24591dbcaad8f244a3e88bd449bb7205a5aec3.1620874069.git.Thinh.Nguyen@synopsys.com>
References: <ba24591dbcaad8f244a3e88bd449bb7205a5aec3.1620874069.git.Thinh.Nguyen@synopsys.com>
Date:   Fri, 14 May 2021 10:26:42 +0300
Message-ID: <87eee97p3h.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:

> The driver incorrectly uses req->num_pending_sgs to track both the
> number of pending and queued SG entries. It only prepares the next
> request if the previous is done, and it doesn't update num_pending_sgs
> until there is TRB completion interrupt. This may starve the controller
> of more TRBs until the num_pending_sgs is decremented.
>
> Fix this by decrementing the num_pending_sgs after they are queued and
> properly track both num_mapped_sgs and num_queued_sgs.
>
> Cc: <stable@vger.kernel.org>
> Tested-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> Reported-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> Fixes: c96e6725db9d ("usb: dwc3: gadget: Correct the logic for queuing sg=
s")
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

Acked-by: Felipe Balbi <balbi@kernel.org>

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFFBAEBCAAvFiEE9DumQ60WEZ09LIErzlfNM9wDzUgFAmCeJjIRHGJhbGJpQGtl
cm5lbC5vcmcACgkQzlfNM9wDzUjfYggAhR1Qjovd+cWCh12AO8upsvOKrCAqr/wH
14/noRG9JSq6tS85ATt8N94DqKoZbnr3Voqi+FU7Jeth6X8A9r7lAdOYnbnAs3dR
ZqzGQl8JlBsWV2NLaAArOpr4OIpDhZpnQa3IJJP7rDxfKcFg0WOwS8Cc3up/Xrqn
KQFSpdx9ioKVOc3g2qmVW5PqiMlL86xGs7oyPqjDUidrLvC94+omx0iDvYDwHImI
BM61wWVaJVXmYmRPOSuyjKl0kfRKSkTXniN5Q5QVrlA459yecbXLMInlDKuyN8hk
VmL8k1aBwvRh/BOLpxxPmY1UNrgZlVWhilQPXk1tI7P0CgvO1D2P4g==
=NdgP
-----END PGP SIGNATURE-----
--=-=-=--
