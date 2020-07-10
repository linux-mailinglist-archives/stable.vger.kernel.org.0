Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F8B21BCC0
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 20:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgGJSDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 14:03:52 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40659 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728268AbgGJSDu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 14:03:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594404230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XN24PGjpaeX+61Yzd0yY+PTaQgU43gwsWj3Uzow6ocE=;
        b=dp6yI/x3UrmaZfgYeUDAlAQ7hRYJ80+MxpdO4krIsANx/Kvez0rpE1CjBuE1kDHZud8cgI
        oFcTSne+GwQdp0ORgT5y28BiwG7d9hcgDVtVvQaEYtmELYx2IHW/UmuBm30SpYgKHnGXxE
        99n2k7V4IdnMrRbS7B/8SM8NX0xKen0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-_VnW-mdIMea6fAcU4Rjghg-1; Fri, 10 Jul 2020 14:03:41 -0400
X-MC-Unique: _VnW-mdIMea6fAcU4Rjghg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4A628027E4;
        Fri, 10 Jul 2020 18:03:39 +0000 (UTC)
Received: from localhost (ovpn-116-13.gru2.redhat.com [10.97.116.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 518907EF89;
        Fri, 10 Jul 2020 18:03:39 +0000 (UTC)
Date:   Fri, 10 Jul 2020 15:03:38 -0300
From:   Bruno Meneguele <bmeneg@redhat.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-integrity@vger.kernel.org, erichte@linux.ibm.com,
        nayna@linux.ibm.com, stable@vger.kernel.org
Subject: Re: [PATCH v5] ima: move APPRAISE_BOOTPARAM dependency on
 ARCH_POLICY to runtime
Message-ID: <20200710180338.GA10547@glitch>
References: <20200709164647.45153-1-bmeneg@redhat.com>
 <1594401804.14405.8.camel@linux.ibm.com>
MIME-Version: 1.0
In-Reply-To: <1594401804.14405.8.camel@linux.ibm.com>
X-PGP-Key: http://keys.gnupg.net/pks/lookup?op=get&search=0x3823031E4660608D
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=bmeneg@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 10, 2020 at 01:23:24PM -0400, Mimi Zohar wrote:
> On Thu, 2020-07-09 at 13:46 -0300, Bruno Meneguele wrote:
> > APPRAISE_BOOTPARAM has been marked as dependent on !ARCH_POLICY in comp=
ile
> > time, enforcing the appraisal whenever the kernel had the arch policy o=
ption
> > enabled.
>=20
> > However it breaks systems where the option is set but the system didn't
> > boot in a "secure boot" platform. In this scenario, anytime an appraisa=
l
> > policy (i.e. ima_policy=3Dappraisal_tcb) is used it will be forced, wit=
hout
> > giving the user the opportunity to label the filesystem, before enforci=
ng
> > integrity.
> >=20
> > Considering the ARCH_POLICY is only effective when secure boot is actua=
lly
> > enabled this patch remove the compile time dependency and move it to a
> > runtime decision, based on the secure boot state of that platform.
>=20
> Perhaps we could simplify this patch description a bit?
>=20
> The IMA_APPRAISE_BOOTPARAM config allows enabling different
> "ima_appraise=3D" modes - log, fix, enforce - at run time, but not when
> IMA architecture specific policies are enabled. =A0This prevents
> properly labeling the filesystem on systems where secure boot is
> supported, but not enabled on the platform. =A0Only when secure boot is
> enabled, should these IMA appraise modes be disabled.
>=20
> This patch removes the compile time dependency and makes it a runtime
> decision, based on the secure boot state of that platform.
>=20

Sounds good to me.

> <snip>
>=20
> > diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity=
/ima/ima_appraise.c
> > index a9649b04b9f1..884de471b38a 100644
> > --- a/security/integrity/ima/ima_appraise.c
> > +++ b/security/integrity/ima/ima_appraise.c
> > @@ -19,6 +19,11 @@
> >  static int __init default_appraise_setup(c
>=20
> > har *str)
> >  {
> >  #ifdef CONFIG_IMA_APPRAISE_BOOTPARAM
> > +=09if (arch_ima_get_secureboot()) {
> > +=09=09pr_info("appraise boot param ignored: secure boot enabled");
>=20
> Instead of a generic statement, is it possible to include the actual
> option being denied? =A0Perhaps something like: "Secure boot enabled,
> ignoring %s boot command line option"
>=20
> Mimi
>=20

Yes, sure.

Thanks!

> > +=09=09return 1;
> > +=09}
> > +
> >  =09if (strncmp(str, "off", 3) =3D=3D 0)
> >  =09=09ima_appraise =3D 0;
> >  =09else if (strncmp(str, "log", 3) =3D=3D 0)
>=20

--=20
bmeneg=20
PGP Key: http://bmeneg.com/pubkey.txt

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEdWo6nTbnZdbDmXutYdRkFR+RokMFAl8IrXoACgkQYdRkFR+R
okMw7wf/QLnOgC+jQhpff5dmbxQXCG/rSbdtVKMUjIej817eUaAGovHn4XwicYqn
xCg2qIqTHuF4e5aYOsVB+kRIVdNZI2GVL27O0SArwFrPgvvOan3CKK5nStQkXRr9
XsLBEsgLKDV91xaQxBXrxWSslJWln5YFZNZYxvOsrhiRLwt4m7P0eSIForfL4UI2
OoJhwTCuBBMEi906mhlmOQwFyTi9/NMQluwf2iB+moJzRMo79cfFU6D//rP9RfoP
yttKBvpWqWUbPQ3cAVHkke+Yqr06Cz8BDYT3hP0oRJaludvY2Q/xVjBIOi3sX0gI
dx8A3npnWwj0SUi90M+u4rIHQm9vCA==
=X95t
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--

