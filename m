Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64415168EF9
	for <lists+stable@lfdr.de>; Sat, 22 Feb 2020 13:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgBVM7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 07:59:34 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:56120 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbgBVM7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Feb 2020 07:59:34 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8982F1C036F; Sat, 22 Feb 2020 13:59:32 +0100 (CET)
Date:   Sat, 22 Feb 2020 13:59:31 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Steve French <stfrench@microsoft.com>,
        Oleg Kravtsov <oleg@tuxera.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 188/191] cifs: log warning message (once) if out of
 disk space
Message-ID: <20200222125931.GC14067@amd>
References: <20200221072250.732482588@linuxfoundation.org>
 <20200221072313.381537875@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="da4uJneut+ArUgXk"
Content-Disposition: inline
In-Reply-To: <20200221072313.381537875@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--da4uJneut+ArUgXk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2020-02-21 08:42:41, Greg Kroah-Hartman wrote:
> From: Steve French <stfrench@microsoft.com>
>=20
> [ Upstream commit d6fd41905ec577851734623fb905b1763801f5ef ]
>=20
> We ran into a confusing problem where an application wasn't checking
> return code on close and so user didn't realize that the application
> ran out of disk space.  log a warning message (once) in these
> cases. For example:
>=20
>   [ 8407.391909] Out of space writing to \\oleg-server\small-share

Out of space can happen on any filesystem, and yes, it can be
confusing. But why is cifs so special that we warn here (and not
elsewhere) and why was this marked for stable?

Best regards,
								Pavel

> +++ b/fs/cifs/smb2pdu.c
> @@ -3425,6 +3425,9 @@ smb2_writev_callback(struct mid_q_entry *mid)
>  				     wdata->cfile->fid.persistent_fid,
>  				     tcon->tid, tcon->ses->Suid, wdata->offset,
>  				     wdata->bytes, wdata->result);
> +		if (wdata->result =3D=3D -ENOSPC)
> +			printk_once(KERN_WARNING "Out of space writing to %s\n",
> +				    tcon->treeName);
>  	} else
>  		trace_smb3_write_done(0 /* no xid */,
>  				      wdata->cfile->fid.persistent_fid,

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--da4uJneut+ArUgXk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl5RJbMACgkQMOfwapXb+vLCGQCgrGjJIfafpgWeDlUD4lQDyTlk
EBwAmgLIA2xgvjoxSOCFHf/XPKc4B7bf
=ux05
-----END PGP SIGNATURE-----

--da4uJneut+ArUgXk--
