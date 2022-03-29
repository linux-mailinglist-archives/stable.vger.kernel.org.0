Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355AA4EB100
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 17:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238537AbiC2Pvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 11:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239006AbiC2Pvt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 11:51:49 -0400
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F13385BD5;
        Tue, 29 Mar 2022 08:50:07 -0700 (PDT)
Received: from imladris.surriel.com ([96.67.55.152])
        by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <riel@shelob.surriel.com>)
        id 1nZE6V-0004sG-4e; Tue, 29 Mar 2022 11:49:55 -0400
Message-ID: <47936edb3b0f9c9f04f0d0d2e7f38383a22b6a3d.camel@surriel.com>
Subject: Re: [PATCH] mm,hwpoison: unmap poisoned page before invalidation
From:   Rik van Riel <riel@surriel.com>
To:     Oscar Salvador <osalvador@suse.de>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kernel-team@fb.com, Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Date:   Tue, 29 Mar 2022 11:49:53 -0400
In-Reply-To: <YkF5Jd6fauTRvVVg@localhost.localdomain>
References: <20220325161428.5068d97e@imladris.surriel.com>
         <YkF5Jd6fauTRvVVg@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-1nbVtLEU+9mQSE0QbNkg"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Sender: riel@shelob.surriel.com
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-1nbVtLEU+9mQSE0QbNkg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2022-03-28 at 11:00 +0200, Oscar Salvador wrote:
> On Fri, Mar 25, 2022 at 04:14:28PM -0400, Rik van Riel wrote:
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (in=
validate_inode_page(page))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0poisonret =3D VM_FAULT_NOPAGE;
>=20
> What is the effect of returning VM_FAULT_NOPAGE?
> I take that we are cool because the pte has been installed and points
> to
> a new page? (I could not find where that is being done).
>=20
It results in us returning to userspace as if the page
fault had been handled, resulting in a second fault on
the same address.

However, now the page is no longer in the page cache,
and we can read it in from disk, to a page that is not
hardware poisoned, and we can then use that second page
without issues.

--=20
All Rights Reversed.

--=-1nbVtLEU+9mQSE0QbNkg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEKR73pCCtJ5Xj3yADznnekoTE3oMFAmJDKqEACgkQznnekoTE
3oPaQwgAjpAAjbiuOWl9S6LuGLV7gTR6piiEa7NFUs+d/D8ndjxb0ImtJrHrTF4b
3YO9bln7laVN1+jACN/9FfGQh7YobgviPQ3HJc0bkdxHC1eMrwIEA3n02e1RaZ6Z
x5Z14n2+DretUQs8O9CFDR5ioV36yWFpe0VKFlcMik20SDdaE3pbATgHvCnXb8nl
NOJcnP95djsEgLMSmSFlBE2EpEF9e1MyYfHF1RVqnNm4KljTEjCouPbiuBU/y/kR
5Wsc8fVZaDSVNKFVM4GCdzBqziwCdYsAaPemPMTO5D9jWrA6f1wudmIKNiO6B1+X
KE2keqO/4AXE0JZc/m+f4157Owu0dA==
=9sBD
-----END PGP SIGNATURE-----

--=-1nbVtLEU+9mQSE0QbNkg--
