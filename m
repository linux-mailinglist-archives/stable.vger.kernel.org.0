Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E0B41F3FF
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 19:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355524AbhJAR45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 13:56:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355478AbhJAR45 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Oct 2021 13:56:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62BE761ABB;
        Fri,  1 Oct 2021 17:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633110912;
        bh=KvMSj/LKzgWx8zgAPk3nu+FT6wv2VG1v44dt004JqA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lcMrFYUOmnxjhR6B8CGaIjCgy0TvuiTMAH/7V6+ORv9P0E87C9507Pfk0f5z/MpVq
         WfKgrL9NwK5bZL+b93kDV7ayCplJm8X6suGxamEaG6a09ZCfReW2WwMZLHRGmj6jzs
         Dkk+3tkrUdETUl8ge2zYlc+xasxuV+zQAITghBvAT8k/3IiA+KAJxsamwadCbJuzjt
         6uhmdz6PMMO5p1XAguMUitzzeJIgLYaBQf8V42HPkStG1JudvCzklQka3JpY84K6rh
         YZJNeZsRqs9Tjccp97kx+p5uQq6asuj/P8AtupUywwSMDdNCakLJz8F99ONXN1+md+
         eZsCR49nufOqw==
Date:   Fri, 1 Oct 2021 18:54:22 +0100
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
Message-ID: <20211001175422.GA53652@sirena.org.uk>
References: <20210928195657.5573-1-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <20210928195657.5573-1-LinoSanfilippo@gmx.de>
X-Cookie: Exact change only.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 28, 2021 at 09:56:57PM +0200, Lino Sanfilippo wrote:

> One example is if the BCM2835 driver is used together with the TPM SPI
> driver:
> At system shutdown first the TPM chip devices (pre) shutdown handler
> (tpm_class_shutdown) is called, stopping the chip and setting an operatio=
ns
> pointer to NULL.
> Then since the BCM2835 shutdown handler unregisters the SPI controller the
> TPM SPI remove function (tpm_tis_spi_remove) is also called. In case of
> TPM 2 this function accesses the now nullified operations pointer,
> resulting in the following NULL pointer access:

This is a bug in that driver, it should be able to cope with a race
between a removal (which might be triggered for some other reason) and a
shutdown.  Obviously this is actively triggered by this code path but it
could happen via some other mechanism.

> The first attempt to fix this was with an extra check in the tpm chip
> driver (see https://marc.info/?l=3Dlinux-integrity&m=3D163129718414118&w=
=3D2) to
> avoid the NULL pointer access.
> Then Jason Gunthorpe noted that the real issue was the BCM driver
> unregistering the chip in the shutdown handler(see
> https://marc.info/?l=3Dlinux-integrity&m=3D163129718414118&w=3D2) which l=
ed
> me to this solution.

Whatever happens here you should still fix the driver.

> -static int bcm2835_spi_remove(struct platform_device *pdev)
> +static void bcm2835_spi_shutdown(struct platform_device *pdev)
>  {
>  	struct spi_controller *ctlr =3D platform_get_drvdata(pdev);
>  	struct bcm2835_spi *bs =3D spi_controller_get_devdata(ctlr);
> =20
> -	bcm2835_debugfs_remove(bs);
> -
> -	spi_unregister_controller(ctlr);
> -
>  	bcm2835_dma_release(ctlr, bs);

It is not at all clear to me that it is safe to deallocate the DMA
resources the controller is using without first releasing the
controller, I don't see what's stopping something coming along and
submitting new transactions which could in turn try to start doing
DMA.

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmFXS00ACgkQJNaLcl1U
h9DMowf/YzeyW9GG6HZnrxNQr0Fv3LJcIERyKp200gfTUFoX9qrnq+RlvQWaITV/
BirqeT5QRR6GaJhBnU/x97668618Euob/QSW84xEYF8/lPGC9bbZJPZWvT6t6War
yZXMlq7ZnJs+4ZgoTJ0a8kvMpOTi9taapELj13Q9hZj0/AjRVttJo0tcIyqsoWVM
1Y4HROz8+Tpq1XblE7aohDCvfqXomPa1D5PWEQTZiSo3xEF1zntFlmDGbn+WIJSD
IpZdJXm6Hb6mg2ooN6vR8W0IbDVCFeBkfJTzekfsFzMxRop9XRg9x3AESdXiqCTS
0p1aQSFVrXQOlxMRIiMoX08tV4o+Sg==
=kSoy
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
