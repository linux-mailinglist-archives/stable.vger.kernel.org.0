Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 561F4105D6D
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 00:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfKUXxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 18:53:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:11343 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbfKUXxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 18:53:52 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Nov 2019 15:53:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,227,1571727600"; 
   d="asc'?scan'208";a="219272737"
Received: from lmhaganx-mobl.amr.corp.intel.com ([10.251.138.123])
  by orsmga002.jf.intel.com with ESMTP; 21 Nov 2019 15:53:51 -0800
Message-ID: <7fa4d937db14f550b3c3624ff5d13875566e8cdd.camel@intel.com>
Subject: Re: [PATCH 4.19 079/422] i40e: use correct length for strncpy
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mitch Williams <mitch.a.williams@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Sasha Levin <sashal@kernel.org>
Date:   Thu, 21 Nov 2019 15:53:50 -0800
In-Reply-To: <20191121103504.GC26882@amd>
References: <20191119051400.261610025@linuxfoundation.org>
         <20191119051404.622986351@linuxfoundation.org> <20191121103504.GC26882@amd>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-ZhLo4uiGTkHBM5nXZKab"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-ZhLo4uiGTkHBM5nXZKab
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-11-21 at 11:35 +0100, Pavel Machek wrote:
> > From: Mitch Williams <mitch.a.williams@intel.com>
> >=20
> > [ Upstream commit 7eb74ff891b4e94b8bac48f648a21e4b94ddee64 ]
> >=20
> > Caught by GCC 8. When we provide a length for strncpy, we should not
> > include the terminating null. So we must tell it one less than the size
> > of the destination buffer.
>=20
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
> > @@ -694,7 +694,8 @@ static long i40e_ptp_create_clock(struct i40e_pf
> *pf)
> >       if (!IS_ERR_OR_NULL(pf->ptp_clock))
> >               return 0;
> > =20
> > -     strncpy(pf->ptp_caps.name, i40e_driver_name, sizeof(pf-
> >ptp_caps.name));
> > +     strncpy(pf->ptp_caps.name, i40e_driver_name,
> > +             sizeof(pf->ptp_caps.name) - 1);
> >       pf->ptp_caps.owner =3D THIS_MODULE;
> >       pf->ptp_caps.max_adj =3D 999999999;
> >       pf->ptp_caps.n_ext_ts =3D 0;
>=20
> So... pf is allocated with kzalloc, which will provide the null
> termination... so the code is okay.
>=20
> On the other hand, the =3D 0 below is unneeded by the same logic, so
> this is a bit confusing.

Thanks for the catch, we are putting together a follow-on patch to cleanup
up the unneeded code.

--=-ZhLo4uiGTkHBM5nXZKab
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl3XI44ACgkQ5W/vlVpL
7c5UdA//T42uWRN1y1+11boQlufWFhFADrtJAQAISRBd8Wd+Biaa3mDw9vtcCSRU
lbPwcFv6DBmpTRKNscMuKPkea4DeAVqtwHTQ2iWR/w7ou8VCgjHhGMp49m+weqaV
gMi+o/Cuj51cq2RxnvLAnmy3eOuyUHzzAycKeVIDJSyoPX7WGPq6Jy40Wv6w8IqV
s9oBMikGYDvHtklBrEui9AO5vhro0rlUmVvwx4HD9pNLUFI8NjU0NNPzghYElU8i
d5fA0PvGjY8lzvabZvM4mAcbFf9n1Wv6vdxCPSnZaxj7phyPb7GdsCgNkoEhxssw
j+y8JjZJvb2Hyt2mPmwecmRt/UTrRwm8zJjEAaaGceuFd5q52+8jmLotQo3ljZdM
91WHDJ1nPEAP2aVECnhRTpb4DAdfH4jAGqfFwKBUeUNGIwwN5H/7xTRZMrzSlbVx
LUEqf9GsTpUEQHUTs1Dz56WrtUvxn5Kh91EC3ZjHFXbTuiJ75PuUsnWzambNhGQe
zoMhP7vmz8HgY4aTFNDrJTsBYRw10saJhfD+tGIO+FkTpoazS0j6NKYvtociWYpT
o9YmQM1ADZ4OTjJFpgFuMCfBXbZUYhNpwvcSeYAm5w/ljPSAA61K3vuL6TMu3ZhP
/wEFmJnsJ1+UcsAW17bA0Mu3ZihJGkgpGPMOxReeaIMbIdQB8hw=
=99Bu
-----END PGP SIGNATURE-----

--=-ZhLo4uiGTkHBM5nXZKab--

