Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E39C224340
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 20:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgGQSkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 14:40:40 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38876 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726322AbgGQSkk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jul 2020 14:40:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595011238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=loX3iNxnC34Mh5q85vIpxAcyIoCVZ/OKd+6NErIYBZY=;
        b=JqPzvek+qOFhJdQB8xPRPZt9nLyEh5Y+5zKhz8sTF0G+ELmIDzK/L7oHWv9hDKaP/MxA87
        fjI4Tv1pbYonbnepDW5qZceionBOlup4Hq/KMzRiJQPhMj+g8/ocer9mJeQ5Th75zW97nf
        M28ELb1IaImyvVNAK1Cj+Mh8BoPaL4c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-9d_YNwHZM0KEqKVjKlTnUQ-1; Fri, 17 Jul 2020 14:40:23 -0400
X-MC-Unique: 9d_YNwHZM0KEqKVjKlTnUQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 535D5800468;
        Fri, 17 Jul 2020 18:40:21 +0000 (UTC)
Received: from localhost (ovpn-116-105.gru2.redhat.com [10.97.116.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 83F0760E3E;
        Fri, 17 Jul 2020 18:40:20 +0000 (UTC)
Date:   Fri, 17 Jul 2020 15:40:19 -0300
From:   Bruno Meneguele <bmeneg@redhat.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-integrity@vger.kernel.org
Cc:     zohar@linux.ibm.com, erichte@linux.ibm.com, nayna@linux.ibm.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v6] ima: move APPRAISE_BOOTPARAM dependency on
 ARCH_POLICY to runtime
Message-ID: <20200717184019.GI2984@glitch>
References: <20200713164830.101165-1-bmeneg@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20200713164830.101165-1-bmeneg@redhat.com>
X-PGP-Key: http://keys.gnupg.net/pks/lookup?op=get&search=0x3823031E4660608D
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xQR6quUbZ63TTuTU"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--xQR6quUbZ63TTuTU
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 13, 2020 at 01:48:30PM -0300, Bruno Meneguele wrote:
> The IMA_APPRAISE_BOOTPARAM config allows enabling different "ima_appraise=
=3D"
> modes - log, fix, enforce - at run time, but not when IMA architecture
> specific policies are enabled. =A0This prevents properly labeling the
> filesystem on systems where secure boot is supported, but not enabled on =
the
> platform. =A0Only when secure boot is actually enabled should these IMA
> appraise modes be disabled.
>=20
> This patch removes the compile time dependency and makes it a runtime
> decision, based on the secure boot state of that platform.
>=20
> Test results as follows:
>=20
> -> x86-64 with secure boot enabled
>=20
> [    0.015637] Kernel command line: <...> ima_policy=3Dappraise_tcb ima_a=
ppraise=3Dfix
> [    0.015668] ima: Secure boot enabled: ignoring ima_appraise=3Dfix boot=
 parameter option
>=20
> -> powerpc with secure boot disabled
>=20
> [    0.000000] Kernel command line: <...> ima_policy=3Dappraise_tcb ima_a=
ppraise=3Dfix
> [    0.000000] Secure boot mode disabled
>=20
> -> Running the system without secure boot and with both options set:
>=20
> CONFIG_IMA_APPRAISE_BOOTPARAM=3Dy
> CONFIG_IMA_ARCH_POLICY=3Dy
>=20
> Audit prompts "missing-hash" but still allow execution and, consequently,
> filesystem labeling:
>=20
> type=3DINTEGRITY_DATA msg=3Daudit(07/09/2020 12:30:27.778:1691) : pid=3D4=
976
> uid=3Droot auid=3Droot ses=3D2
> subj=3Dunconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 op=3Dapprais=
e_data
> cause=3Dmissing-hash comm=3Dbash name=3D/usr/bin/evmctl dev=3D"dm-0" ino=
=3D493150
> res=3Dno
>=20
> Cc: stable@vger.kernel.org
> Fixes: d958083a8f64 ("x86/ima: define arch_get_ima_policy() for x86")
> Signed-off-by: Bruno Meneguele <bmeneg@redhat.com>
> ---
> v6:
>   - explictly print the bootparam being ignored to the user (Mimi)
> v5:
>   - add pr_info() to inform user the ima_appraise=3D boot param is being
> =09ignored due to secure boot enabled (Nayna)
>   - add some testing results to commit log
> v4:
>   - instead of change arch_policy loading code, check secure boot state a=
t
> =09"ima_appraise=3D" parameter handler (Mimi)
> v3:
>   - extend secure boot arch checker to also consider trusted boot
>   - enforce IMA appraisal when secure boot is effectively enabled (Nayna)
>   - fix ima_appraise flag assignment by or'ing it (Mimi)
> v2:
>   - pr_info() message prefix correction
>  security/integrity/ima/Kconfig        | 2 +-
>  security/integrity/ima/ima_appraise.c | 6 ++++++
>  2 files changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kcon=
fig
> index edde88dbe576..62dc11a5af01 100644
> --- a/security/integrity/ima/Kconfig
> +++ b/security/integrity/ima/Kconfig
> @@ -232,7 +232,7 @@ config IMA_APPRAISE_REQUIRE_POLICY_SIGS
> =20
>  config IMA_APPRAISE_BOOTPARAM
>  =09bool "ima_appraise boot parameter"
> -=09depends on IMA_APPRAISE && !IMA_ARCH_POLICY
> +=09depends on IMA_APPRAISE
>  =09default y
>  =09help
>  =09  This option enables the different "ima_appraise=3D" modes
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/i=
ma/ima_appraise.c
> index a9649b04b9f1..28a59508c6bd 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -19,6 +19,12 @@
>  static int __init default_appraise_setup(char *str)
>  {
>  #ifdef CONFIG_IMA_APPRAISE_BOOTPARAM
> +=09if (arch_ima_get_secureboot()) {
> +=09=09pr_info("Secure boot enabled: ignoring ima_appraise=3D%s boot para=
meter option",
> +=09=09=09str);
> +=09=09return 1;
> +=09}
> +
>  =09if (strncmp(str, "off", 3) =3D=3D 0)
>  =09=09ima_appraise =3D 0;
>  =09else if (strncmp(str, "log", 3) =3D=3D 0)
> --=20
> 2.26.2
>=20

Ping for review.

Many thanks.

--=20
bmeneg=20
PGP Key: http://bmeneg.com/pubkey.txt

--xQR6quUbZ63TTuTU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEdWo6nTbnZdbDmXutYdRkFR+RokMFAl8R8JMACgkQYdRkFR+R
okMiPAf+Lawa+3mJ/dDC1Np/eBpA/UCMscxAKYRNlkGVChCpXeeXX1JV4M4CKHzu
bmfws9NGfx4kw++hn8IeF86ypV3XhdKQyz7zQ6L4Rgmv08a/AE1msMRwwSMky9li
n/Mh5HcYsfnLmGrLrSYjR/PTNqmz0WPgRCOSpFaTRcqTVKkUMJ8m83cwTe/5Avm9
SmUyq80QY4AV4bJcedr1U+Ror8it5dHdtgy5bz0TPepRnhk/lE7Ro+mZE0e8N0R+
3BiyCiYhUMD7E5LODlnMAWvbd/vEf3I0a0rYuQmxcauXs8HVI6j42A9Tmc/7PcDG
EGRCFOvOOkQz6WddH1svTgptnLyGsA==
=Ggbe
-----END PGP SIGNATURE-----

--xQR6quUbZ63TTuTU--

