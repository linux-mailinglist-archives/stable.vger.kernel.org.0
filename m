Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 851089FB37
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 09:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbfH1HLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 03:11:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54935 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfH1HLX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 03:11:23 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id E66BF81849; Wed, 28 Aug 2019 09:11:06 +0200 (CEST)
Date:   Wed, 28 Aug 2019 09:11:19 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Steve Dickson <steved@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 35/98] NFS: Fix regression whereby fscache errors
 are appearing on nofsc mounts
Message-ID: <20190828071119.GA10462@amd>
References: <20190827072718.142728620@linuxfoundation.org>
 <20190827072720.043818271@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <20190827072720.043818271@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2019-08-27 09:50:14, Greg Kroah-Hartman wrote:
> [ Upstream commit dea1bb35c5f35e0577cfc61f79261d80b8715221 ]
>=20
> People are reporing seeing fscache errors being reported concerning
> duplicate cookies even in cases where they are not setting up fscache
> at all. The rule needs to be that if fscache is not enabled, then it
> should have no side effects at all.
>=20
> To ensure this is the case, we disable fscache completely on all superblo=
cks
> for which the 'fsc' mount option was not set. In order to avoid issues
> with '-oremount', we also disable the ability to turn fscache on via
> remount.

Actually, the code seems to suggest that you disable the ability to
turn fscache _off_ via remount, too.

Is that intentional?

Best regards,
								Pavel

> @@ -2239,6 +2239,7 @@ nfs_compare_remount_data(struct nfs_server *nfss,
>  	    data->acdirmin !=3D nfss->acdirmin / HZ ||
>  	    data->acdirmax !=3D nfss->acdirmax / HZ ||
>  	    data->timeo !=3D (10U * nfss->client->cl_timeout->to_initval / HZ) =
||
> +	    (data->options & NFS_OPTION_FSCACHE) !=3D (nfss->options & NFS_OPTI=
ON_FSCACHE) ||
>  	    data->nfs_server.port !=3D nfss->port ||
>  	    data->nfs_server.addrlen !=3D nfss->nfs_client->cl_addrlen ||
>  	    !rpc_cmp_addr((struct sockaddr *)&data->nfs_server.address,

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl1mKRcACgkQMOfwapXb+vIEvACfVpzLbeyLcBleN3N5tPiXdRHY
yqsAoKVSoLdRl2MIVRw24zZV2bl8V+9T
=hqyc
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
