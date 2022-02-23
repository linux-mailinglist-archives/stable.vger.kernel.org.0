Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F41D74C189C
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 17:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbiBWQdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 11:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242829AbiBWQc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 11:32:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C33B4F47B
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 08:32:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86C3DB820CB
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 16:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A7FC340EB;
        Wed, 23 Feb 2022 16:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645633944;
        bh=kkXDWw5Ws312JHgwMVFdyKq3XYsYFAROXJIkaljA6c0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hd5lBxoWASm7C9idlzoTFALSV/KdcWeDEC7fY8oz2NFtEkgUr4INWDQNUk8FnTmML
         pKaYdhd8Os/QxmUZ9nJXx6UxP44hX8FkfbJn82GdGILGPtD2BMXoC9uxLZaLDHjRGT
         QdLICOzUQuOn2xBogLZQeUW4OdfuY9Af9G919hHig3I0ssGmxHsj2o/RlwN+4RPwAu
         /akVavXXDxaAdRUEfoIm+djBPW5Z5X0EiMc+Ns84wRFT3sLsFocMleGTtTq/Mof2j4
         yOfRzimHSdfKCe1KWMqjpgzBIteFojeW0BHGgvEWsaPx/obP+qSCeQ8DkPrErSiG3q
         tcbnSuY8ghHtw==
Date:   Wed, 23 Feb 2022 16:32:19 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Marek Vasut <marex@denx.de>, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ASoC: ops: Shift tested values in snd_soc_put_volsw() by
 +min
Message-ID: <YhZhkz6gQYsK3Fwd@sirena.org.uk>
References: <20220215130645.164025-1-marex@denx.de>
 <s5hy221y6md.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="K4+LhN6i3Z7XS3AP"
Content-Disposition: inline
In-Reply-To: <s5hy221y6md.wl-tiwai@suse.de>
X-Cookie: I smell a wumpus.
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--K4+LhN6i3Z7XS3AP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 23, 2022 at 03:55:54PM +0100, Takashi Iwai wrote:
>=20
> But, more reading the code, I suspect whether the function does work
> correctly at all...  How is the mask calculation done in that way?
>   unsigned int mask =3D (1U << (fls(min + max) - 1)) - 1;
> What's the difference of this function with snd_soc_put_volsw()?

Yeah, I'm not clear either - Marek mentioned _SX when he was doing the
patch but I didn't get the bandwidth to figure out what it's doing
properly yet.  At this point I'm not clear what _SX is supposed to do,
I'm hoping it works well for the devices that use it but I don't have
any of them.

> Furthermore, the mask calculation and usage in snd_soc_put_volsw()
> isn't right, either, I'm afraid; if the range is [-10, 0], max=3D0, then
> mask will 0, which will omit all values...

Indeed, if anyone did that.  Fortunately I don't *think* that's an
issue.  The whole way that code handles signed bitfields by remapping
them into unsigned user visible controls is a landmine, it's not even
obvious that they handle signed bitfields in the first place.

--K4+LhN6i3Z7XS3AP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmIWYZMACgkQJNaLcl1U
h9ADZwf/Zzguub4Yl2PGwVZbKy+3Yyz5xv1y9d0rGtN8wkYdlXsSKholjgiNyjd1
qP1aTg7VEFpkX96xLYth0Zpb+49xvQYV5MGvDs+lhXgGQ9Vi7WYE7kLIY1XtQt1L
DShepF2VtcFgWSRiPP916BPFXvIPZSp1vAYlSiOpdvLtVy1FF/s4hqsYCShRFZQp
rUMPLjTi4CYxqomIWPw3gyepInvXv5BaaJb/4W+0TEmkTtEx4j7gd+i3j0b4ezg+
JB5IDi40XgR9NqLhz8nRcK9emSDtM4cIUIaP9pWKY151Q/CM3ua4cObX4ckP7KDM
zho+HpW4zeQj5MG7UsMX6bR7qO2/KA==
=ZXyI
-----END PGP SIGNATURE-----

--K4+LhN6i3Z7XS3AP--
