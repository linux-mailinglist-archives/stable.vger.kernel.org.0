Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9A5537913
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 12:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbiE3K3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 06:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbiE3K3J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 06:29:09 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DA77C16B;
        Mon, 30 May 2022 03:29:01 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 73F851C0B82; Mon, 30 May 2022 12:28:59 +0200 (CEST)
Date:   Mon, 30 May 2022 12:28:59 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.14 04/33] Input: stmfts - fix reference leak in
 stmfts_input_open
Message-ID: <20220530102859.GA32111@duo.ucw.cz>
References: <20220523165746.957506211@linuxfoundation.org>
 <20220523165747.818755611@linuxfoundation.org>
 <20220525105248.GA31002@duo.ucw.cz>
 <Yo5vmwfaJKhg9fzF@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <Yo5vmwfaJKhg9fzF@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > From: Zheng Yongjun <zhengyongjun3@huawei.com>
> > >=20
> > > [ Upstream commit 26623eea0da3476446909af96c980768df07bbd9 ]
> > >=20
> > > pm_runtime_get_sync() will increment pm usage counter even it
> > > failed. Forgetting to call pm_runtime_put_noidle will result
> > > in reference leak in stmfts_input_open, so we should fix it.
> >=20
> > This is wrong, AFAICT.
>=20
> Yes, I think you are right. How about below?

Looks good to me.

> Input: stmfts - do not leave device disabled in stmfts_input_open
>=20
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>=20
> The commit 26623eea0da3 attempted to deal with potential leak of runtime
> PM counter when opening the touchscreen device, however it ended up
> erroneously dropping the counter in the case of successfully enabling the
> device.
>=20
> Let's address this by using pm_runtime_resume_and_get() and then executing
> pm_runtime_put_sync() only when we fail to send "sense on" command to the
> device.
>=20
> Fixes: 26623eea0da3 ("Input: stmfts - fix reference leak in stmfts_input_=
open")

Reviewed-by: Pavel Machek <pavel@denx.de>

Thank you,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYpScawAKCRAw5/Bqldv6
8vA0AJ0WjbKH+mFtXAIKAZ3By6pG9v1jhgCfTV013nZ/6CHe/OW8Cyz5Utg7wrE=
=73fp
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
