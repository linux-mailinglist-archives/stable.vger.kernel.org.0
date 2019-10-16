Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 644BADA194
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbfJPWfY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:35:24 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:60262 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbfJPWfY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 18:35:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=X6Sf04ArD7jN+fMhh6LgGi0CQBGg138wDjt0wx/X6YQ=; b=nPOPzYG2BZgfRlCTsM1Tw9T/f
        1+5ByqsJqcq2PpoevodlkHfjpX3svIy4yaebHYxPSOm7dB/LKY9dmOGDmAwVjzql0xRcmuzMcqo66
        eF6rHeN3PyN+rGA6knH5G1AAvWUgHF4JXP/CUugqDvXRDieF0tz73AOB4o2y6dgROksrY=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1iKrt1-0006P1-O3; Wed, 16 Oct 2019 22:35:19 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id C841B274325C; Wed, 16 Oct 2019 23:35:18 +0100 (BST)
Date:   Wed, 16 Oct 2019 23:35:18 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Richard Leitner <richard.leitner@skidata.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH 5.3 112/112] ASoC: sgtl5000: add ADC mute control
Message-ID: <20191016223518.GC11473@sirena.co.uk>
References: <20191016214844.038848564@linuxfoundation.org>
 <20191016214907.599726506@linuxfoundation.org>
 <20191016220044.GB11473@sirena.co.uk>
 <20191016221025.GA990599@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ALfTUftag+2gvp1h"
Content-Disposition: inline
In-Reply-To: <20191016221025.GA990599@kroah.com>
X-Cookie: Auction:
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ALfTUftag+2gvp1h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2019 at 03:10:25PM -0700, Greg Kroah-Hartman wrote:
> On Wed, Oct 16, 2019 at 11:00:44PM +0100, Mark Brown wrote:
> > On Wed, Oct 16, 2019 at 02:51:44PM -0700, Greg Kroah-Hartman wrote:
> > > From: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>

> > > commit 694b14554d75f2a1ae111202e71860d58b434a21 upstream.

> > > This control mute/unmute the ADC input of SGTL5000
> > > using its CHIP_ANA_CTRL register.

> > This seems like a new feature and not an obvious candidate for stable?

> there was a long email from Richard that said:
> 	Upstream commit 631bc8f0134a ("ASoC: sgtl5000: Fix of unmute
> 	outputs on probe"), which is e9f621efaebd in v5.3 replaced
> 	snd_soc_component_write with snd_soc_component_update_bits and
> 	therefore no longer cleared the MUTE_ADC flag. This caused the
> 	ADC to stay muted and recording doesn't work any longer. This
> 	patch fixes this problem by adding a Switch control for
> 	MUTE_ADC.

> That's why I took this.  If this isn't true, I'll be glad to drop this.

That's probably not an appropriate fix for stable - it's going to add a
new control which users will need to manually set (or hope their
userspace automatically figures out that it should set for them, more
advanced userspaces like PulseAudio should) which isn't a drop in fix.=20
You could either drop the backport that was done for zero cross or take
a new patch that clears the MUTE_ADC flag (rather than punting to
userspace to do so), or just be OK with what you've got at the minute
which might be fine given the lack of user reports.

--ALfTUftag+2gvp1h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl2nmyUACgkQJNaLcl1U
h9DWfwf+K0fc88QLIuGcWpAJ3DwOZiSnXrA9pkmrlSQ4aR8OEk+t2JiTrfCySwH8
F6FczIz+0Zu3FHrozTsnmaB/QTl8PprwARpVQitGnY7h/U4ULv4WRiuMZGA2azXG
nzcm/7hCpE+WqFCGcwU2crKtn01HZ3xHMaizHW0xJqoQAP8gXeEz/B6+HGercbkX
v/FzDuyaispEy48+7/ktcWkQOj0xCZl/newEY1Z6B+PvfteUgoKaa440Vo01WzM3
PBB7x1rz54Z0ws/z+tFJY9RykpE4t16j2hjIMlhKdsZQMA2kJzEjI7dn4shL4uKV
oPkSvOU4E3YPneqh4cxbBxAcwezFnA==
=kUz1
-----END PGP SIGNATURE-----

--ALfTUftag+2gvp1h--
