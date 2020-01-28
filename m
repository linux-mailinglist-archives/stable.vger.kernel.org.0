Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71E0214BF16
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 19:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgA1SCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 13:02:35 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:55588 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgA1SCe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 13:02:34 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8F4A31C25FD; Tue, 28 Jan 2020 19:02:32 +0100 (CET)
Date:   Tue, 28 Jan 2020 19:02:31 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Masato Suzuki <masato.suzuki@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4.19 59/92] sd: Fix REQ_OP_ZONE_REPORT completion handling
Message-ID: <20200128180231.GA11577@amd>
References: <20200128135809.344954797@linuxfoundation.org>
 <20200128135816.802992447@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20200128135816.802992447@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Masato Suzuki <masato.suzuki@wdc.com>
>=20
>

> ZBC/ZAC report zones command may return less bytes than requested if the
> number of matching zones for the report request is small. However, unlike
> read or write commands, the remainder of incomplete report zones commands
> cannot be automatically requested by the block layer: the start sector of
> the next report cannot be known, and the report reply may not be 512B
> aligned for SAS drives (a report zone reply size is always a multiple of
> 64B). The regular request completion code executing bio_advance() and
> restart of the command remainder part currently causes invalid zone
> descriptor data to be reported to the caller if the report zone size is
> smaller than 512B (a case that can happen easily for a report of the last
> zones of a SAS drive for example).

What is the story here? Mainline does not seem to have this patch, so
this is not the case of "upstream commit xxx" line simply missing. If
the same bug is fixed in mainline different way, it would be nice to
point to that commit..

Mainline does not handle REQ_OP_ZONE_REPORT in sd.c at all..

Best regards,
								Pavel


> +++ b/drivers/scsi/sd.c
> @@ -1969,9 +1969,13 @@ static int sd_done(struct scsi_cmnd *SCp
>  		}
>  		break;
>  	case REQ_OP_ZONE_REPORT:
> +		/* To avoid that the block layer performs an incorrect
> +		 * bio_advance() call and restart of the remainder of
> +		 * incomplete report zone BIOs, always indicate a full
> +		 * completion of REQ_OP_ZONE_REPORT.
> +		 */
>  		if (!result) {
> -			good_bytes =3D scsi_bufflen(SCpnt)
> -				- scsi_get_resid(SCpnt);
> +			good_bytes =3D scsi_bufflen(SCpnt);
>  			scsi_set_resid(SCpnt, 0);
>  		} else {
>  			good_bytes =3D 0;
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl4wdzcACgkQMOfwapXb+vJJBwCeLQyPnq8FAEx/J/yRghFbLGAE
mTMAn3JA2MG9VnuwFEaOvDtlPs75pcTk
=mA8J
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
