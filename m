Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA171F9908
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbgFONgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:36:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730109AbgFONgt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 09:36:49 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25A9E207D3;
        Mon, 15 Jun 2020 13:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592228208;
        bh=Hs7nuZ6Ujtne3R8pyXXb7XHOf/MxT4zald4XbINg9kg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gukh6y5LOywbiptR4BP1qZMvMTmpFHvYXpm1nVZvZ9nV80CgKS9R0DTuQq3twmQrp
         U81TWQ1d3ltRvFYFgLou3mfE6NzIwPBeuXEvuhmp3YivqKtbeeG+suvV19pr/yOZ3B
         4c30at3Lxnycj3JIwevk+++E03O+4Cx6BKNdY2kQ=
Date:   Mon, 15 Jun 2020 14:36:46 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Wolfram Sang <wsa@kernel.org>, stable@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Subject: Re: [PATCH v2 1/3] spi: spi-fsl-dspi: Fix external abort on
 interrupt in exit paths
Message-ID: <20200615133646.GU4447@sirena.org.uk>
References: <1592208439-17594-1-git-send-email-krzk@kernel.org>
 <e1f0326c-8ae8-ffb3-aace-10433b0c78a6@pengutronix.de>
 <20200615123052.GO4447@sirena.org.uk>
 <CA+h21hqC7hAenifvRqbwss=Sr+dAu3H9Dx=UF0TS0WVbkzTj2Q@mail.gmail.com>
 <20200615131006.GR4447@sirena.org.uk>
 <CA+h21hpusy=zx8AuUqk_4zShtst8QeNJxCPT4dMGh0jhm5uZng@mail.gmail.com>
 <20200615132441.GS4447@sirena.org.uk>
 <CA+h21hpymKP5JGWZBNQTq4bZwJ6QZ3erACWV86nEaGsevZ++BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="i483Pv/KqyjCUwB1"
Content-Disposition: inline
In-Reply-To: <CA+h21hpymKP5JGWZBNQTq4bZwJ6QZ3erACWV86nEaGsevZ++BA@mail.gmail.com>
X-Cookie: Offer may end without notice.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--i483Pv/KqyjCUwB1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 15, 2020 at 04:29:15PM +0300, Vladimir Oltean wrote:
> On Mon, 15 Jun 2020 at 16:24, Mark Brown <broonie@kernel.org> wrote:

> > I see - this could be fixed by having the interrupt handler bounce the
> > clock on, there's a little overhead from that but hopefully not too
> > much.  That should also help with the remove case I guess so long as the
> > clock is registered before the interrupt is requested?

> Doesn't this mean that we risk leaving the clock enabled during suspend?

If we suspend with the interrupt handler running but IIRC the suspend
sequence will allow interrupt handlers to complete.

> Is there any function in the SPI core that quiesces any pending
> transactions, and then stops the controller? I would have expected
> spi_controller_suspend to do that, but I'm not sure (it doesn't look
> like it).

spi_stop_queue() should do this (but will time out if the queue is too
busy).  It doesn't stop new transactions being issued, I'm guessing
because that'll most likely cause more problems than it solves but that
code predates my involvement.

--i483Pv/KqyjCUwB1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7neW0ACgkQJNaLcl1U
h9Awewf/S60KrRHANcrt8yuP4f/0IVWXkNY5EEnxhSNYxYSGJpNXf0W4HNqSe1Yq
4VO4Wb4cRXKId51u9uCltVuOosIyMMxtIGfT6qE+KS9yj/J7i0fwx/es5ULmYudk
ncz1FbnZSCiK7vpBqsfwrzHeXBBTAOnnJplWozejxLXhec2fLPwhA0kU68AGyQFw
QOaKoRUJSejGltsnaPCdmi7d+h4ET165V3NZyZ/WMfq36yq9oF4IHsTnIMydZaz4
5svVPIKpqUobu/52IVDZ9Yn/SWkyWvLXKT6yVDKplLzCntW5SL8ihBWAMGS+zfgS
rXihk1/dR5lRMfaFiEsMricY8Xaa8A==
=bZvG
-----END PGP SIGNATURE-----

--i483Pv/KqyjCUwB1--
