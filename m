Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59781F76C4
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 12:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgFLKb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 06:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgFLKb6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jun 2020 06:31:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833C7C08C5C1
        for <stable@vger.kernel.org>; Fri, 12 Jun 2020 03:31:57 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jjgyU-0006sD-8S; Fri, 12 Jun 2020 12:31:50 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jjgyT-0007v1-Fk; Fri, 12 Jun 2020 12:31:49 +0200
Date:   Fri, 12 Jun 2020 12:31:49 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Wolfram Sang <wsa@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: imx: Fix external abort on early interrupt
Message-ID: <20200612103149.2onoflu5qgwaooli@pengutronix.de>
References: <1591796802-23504-1-git-send-email-krzk@kernel.org>
 <20200612090517.GA3030@ninjato>
 <20200612092941.GA25990@pi3>
 <20200612095604.GA17763@ninjato>
 <20200612102113.GA26056@pi3>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ih5p7jdiwpepz4ji"
Content-Disposition: inline
In-Reply-To: <20200612102113.GA26056@pi3>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:25:27 up 210 days,  1:44, 208 users,  load average: 0.19, 0.11,
 0.10
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ih5p7jdiwpepz4ji
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 12, 2020 at 12:21:13PM +0200, Krzysztof Kozlowski wrote:
> On Fri, Jun 12, 2020 at 11:56:04AM +0200, Wolfram Sang wrote:
> > On Fri, Jun 12, 2020 at 11:29:41AM +0200, Krzysztof Kozlowski wrote:
> > > On Fri, Jun 12, 2020 at 11:05:17AM +0200, Wolfram Sang wrote:
> > > > On Wed, Jun 10, 2020 at 03:46:42PM +0200, Krzysztof Kozlowski wrote:
> > > > > If interrupt comes early (could be triggered with CONFIG_DEBUG_SH=
IRQ),
> > > >=20
> > > > That code is disabled since 2011 (6d83f94db95c ("genirq: Disable the
> > > > SHIRQ_DEBUG call in request_threaded_irq for now"))? So, you had th=
is
> > > > without fake injection, I assume?
> > >=20
> > > No, I observed it only after enabling DEBUG_SHIRQ (to a kernel with
> > > some debugging options already).
> >=20
> > Interesting. Maybe probe was deferred and you got the extra irq when
> > deregistering?
>=20
> Yes, good catch. The abort happens right after deferred probe exit.  It
> could be then different reason than I thought - the interrupt is freed
> through devm infrastructure quite late.  At this time, the clock might
> be indeed disabled (error path of probe()).

This line looks suspicious to me:
 Unhandled fault: external abort on non-linefetch (0x1008) at 0x8882d003

0x8882d003 looks like not initialized pointer.
The only not initialized value at devm_request_irq stage is i2c_imx->queue.


--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--ih5p7jdiwpepz4ji
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl7jWZEACgkQ4omh9DUa
UbMz+RAAwthmvYid3GV24DtJKEJYoXymSfUbkZWCcEaFFrlus3duYL2tm5N6lHTm
KhM0BxARTVJo8kMoCN88mg5f+cJR1qC8dFmMvUseU1tyeb8UhFiAliVeXBIB60+U
7C5BdpptLFc/VOtBY5xfogZ3ZiFoe808iX1bI8gNYA5Ut9c8j+6mG2eTPnKghxNJ
906Efve2mCRFgvvZ29rxgKMmvHwcjGumrkpfpD/9XpP2dvCwkIfW8jKp00ws9Wrq
pnlVQFhOxVzd3dU4jmZd33zq3Mntjbez2FzjCwOEYdBYKLL3omtV/BsfsBEWm7j5
jCJXJntfPEYf8R6DNTgqAD9vSE0tOUwL7ddeCzOd6MJhC2Xp0/mNAWMcSSUlr+XR
GNb2ZlkNewGsrQUnfINdGD9otKTO9VwbogfHHz0zafVk1bEnSM842a/9rhFRzjQI
/3HQdZ1bTANbIr9jLBKxFM5kANoSr0AGEyct80rRokFV4BhmkaTlmlvrX7F7NMqZ
boG4W6JNgwyrFKcZWYVE4I1TyaBh3P/JQza1yKHVAKqT7FuPDmwzW5ssX5+GU8Tc
E7q/WQkjCePUYMG4JEOotlFIc5p+tBjFgDihuzP9/u7Jad/kkbaD8gXllvZziTFP
Uh1m1pQ0WmXJEi4bUgXU4lKbD5N2yQDU17CSSe8jVgw4+yyorOY=
=szJB
-----END PGP SIGNATURE-----

--ih5p7jdiwpepz4ji--
