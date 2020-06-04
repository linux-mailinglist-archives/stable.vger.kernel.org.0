Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20011EEAF1
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 21:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbgFDTMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 15:12:17 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45895 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726446AbgFDTMR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jun 2020 15:12:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591297936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t26H1FhBTAEpRrmN8caMlOthl/eu2irMbt7QQDhOhB8=;
        b=O6L1UZ6NTvTJoMXGZOKYUdkiGrzZwORU8EhrvWqS9fBnClp7WrYET0iOYlGnL/Nx0jbTjJ
        Ss4DmMnNT6yo94YqKfLoXI1Fo6OaepWMtlyocsvwQiWEQQgNGSgQfwnoEa/hZoWIA2Y0iw
        dECsFPovbk2SlVT4cPtw/CMaS6sN0Hg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-PVgD82seO1ybcW8gYaZkvg-1; Thu, 04 Jun 2020 15:12:11 -0400
X-MC-Unique: PVgD82seO1ybcW8gYaZkvg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED54C18A8223;
        Thu,  4 Jun 2020 19:12:09 +0000 (UTC)
Received: from localhost (ovpn-116-137.gru2.redhat.com [10.97.116.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23B5C5D9D5;
        Thu,  4 Jun 2020 19:12:08 +0000 (UTC)
Date:   Thu, 4 Jun 2020 16:12:07 -0300
From:   Bruno Meneguele <bmeneg@redhat.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     Roberto Sassu <roberto.sassu@huawei.com>, tiwai@suse.de,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] ima: Call ima_calc_boot_aggregate() in
 ima_eventdigest_init()
Message-ID: <20200604191207.GR2970@glitch>
References: <20200603150821.8607-1-roberto.sassu@huawei.com>
 <20200603150821.8607-2-roberto.sassu@huawei.com>
 <1591221815.5146.31.camel@linux.ibm.com>
MIME-Version: 1.0
In-Reply-To: <1591221815.5146.31.camel@linux.ibm.com>
X-PGP-Key: http://keys.gnupg.net/pks/lookup?op=get&search=0x3823031E4660608D
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uRjmd8ppyyws0Tml"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--uRjmd8ppyyws0Tml
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 03, 2020 at 06:03:35PM -0400, Mimi Zohar wrote:
> Hi Roberto,
>=20
> On Wed, 2020-06-03 at 17:08 +0200, Roberto Sassu wrote:
> > If the template field 'd' is chosen and the digest to be added to the
> > measurement entry was not calculated with SHA1 or MD5, it is
> > recalculated with SHA1, by using the passed file descriptor. However, t=
his
> > cannot be done for boot_aggregate, because there is no file descriptor.
> >=20
> > This patch adds a call to ima_calc_boot_aggregate() in
> > ima_eventdigest_init(), so that the digest can be recalculated also for=
 the
> > boot_aggregate entry.
> >=20
> > Cc: stable@vger.kernel.org # 3.13.x
> > Fixes: 3ce1217d6cd5d ("ima: define template fields library and new help=
ers")
> > Reported-by: Takashi Iwai <tiwai@suse.de>
> > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
>=20
> Thanks, Roberto.
>=20
> I've pushed both patches out to the next-integrity branch and would
> appreciate some additional testing.
>=20
> thanks,
>=20
> Mimi
>=20

Hi Mimi and Roberto,

FWIW, I've tested this patch manually and things went fine, with no
unexpected behavior or results.=20

However, wouldn't it be worth add a note in kmsg about the
ima_calc_boot_aggregate() being called with an algo different from the
system's default? Just to let the user know he won't find a sha256 when
check the measurement. But that's something we can add later too.

Thanks.

--=20
bmeneg=20
PGP Key: http://bmeneg.com/pubkey.txt

--uRjmd8ppyyws0Tml
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEdWo6nTbnZdbDmXutYdRkFR+RokMFAl7ZR4cACgkQYdRkFR+R
okPv+gf8DgXvxo4KWoJAItxE9kGVy1gfkC+UMthV9x2KPxkqo/6z4raVsZEs9KuG
rX4dy8/WPi7ddz9pfagsZ2d8mzruEmNSxnvm658tFQRbno+SyiOAMpafkRHXK928
jsxO53HYwe6nmW21ix+ZKSKc3Q1hKDwlxjNr+gvOCkt44LJ1bOTV0IDUzQ+mxmlV
a1IJVBMN2+mwkmUjj8B10E/HHlzM4Ai8i9UNrwe2Lj6wpQeWzkckdTor3IZe8W6O
cdow1P8bqES3n4/5A1tM/2lzRcl1tnIi9bX4E14YbYiAW3oOj39JMZr77D5AD4Vs
Z8O3ba0++rFejZ0TDCwACE72Wjalrw==
=e59Z
-----END PGP SIGNATURE-----

--uRjmd8ppyyws0Tml--

