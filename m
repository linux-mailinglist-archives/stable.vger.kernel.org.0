Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196C11EEB6C
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 21:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729452AbgFDT5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 15:57:55 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51124 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729302AbgFDT5z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jun 2020 15:57:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591300673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G1kd6xwQuWcQevYgiN5E77Wh4Al+ZX6bmwJ65V9TlV0=;
        b=IV6lJXWQXaMsksDi3B5jxtKopyc6NEJdBXJXcr7XRs7UQIy61ou6Ddy4iogVoaIupu+rpQ
        G3/2mX4IPAOBoXMaNaYMQH4iL9Hc2bv2D9o4lfirMRVsMSvbgD1KCv9tNJBsU7ahnpuSVk
        9xrVD0z/UyXZr6MwK7DmeivjrcS0NFo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-raNl8zeOO4quuV5b7wLdXA-1; Thu, 04 Jun 2020 15:57:49 -0400
X-MC-Unique: raNl8zeOO4quuV5b7wLdXA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A13F464;
        Thu,  4 Jun 2020 19:57:47 +0000 (UTC)
Received: from localhost (ovpn-116-137.gru2.redhat.com [10.97.116.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FCA27CCD8;
        Thu,  4 Jun 2020 19:57:45 +0000 (UTC)
Date:   Thu, 4 Jun 2020 16:57:44 -0300
From:   Bruno Meneguele <bmeneg@redhat.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     Roberto Sassu <roberto.sassu@huawei.com>, tiwai@suse.de,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] ima: Call ima_calc_boot_aggregate() in
 ima_eventdigest_init()
Message-ID: <20200604195744.GS2970@glitch>
References: <20200603150821.8607-1-roberto.sassu@huawei.com>
 <20200603150821.8607-2-roberto.sassu@huawei.com>
 <1591221815.5146.31.camel@linux.ibm.com>
 <20200604191207.GR2970@glitch>
 <1591299320.5146.53.camel@linux.ibm.com>
MIME-Version: 1.0
In-Reply-To: <1591299320.5146.53.camel@linux.ibm.com>
X-PGP-Key: http://keys.gnupg.net/pks/lookup?op=get&search=0x3823031E4660608D
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="N+qDRRsDvMgizTft"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--N+qDRRsDvMgizTft
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 04, 2020 at 03:35:20PM -0400, Mimi Zohar wrote:
> On Thu, 2020-06-04 at 16:12 -0300, Bruno Meneguele wrote:
> > On Wed, Jun 03, 2020 at 06:03:35PM -0400, Mimi Zohar wrote:
> > > Hi Roberto,
> > >=20
> > > On Wed, 2020-06-03 at 17:08 +0200, Roberto Sassu wrote:
> > > > If the template field 'd' is chosen and the digest to be added to t=
he
> > > > measurement entry was not calculated with SHA1 or MD5, it is
> > > > recalculated with SHA1, by using the passed file descriptor. Howeve=
r, this
> > > > cannot be done for boot_aggregate, because there is no file descrip=
tor.
> > > >=20
> > > > This patch adds a call to ima_calc_boot_aggregate() in
> > > > ima_eventdigest_init(), so that the digest can be recalculated also=
 for the
> > > > boot_aggregate entry.
> > > >=20
> > > > Cc: stable@vger.kernel.org # 3.13.x
> > > > Fixes: 3ce1217d6cd5d ("ima: define template fields library and new =
helpers")
> > > > Reported-by: Takashi Iwai <tiwai@suse.de>
> > > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > >=20
> > > Thanks, Roberto.
> > >=20
> > > I've pushed both patches out to the next-integrity branch and would
> > > appreciate some additional testing.
> > >=20
> > > thanks,
> > >=20
> > > Mimi
> > >=20
> >=20
> > Hi Mimi and Roberto,
> >=20
> > FWIW, I've tested this patch manually and things went fine, with no
> > unexpected behavior or results.=20
>=20
> Thanks, Bruno!
>=20
> > However, wouldn't it be worth add a note in kmsg about the
> > ima_calc_boot_aggregate() being called with an algo different from the
> > system's default? Just to let the user know he won't find a sha256 when
> > check the measurement. But that's something we can add later too.
>=20
> There's no guarantees that the IMA default crypto algorithm will be
> used for calculating the boot_aggregate. =A0The algorithm is dependent
> on the TPM. =A0For example, the default IMA algorithm could be sha256,
> but on a system with TPM 1.2, the boot_aggregate would have to be
> sha1.

Ah Indeed.. it makes sense.

>=20
> This patch addresses a mismatch between the template format field ('d'
> field) and the larger digest. =A0We could require the "ima_template_fmt"
> specified on the boot command line define an appropriate format, but
> Roberto decided to support the situation where both "d" and "d-ng" are
> defined.

Yes, personally I also prefer to "fail earlier" or to be more stricter
on user definitions, but I also understand going the other way allowing
both d & d-ng.

>=20
> Mimi
>=20

thanks Mimi.

--=20
bmeneg=20
PGP Key: http://bmeneg.com/pubkey.txt

--N+qDRRsDvMgizTft
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEdWo6nTbnZdbDmXutYdRkFR+RokMFAl7ZUjgACgkQYdRkFR+R
okMoZgf/YKUFxFPcsI8P3M88CPBksamyJpDCfsFn0+pFPHLS2y6My9cUdESk33Pc
SygUKgfNnw2sCPsawDBq3UE3IIQ33rI4XTGRuJR1PmJHz/s9qITC4aBugkC2ufDv
a5sw/TCUHvUopciZGg4ryAIM+crwCqjiGUe7WHX6VunpaYjE724CNLP57Dg2GqGe
r8OYClMIuRhyVtTfa3hjlFNiQdiymCXrguUBj1ss7YXxPpJAyB86Rdc1OHITFFl5
SUPt1g5z8v3xIRoClUNiUyLKqI3hJ5U/OKndzsfzlmjhOPVbkfFe30EJHfW5vMT/
PggXwoxgm0PKYxHxT+BBUFDAY6/9ag==
=1GTw
-----END PGP SIGNATURE-----

--N+qDRRsDvMgizTft--

