Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0756BFA36
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 14:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjCRN2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 09:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjCRN2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 09:28:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E857EB70;
        Sat, 18 Mar 2023 06:28:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EAEBB81256;
        Sat, 18 Mar 2023 13:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E902C4339B;
        Sat, 18 Mar 2023 13:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679146080;
        bh=psfrA5p2uM2bG6uslEqzGHJfqnkRsqqP4wOcTu2JuI0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XVvjldRum0mYqqLg3J0njpE/2CJ+rInCUxKd3dKe+NIm/l1c3lmj46yXdaC6hO0yB
         v6v0abyyKxUe0ot56XTpset+L6e1iIAX9PsJoyJzIG4GAAQhTt2psIf/ifHU9fbRQm
         AGKaivvYd4Pao2KOIU26LgX8qqJA7EXdZQKBPzWH4wT9qCI4riipRUkQJMxg/y03uG
         BAijyOIXEn0a5pnjpR7D/8vGIgcdYrzAG8SLlR514wGZdkC3sSL3v6pg9RsP4SeTJv
         TrQ6oP8MIPazxYREfyV9WG26l8Z9hb6YyhChAetdVfKK3qu98fo+ocHYHL8SgEHIw8
         1uD5GeMGMbizA==
Date:   Sat, 18 Mar 2023 09:27:56 -0400
From:   William Breathitt Gray <wbg@kernel.org>
To:     William Breathitt Gray <william.gray@linaro.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        jic23@kernel.org, lars@metafoo.de, stable@vger.kernel.org
Subject: Re: [PATCH 6.1,6.2,6.3 v3 1/6] counter: 104-quad-8: Fix race
 condition between FLAG and CNTR reads
Message-ID: <ZBW8XN71fYwJe6rW@ishi>
References: <20230312231554.134858-1-william.gray@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+wDaARczjHaj/9wJ"
Content-Disposition: inline
In-Reply-To: <20230312231554.134858-1-william.gray@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+wDaARczjHaj/9wJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 12, 2023 at 07:15:49PM -0400, William Breathitt Gray wrote:
> The Counter (CNTR) register is 24 bits wide, but we can have an
> effective 25-bit count value by setting bit 24 to the XOR of the Borrow
> flag and Carry flag. The flags can be read from the FLAG register, but a
> race condition exists: the Borrow flag and Carry flag are instantaneous
> and could change by the time the count value is read from the CNTR
> register.
>=20
> Since the race condition could result in an incorrect 25-bit count
> value, remove support for 25-bit count values from this driver;
> hard-coded maximum count values are replaced by a LS7267_CNTR_MAX define
> for consistency and clarity.
>=20
> Fixes: 28e5d3bb0325 ("iio: 104-quad-8: Add IIO support for the ACCES 104-=
QUAD-8")
> Cc: <stable@vger.kernel.org> # 6.1.x
> Cc: <stable@vger.kernel.org> # 6.2.x
> Signed-off-by: William Breathitt Gray <william.gray@linaro.org>

Applied to counter-fixes.

William Breathitt Gray

--+wDaARczjHaj/9wJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSNN83d4NIlKPjon7a1SFbKvhIjKwUCZBW8XAAKCRC1SFbKvhIj
K3KAAP9w7bhPNGq7bLugVAL4kGTJV/4p+qiDV2F5A/IX3elolgD8DG1UjgHl24Fc
AMX6rxI+muLu7Rag/fABBAakHSLxyAM=
=ZPSs
-----END PGP SIGNATURE-----

--+wDaARczjHaj/9wJ--
