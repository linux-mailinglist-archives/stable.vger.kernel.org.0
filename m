Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E916129F03D
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 16:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgJ2Pj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 11:39:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:35650 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728420AbgJ2Pj0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Oct 2020 11:39:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1603985963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=47PdL2vSj8GaMm5B9GKdrojmHctd//BKwcYIBTeFsLk=;
        b=YrtUPBFel0gpSL/B9Cq1VE4szKaFL/c7muxY+vXdCyqmnWirrHHFD8voW9YVCFALDh42N7
        FrsejlmMaWqoKREhTxj3cMwKr8uplenuXhdRmasBJSckkc6v4Mdb2l7iv9TQFfq/LPL7Di
        elDFxV6HjAYRIpGwvtw64P7iOdsupLQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9FCA0AC6A;
        Thu, 29 Oct 2020 15:39:23 +0000 (UTC)
Date:   Thu, 29 Oct 2020 16:39:21 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Roman Gushchin <guro@fb.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kernel-team@fb.com, ltp@lists.linux.it,
        Richard Palethorpe <rpalethorpe@suse.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: memcg: link page counters to root if
 use_hierarchy is false
Message-ID: <20201029153921.GC9928@blackbook>
References: <20201026231326.3212225-1-guro@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2/5bycvrmDh4d1IB"
Content-Disposition: inline
In-Reply-To: <20201026231326.3212225-1-guro@fb.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--2/5bycvrmDh4d1IB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi.

On Mon, Oct 26, 2020 at 04:13:26PM -0700, Roman Gushchin <guro@fb.com> wrot=
e:
> Please note, that in the non-hierarchical mode all objcgs are always
> reparented to the root memory cgroup, even if the hierarchy has more
> than 1 level. This patch doesn't change it.
>=20
> The patch also doesn't affect how the hierarchical mode is working,
> which is the only sane and truly supported mode now.
I agree with the patch and you can add
Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>

However, it effectively switches any users of root.use_hierarchy=3D0 (if th=
ere
are any, watching the counters of root memcg) into root.use_hierarchy=3D1.
So I'd show them the warning even with a single level of cgroups, i.e.
add this hunk

@@ -5356,12 +5356,11 @@
 		page_counter_init(&memcg->kmem, &root_mem_cgroup->kmem);
 		page_counter_init(&memcg->tcpmem, &root_mem_cgroup->tcpmem);
 		/*
-		 * Deeper hierachy with use_hierarchy =3D=3D false doesn't make
+		 * Hierachy with use_hierarchy =3D=3D false doesn't make
 		 * much sense so let cgroup subsystem know about this
 		 * unfortunate state in our controller.
 		 */
-		if (parent !=3D root_mem_cgroup)
-			memory_cgrp_subsys.broken_hierarchy =3D true;
+		memory_cgrp_subsys.broken_hierarchy =3D true;
 	}
=20
 	/* The following stuff does not apply to the root */

What do you think?

Michal

--2/5bycvrmDh4d1IB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAl+a4iEACgkQia1+riC5
qShc2RAAmjtCmuIa3ZwnDGZzw0oV6CtPxW9sj6/KFmioBPpQRrUGlRnoSN5jqyT2
yEMHbsSKl/TE0f/avpNQNNeEvqkdoUFdl89eSCh2Fwt90S8GgDyJZcOnWxTMc3pg
unhhXqB1xoD2qPmIRY31jf9j1za/d4OfDdJK0jUrgLhClnos9eF5i0IKwIaAY79f
VIeyWDuEMe/CE6LVBiomObarQK7PUETE2jfYcXAdBzEKfudbINDE4yeV+DzJ4ZlK
bv61oAW+0D0oJTP+V9JCXORfgLgnNObNCP1BBcayhl1bfQQ5bGbuipDYJAriL7Ce
OYjUC8H3VEfBcALEsZjFmxWRNJkYxupjIeX1CjaRncBmXC4uuFrEKdwsdRWeIiW0
FyvzuDUi0LiTd7lPN9R0yWehwoqGvb1ES0l2X3XGzTzXprZPTOgLNz+MyXfn4x1d
QqiP27paN+TGgW/Oa1846nwKTgwG35RAvxuheP2ZcyYGbcEJOKx1stld1EuSOGob
JINTltj2rwk/yHO4XVz5ptyOG/HAfokyPwGTiC+bJrl8ipmueFkq/mEYYsUVrmbD
TtQXNjSB1EW6cS07aAw9mEj6XnJ7B9NJY2MSKv895wXDNelXmC+dYeTJQED9vVIP
yPyo/1wcbERct2ojN4BYFNYW/66EfGoFnFowOAsaCMSBjZPh4x4=
=I9HI
-----END PGP SIGNATURE-----

--2/5bycvrmDh4d1IB--
