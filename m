Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D7B1F985C
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbgFONYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:24:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730043AbgFONYo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 09:24:44 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10E802076A;
        Mon, 15 Jun 2020 13:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592227483;
        bh=bqX1ozenFRae/r9wyA5J47at6vYcCkVYO8dbmr9c2P0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t6MngLWC5aDomduESoTEtDrKX8VoWBqS3vmbPPajFduTYMnWH+uaEbWfuyPrzt2+A
         NG5Tt0EW2x6gEMcFxWKu+8zhtdeFSDuU1J94sh37v074z0hcou0j7GB86SAUlDHr4D
         oW31DO8iFj3n+sSP6ZMwTjFFEG+Afht9IyvINook=
Date:   Mon, 15 Jun 2020 14:24:41 +0100
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
Message-ID: <20200615132441.GS4447@sirena.org.uk>
References: <1592208439-17594-1-git-send-email-krzk@kernel.org>
 <e1f0326c-8ae8-ffb3-aace-10433b0c78a6@pengutronix.de>
 <20200615123052.GO4447@sirena.org.uk>
 <CA+h21hqC7hAenifvRqbwss=Sr+dAu3H9Dx=UF0TS0WVbkzTj2Q@mail.gmail.com>
 <20200615131006.GR4447@sirena.org.uk>
 <CA+h21hpusy=zx8AuUqk_4zShtst8QeNJxCPT4dMGh0jhm5uZng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6pbY/KU4ayLo+qis"
Content-Disposition: inline
In-Reply-To: <CA+h21hpusy=zx8AuUqk_4zShtst8QeNJxCPT4dMGh0jhm5uZng@mail.gmail.com>
X-Cookie: Offer may end without notice.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6pbY/KU4ayLo+qis
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 15, 2020 at 04:12:28PM +0300, Vladimir Oltean wrote:
> On Mon, 15 Jun 2020 at 16:10, Mark Brown <broonie@kernel.org> wrote:

> > It's a bit unusual to need to actually free the IRQ over suspend -
> > what's driving that requirement here?

> clk_disable_unprepare(dspi->clk); is driving the requirement - same as
> in dspi_remove case, the module will fault when its registers are
> accessed without a clock.

I see - this could be fixed by having the interrupt handler bounce the
clock on, there's a little overhead from that but hopefully not too
much.  That should also help with the remove case I guess so long as the
clock is registered before the interrupt is requested?

--6pbY/KU4ayLo+qis
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7ndpgACgkQJNaLcl1U
h9BUcgf/VzR+PRLWRTMg/gGQBftAw+yKEACOAdw8HxYwJw4eaK7326GSdVE6qWwo
t/aZTKrRKSSid1YvuquFNG39qeEiWp3t8ZZSmd8EyYhvdFq6mwEdQ36uuPg5/27C
Dff+yXcHU39inkRIPxF6uI655J+L+/6IC+0B3EX8FmjcFngDxcnDomnqldhnXQCX
WaTRTKYrUHnvEQ7skEQJFzttM7sgs3tOPhYfLuz7eQSSAUqo02fNLseRZhP1VZY5
f+HxXawJLRuf0/wD/IOTjvwEWEERjVte6OyT71Y/pbYPg+QnshDtYOsTF+14W8FF
8XAQwxWofipni82ASNlssY48IXD9uA==
=ouiV
-----END PGP SIGNATURE-----

--6pbY/KU4ayLo+qis--
