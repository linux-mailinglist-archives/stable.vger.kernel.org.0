Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277183660AF
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 22:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233872AbhDTUNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 16:13:41 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:40030 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbhDTUNk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Apr 2021 16:13:40 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 215411C0B80; Tue, 20 Apr 2021 22:13:06 +0200 (CEST)
Date:   Tue, 20 Apr 2021 22:13:05 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sanjay Kumar <sanjay.k.kumar@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.11 007/122] dmaengine: idxd: Fix clobbering of SWERR
 overflow bit on writeback
Message-ID: <20210420201305.GA9942@duo.ucw.cz>
References: <20210419130530.166331793@linuxfoundation.org>
 <20210419130530.423797059@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <20210419130530.423797059@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Current code blindly writes over the SWERR and the OVERFLOW bits. Write
> back the bits actually read instead so the driver avoids clobbering the
> OVERFLOW bit that comes after the register is read.

I believe this is incorrect. Changelog explains that we need to
preserve bits in the register...

> diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
> index a60ca11a5784..f1463fc58112 100644
> --- a/drivers/dma/idxd/irq.c
> +++ b/drivers/dma/idxd/irq.c
> @@ -124,7 +124,9 @@ static int process_misc_interrupts(struct idxd_device=
 *idxd, u32 cause)
>  		for (i =3D 0; i < 4; i++)
>  			idxd->sw_err.bits[i] =3D ioread64(idxd->reg_base +
>  					IDXD_SWERR_OFFSET + i * sizeof(u64));
> -		iowrite64(IDXD_SWERR_ACK, idxd->reg_base + IDXD_SWERR_OFFSET);
> +
> +		iowrite64(idxd->sw_err.bits[0] & IDXD_SWERR_ACK,
> +			  idxd->reg_base + IDXD_SWERR_OFFSET);

=2E..but that is not what the code does.

I suspect it should be=20

> +		iowrite64(idxd->sw_err.bits[0] | IDXD_SWERR_ACK,
> +			  idxd->reg_base + IDXD_SWERR_OFFSET);

Best regards,
								Pavel

--=20
http://www.livejournal.com/~pavelmachek

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYH810QAKCRAw5/Bqldv6
8kEaAJ4hgBh3lQTBYyaOPBaM2scS2Bs/ywCdEQL6iQn+iCdKaJJGKFHqVLsaNVk=
=Z9jg
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
