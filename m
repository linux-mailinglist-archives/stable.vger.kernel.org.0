Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97A04133038
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 21:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbgAGUCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:02:16 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36038 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728358AbgAGUCQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 15:02:16 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iov3O-0002h0-OP; Tue, 07 Jan 2020 20:02:14 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1iov3O-006wFS-6r; Tue, 07 Jan 2020 20:02:14 +0000
Message-ID: <1dbd23b3f9d8d9e584f2339e402130b49de44285.camel@decadent.org.uk>
Subject: Re: [PATCH][STABLE backport 4.4] dmaengine: qcom: bam_dma: Fix
 resource leak
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Jeffrey Hugo <jeffrey.l.hugo@gmail.com>, stable@vger.kernel.org
Cc:     vkoul@kernel.org
Date:   Tue, 07 Jan 2020 20:02:09 +0000
In-Reply-To: <20191105202120.28520-1-jeffrey.l.hugo@gmail.com>
References: <20191105202120.28520-1-jeffrey.l.hugo@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-zXhieadOmE8rRJndeXab"
User-Agent: Evolution 3.34.1-2+b1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-zXhieadOmE8rRJndeXab
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-11-05 at 12:21 -0800, Jeffrey Hugo wrote:
> Commit 7667819385457b4aeb5fac94f67f52ab52cc10d5 upstream.
>=20
> bam_dma_terminate_all() will leak resources if any of the transactions ar=
e
> committed to the hardware (present in the desc fifo), and not complete.
> Since bam_dma_terminate_all() does not cause the hardware to be updated,
> the hardware will still operate on any previously committed transactions.
> This can cause memory corruption if the memory for the transaction has be=
en
> reassigned, and will cause a sync issue between the BAM and its client(s)=
.
>=20
> Fix this by properly updating the hardware in bam_dma_terminate_all().
>=20
> Fixes: e7c0fe2a5c84 ("dmaengine: add Qualcomm BAM dma driver")
> Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/20191017152606.34120-1-jeffrey.l.hugo@gma=
il.com
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> ---
> Backported to 4.4 which is lacking 6b4faeac05bc
> ("dmaengine: qcom-bam: Process multiple pending descriptors")

This seems to be needed for 3.16 as well, so I've queued it up.  Let me
know if this is wrong.

Ben.

> ---
>  drivers/dma/qcom_bam_dma.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>=20
> diff --git a/drivers/dma/qcom_bam_dma.c b/drivers/dma/qcom_bam_dma.c
> index 5a250cdc8376..eca5b106d7d4 100644
> --- a/drivers/dma/qcom_bam_dma.c
> +++ b/drivers/dma/qcom_bam_dma.c
> @@ -671,7 +671,21 @@ static int bam_dma_terminate_all(struct dma_chan *ch=
an)
> =20
>  	/* remove all transactions, including active transaction */
>  	spin_lock_irqsave(&bchan->vc.lock, flag);
> +	/*
> +	 * If we have transactions queued, then some might be committed to the
> +	 * hardware in the desc fifo.  The only way to reset the desc fifo is
> +	 * to do a hardware reset (either by pipe or the entire block).
> +	 * bam_chan_init_hw() will trigger a pipe reset, and also reinit the
> +	 * pipe.  If the pipe is left disabled (default state after pipe reset)
> +	 * and is accessed by a connected hardware engine, a fatal error in
> +	 * the BAM will occur.  There is a small window where this could happen
> +	 * with bam_chan_init_hw(), but it is assumed that the caller has
> +	 * stopped activity on any attached hardware engine.  Make sure to do
> +	 * this first so that the BAM hardware doesn't cause memory corruption
> +	 * by accessing freed resources.
> +	 */
>  	if (bchan->curr_txd) {
> +		bam_chan_init_hw(bchan, bchan->curr_txd->dir);
>  		list_add(&bchan->curr_txd->vd.node, &bchan->vc.desc_issued);
>  		bchan->curr_txd =3D NULL;
>  	}
--=20
Ben Hutchings
Larkinson's Law: All laws are basically false.



--=-zXhieadOmE8rRJndeXab
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl4U48EACgkQ57/I7JWG
EQnYdw//UrYxKOfQU4xwdzMwe3YNLPdl0ZN0MaZ5gL1tgxT1wyoIXVfYahMXqYEM
RS7lRDFGonn0YO/zVn8ifx4wAu9IH9symhj2R9t0cMlc5OHZnYNPF0p25Q51FxyO
i59q0mWyMoxA0Bk2kqla7sl1RpGbsowOkL44d1SGA3Xua4Luu37wZ4ABIxLJ1HqP
ra5WGMoD9V9AaYR8IV5uhsBhezjSOQbNk4Phy/TNkL1MbuGA7dkXf9tHbV3jD8qG
yNTOjgTGMteisTmxclWjU81Wtfe2ODhK8OMJ9YCwtrHus2449Z3LmtbhveDP940r
mWVzs3jSKnqeD8rNrUqIEQU26Ln5A0yWuxSYZIB1HmXDtvXR6FfatOnBIYmE2wJY
PQTrO1x7aN+bpyqRLN5Hewn+FRM78hcHxWOghUGI69e3Ejo+uzNSNeTV3Nyp+x7z
AEooz5ZijVDN2yQnEuQ868iSVRyLz1SLnXnWXYIe4iS/s9Vut9o+rg/etkIs1Hhl
TRHaz4pNBAA2m1UhOr3ynh0sDy6a7btuyph0nmADUgHAFC8LshJe8XqGB7elqUdT
SL4lJFFpOHiRZoxhjRnPVX97FfQg/6BP/J+AkmnCLVXQEu1wxTCGE+W1GkJfi4sa
WmnKSmyBKLjxWN9wrrvL2UeqThL+fAiEafNv3gtpa9YYJENEpiY=
=icZ+
-----END PGP SIGNATURE-----

--=-zXhieadOmE8rRJndeXab--
