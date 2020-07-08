Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC935218952
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 15:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbgGHNjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 09:39:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43611 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729741AbgGHNju (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 09:39:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594215589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Whg0V+e+iLanotPtqCQ8xZyauguWHsR7nTJtmfu3D5w=;
        b=JyViYo1afE3NSkHRtjnf+Zt7hN/CYCGUZ7VUU2H7eW0iy0ZWLeyVNWW3WrNnyqDNWsa4Fo
        Q+D+bHdQkkZem4v2ZotJ3D39TCH5kFsFFQsRSyJdpvmsIHygCkcnLZ7bnk2WWz7VktP7+n
        GHSXBLVGJR9FZt7lvXjmSdWVgtwCwVU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-0kgb-8tfNySqU4jQzYne5A-1; Wed, 08 Jul 2020 09:39:44 -0400
X-MC-Unique: 0kgb-8tfNySqU4jQzYne5A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C55080BCA8;
        Wed,  8 Jul 2020 13:39:43 +0000 (UTC)
Received: from localhost (ovpn-116-140.gru2.redhat.com [10.97.116.140])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDE4178485;
        Wed,  8 Jul 2020 13:39:42 +0000 (UTC)
Date:   Wed, 8 Jul 2020 10:39:41 -0300
From:   Bruno Meneguele <bmeneg@redhat.com>
To:     Nayna <nayna@linux.vnet.ibm.com>
Cc:     linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.ibm.com, erichte@linux.ibm.com, nayna@linux.ibm.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v4] ima: move APPRAISE_BOOTPARAM dependency on
 ARCH_POLICY to runtime
Message-ID: <20200708133941.GA2651@glitch>
References: <20200703180049.15608-1-bmeneg@redhat.com>
 <91a81761-1490-7250-8245-4d78d190385f@linux.vnet.ibm.com>
MIME-Version: 1.0
In-Reply-To: <91a81761-1490-7250-8245-4d78d190385f@linux.vnet.ibm.com>
X-PGP-Key: http://keys.gnupg.net/pks/lookup?op=get&search=0x3823031E4660608D
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=bmeneg@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 07, 2020 at 07:56:37PM -0400, Nayna wrote:
>=20
> On 7/3/20 2:00 PM, Bruno Meneguele wrote:
> > APPRAISE_BOOTPARAM has been marked as dependent on !ARCH_POLICY in comp=
ile
> > time, enforcing the appraisal whenever the kernel had the arch policy o=
ption
> > enabled.
> >=20
> > However it breaks systems where the option is set but the system wasn't
> > booted in a "secure boot" platform. In this scenario, anytime an apprai=
sal
> > policy (i.e. ima_policy=3Dappraisal_tcb) is used it will be forced, giv=
ing no
> > chance to the user set the 'fix' state (ima_appraise=3Dfix) to actually
> > measure system's files.
>=20
> "measure" is incorrect. It is appraisal.
>=20

Yes, of course, sorry.

> How about changing the statement to "without giving the user the opportun=
ity
> to label the filesystem, before enforcing integrity." ?
>=20

Ack.
That's better :)

> > diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity=
/ima/ima_appraise.c
> > index a9649b04b9f1..4fc83b3fbd5c 100644
> > --- a/security/integrity/ima/ima_appraise.c
> > +++ b/security/integrity/ima/ima_appraise.c
> > @@ -18,14 +18,16 @@
> >   static int __init default_appraise_setup(char *str)
> >   {
> > -#ifdef CONFIG_IMA_APPRAISE_BOOTPARAM
> > -=09if (strncmp(str, "off", 3) =3D=3D 0)
> > -=09=09ima_appraise =3D 0;
> > -=09else if (strncmp(str, "log", 3) =3D=3D 0)
> > -=09=09ima_appraise =3D IMA_APPRAISE_LOG;
> > -=09else if (strncmp(str, "fix", 3) =3D=3D 0)
> > -=09=09ima_appraise =3D IMA_APPRAISE_FIX;
> > -#endif
> > +=09if (IS_ENABLED(CONFIG_IMA_APPRAISE_BOOTPARAM) &&
> > +=09    !arch_ima_get_secureboot()) {
> > +=09=09if (strncmp(str, "off", 3) =3D=3D 0)
> > +=09=09=09ima_appraise =3D 0;
> > +=09=09else if (strncmp(str, "log", 3) =3D=3D 0)
> > +=09=09=09ima_appraise =3D IMA_APPRAISE_LOG;
> > +=09=09else if (strncmp(str, "fix", 3) =3D=3D 0)
> > +=09=09=09ima_appraise =3D IMA_APPRAISE_FIX;
> > +=09}
> > +
> >   =09return 1;
> >   }
>=20
> If secureboot is enabled, it is silently ignoring the boot parameters. It
> would be helpful if there is a log message notifying user about that.
>=20
> Can you please Cc powerpc, s390, and x86 mailing list and maintainers, wh=
en
> you post the next version ?
>=20
> I would try to test it sometime in this week.
>=20

Sure. I'm preparing a new version and will post soon.

> Thanks & Regards,
>=20

Thank you.

--=20
bmeneg=20
PGP Key: http://bmeneg.com/pubkey.txt

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEdWo6nTbnZdbDmXutYdRkFR+RokMFAl8FzJ0ACgkQYdRkFR+R
okMq6Af8C2ESthjH/+dcvYY/UHC/wi1UDnVP+n25pPQ5U7Is2K0Xo4Q8wUhBfxVM
+lcoVTkmqED/SVLlqXsStb9y3Qk8HDvlC3LRYfdkD2w7bdIpMkuBB6Ba5MbsPRr+
NTnIwGC082mwafFxrC3ISUcJ/lOWx1vrUETPttd6evuG3b2ogGI7iEHYntCifAhv
GPIbKhJaAdyoJx2ynldpYCPYcKwN/4uv6XrOfiwmrGPYbjBqssqqyuqly4wu2s66
bwmLQtiaCZb88TMVhAXkN4DAJirijPDAEGgt+VrKbpgsBrbTidFAfDoYO+ASf5qQ
QqI7/t89XIw5EHNNfgkAQxJKcxoaWw==
=jY7V
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--

