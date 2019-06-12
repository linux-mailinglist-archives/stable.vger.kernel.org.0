Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A20C41D7B
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 09:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbfFLHTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 03:19:22 -0400
Received: from mx1.emlix.com ([188.40.240.192]:34610 "EHLO mx1.emlix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727188AbfFLHTW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jun 2019 03:19:22 -0400
Received: from mailer.emlix.com (unknown [81.20.119.6])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.emlix.com (Postfix) with ESMTPS id EE5CF605E6;
        Wed, 12 Jun 2019 09:19:19 +0200 (CEST)
From:   Rolf Eike Beer <eb@emlix.com>
To:     Greg KH <greg@kroah.com>
Cc:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        stable@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 4.9.180 build fails with gcc 9 and 'cleanup_module' specifies less restrictive attribute than its target =?UTF-8?B?4oCm?=
Date:   Wed, 12 Jun 2019 09:19:15 +0200
Message-ID: <3659495.RxnUGBN4mp@devpool35>
Organization: emlix GmbH
In-Reply-To: <20190606185900.GA19937@kroah.com>
References: <259986242.BvXPX32bHu@devpool35> <CANiq72nfFqYkiYgKJ1UZV3Mx2C3wzu_7TRtXFn=iafNt+Oc_2g@mail.gmail.com> <20190606185900.GA19937@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3801749.mJlyZb5Pfn"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--nextPart3801749.mJlyZb5Pfn
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Am Donnerstag, 6. Juni 2019, 20:59:00 CEST schrieb Greg KH:
> On Thu, Jun 06, 2019 at 08:25:28PM +0200, Miguel Ojeda wrote:
> > On Thu, Jun 6, 2019 at 5:29 PM Greg KH <greg@kroah.com> wrote:
> > > And if you want this, you should look at how the backports to 4.14.y
> > > worked, they did not include a3f8a30f3f00 ("Compiler Attributes: use
> > > feature checks instead of version checks"), as that gets really messy=
=2E..
> >=20
> > I am confused -- I interpreted Rolf's message as reporting that he
> > already successfully built 4.9 by applying a6e60d84989f
> > ("include/linux/module.h: copy __init/__exit attrs to
> > init/cleanup_module") and manually fixing it up. But maybe I am
> > completely wrong... :-)
>=20
> "manually fixing it up" means "hacked it to pieces" to me, I have no
> idea what the end result really was :)
>=20
> If someone wants to send me some patches I can actually apply, that
> would be best...

Hi all,

the patch I actually used was this:

diff --git a/include/linux/module.h b/include/linux/module.h
index 8fa38d3e7538..f5bc4c046461 100644
=2D-- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -129,13 +129,13 @@ extern void cleanup_module(void);
 #define module_init(initfn)					\
 	static inline initcall_t __maybe_unused __inittest(void)		\
 	{ return initfn; }					\
=2D	int init_module(void) __attribute__((alias(#initfn)));
+	int init_module(void) __attribute__((__copy__(initfn))) __attribute__((al=
ias(#initfn)));
=20
 /* This is only required if you want to be unloadable. */
 #define module_exit(exitfn)					\
 	static inline exitcall_t __maybe_unused __exittest(void)		\
 	{ return exitfn; }					\
=2D	void cleanup_module(void) __attribute__((alias(#exitfn)));
+	void cleanup_module(void) __attribute__((__copy__(exitfn))) __attribute__=
((alias(#exitfn)));
=20
 #endif
=20

So the final question is: do we want 4.9.x to be buildable with gcc 9.x? If
yes then we can probably get this patches into shape.

Eike
=2D-=20
Rolf Eike Beer, emlix GmbH, http://www.emlix.com
=46on +49 551 30664-0, Fax +49 551 30664-11
Gothaer Platz 3, 37083 G=C3=B6ttingen, Germany
Sitz der Gesellschaft: G=C3=B6ttingen, Amtsgericht G=C3=B6ttingen HR B 3160
Gesch=C3=A4ftsf=C3=BChrung: Heike Jordan, Dr. Uwe Kracke =E2=80=93 Ust-IdNr=
=2E: DE 205 198 055

emlix - smart embedded open source
--nextPart3801749.mJlyZb5Pfn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iLMEAAEIAB0WIQQ/Uctzh31xzAxFCLur5FH7Xu2t/AUCXQCncwAKCRCr5FH7Xu2t
/GYfA/9u1Sycs/vlm097vxGuaqNV/WnJzpTcgHbwSLP0MjrOM8D8YY/MjPqNe4qg
mmzWkA4m6dZMjposXkBnaUaOOXyBtDBy/K80Rg6YkBNYT4Ew3OD8Bq4rfsXcDv/5
IQVY0AcGL56RYH6c/bdYMH5q48mUXDNtrkypXEy7pvRQPVTQtw==
=aDR5
-----END PGP SIGNATURE-----

--nextPart3801749.mJlyZb5Pfn--



