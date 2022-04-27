Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7C85123F8
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 22:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236798AbiD0Ug0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 16:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237070AbiD0UgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 16:36:20 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5FBB6D11;
        Wed, 27 Apr 2022 13:32:50 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id EB5F61C0B8F; Wed, 27 Apr 2022 22:32:48 +0200 (CEST)
Date:   Wed, 27 Apr 2022 22:32:48 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 14/86] dmaengine: mediatek:Fix PM usage reference
 leak of mtk_uart_apdma_alloc_chan_resources
Message-ID: <20220427203248.GA2175@duo.ucw.cz>
References: <20220426081741.202366502@linuxfoundation.org>
 <20220426081741.617352615@linuxfoundation.org>
 <20220427202836.GA1337@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <20220427202836.GA1337@duo.ucw.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > pm_runtime_get_sync will increment pm usage counter even it failed.
> > Forgetting to putting operation will result in reference leak here.
> > We fix it:
> > 1) Replacing it with pm_runtime_resume_and_get to keep usage counter
> >    balanced.
>=20
> Suspect.
>=20
> > 2) Add putting operation before returning error.
>=20
> Yes but you also put in success case, which is likely
> wrong. mtk_uart_apdma_free_chan_resources() does second put.

This is possible fix for the second problem:

Signed-off-by: Pavel Machek <pavel@denx.de>

diff --git a/drivers/dma/mediatek/mtk-uart-apdma.c b/drivers/dma/mediatek/m=
tk-uart-apdma.c
index a1517ef1f4a0..8ec046a7e714 100644
--- a/drivers/dma/mediatek/mtk-uart-apdma.c
+++ b/drivers/dma/mediatek/mtk-uart-apdma.c
@@ -300,7 +300,8 @@ static int mtk_uart_apdma_alloc_chan_resources(struct d=
ma_chan *chan)
=20
 	if (mtkd->support_33bits)
 		mtk_uart_apdma_write(c, VFF_4G_SUPPORT, VFF_4G_SUPPORT_CLR_B);
-
+	return 0;
+=09
 err_pm:
 	pm_runtime_put_noidle(mtkd->ddev.dev);
 	return ret;

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYmmocAAKCRAw5/Bqldv6
8vfVAJ9QZloVylqz/nLmks05g9Rf0EI/aQCfXpqsymRDI4DHgSkcuxU3sBVBJAE=
=BoSZ
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
