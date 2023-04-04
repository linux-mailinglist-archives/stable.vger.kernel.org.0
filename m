Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585976D5EDE
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 13:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbjDDLWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 07:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234066AbjDDLWF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 07:22:05 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDF5DC
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 04:22:03 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 450311C0DFD; Tue,  4 Apr 2023 13:22:02 +0200 (CEST)
Date:   Tue, 4 Apr 2023 13:22:01 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 006/173] ipmi:ssif: resend_msg() cannot fail
Message-ID: <ZCwIWfSovPxvPzU2@duo.ucw.cz>
References: <20230403140414.174516815@linuxfoundation.org>
 <20230403140414.435644519@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="kaXC/y2ScS6jCe+I"
Content-Disposition: inline
In-Reply-To: <20230403140414.435644519@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=SPF_HELO_NONE,SPF_NEUTRAL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--kaXC/y2ScS6jCe+I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> The resend_msg() function cannot fail, but there was error handling
> around using it.  Rework the handling of the error, and fix the out of
> retries debug reporting that was wrong around this, too.

> @@ -909,31 +909,17 @@ static void msg_written_handler(struct ssif_info *s=
sif_info, int result,
>  	if (result < 0) {
>  		ssif_info->retries_left--;
>  		if (ssif_info->retries_left > 0) {
> -			if (!start_resend(ssif_info)) {
> -				ssif_inc_stat(ssif_info, send_retries);
> -				return;
> -			}
> -			/* request failed, just return the error. */
> -			ssif_inc_stat(ssif_info, send_errors);
> -
> -			if (ssif_info->ssif_debug & SSIF_DEBUG_MSG)
> -				dev_dbg(&ssif_info->client->dev,
> -					"%s: Out of retries\n", __func__);
> -			msg_done_handler(ssif_info, -EIO, NULL, 0);
> +			start_resend(ssif_info);
>  			return;
>  		}

ssif_inc_stat(ssif_info, send_errors); disappeared here, is that
intentional?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--kaXC/y2ScS6jCe+I
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZCwIWQAKCRAw5/Bqldv6
8k2lAKCAMfVys8P3G+wY0FR3nIJt5iaDkwCgu8ib2MYDHIpRvpm1docPUDK3BpQ=
=nS+o
-----END PGP SIGNATURE-----

--kaXC/y2ScS6jCe+I--
