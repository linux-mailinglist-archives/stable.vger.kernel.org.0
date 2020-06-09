Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52491F46BE
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 21:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729806AbgFITDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 15:03:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42836 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729793AbgFITDn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 15:03:43 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jijXB-0005AC-L6; Tue, 09 Jun 2020 20:03:41 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jijXB-006YBu-7J; Tue, 09 Jun 2020 20:03:41 +0100
Message-ID: <6c67b93d8720b9f8ca557a59a93f18d5d351f950.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 42/61] scsi: sg: don't return bogus Sg_requests
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Tony Battersby <tonyb@cybernetics.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Andrey Konovalov <andreyknvl@google.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Doug Gilbert <dgilbert@interlog.com>
Date:   Tue, 09 Jun 2020 20:03:35 +0100
In-Reply-To: <746e3939-9e5e-8610-5878-07330b2de87e@cybernetics.com>
References: <lsq.1591725832.563793501@decadent.org.uk>
         <746e3939-9e5e-8610-5878-07330b2de87e@cybernetics.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-rTuKF5/YgwFSKt61cS0h"
User-Agent: Evolution 3.36.2-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-rTuKF5/YgwFSKt61cS0h
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2020-06-09 at 14:28 -0400, Tony Battersby wrote:
> On 6/9/20 2:04 PM, Ben Hutchings wrote:
> > 3.16.85-rc1 review patch.  If anyone has any objections, please let me =
know.
> >=20
> > ------------------
> >=20
> > From: Johannes Thumshirn <jthumshirn@suse.de>
> >=20
> > commit 48ae8484e9fc324b4968d33c585e54bc98e44d61 upstream.
> >=20
> > If the list search in sg_get_rq_mark() fails to find a valid request, w=
e
> > return a bogus element. This then can later lead to a GPF in
> > sg_remove_scat().
> >=20
> > So don't return bogus Sg_requests in sg_get_rq_mark() but NULL in case
> > the list search doesn't find a valid request.
> >=20
> > Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> > Reported-by: Andrey Konovalov <andreyknvl@google.com>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Doug Gilbert <dgilbert@interlog.com>
> > Reviewed-by: Hannes Reinecke <hare@suse.de>
> > Acked-by: Doug Gilbert <dgilbert@interlog.com>
> > Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> > Cc: Tony Battersby <tonyb@cybernetics.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> >  drivers/scsi/sg.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >=20
> > --- a/drivers/scsi/sg.c
> > +++ b/drivers/scsi/sg.c
> > @@ -2085,11 +2085,12 @@ sg_get_rq_mark(Sg_fd * sfp, int pack_id)
> >  		if ((1 =3D=3D resp->done) && (!resp->sg_io_owned) &&
> >  		    ((-1 =3D=3D pack_id) || (resp->header.pack_id =3D=3D pack_id))) =
{
> >  			resp->done =3D 2;	/* guard against other readers */
> > -			break;
> > +			write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
> > +			return resp;
> >  		}
> >  	}
> >  	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
> > -	return resp;
> > +	return NULL;
> >  }
> > =20
> >  /* always adds to end of list */
> >=20
> The following "cleanup" commit to the sg driver introduced a number of bu=
gs:
>=20
> 109bade9c625 ("scsi: sg: use standard lists for sg_requests") (v4.12-rc1)
>=20
> This one bad commit requires all of the following fixes:
>=20
> 48ae8484e9fc ("scsi: sg: don't return bogus Sg_requests") (v4.12-rc1)
> bd46fc406b30 ("scsi: sg: off by one in sg_ioctl()") (v4.13-rc7)
> 4759df905a47 ("scsi: sg: factor out sg_fill_request_table()") (v4.14-rc1)
> 3e0097499839 ("scsi: sg: fixup infoleak when using SG_GET_REQUEST_TABLE")=
 (v4.14-rc1)
> 587c3c9f286c ("scsi: sg: Re-fix off by one in sg_fill_request_table()") (=
v4.14-rc6)
>=20
> AFAIK, there is no reason to backport any of these changes to -stable,
> but if for some reason you do need to backport any one of these patches,
> then make sure you get all of them.

I couldn't see how to backport some of the more recent fixes without
applying this change first.  For this review cycle I've picked all of
the bug fixes that were on the 4.4-stable and 4.9-stable branches and
not yet in 3.16-stable, so I do have all the fixes you identified
above.

Ben.

> My guess is that the initial buggy patch was backported to other -stable
> trees because the fixes for it looked important, and of course the fixes
> depended on the patch that introduced all of the problems to begin with.

--=20
Ben Hutchings
The two most common things in the universe are hydrogen and stupidity.



--=-rTuKF5/YgwFSKt61cS0h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl7f3QcACgkQ57/I7JWG
EQnsLw/8DyhJUymHh216B1Do/ezqFxNFcrXBiz+3fhpS6LIaZjr7dkz9eAIjtHc3
Z+Tlt5RU6NVifsA2rKSd+dX+KLZ7bv8co9IsP8E8868RF4sVLQMJw0cCW1bUrWBl
akwmIJSjOvF00XQ2Ijh3t+/nhSy1sNUIRUtnaZ5/egVbEWr1On6rQ2TtxyemxyaL
fJoklFTDsqRmZcQ9Qv3sbYCyZsHH2Gm49G4w0eQ8sLvAhvf5R4AqpeE9CaeOE2Xh
HE8vzx2V429bNhXWUT475/QK9xJbIlkB+4AzI0eQ87T/vhHJaB4IfagebXSsMVjk
MwjDktPgxEgYjI952ZgDVlzrfdQj0GZvxoZAoIwEqNlR8R7fczLZEV89xv+XQ/34
/vlInsiEQb84dT9Qm6EmdKoFOiCfw3OCZNuoY0UJqtNTSNsCeKenEBDm4Q+07TdL
kc8lnKH0b3Qyu+wBW3ULA91gumkg59IViab+tHu6Aji060J15i80SlA21AVnzMq9
OTy1hGpcn0OKL1TQxM2Kwcctbg4zw4pxRi/XWrnF8HdtIWVgUHx66OCmRB7VTaJQ
skZ9bkuN2MC4FliEQ+IbW5R/W4oUDu3USGL4ig4ehTDbXiQD+yHgHKmM405gA1P/
bB6+vupJtaAmyKpsJZ33NHdlTQyeDxWRLdkhazY83UQUf5QUv+I=
=Mn9K
-----END PGP SIGNATURE-----

--=-rTuKF5/YgwFSKt61cS0h--
