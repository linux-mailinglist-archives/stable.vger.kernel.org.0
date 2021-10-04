Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1426420B2C
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 14:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbhJDMvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 08:51:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229836AbhJDMvN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 08:51:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B20396124C;
        Mon,  4 Oct 2021 12:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633351764;
        bh=+HwUhsuP6MVKRpgbKf+vXOZOCYCgZp8OBkYFKe3NbyE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k2rzhQnyHr6jnh5xTvXNa+gPYf7uCWtdQFWsNzYolRM5TM7kOLAMEB7LcZbNLATU+
         bKxpbxah0ol0M/TGU7dAGCKTyYZTtbqfEpP95HRHVv8bZvL+s8/Ad1XN1AJoYpbCek
         8nGPkVECzAcDKAd/tUXPTEP9fLZ6hzNoD1G89zUmpaWqrMP3Ex23OPNLtHrMfwVzeQ
         9oPxekGskiNYLVX3ehkEU70vmYdJB6dWnB2b7P0HKAKrMILX6c6B+eab2zbvbrGkth
         hltyOBaIc+VW5NUL8yyfBZuNBCplwNEf9Tzv/YS4eWVoZaSp84W1HbteTRSK5Ryibq
         sSCYFvbMBLtbA==
Date:   Mon, 4 Oct 2021 13:49:21 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     f.fainelli@gmail.com, rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, nsaenz@kernel.org,
        linux-spi@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jgg@ziepe.ca, p.rosenberger@kunbus.com,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] spi: bcm2835: do not unregister controller in shutdown
 handler
Message-ID: <YVr4USeiIoQJ0Pqh@sirena.org.uk>
References: <20210928195657.5573-1-LinoSanfilippo@gmx.de>
 <20211001175422.GA53652@sirena.org.uk>
 <2c4d7115-7a02-f79e-c91b-3c2dd54051b2@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="RcF28Bs204Ejhms1"
Content-Disposition: inline
In-Reply-To: <2c4d7115-7a02-f79e-c91b-3c2dd54051b2@gmx.de>
X-Cookie: If it heals good, say it.
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--RcF28Bs204Ejhms1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 03, 2021 at 05:25:47PM +0200, Lino Sanfilippo wrote:

> I see your point here. So what about narrowing down the shutdown handler
> to only disable the hardware:

> static void bcm2835_spi_shutdown(struct platform_device *pdev)
> {
> 	struct spi_controller *ctlr =3D platform_get_drvdata(pdev);
> 	struct bcm2835_spi *bs =3D spi_controller_get_devdata(ctlr);
>=20
> 	if (ctlr->dma_tx)
> 		dmaengine_terminate_sync(ctlr->dma_tx);
>=20
> 	if (ctlr->dma_rx)
> 		dmaengine_terminate_sync(ctlr->dma_rx);
>=20
> 	/* Clear FIFOs, and disable the HW block */
> 	bcm2835_wr(bs, BCM2835_SPI_CS,
> 		   BCM2835_SPI_CS_CLEAR_RX | BCM2835_SPI_CS_CLEAR_TX);
>=20
> 	clk_disable_unprepare(bs->clk);
> }

This still leaves a potential race where something (eg, an interrupt
handler) could come in and try to schedule more SPI transfers on the
shut down hardware.  I'm really not sure we can do something that's
totally robust here without also ensuring that all the client drivers
also have effective shutdown implementations (which seems ambitious) or
doing what we have now and unregistering the clients.  I am, however,
wondering if we really need the shutdown callback at all - the commit
adding it just describes what it's doing, it doesn't explain why it's
particularly needed.  I guess there might be an issue on reboot with
reset not completely resetting the hardware?

--RcF28Bs204Ejhms1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmFa+FEACgkQJNaLcl1U
h9Aw9wf/Q1ESD1wDdZcEiaAk3DV1WXkmfSTqsKkW5cXYRyNVoUNqBH6qZIDJWV9t
l5qRi5zzy+yxR4mj1JKYTxidOe8N0SxRxqnGus6CQ9ZBjuGWOV9GK6gT+15eoLR4
+g2ew8Kg6j1VBn5tvZyZYvqmKYwd5FxxF5hBE7NeIU8J8nbe5MHWl4jPkJ8SDvJb
KofgwdfezKmkR6eioIJtYKKaxUxgK1JWb33TYGQvKXu5MeMoroR0BjoWJ6k/cOim
+srK5/1OMyVMBXoHXj8rEHJ+uNEtvXcriwM5UkreCeMiLSpf1ayUehz1wxB0aAXq
h5uj2fyE1BzNy1id1yqSDsutP49RkA==
=yMkL
-----END PGP SIGNATURE-----

--RcF28Bs204Ejhms1--
