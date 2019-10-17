Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A08E0DB853
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 22:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390041AbfJQUeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 16:34:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56026 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728177AbfJQUeY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Oct 2019 16:34:24 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7D36C7FDFA;
        Thu, 17 Oct 2019 20:34:24 +0000 (UTC)
Received: from linux-ws.nc.xsintricity.com (ovpn-112-37.rdu2.redhat.com [10.10.112.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5379E19C70;
        Thu, 17 Oct 2019 20:34:23 +0000 (UTC)
Message-ID: <0af4756e60b72629cad79e93ce7f0c8a8451f116.camel@redhat.com>
Subject: Re: [PATCH for-rc 1/2] IB/hfi1: Avoid excessive retry for TID RDMA
 READ request
From:   Doug Ledford <dledford@redhat.com>
To:     Dennis Dalessandro <dennis.dalessandro@intel.com>, jgg@ziepe.ca
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
Date:   Thu, 17 Oct 2019 16:34:20 -0400
In-Reply-To: <20191004204035.26542.41684.stgit@awfm-01.aw.intel.com>
References: <20191004203739.26542.57060.stgit@awfm-01.aw.intel.com>
         <20191004204035.26542.41684.stgit@awfm-01.aw.intel.com>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-tAxF7jddLh5b38osEc7G"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 17 Oct 2019 20:34:24 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-tAxF7jddLh5b38osEc7G
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-10-04 at 16:40 -0400, Dennis Dalessandro wrote:
> From: Kaike Wan <kaike.wan@intel.com>
>=20
> A TID RDMA READ request could be retried under one of the following
> conditions:
> - The RC retry timer expires;
> - A later TID RDMA READ RESP packet is received before the next
>   expected one.
> For the latter, under normal conditions, the PSN in IB space is used
> for comparison. More specifically, the IB PSN in the incoming TID RDMA
> READ RESP packet is compared with the last IB PSN of a given TID RDMA
> READ request to determine if the request should be retried. This is
> similar to the retry logic for noraml RDMA READ request.
>=20
> However, if a TID RDMA READ RESP packet is lost due to congestion,
> header suppresion will be disabled and each incoming packet will raise
> an interrupt until the hardware flow is reloaded. Under this
> condition,
> each packet KDETH PSN will be checked by software against r_next_psn
> and a retry will be requested if the packet KDETH PSN is later than
> r_next_psn. Since each TID RDMA READ segment could have up to 64
> packets and each TID RDMA READ request could have many segments, we
> could make far more retries under such conditions, and thus leading to
> RETRY_EXC_ERR status.
>=20
> This patch fixes the issue by removing the retry when the incoming
> packet KDETH PSN is later than r_next_psn. Instead, it resorts to
> RC timer and normal IB PSN comparison for any request retry.
>=20
> Fixes: 9905bf06e890 ("IB/hfi1: Add functions to receive TID RDMA READ
> response")
> Cc: <stable@vger.kernel.org>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> Signed-off-by: Kaike Wan <kaike.wan@intel.com>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>

Thanks, applied to for-rc.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-tAxF7jddLh5b38osEc7G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAl2o0EwACgkQuCajMw5X
L92LCA/+KLULbI2AvkAcSBEYv3k1hAkTIo+FzfJj3o0/OGLQi2DvwyDpp/KLIJm5
NwdQHKpRq9rGuPxzcNekNrKVvWGnDKzCvLusajY1WF1q5j0A3cGDZPLbEvBA05Uo
K86v1u+BR+6UvibjkDP+ZGc9os2H8TTFuFmRd9aKdHgopzRPM7eNcOBMG5d8Pccf
H7pz4Q9fWQMIpYwRgJJkaBtJqTSNCoSyHqeL3c6gCRIwbsPS9rT6TBCrCF2qAsst
eoe/PjjARu3DrAXYB187CPTit9k73xXwxtHSS2UrmV4voItfTOA3c52qCloVfDWh
vOpo3+DYW5qiete6JC5EKQbPT4uxvxGclzE9XA+aW03P5UkqDhdDvr8KF7qvujbj
0CvphbqlJHxJ6JXmXl0Yvw9TeHL+0TwxJzvY+BP1MfkT1eUp/mx44uTCS3Xx0w+n
IgE2mhL+LxNla/hso/pGdzBUpnS9SyauICArSIjdX0v+pWRj1l0sxnrYTgXyzfUb
Id1CT8/b5+gqE9Qke3fzsyImdgI51xc0npt5eLqCQoPFHkHlyUYWduGwHmTUqnwA
3ND/YK/kfjPlPQ1Oh3HFXneoIO6ZGqnJ0atJjBod1dnjrGuaGtKvJEfu3WQjeDvg
zlu4F6OIT3QuFVAHvB4oUSLxF0JYeUYt8EVE1oYUg/M8gqogPNI=
=lj3R
-----END PGP SIGNATURE-----

--=-tAxF7jddLh5b38osEc7G--

