Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A851F97F4
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730257AbgFONKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:10:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729875AbgFONKK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 09:10:10 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38E642074D;
        Mon, 15 Jun 2020 13:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592226610;
        bh=Q4kYEv8y1kbvADRAP1BgbtoDH5hmbT0bRy3I3ZrTBxo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LqTVQ+jqhr9sSuJEIjKtb+t7uP4Os3/80y041zWF2krFR9JKwQskpt0QEd/T7vJgW
         6QPbsSsF+Q8LvR4mLDEWheUmbYY7U/rm3Nz/8raTQmh9v0P8ie0/r5CA1EnmeFIDG5
         40QA+6TE1KO+vSLWQ4RcWUL7JJLez+pRm3r/kGv8=
Date:   Mon, 15 Jun 2020 14:10:06 +0100
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
Message-ID: <20200615131006.GR4447@sirena.org.uk>
References: <1592208439-17594-1-git-send-email-krzk@kernel.org>
 <e1f0326c-8ae8-ffb3-aace-10433b0c78a6@pengutronix.de>
 <20200615123052.GO4447@sirena.org.uk>
 <CA+h21hqC7hAenifvRqbwss=Sr+dAu3H9Dx=UF0TS0WVbkzTj2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="y2MHPAl/EzyWgzIZ"
Content-Disposition: inline
In-Reply-To: <CA+h21hqC7hAenifvRqbwss=Sr+dAu3H9Dx=UF0TS0WVbkzTj2Q@mail.gmail.com>
X-Cookie: Offer may end without notice.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--y2MHPAl/EzyWgzIZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 15, 2020 at 03:56:01PM +0300, Vladimir Oltean wrote:

> And the down-shot is that whatever is done in dspi_remove (free_irq)
> also needs to be done in dspi_suspend, but with extra care in
> dspi_resume not only to request the irq again, but also to flush the
> module's FIFOs and clear interrupts, because there might have been
> nasty stuff uncaught during sleep:

>     regmap_update_bits(dspi->regmap, SPI_MCR,
>                SPI_MCR_CLR_TXF | SPI_MCR_CLR_RXF,
>                SPI_MCR_CLR_TXF | SPI_MCR_CLR_RXF);
>     regmap_write(dspi->regmap, SPI_SR, SPI_SR_CLEAR);

> So it's pretty messy.

It's a bit unusual to need to actually free the IRQ over suspend -
what's driving that requirement here?  I can see we might need to
reinit the hardware but usually the interrupt handler can be left there
safely.

--y2MHPAl/EzyWgzIZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7ncy4ACgkQJNaLcl1U
h9ByxAf/Viw1asiMeFVTEX5NW6sj2JWKphdxsdlXt8jQ48yPQUOSKBWTcHKvZUop
ugkURiAdYNLhV5qA/+6ORBe21lszw0YK85cF/+vY4T5AoeUnutOiw7yfl3w68zVX
hibcK47M3IJ1vcbyruaMSvPSvc/EeAXs08szmYOtgAPCCL5eYd6iWt/bCVj/FtqO
30k5jVxSAvPUlOIrFWYcNkAFYYtrir6EOSRemnKkBuF+LIKW11LG1apvb28X56jv
cRvTVPjzMAc9KlAVOoLWEEQ/o/XTA9PT70Qd2It67gRmdQZ/13L/L6Cqrys+5Du5
SCO6T+EoDrqAzA8mzY8EpJ18jhIDtA==
=h3aO
-----END PGP SIGNATURE-----

--y2MHPAl/EzyWgzIZ--
