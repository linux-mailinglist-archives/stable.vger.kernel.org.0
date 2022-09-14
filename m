Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1138D5B8864
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 14:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiINMig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 08:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiINMi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 08:38:27 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13F772FDD;
        Wed, 14 Sep 2022 05:38:21 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 49D7C1C0001; Wed, 14 Sep 2022 14:38:20 +0200 (CEST)
Date:   Wed, 14 Sep 2022 14:38:19 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stable <stable@kernel.org>, Fedor Pchelkin <pchelkin@ispras.ru>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: Re: [PATCH 5.10 04/79] tty: n_gsm: avoid call of sleeping functions
 from atomic context
Message-ID: <20220914123819.GA12582@duo.ucw.cz>
References: <20220913140350.291927556@linuxfoundation.org>
 <20220913140350.501815100@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <20220913140350.501815100@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Fedor Pchelkin <pchelkin@ispras.ru>
>=20
> commit 902e02ea9385373ce4b142576eef41c642703955 upstream.
>=20
> Syzkaller reports the following problem:
>=20
> BUG: sleeping function called from invalid context at kernel/printk/print=
k.c:2347
> in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 1105, name: syz-ex=
ecutor423
> 3 locks held by syz-executor423/1105:

Does this happen in 5.10, too? printk locking changed significantly in
recent years.

> The problem happens in the following control flow:
>=20
> gsmld_write(...)
> spin_lock_irqsave(&gsm->tx_lock, flags) // taken a spinlock on TX data
>  con_write(...)
>   do_con_write(...)
>    console_lock()
>     might_sleep() // -> bug
>=20
> As far as console_lock() might sleep it should not be called with
> spinlock held.

Ok.

> The patch replaces tx_lock spinlock with mutex in order to avoid the
> problem.

Are you sure you can do that? Original code disabled interrupts,
because parts of protected data were accessed from interrupt context,
and you simply removed that protection.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYyHLOwAKCRAw5/Bqldv6
8npSAKDEPe+ji9UMBxkVaJcFR3gg3rPcowCgmWLb0zoDlnNvnF5VaS+GMX2FlzU=
=JIa4
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
