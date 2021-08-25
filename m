Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649243F70DA
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 10:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234259AbhHYIFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 04:05:38 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:50920 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhHYIFg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 04:05:36 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7CE951C0B7A; Wed, 25 Aug 2021 10:04:50 +0200 (CEST)
Date:   Wed, 25 Aug 2021 10:04:50 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Adrian Larumbe <adrian.martinezlarumbe@imgtec.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH 5.10 16/98] dmaengine: xilinx_dma: Fix read-after-free
 bug when terminating transfers
Message-ID: <20210825080449.GA7551@duo.ucw.cz>
References: <20210824165908.709932-1-sashal@kernel.org>
 <20210824165908.709932-17-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <20210824165908.709932-17-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 7dd2dd4ff9f3abda601f22b9d01441a0869d20d7 ]
>=20
> When user calls dmaengine_terminate_sync, the driver will clean up any
> remaining descriptors for all the pending or active transfers that had
> previously been submitted. However, this might happen whilst the tasklet =
is
> invoking the DMA callback for the last finished transfer, so by the time =
it
> returns and takes over the channel's spinlock, the list of completed
> descriptors it was traversing is no longer valid. This leads to a
> read-after-free situation.
>=20
> Fix it by signalling whether a user-triggered termination has happened by
> means of a boolean variable.

I see the variable is cleared and tested under spinlock, but it is set
without any locking. Do we need to take the spinlock, too?

Best regards,
								Pavel

> @@ -1049,6 +1051,13 @@ static void xilinx_dma_chan_desc_cleanup(struct xi=
linx_dma_chan *chan)
>  		/* Run any dependencies, then free the descriptor */
>  		dma_run_dependencies(&desc->async_tx);
>  		xilinx_dma_free_tx_descriptor(chan, desc);
> +
> +		/*
> +		 * While we ran a callback the user called a terminate function,
> +		 * which takes care of cleaning up any remaining descriptors
> +		 */
> +		if (chan->terminating)
> +			break;
>  	}
> =20
>  	spin_unlock_irqrestore(&chan->lock, flags);
> @@ -1965,6 +1974,8 @@ static dma_cookie_t xilinx_dma_tx_submit(struct dma=
_async_tx_descriptor *tx)
>  	if (desc->cyclic)
>  		chan->cyclic =3D true;
> =20
> +	chan->terminating =3D false;
> +
>  	spin_unlock_irqrestore(&chan->lock, flags);
> =20
>  	return cookie;
> @@ -2436,6 +2447,7 @@ static int xilinx_dma_terminate_all(struct dma_chan=
 *dchan)
> =20
>  	xilinx_dma_chan_reset(chan);
>  	/* Remove and free all of the descriptors in the lists */
> +	chan->terminating =3D true;
>  	xilinx_dma_free_descriptors(chan);
>  	chan->idle =3D true;
> =20

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYSX5oQAKCRAw5/Bqldv6
8qfhAJ9P+qJke/JZZCh0yqyJhnsvxzQJTQCfcqqmy7GprAi7UtTnGnJ/sPUGaIQ=
=n2xD
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
