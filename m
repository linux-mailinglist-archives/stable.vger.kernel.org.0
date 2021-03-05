Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052AD32F604
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 23:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhCEWma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 17:42:30 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:48246 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhCEWm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 17:42:29 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 63F581C0B81; Fri,  5 Mar 2021 23:42:27 +0100 (CET)
Date:   Fri, 5 Mar 2021 23:42:26 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Adam Nichols <adam@grimm-co.com>,
        Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 5.10 083/102] scsi: iscsi: Restrict sessions and handles
 to admin capabilities
Message-ID: <20210305224226.GA801@amd>
References: <20210305120903.276489876@linuxfoundation.org>
 <20210305120907.364742631@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <20210305120907.364742631@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Lee Duncan <lduncan@suse.com>
>=20
> commit 688e8128b7a92df982709a4137ea4588d16f24aa upstream.
>=20
> Protect the iSCSI transport handle, available in sysfs, by requiring
> CAP_SYS_ADMIN to read it. Also protect the netlink socket by restricting
> reception of messages to ones sent with CAP_SYS_ADMIN. This disables
> normal users from being able to end arbitrary iSCSI sessions.

Should not normal filesystem permissions be used?

> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -132,6 +132,9 @@ show_transport_handle(struct device *dev
>  		      char *buf)
>  {
>  	struct iscsi_internal *priv =3D dev_to_iscsi_internal(dev);
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EACCES;
>  	return sprintf(buf, "%llu\n", (unsigned long long)iscsi_handle(priv->is=
csi_transport));
>  }
>  static DEVICE_ATTR(handle, S_IRUGO, show_transport_handle, NULL);

AFAICT we make the file 0444 (world readable) and then fail the read
with capability check. If the file is not supposed to be
world-readable, it should have 0400 permissions, right?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBCs9IACgkQMOfwapXb+vIsdwCgjcQuK8NkqZ8lM4jIvGfPCp1N
Th4AoKvOHXdxsh61FJi5vnG6bJ8zD4yF
=wfqM
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
