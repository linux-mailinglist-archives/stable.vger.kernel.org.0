Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3D2608DE1
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 17:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJVPMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 11:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiJVPMD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 11:12:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B16AE70;
        Sat, 22 Oct 2022 08:12:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72974600A0;
        Sat, 22 Oct 2022 15:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0AFC433D6;
        Sat, 22 Oct 2022 15:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666451520;
        bh=In+jdEa6PaDm6UxK4aTuN5Z+tRddb8x9/v/8UOAx4CM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=avjcX0lGs5FKvcorr1rpwJrsynEOYAg7eZCBvamwCXmQjykE5sZcFKeG7ynty2vnB
         lPCC+DgCSCcY6//vEXcP/TZwPQb251pZyc2mbOpCtgSdW21X3+P9nN3sKHxeUZ5V1N
         uWW7Xdw/ycciT0Y2+qf9W8E7qHS7mdVvpMf8dTY2w1g4xteLcAr6ObnbE/B9bRAzcj
         fAy7W8DoHvqfW25UGZz5N6pPFsUDbHhl9FQYcbSbf0xuW5kp6lgHJp5JPY8IlRLTCK
         8UhYL7bV0qHhDJ6hGvahLp0JUMMuDdjHm5v1oOXmNvAL4KAnaJdPJIM88jE1Zz7N+L
         /1l0X67CqJ5MA==
Date:   Sat, 22 Oct 2022 11:11:57 -0400
From:   William Breathitt Gray <wbg@kernel.org>
To:     William Breathitt Gray <william.gray@linaro.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] counter: 104-quad-8: Fix race getting function mode and
 direction
Message-ID: <Y1QIPTIxjo9rDF/I@ishi>
References: <20221020141121.15434-1-william.gray@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dzif1vsoZY6O8z+P"
Content-Disposition: inline
In-Reply-To: <20221020141121.15434-1-william.gray@linaro.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--dzif1vsoZY6O8z+P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 20, 2022 at 10:11:21AM -0400, William Breathitt Gray wrote:
> The quad8_action_read() function checks the Count function mode and
> Count direction without first acquiring a lock. This is a race condition
> because the function mode could change by the time the direction is
> checked.
>=20
> Because the quad8_function_read() already acquires a lock internally,
> the quad8_function_read() is refactored to spin out the no-lock code to
> a new quad8_function_get() function.
>=20
> To resolve the race condition in quad8_action_read(), a lock is acquired
> before calling quad8_function_get() and quad8_direction_read() in order
> to get both function mode and direction atomically.
>=20
> Fixes: f1d8a071d45b ("counter: 104-quad-8: Add Generic Counter interface =
support")
> Cc: stable@vger.kernel.org
> Signed-off-by: William Breathitt Gray <william.gray@linaro.org>

Queued for counter-fixes.

William Breathitt Gray

--dzif1vsoZY6O8z+P
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSNN83d4NIlKPjon7a1SFbKvhIjKwUCY1QIPQAKCRC1SFbKvhIj
K6z5AQCj3RPjeKPKXVs69W7SAqiVcTUbu46rIwXSIikUGSybxwD+JfO7SUyOLwXt
qnYk5EPvhrdJJJbHQUFmFGRg35rouQQ=
=B0rH
-----END PGP SIGNATURE-----

--dzif1vsoZY6O8z+P--
