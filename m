Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E434D2F23
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 13:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiCIMgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 07:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiCIMgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 07:36:11 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A387617288D;
        Wed,  9 Mar 2022 04:35:11 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id CC1D51C0B77; Wed,  9 Mar 2022 13:35:09 +0100 (CET)
Date:   Wed, 9 Mar 2022 13:35:09 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Yongzhi Liu <lyz_cs@pku.edu.cn>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 012/105] dmaengine: shdma: Fix runtime PM imbalance
 on error
Message-ID: <20220309123509.GA30506@duo.ucw.cz>
References: <20220307091644.179885033@linuxfoundation.org>
 <20220307091644.529997660@linuxfoundation.org>
 <20220309105420.GA22677@duo.ucw.cz>
 <YiiWduSVDz1yYA9z@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <YiiWduSVDz1yYA9z@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2022-03-09 12:58:46, Greg Kroah-Hartman wrote:
> On Wed, Mar 09, 2022 at 11:54:20AM +0100, Pavel Machek wrote:
> > Hi!
> >=20
> > > From: Yongzhi Liu <lyz_cs@pku.edu.cn>
> > >=20
> > > [ Upstream commit 455896c53d5b803733ddd84e1bf8a430644439b6 ]
> > >=20
> > > pm_runtime_get_() increments the runtime PM usage counter even
> > > when it returns an error code, thus a matching decrement is needed on
> > > the error handling path to keep the counter balanced.
> >=20
> > This patch will break things.
> >=20
> > Notice that -ret is ignored (checked 4.4 and 5.10), so we don't
> > actually abort/return error; we just printk. We'll do two
> > pm_runtime_put's after the "fix".
> >=20
> > Please drop from -stable.
> >=20
> > It was discussed during AUTOSEL review:
> >=20
> > Date: Fri, 25 Feb 2022 14:25:10 +0800 (GMT+08:00)
> > From: =E5=88=98=E6=B0=B8=E5=BF=97 <lyz_cs@pku.edu.cn>
> > To: pavel machek <pavel@denx.de>
> > Cc: sasha levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
> > Subject: Re: [PATCH AUTOSEL 5.16 24/30] dmaengine: shdma: Fix runtime PM
> > 	imbalance on error
>=20
> So 5.15 and 5.16 is ok, but older is not?

I believe commit is wrong for mainline and all stable releases, and
author seems to agree. Drop from everywhere.

(And sorry for confusion, I concentrate on 5.10/4.19; that's why mail
was ambiguous).

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYiie/QAKCRAw5/Bqldv6
8qjOAJ0TyLXjvWsKvnzXpRaKU/dTVC74FgCfVNEdUBsVlOOzCTnrIr5gjsBVDRw=
=Knv5
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
