Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF6A15123E7
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 22:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236266AbiD0Ubw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 16:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbiD0Ubv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 16:31:51 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF120B18B7;
        Wed, 27 Apr 2022 13:28:39 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0691E1C0B8E; Wed, 27 Apr 2022 22:28:37 +0200 (CEST)
Date:   Wed, 27 Apr 2022 22:28:36 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 14/86] dmaengine: mediatek:Fix PM usage reference
 leak of mtk_uart_apdma_alloc_chan_resources
Message-ID: <20220427202836.GA1337@duo.ucw.cz>
References: <20220426081741.202366502@linuxfoundation.org>
 <20220426081741.617352615@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <20220426081741.617352615@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> pm_runtime_get_sync will increment pm usage counter even it failed.
> Forgetting to putting operation will result in reference leak here.
> We fix it:
> 1) Replacing it with pm_runtime_resume_and_get to keep usage counter
>    balanced.

Suspect.

> 2) Add putting operation before returning error.

Yes but you also put in success case, which is likely
wrong. mtk_uart_apdma_free_chan_resources() does second put.

> +++ b/drivers/dma/mediatek/mtk-uart-apdma.c
> @@ -274,7 +274,7 @@ static int mtk_uart_apdma_alloc_chan_resources(struct=
 dma_chan *chan)
>  	unsigned int status;
>  	int ret;
> =20
> -	ret =3D pm_runtime_get_sync(mtkd->ddev.dev);
> +	ret =3D pm_runtime_resume_and_get(mtkd->ddev.dev);
>  	if (ret < 0) {
>  		pm_runtime_put_noidle(chan->device->dev);
>  		return ret;


This is suspect, too. What is the put_noidle doing there? Seems like
it was meant to undo the get_sync operation, but uses different
argument?

> @@ -288,18 +288,21 @@ static int mtk_uart_apdma_alloc_chan_resources(stru=
ct dma_chan *chan)
> =20
>  	if (mtkd->support_33bits)
>  		mtk_uart_apdma_write(c, VFF_4G_SUPPORT, VFF_4G_SUPPORT_CLR_B);
> =20
> +err_pm:
> +	pm_runtime_put_noidle(mtkd->ddev.dev);
>  	return ret;
>  }

This should only be done in error case.

Best regards,
								Pavel
--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYmmndAAKCRAw5/Bqldv6
8ofDAJ9Wn50KlpBHmmRdY76q8yRqCjKaCACcC0Z9sLXZFmOs9LULKyBcCPbpmmE=
=N0Sr
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
