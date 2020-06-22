Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD402041C7
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 22:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgFVUQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 16:16:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31301 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728475AbgFVUQd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 16:16:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592856991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q8j62mIYdtNkiHL9WkLLOhYh1dTdZGvBz2lL+VXCcds=;
        b=KIZ0+9qwj8ibyR7xlWpwtVw8nSbhoR2MdoOQMtkitEl9hWIBREGmM9pvAE8XYpS5RyWy/s
        dV2TEJ6+ec/xTkUQYRH+B14jUgRjXuWEHe6O67qtu71ce5Qlqy2doKOKOFj6Y+0ivsw6JJ
        KwSlDOR5ioi0Pcnb6HeO71eJrW3EtKo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-7U9ztWpDP-aLhplNYLClgg-1; Mon, 22 Jun 2020 16:16:26 -0400
X-MC-Unique: 7U9ztWpDP-aLhplNYLClgg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8896A8031C2;
        Mon, 22 Jun 2020 20:16:25 +0000 (UTC)
Received: from localhost (ovpn-116-68.gru2.redhat.com [10.97.116.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D02D612BA;
        Mon, 22 Jun 2020 20:16:24 +0000 (UTC)
Date:   Mon, 22 Jun 2020 17:16:23 -0300
From:   Bruno Meneguele <bmeneg@redhat.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        erichte@linux.ibm.com, nayna@linux.ibm.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] ima: move APPRAISE_BOOTPARAM dependency on
 ARCH_POLICY to runtime
Message-ID: <20200622201623.GC8956@glitch>
References: <20200622172754.10763-1-bmeneg@redhat.com>
 <1592854093.4987.15.camel@linux.ibm.com>
MIME-Version: 1.0
In-Reply-To: <1592854093.4987.15.camel@linux.ibm.com>
X-PGP-Key: http://keys.gnupg.net/pks/lookup?op=get&search=0x3823031E4660608D
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kVXhAStRUZ/+rrGn"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--kVXhAStRUZ/+rrGn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 22, 2020 at 03:28:13PM -0400, Mimi Zohar wrote:
> On Mon, 2020-06-22 at 14:27 -0300, Bruno Meneguele wrote:
> > IMA_APPRAISE_BOOTPARAM has been marked as dependent on !IMA_ARCH_POLICY=
 in
> > compile time, enforcing the appraisal whenever the kernel had the arch
> > policy option enabled.
> >=20
> > However it breaks systems where the option is actually set but the syst=
em
> > wasn't booted in a "secure boot" platform. In this scenario, anytime th=
e
> > an appraisal policy (i.e. ima_policy=3Dappraisal_tcb) is used it will b=
e
> > forced, giving no chance to the user set the 'fix' state (ima_appraise=
=3Dfix)
> > to actually measure system's files.
> >=20
> > This patch remove this compile time dependency and move it to a runtime
> > decision, based on the arch policy loading failure/success.
> >=20
> > Cc: stable@vger.kernel.org
> > Fixes: d958083a8f64 ("x86/ima: define arch_get_ima_policy() for x86")
> > Signed-off-by: Bruno Meneguele <bmeneg@redhat.com>
> > ---
> > changes from v1:
> > =09- removed "ima:" prefix from pr_info() message
> >=20
> >  security/integrity/ima/Kconfig      | 2 +-
> >  security/integrity/ima/ima_policy.c | 8 ++++++--
> >  2 files changed, 7 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kc=
onfig
> > index edde88dbe576..62dc11a5af01 100644
> > --- a/security/integrity/ima/Kconfig
> > +++ b/security/integrity/ima/Kconfig
> > @@ -232,7 +232,7 @@ config IMA_APPRAISE_REQUIRE_POLICY_SIGS
> > =20
> >  config IMA_APPRAISE_BOOTPARAM
> >  =09bool "ima_appraise boot parameter"
> > -=09depends on IMA_APPRAISE && !IMA_ARCH_POLICY
> > +=09depends on IMA_APPRAISE
> >  =09default y
> >  =09help
> >  =09  This option enables the different "ima_appraise=3D" modes
> > diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/i=
ma/ima_policy.c
> > index e493063a3c34..c876617d4210 100644
> > --- a/security/integrity/ima/ima_policy.c
> > +++ b/security/integrity/ima/ima_policy.c
> > @@ -733,11 +733,15 @@ void __init ima_init_policy(void)
> >  =09 * (Highest priority)
> >  =09 */
> >  =09arch_entries =3D ima_init_arch_policy();
> > -=09if (!arch_entries)
> > +=09if (!arch_entries) {
> >  =09=09pr_info("No architecture policies found\n");
> > -=09else
> > +=09} else {
> > +=09=09/* Force appraisal, preventing runtime xattr changes */
> > +=09=09pr_info("setting IMA appraisal to enforced\n");
> > +=09=09ima_appraise =3D IMA_APPRAISE_ENFORCE;
> >  =09=09add_rules(arch_policy_entry, arch_entries,
> >  =09=09=09  IMA_DEFAULT_POLICY | IMA_CUSTOM_POLICY);
> > +=09}
> > =20
> >  =09/*
> >  =09 * Insert the builtin "secure_boot" policy rules requiring file
>=20
> CONFIG_IMA_APPRAISE_BOOTPARAM controls the "ima_appraise" mode bits. =A0
> The mode bits are or'ed with the MODULES, FIRMWARE, POLICY, and KEXEC
> bits, which have already been set in ima_init_arch_policy().
>=20

Sorry for missing this part! Of course I should've spoted that just my
following ima_appraise down the code.

> From ima.h:
> /* Appraise integrity measurements */
> #define IMA_APPRAISE_ENFORCE=A0=A0=A0=A00x01
> #define IMA_APPRAISE_FIX=A0=A0=A0=A0=A0=A0=A0=A00x02
> #define IMA_APPRAISE_LOG=A0=A0=A0=A0=A0=A0=A0=A00x04
> #define IMA_APPRAISE_MODULES=A0=A0=A0=A00x08
> #define IMA_APPRAISE_FIRMWARE=A0=A0=A00x10
> #define IMA_APPRAISE_POLICY=A0=A0=A0=A0=A00x20
> #define IMA_APPRAISE_KEXEC=A0=A0=A0=A0=A0=A00x40
>=20
> As Nayna pointed out, only when an architecture specific "secure boot"
> policy is loaded, is this applicable.=A0

Yes, will come up with patch covering only this case.

Thanks Mimi!

--=20
bmeneg=20
PGP Key: http://bmeneg.com/pubkey.txt

--kVXhAStRUZ/+rrGn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEdWo6nTbnZdbDmXutYdRkFR+RokMFAl7xEZcACgkQYdRkFR+R
okNwiwgAo2KRQCaFz9KPkrZ0oX0jhJCP5XzSAfzAZUjcBvxXrHDQ4LDkM/610jGO
phzTOE9Ij7YbyiVArsoQT+5LgpFfj8BON4NcUcJvb5IS4m8pBzmEkfGlewCQK78G
LFpOw+BCosN5L6xyovp0kjIvM2yZ8cPkv1vPjnDgmgWHz664qtrXgJ+vMW/ZCp5b
uUps/GyhGwNtVSV9cAooI9tgUJ+Pv23TsvBWeILYPaE0KvIN1cgRyooZF+oIhqgJ
iCx0jhzgS7HeNi8TtpKVnjHdIiofR4OJdwnLngG7/B3a9HNLZA2H7beCagXtp+6/
klHILxuaKmxJQIXCbX11RDpXb4El8A==
=NxjM
-----END PGP SIGNATURE-----

--kVXhAStRUZ/+rrGn--

