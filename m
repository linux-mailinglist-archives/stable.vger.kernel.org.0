Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373CE21BD9C
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 21:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgGJTZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 15:25:38 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23574 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728269AbgGJTZf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 15:25:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594409133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dB+4p3mFcNbkumvGSSHU5rWnmgenBPiiFxkhyGA7nh8=;
        b=Obv3yu1SiTZT/VRBCG7bbPKPnpH4WkYI72x/Ic1B6FueUQyJvsvmCNz2Ngo4cvTDOEPIU3
        dnwFJx+RpLQioFGij2/MOBuFHAYVCW7XhjENtsIv7no/ns4BzTBzpTwVihCCAllTU58e/L
        9UJujHWNaPq7u68p0u31cEoJbet4LeA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-D3aiIOxYOIuMLB_d2DOSHw-1; Fri, 10 Jul 2020 15:25:20 -0400
X-MC-Unique: D3aiIOxYOIuMLB_d2DOSHw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81758106B242;
        Fri, 10 Jul 2020 19:25:18 +0000 (UTC)
Received: from localhost (ovpn-116-13.gru2.redhat.com [10.97.116.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DCD91010404;
        Fri, 10 Jul 2020 19:25:17 +0000 (UTC)
Date:   Fri, 10 Jul 2020 16:25:16 -0300
From:   Bruno Meneguele <bmeneg@redhat.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-integrity@vger.kernel.org, erichte@linux.ibm.com,
        nayna@linux.ibm.com, stable@vger.kernel.org
Subject: Re: [PATCH v5] ima: move APPRAISE_BOOTPARAM dependency on
 ARCH_POLICY to runtime
Message-ID: <20200710192516.GC10547@glitch>
References: <20200709164647.45153-1-bmeneg@redhat.com>
 <1594401804.14405.8.camel@linux.ibm.com>
 <20200710180338.GA10547@glitch>
 <20200710183420.GB10547@glitch>
 <1594407288.14405.36.camel@linux.ibm.com>
MIME-Version: 1.0
In-Reply-To: <1594407288.14405.36.camel@linux.ibm.com>
X-PGP-Key: http://keys.gnupg.net/pks/lookup?op=get&search=0x3823031E4660608D
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VywGB/WGlW4DM4P8"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--VywGB/WGlW4DM4P8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 10, 2020 at 02:54:48PM -0400, Mimi Zohar wrote:
> On Fri, 2020-07-10 at 15:34 -0300, Bruno Meneguele wrote:
> > On Fri, Jul 10, 2020 at 03:03:38PM -0300, Bruno Meneguele wrote:
> > > On Fri, Jul 10, 2020 at 01:23:24PM -0400, Mimi Zohar wrote:
> > > > On Thu, 2020-07-09 at 13:46 -0300, Bruno Meneguele wrote:
> > > > > APPRAISE_BOOTPARAM has been marked as dependent on !ARCH_POLICY i=
n compile
> > > > > time, enforcing the appraisal whenever the kernel had the arch po=
licy option
> > > > > enabled.
> > > >=20
> > > > > However it breaks systems where the option is set but the system =
didn't
> > > > > boot in a "secure boot" platform. In this scenario, anytime an ap=
praisal
> > > > > policy (i.e. ima_policy=3Dappraisal_tcb) is used it will be force=
d, without
> > > > > giving the user the opportunity to label the filesystem, before e=
nforcing
> > > > > integrity.
> > > > >=20
> > > > > Considering the ARCH_POLICY is only effective when secure boot is=
 actually
> > > > > enabled this patch remove the compile time dependency and move it=
 to a
> > > > > runtime decision, based on the secure boot state of that platform=
.
> > > >=20
> > > > Perhaps we could simplify this patch description a bit?
> > > >=20
> > > > The IMA_APPRAISE_BOOTPARAM config allows enabling different
> > > > "ima_appraise=3D" modes - log, fix, enforce - at run time, but not =
when
> > > > IMA architecture specific policies are enabled. =A0This prevents
> > > > properly labeling the filesystem on systems where secure boot is
> > > > supported, but not enabled on the platform. =A0Only when secure boo=
t is
> > > > enabled, should these IMA appraise modes be disabled.
> > > >=20
> > > > This patch removes the compile time dependency and makes it a runti=
me
> > > > decision, based on the secure boot state of that platform.
> > > >=20
> > >=20
> > > Sounds good to me.
> > >=20
> > > > <snip>
> > > >=20
> > > > > diff --git a/security/integrity/ima/ima_appraise.c b/security/int=
egrity/ima/ima_appraise.c
> > > > > index a9649b04b9f1..884de471b38a 100644
> > > > > --- a/security/integrity/ima/ima_appraise.c
> > > > > +++ b/security/integrity/ima/ima_appraise.c
> > > > > @@ -19,6 +19,11 @@
> > > > >  static int __init default_appraise_setup(c
> > > >=20
> > > > > har *str)
> > > > >  {
> > > > >  #ifdef CONFIG_IMA_APPRAISE_BOOTPARAM
> > > > > +=09if (arch_ima_get_secureboot()) {
> > > > > +=09=09pr_info("appraise boot param ignored: secure boot enabled"=
);
> > > >=20
> > > > Instead of a generic statement, is it possible to include the actua=
l
> > > > option being denied? =A0Perhaps something like: "Secure boot enable=
d,
> > > > ignoring %s boot command line option"
> > > >=20
> > > > Mimi
> > > >=20
> > >=20
> > > Yes, sure.
> > >=20
> >=20
> > Btw, would it make sense to first make sure we have a valid "str"
> > option and not something random to print?
> > =20
> > diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity=
/ima/ima_appraise.c
> > index a9649b04b9f1..1f1175531d3e 100644
> > --- a/security/integrity/ima/ima_appraise.c
> > +++ b/security/integrity/ima/ima_appraise.c
> > @@ -25,6 +25,16 @@ static int __init default_appraise_setup(char *str)
> >                 ima_appraise =3D IMA_APPRAISE_LOG;
> >         else if (strncmp(str, "fix", 3) =3D=3D 0)
> >                 ima_appraise =3D IMA_APPRAISE_FIX;
> > +       else
> > +               pr_info("invalid \"%s\" appraise option");
> > +
> > +       if (arch_ima_get_secureboot()) {
> > +               if (!is_ima_appraise_enabled()) {
> > +                       pr_info("Secure boot enabled: ignoring ima_appr=
aise=3D%s boot parameter option",
> > +                               str);
> > +                       ima_appraise =3D IMA_APPRAISE_ENFORCE;
> > +               }
> > +       }
>=20
> Providing feedback is probably a good idea. =A0However, the
> "arch_ima_get_secureboot" test can't come after setting
> "ima_appraise."
>=20

Sorry, but I'm not sure if I got the reason to why it can't be done
after: would it be basically to prevent any further processing about
ima_appraise as a matter of security principle? Or maybe to keep the
dependency between secureboot and bootparam truly strict?=20

Or are there something else I'm missing?

> Mimi
>=20
> >  #endif
> >         return 1;
> >  }
> >=20
> >=20
> > The "else" there I think would make sense as well, at least to give the
> > user some feedback about a possible mispelling of him (as a separate
> > patch).
> >=20
> > And "if(!is_ima_appraise_enabled())" would avoid to print anything abou=
t
> > "ignoring the option" to the user in case he explicitly set "enforce",
> > which we know there isn't any real effect but is allowed and shown in
> > kernel-parameters.txt.
> >=20
> > > Thanks!
> > >=20
> > > > > +=09=09return 1;
> > > > > +=09}
> > > > > +
> > > > >  =09if (strncmp(str, "off", 3) =3D=3D 0)
> > > > >  =09=09ima_appraise =3D 0;
> > > > >  =09else if (strncmp(str, "log", 3) =3D=3D 0)
> > > >=20
> > >=20
> > > --=20
> > > bmeneg=20
> > > PGP Key: http://bmeneg.com/pubkey.txt
> >=20
> >=20
> >=20
>=20

--=20
bmeneg=20
PGP Key: http://bmeneg.com/pubkey.txt

--VywGB/WGlW4DM4P8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEdWo6nTbnZdbDmXutYdRkFR+RokMFAl8IwJwACgkQYdRkFR+R
okPoHwgAy7MLZ15gY7OtTlh4cernWNb6w8odML7tp8dhQG8ToXwkPwBdBjC5WU6z
nbhxCHTxLej0ej8nHoo0IEsAv+4iNnlM+VtS/mWT5p1/dD2HkiM2cTK3Zwj1kqZk
1L9tPFbvBIllDRAFzzn44vSDG/jixbGFMGU9y3rFAQQHqFNi1ZDz3hg0yzgwJNar
pW4FPhxzXVi5ASCGhm7/Z5/qbx6ARtwH5U/eFIx45dG3oAafXqcZiJ1fj871nEjR
1ddrO2U4Yy53z4JqimlRxhu/VlB+U1wlRG8GnEuM1ngkiKwJ48Zrdo+Ren8dOdTK
0gu15PhNDXuOPPzVHi2ot69JM1kq1Q==
=nip5
-----END PGP SIGNATURE-----

--VywGB/WGlW4DM4P8--

