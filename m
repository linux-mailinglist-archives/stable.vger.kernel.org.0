Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F150C410D01
	for <lists+stable@lfdr.de>; Sun, 19 Sep 2021 21:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhISTLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Sep 2021 15:11:52 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:34794 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbhISTLv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Sep 2021 15:11:51 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 22E111C0B7A; Sun, 19 Sep 2021 21:10:25 +0200 (CEST)
Date:   Sun, 19 Sep 2021 21:10:25 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 058/306] scsi: bsg: Remove support for
 SCSI_IOCTL_SEND_COMMAND
Message-ID: <20210919191025.GB12836@amd>
References: <20210916155753.903069397@linuxfoundation.org>
 <20210916155755.923264527@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="eAbsdosE1cNLO4uF"
Content-Disposition: inline
In-Reply-To: <20210916155755.923264527@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--eAbsdosE1cNLO4uF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Christoph Hellwig <hch@lst.de>
>=20
> [ Upstream commit beec64d0c9749afedf51c3c10cf52de1d9a89cc0 ]
>=20
> SCSI_IOCTL_SEND_COMMAND has been deprecated longer than bsg exists and has
> been warning for just as long.  More importantly it harcodes SCSI CDBs and
> thus will do the wrong thing on non-SCSI bsg nodes.

I see removing deprecated stuff is good idea in mainline, but do we
want to do that in -stable?

Best regads,
								Pavel

> +++ b/block/bsg.c
> @@ -371,10 +371,13 @@ static long bsg_ioctl(struct file *file, unsigned i=
nt cmd, unsigned long arg)
>  	case SG_GET_RESERVED_SIZE:
>  	case SG_SET_RESERVED_SIZE:
>  	case SG_EMULATED_HOST:
> -	case SCSI_IOCTL_SEND_COMMAND:
>  		return scsi_cmd_ioctl(bd->queue, NULL, file->f_mode, cmd, uarg);
>  	case SG_IO:
>  		return bsg_sg_io(bd->queue, file->f_mode, uarg);
> +	case SCSI_IOCTL_SEND_COMMAND:
> +		pr_warn_ratelimited("%s: calling unsupported SCSI_IOCTL_SEND_COMMAND\n=
",
> +				current->comm);
> +		return -EINVAL;
>  	default:
>  		return -ENOTTY;
>  	}

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--eAbsdosE1cNLO4uF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmFHiyAACgkQMOfwapXb+vLmdwCgs0WQx7XvtgmcxnDZppaLxCuR
rcYAn1402PBt/0JDtUe9J3j40oWqWZYE
=UZBQ
-----END PGP SIGNATURE-----

--eAbsdosE1cNLO4uF--
