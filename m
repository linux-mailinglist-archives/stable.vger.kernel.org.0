Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA8253D677
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 12:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbiFDKyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 06:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbiFDKyY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 06:54:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35DA1BEBE;
        Sat,  4 Jun 2022 03:54:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8A1EBCE1B5F;
        Sat,  4 Jun 2022 10:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1B7C385B8;
        Sat,  4 Jun 2022 10:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654340059;
        bh=XSgAT6Qa746JkUKZu2WdrPZufNxuTdOO5FZEJqdOtTE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GndVuzkhMIP8Zx5VWYyyDFT5i4CWNbs41+omM2P6aXnMylnnHAA7x+OKXHK69de7n
         rq64PaZtdpvkTAtmYddS7q3/fnxgTqPlZfYPcM0cy4/apq8+oClpac8JET508XleWg
         Tx5m5qIVNkryaBkXmTSjua8Q0XUFBv5OvkodzfEwTgOmn4J/bwsbcVZWkBcrXOjNGg
         Ul6CHBW9JWlAHCrQFUdGdYRppreKKud8qSLBVcEtvgjRR0NsR193LLHCXp6AwZyUck
         4jLj18gnGijLv4AoyW1/WkIQi2AgBvecqHNUPmk3fsixPUEtD6pN7mKNRHslR1xdbD
         xs+JMaCa/Wf2w==
Date:   Sat, 4 Jun 2022 11:54:16 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        theflamefire89@gmail.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 34/48] ASoC: ops: Reject out of bounds values in
 snd_soc_put_volsw_sx()
Message-ID: <Yps52Chdx5AvSgTp@sirena.org.uk>
References: <20220207103752.341184175@linuxfoundation.org>
 <20220207103753.450763414@linuxfoundation.org>
 <20220603100613.GA26825@duo.ucw.cz>
 <YpniNuBDbv/RRY/2@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6Hgaug9cUcpOsW/z"
Content-Disposition: inline
In-Reply-To: <YpniNuBDbv/RRY/2@sirena.org.uk>
X-Cookie: May your camel be as swift as the wind.
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6Hgaug9cUcpOsW/z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 03, 2022 at 12:28:09PM +0200, Mark Brown wrote:
> On Fri, Jun 03, 2022 at 12:06:13PM +0200, Pavel Machek wrote:
>=20
> > We are getting reports that this commit breaks audio on some
> > phones... and indeed it looks like "+ min" is missing in first conditio=
n:
>=20
> > https://github.com/baunilla/android_kernel_xiaomi_rosy/commit/969b9d366=
c1e9564e173aea325ec544dcd7804ff
>=20
> > 	val =3D ucontrol->value.integer.value[0];
> > -=EF=BF=BC	if (mc->platform_max && val > mc->platform_max)
> > +=EF=BF=BC	if (mc->platform_max && ((int)val + min) > mc->platform_max)
> > =EF=BF=BC		return -EINVAL;
>=20
> > What needs to be done to get this fixed?
>=20
> The downstream kernel platform_max configuration should really be
> using the user visible value, not a direct register value.  Note
> that some of the Qualcomm vendor trees have modifictions to the
> semantics of some of the controls which cause issues, and partly
> due to this confusion there should be some fixes for their
> upstream drivers coming soon.

Actually potentially we want to revert the handling of
platform_max only.  Do we know where these systems are getting
their platform_max values from (a machine driver or sometehing
else?)?  Sadly these controls were not even self consistent so
it's not clear which behaviour to fix, though fortunately it's
all in the areas where the userspaces were out of spec trying to
use the behaviour.

--6Hgaug9cUcpOsW/z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmKbOdcACgkQJNaLcl1U
h9CsVAf+JZrYZvdulmEEZZZFwGh5DjJudgTO4yLWYZxHvtbzWg0Q2AswpUL9SP8j
4GvcI/1jkY+lX2JI7aCAaJNVI4Gef6ehHt4rZ0xElmRwzSD0wP2AkNILfbtfHvOb
W2ZsCm02RlIX7s9HgC4KoUc+ag7ENVv2w8XIxosk1DMFJoT1tfSKw5wV7dZcfGI+
p3Vo5RGxknV3YKf1pcKtPdlDaesFQMs6Z9y1cxRf81cys0w8SYW/B1wMZSbsnaU4
BHWrjphZLxGEBZULVdo5/aGvQY+KaURsCmceGpoIkavg6ZfvqgiccLf55kOFavpf
+jByv2+bLIjdIegZfOcxa9+DXxahNA==
=9kY7
-----END PGP SIGNATURE-----

--6Hgaug9cUcpOsW/z--
