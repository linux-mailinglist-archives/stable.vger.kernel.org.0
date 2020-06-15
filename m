Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914A91F9688
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 14:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729747AbgFOMaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 08:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729097AbgFOMaz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 08:30:55 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 083372067B;
        Mon, 15 Jun 2020 12:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592224254;
        bh=i8N9J5qB7qy0u2YyO0rgmh5R5aAf99CFTa196p1B1/s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Se+C781YoVCGv8KWeRMEmO6xVnl093tvTzjUzYRHOO7M2+1wImoMdVZSFrLYD2P1t
         svVFa6h84mEEzlH3CdW83CyUmYkIO47MACV1o/2JCtI9oHXunmMb7SVoX2K8z64ODB
         8TOfUT7Cqmh/5v17mwMu2+derNBBeqDiW5S/KGt0=
Date:   Mon, 15 Jun 2020 13:30:52 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa@kernel.org>, stable@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH v2 1/3] spi: spi-fsl-dspi: Fix external abort on
 interrupt in exit paths
Message-ID: <20200615123052.GO4447@sirena.org.uk>
References: <1592208439-17594-1-git-send-email-krzk@kernel.org>
 <e1f0326c-8ae8-ffb3-aace-10433b0c78a6@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="aTCJOP0qgkSGqHWA"
Content-Disposition: inline
In-Reply-To: <e1f0326c-8ae8-ffb3-aace-10433b0c78a6@pengutronix.de>
X-Cookie: Offer may end without notice.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--aTCJOP0qgkSGqHWA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 15, 2020 at 10:17:07AM +0200, Marc Kleine-Budde wrote:
> On 6/15/20 10:07 AM, Krzysztof Kozlowski wrote:
> > If interrupt comes late, during probe error path or device remove (could
> > be triggered with CONFIG_DEBUG_SHIRQ), the interrupt handler
> > dspi_interrupt() will access registers with the clock being disabled.  This
> > leads to external abort on non-linefetch on Toradex Colibri VF50 module
> > (with Vybrid VF5xx):

> >     Unhandled fault: external abort on non-linefetch (0x1008) at 0x8887f02c
> >     Internal error: : 1008 [#1] ARM
> >     CPU: 0 PID: 136 Comm: sh Not tainted 5.7.0-next-20200610-00009-g5c913fa0f9c5-dirty #74
> >     Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
> >       (regmap_mmio_read32le) from [<8061885c>] (regmap_mmio_read+0x48/0x68)
> >       (regmap_mmio_read) from [<8060e3b8>] (_regmap_bus_reg_read+0x24/0x28)
> >       (_regmap_bus_reg_read) from [<80611c50>] (_regmap_read+0x70/0x1c0)

Please think hard before including complete backtraces in upstream
reports, they are very large and contain almost no useful information
relative to their size so often obscure the relevant content in your
message. If part of the backtrace is usefully illustrative (it often is
for search engines if nothing else) then it's usually better to pull out
the relevant sections.

> > +disable_irq:
> > +	if (dspi->irq > 0)
> > +		disable_irq(dspi->irq);

> What happens, if you re-bind the driver?
> Is the IRQ still working?
> Who is taking care of calling the enable_irq() again?
> What happens, if you really have a shared IRQ line?
> Is the IRQ disabled for all other devices on the same IRQ line?

Indeed.  The upshot of all this is that the interrupt needs to be freed
not disabled before the clocks are disabled, or some other mechanism
needs to be used to ensure that the interrupt handler won't attempt to
access the hardware when it shouldn't.  As Vladimir says there are
serious issues using devm for interrupt handlers (or anything else that
might cause code to be run) due to problems like this.

--aTCJOP0qgkSGqHWA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7nafsACgkQJNaLcl1U
h9CEeQf6AqyBx23NNkphpN0LyXwCEF6BpZbiHzD1nSTv4uSltiKHVWIZPMlj9StO
IHDwrPLxhmCagF0p4wLjUkfoNe/EhLYBp7dOxLKqu52DJs0j8wimK9GTnm0LhwXt
r8ZQe9MwYPcoc7ZvfRtqk00Wh6LGPCwIjWhYfyXFk54yxNo91/eAwkMPr1aeqWh0
uffpdYaqwpmNcLTyenWLZLwILeDVnvVAyQB82Bl/4uR3UMhS6hghr5Ji4HfKMVO6
iyvcsUShI+F8KkqZn7/bqR2j4jyEEKKVhiHRpP9EnPEyqTfFBQx2gvNCQCDXfKLp
qS9ptlvMW1ZqLLlIqLa4IIRC0YF9aA==
=0lOe
-----END PGP SIGNATURE-----

--aTCJOP0qgkSGqHWA--
