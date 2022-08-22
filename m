Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7285A59BB02
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbiHVIHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233393AbiHVIEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:04:55 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5CA2B1BF;
        Mon, 22 Aug 2022 01:04:17 -0700 (PDT)
Received: (Authenticated sender: paul.kocialkowski@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 915AE40002;
        Mon, 22 Aug 2022 08:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661155456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Af8UEwDVr1WeGoIs7qSh0v1VGOmRYqe15mtkRmwM7uI=;
        b=F6wrILK6/Vtb/q8w5hOXTvAsOa3WjkHRwEnPve2X3KrHfH1qA61FhjSKDyZrYWPg/yj3hV
        HFTOtY/Qu8Oi/VWaorVVxt+27huAxDuUSodv34SjWC99G4DvSZsti2lCCk6e5iuFlaGmVI
        CC/4b6m2ZoRNFAgueszlc7rX4iTGBqthYkeqISeAR63AkgPINL78Z39GLMOZ8E48S6xDDX
        r0LdNf7sudzs+grPZ4SfAQ/EyhF1WsoDGHH0DEri8U2IBF0eN26CSmi9MUPkfVJ9PrGcLy
        6a98B4isZpl/21k/Gu+HCnMnXl05BE2SSMjW5YzQFVacOl+NsOMh9tsh291t5A==
Date:   Mon, 22 Aug 2022 10:04:09 +0200
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc:     linux-media@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>, kernel@collabora.com,
        stable@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/3] media: cedrus: Fix watchdog race condition
Message-ID: <YwM4efK9V4t38RFe@aptenodytes>
References: <20220818203308.439043-1-nicolas.dufresne@collabora.com>
 <20220818203308.439043-2-nicolas.dufresne@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9C9XXDtt+KGo1SiH"
Content-Disposition: inline
In-Reply-To: <20220818203308.439043-2-nicolas.dufresne@collabora.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9C9XXDtt+KGo1SiH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nicolas,

On Thu 18 Aug 22, 16:33, Nicolas Dufresne wrote:
> The watchdog needs to be schedule before we trigger the decode
> operation, otherwise there is a risk that the decoder IRQ will be
> called before we have schedule the watchdog. As a side effect, the
> watchdog would never be cancelled and its function would be called
> at an inappropriate time.
>=20
> This was observed while running Fluster with GStreamer as a backend.
> Some programming error would cause the decoder IRQ to be call very
> quickly after the trigger. Later calls into the driver would deadlock
> due to the unbalanced state.

Good catch, thanks!

Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Cheers,

Paul

> Cc: stable@vger.kernel.org
> Fixes: 7c38a551bda1 ("media: cedrus: Add watchdog for job completion")
> Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> ---
>  drivers/staging/media/sunxi/cedrus/cedrus_dec.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c b/drivers/st=
aging/media/sunxi/cedrus/cedrus_dec.c
> index 3b6aa78a2985f..e7f7602a5ab40 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> @@ -106,11 +106,11 @@ void cedrus_device_run(void *priv)
> =20
>  	/* Trigger decoding if setup went well, bail out otherwise. */
>  	if (!error) {
> -		dev->dec_ops[ctx->current_codec]->trigger(ctx);
> -
>  		/* Start the watchdog timer. */
>  		schedule_delayed_work(&dev->watchdog_work,
>  				      msecs_to_jiffies(2000));
> +
> +		dev->dec_ops[ctx->current_codec]->trigger(ctx);
>  	} else {
>  		v4l2_m2m_buf_done_and_job_finish(ctx->dev->m2m_dev,
>  						 ctx->fh.m2m_ctx,
> --=20
> 2.37.2
>=20

--=20
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

--9C9XXDtt+KGo1SiH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAmMDOHgACgkQ3cLmz3+f
v9ENKwf+JRXzzEmrQxZWhfCKskt7uuVhWKW/HBMQrYb3guv4d6PGcqi52+9lyStB
49tTvjlH655bRsQKMEC3DT6Md1inbO6G7CZhH8uAaX43iLx3UgXbI13OCTEfz2V2
CF1UK+Rm/Cv6eZhS7jCml/bOTA058ScUkemASDt61IhDcsjNo1rmKWulkGtiKhl4
Fj+Hq4ut9YLfyb/l5RAVPixiXgsMUye4J0z0ANN8XADhL5pkjLIh+wU9BT4jB3Y6
u9KVVjjwRsux5p78R5jZ9PKhWIbtySCtWWmjK+vsl/+X6jUwcgWUW3tPnxB/JYSI
FRlmnT/A5hJvZu8f2xD+DF23Oyv1HA==
=7kSt
-----END PGP SIGNATURE-----

--9C9XXDtt+KGo1SiH--
