Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9521966C2CA
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbjAPOxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjAPOwg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:52:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1656023D8A;
        Mon, 16 Jan 2023 06:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 88DE7CE1169;
        Mon, 16 Jan 2023 14:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F89C433F0;
        Mon, 16 Jan 2023 14:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673880009;
        bh=qCQNprj6nr0lXLsaTVV6wQyMOyfyBoo19yyE5Px7Q6M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AztPyLCvQ1+2OjD3/3xu098AjFJSckBiTwktM+DJ28eiB3Y+stOtqnFYFCMT6HfQ9
         qXtHaqi4wSjVQtG7mZF8QubhbSEvAXnI9WlgEod94njvyXRPBT6zoiQ0Vg/2TTtxyF
         Mz8pLE+Is2dJMe4BB2r+ud4E6thGUU+/mplq/5vov+YC7k79AwJz5ep+Xm2yZtyiJe
         MxTjWaKC741NCzNH6QAw0qCiFgLRYVvVgwwF6VTnNYqx5ayrBK9ZtWxzVRKiSRMzj8
         vxhNiw7bbJXv09e6MHUyNad67D22/lUTHs51V6ks1rT/iTEd9jmyFOqaq42nZIEKgT
         l5frAUxY1xLMA==
Date:   Mon, 16 Jan 2023 14:40:05 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        linux-spi@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 11/17] spi: spidev: fix a race condition
 when accessing spidev->spi
Message-ID: <Y8VhxYxMjwtu12k2@sirena.org.uk>
References: <20230116140448.116034-1-sashal@kernel.org>
 <20230116140448.116034-11-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="HRyw640IPxuIZjTZ"
Content-Disposition: inline
In-Reply-To: <20230116140448.116034-11-sashal@kernel.org>
X-Cookie: Serving suggestion.
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--HRyw640IPxuIZjTZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 16, 2023 at 09:04:42AM -0500, Sasha Levin wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>=20
> [ Upstream commit a720416d94634068951773cb9e9d6f1b73769e5b ]
>=20
> There's a spinlock in place that is taken in file_operations callbacks
> whenever we check if spidev->spi is still alive (not null). It's also
> taken when spidev->spi is set to NULL in remove().

There are ongoing discussions of race conditions with this commit.

--HRyw640IPxuIZjTZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmPFYcUACgkQJNaLcl1U
h9B32Af/c2VYOXgQmB1VgAWYJ1esiMKPBMqNlhspvd31are1grJmxa1QlA21KMXR
9meJyt94TbUOs22oJhx5Mrcegc80jfoRKFgtlOmWDviFBfDC634HOUuYGfVQHy1B
croJdlBxTXJmSZwfarZxhFrXnQr0DBN/xs/6LWGNEErpiF2H9bJJg5rD5NsGBUcT
b33P0Hdurru1D4HKBUzU0woy32SipUzn6fNmbAxyf5xOGvLiQJXbERWeYZQYyhpP
y6vH91cIcrfxWDh5UaWIHrJtWsNcpZOgGgTZWCMzv8g7OIJGUKc2wkRyKqN9F8nW
CEjbOAkOSsrMDrPVvgdJC2n7V3tdTA==
=OmQE
-----END PGP SIGNATURE-----

--HRyw640IPxuIZjTZ--
