Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96BE5390BD9
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 00:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhEYWBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 18:01:41 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:50092 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbhEYWBl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 18:01:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Q/aVwAl9ZbVzeROasWm9GqY9AVIvFYpQG1yWzJt4tok=; b=Kcj1d6Qlw0QazwDKdN+7hBCrS3
        LDQOLK20ivePLU0b90/AgK0s2JnPTfrGFmHrfpfeHtvfM4PXyqDq7SCchpexKKlrcwTJdo0lSmoD4
        1j1LG90iGfpfcXOdmf1CLSgXNJ+8WEFR+kUt373fMOb3DhucVpPpS5W9z7HrYoZhlbfs=;
Received: from 94.196.90.140.threembb.co.uk ([94.196.90.140] helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <broonie@sirena.org.uk>)
        id 1llf5j-005qUg-G1; Tue, 25 May 2021 21:59:59 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id C36A4D0E998; Tue, 25 May 2021 23:00:33 +0100 (BST)
Date:   Tue, 25 May 2021 23:00:33 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.10 29/62] Revert "ASoC: rt5645: fix a NULL
 pointer dereference"
Message-ID: <YK1zgS7FwtySdeCg@sirena.org.uk>
References: <20210524144744.2497894-1-sashal@kernel.org>
 <20210524144744.2497894-29-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="DdwHdDdz+wOD3YAw"
Content-Disposition: inline
In-Reply-To: <20210524144744.2497894-29-sashal@kernel.org>
X-Cookie: You are always busy.
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--DdwHdDdz+wOD3YAw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 24, 2021 at 10:47:10AM -0400, Sasha Levin wrote:

> Lots of things seem to be still allocated here and must be properly
> cleaned up if an error happens here.

That's not true, the core already has cleanup for everything else
(as the followup patch in your series identified, though it was a
bit confused as to how).

>  		RT5645_HWEQ_NUM, sizeof(struct rt5645_eq_param_s),
>  		GFP_KERNEL);
> =20
> -	if (!rt5645->eq_param)
> -		return -ENOMEM;
> -

Without the followup patch (which I don't think is suitable for
stable) this will just remove error checking.  It's not likely to
happen and hence make a difference but on the other hand it
introduces a problem, especially when backported in isolation.

--DdwHdDdz+wOD3YAw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmCtc4EACgkQJNaLcl1U
h9DmWwf/eYEFvTLEKSVeNp5s76miE9DNZEsJf+6meHS2E2vLXz8rU0IPk5IpTcPy
BbXfaYsKCBHYU2Je394Xa8Nfjix4kxZoD/JXNG/cbAIFeinaUeXvY0ig4oWIvCxK
DbHtmyn50GMD4xLrZgCSc0bX5PSXU3hcFZUrLkfND5gHfo+rchxQ4MvWaybzcYh9
n0+xo8pyhFPcYuCpM+rRj27xBhHeIv6fKdVwtuoZGZnh9OHn7a37ZUcZceNwPY/p
oU/QrvPTrXzgad3OnsywWhE2Vo5U7djjfGT8hAay1ckC6kQlIWlnIvuLTx67GD9N
T7JzAerzodiHmeEVJmGBkPgJdcJYMQ==
=bVSZ
-----END PGP SIGNATURE-----

--DdwHdDdz+wOD3YAw--
