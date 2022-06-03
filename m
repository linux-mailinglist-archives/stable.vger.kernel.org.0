Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98AC953C89F
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 12:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239109AbiFCK2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 06:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237693AbiFCK2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 06:28:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BB5E01E;
        Fri,  3 Jun 2022 03:28:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A718C60C8C;
        Fri,  3 Jun 2022 10:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19D1C385A9;
        Fri,  3 Jun 2022 10:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654252089;
        bh=hZ5cSwyo7EzHMEbyT4ghAzT5Uo6NhCs7zRE3Q+mOoHA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sGYVoWmDur/WytEsZLyZOXTpZDnKsTCPjRSA3X3MABPU2G3ZuUJhjuF5Sss0XT0tv
         SpXFdH1w/NgmGX5ICFTumTPXFKmAqOXvFUPCj6voDq4Ux4eFlP0zqdOM7jq1QB72SD
         Xta+NHZAMG8SCY6Vp/KAiUJNImWQKHr3PB0fkuRmn8mFIf1apLlB+PuA8vV3Py5joX
         8b1ku6PzU1t+P0SC4C1oFykm56lPu+JIU4M7OEwwLNX3Ll74W7J3bDIVsSbZkBf2B/
         WjYy20I57Vb+kYsxvP7Pptsq3O1ytiEm1AGWWAD6q0JVXecGEWQ2A6q4jhqwqp49yf
         Ee0KoffGrfjSA==
Date:   Fri, 3 Jun 2022 12:28:06 +0200
From:   Mark Brown <broonie@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        theflamefire89@gmail.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 34/48] ASoC: ops: Reject out of bounds values in
 snd_soc_put_volsw_sx()
Message-ID: <YpniNuBDbv/RRY/2@sirena.org.uk>
References: <20220207103752.341184175@linuxfoundation.org>
 <20220207103753.450763414@linuxfoundation.org>
 <20220603100613.GA26825@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ZJvHfhMxfZ0Ue3YX"
Content-Disposition: inline
In-Reply-To: <20220603100613.GA26825@duo.ucw.cz>
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


--ZJvHfhMxfZ0Ue3YX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 03, 2022 at 12:06:13PM +0200, Pavel Machek wrote:

> We are getting reports that this commit breaks audio on some
> phones... and indeed it looks like "+ min" is missing in first condition:

> https://github.com/baunilla/android_kernel_xiaomi_rosy/commit/969b9d366c1=
e9564e173aea325ec544dcd7804ff

> 	val =3D ucontrol->value.integer.value[0];
> -=EF=BF=BC	if (mc->platform_max && val > mc->platform_max)
> +=EF=BF=BC	if (mc->platform_max && ((int)val + min) > mc->platform_max)
> =EF=BF=BC		return -EINVAL;

> What needs to be done to get this fixed?

The downstream kernel platform_max configuration should really be
using the user visible value, not a direct register value.  Note
that some of the Qualcomm vendor trees have modifictions to the
semantics of some of the controls which cause issues, and partly
due to this confusion there should be some fixes for their
upstream drivers coming soon.

--ZJvHfhMxfZ0Ue3YX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmKZ4jYACgkQJNaLcl1U
h9CkYQf/b0ZSozDl7hMZY7oH/qdRK7mLBPjQiF/bXToFEqAI4NTsylsVqfzjjuGe
tL+aOQsDxIgWT60U5Q3CXBpTfZbVQkC6IvahCNc4rIrna8QFdIIKr0spxqj0Rsqj
SZXXP9rrDzNVrxrR6o2X5ot8dc3y+OG88YrNmbY7J9o4SFbwEkp2cf4456GNemrB
7DDCosap+5bi4SmPuH3jH4Yh4ma9IEGWsVXOdN3qTB4hmytFQXZI8lLLXtcPMoHK
uxSiR2MvgTNa24TkfhZtjY1iVQLF/Ys7KAcNVDXj31StkGfBNMBixo/S1UGhMVmX
h05BHpJEqiS3l9sWdYofqAB2mx/2yA==
=LPQb
-----END PGP SIGNATURE-----

--ZJvHfhMxfZ0Ue3YX--
