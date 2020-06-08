Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932CF1F1760
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 13:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729398AbgFHLQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 07:16:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729371AbgFHLQW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 07:16:22 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 304192072F;
        Mon,  8 Jun 2020 11:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591614981;
        bh=zYU+C+PGf5dDW4qDWm1pWIclB3owG0XcTceTu8qombA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q9Wpo9bEJEdcTJMCyKy7ZT9rxa47Nd99waxgfzn77Rlv9kyqNQWO/sOpSwzfoBVg9
         0DW8je9lPY6x510TuzCC+BBhYLLYeQnZdCEcktminkIoc29RmfBjPj2+A9m0xqKQKi
         MNJPs5KbE8PQtxoMoXhlZQv4RFvDnxmq2xZb2DdE=
Date:   Mon, 8 Jun 2020 12:16:19 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        fengsheng <fengsheng5@huawei.com>,
        Xinwei Kong <kong.kongxinwei@hisilicon.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 15/28] spi: dw: use "smp_mb()" to avoid sending spi
 data error
Message-ID: <20200608111619.GB4593@sirena.org.uk>
References: <20200605140252.338635395@linuxfoundation.org>
 <20200605140253.279609547@linuxfoundation.org>
 <20200607200910.GA13138@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="JYK4vJDZwFMowpUq"
Content-Disposition: inline
In-Reply-To: <20200607200910.GA13138@amd>
X-Cookie: I'm rated PG-34!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--JYK4vJDZwFMowpUq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 07, 2020 at 10:09:11PM +0200, Pavel Machek wrote:

> > Because of out-of-order execution about some CPU architecture,
> > In this debug stage we find Completing spi interrupt enable ->
> > prodrucing TXEI interrupt -> running "interrupt_transfer" function
> > will prior to set "dw->rx and dws->rx_end" data, so this patch add
> > memory barrier to enable dw->rx and dw->rx_end to be visible and
> > solve to send SPI data error.

> So, this is apparently CPU-vs-device issue...

The commit message is a bit unclear but my read had been interrupt
handler racing with sending new data rather than an ordering issue with
writes to the hardware. =20

--JYK4vJDZwFMowpUq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7eHgIACgkQJNaLcl1U
h9DhCwf/d1dXgEHH5Hb83+eAVx5v90fL3DClK2WyN5AJ/z1D2CZILow8Ky35z2Yb
33tiaskGua1M+7vsabIQ9pYSZL8oOkYwrDwP5UXGTJK4pwJxkBEpFL5ab+x6dTc9
9TUx/93YOc/OhD45++q3dEzUmS8ZoPKHiwxaglfe76Dw6S2wSErBsACqmWWZMUvz
VkkLcuJDcxpL+jjIwWDfkD4jKovGgJd8g4dAoJ+WGBHGYSr0SqYxlBVWlYP0yPaV
+h8aMjgeKHdWytbm6DHuo3bBgxgGUoif0s9wbAYxaW0piJzB9DGqHBxFhMtE3FF3
PZZ49fhK8VXpyCy+4wNylwx+lE2JXg==
=cxCC
-----END PGP SIGNATURE-----

--JYK4vJDZwFMowpUq--
