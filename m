Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1964EA9F
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 16:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfFUOa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 10:30:59 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:35010 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbfFUOa6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 10:30:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hxG4OzKJll+CUOuLlcP/6L1BRl/sjRJOcnpnlIt2izg=; b=G6A6WZOmQTJlzMKdN63KDKI8R
        3j/1J1Y9dPK+PHFgwDlXca8WROH+SGyJriWhC2dbK4K2dylvXlrOyO7kAH4lxNDIh4r5vUTxd0yv4
        5JO/rJPyY6YClQAlrcZ7+J8OnWcW9ZOKxoQ3e2SseJiI45A1CRGKIDxLHQ/8VtHGbok7A=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=finisterre.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1heKZ4-0002ZU-0o; Fri, 21 Jun 2019 14:30:54 +0000
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
        id 87D56440046; Fri, 21 Jun 2019 15:30:53 +0100 (BST)
Date:   Fri, 21 Jun 2019 15:30:53 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] ASoC: dapm: Adapt for debugfs API change
Message-ID: <20190621143053.GH5316@sirena.org.uk>
References: <20190621113357.8264-1-broonie@kernel.org>
 <20190621113357.8264-2-broonie@kernel.org>
 <20190621132222.GB10459@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="GyBFFrpYHGV4SYp0"
Content-Disposition: inline
In-Reply-To: <20190621132222.GB10459@kroah.com>
X-Cookie: Editing is a rewording activity.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--GyBFFrpYHGV4SYp0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 21, 2019 at 03:22:22PM +0200, Greg KH wrote:
> On Fri, Jun 21, 2019 at 12:33:57PM +0100, Mark Brown wrote:

> >  	struct dentry *d;
> > =20
> > -	if (!parent)
> > +	if (!parent || IS_ERR(parent))
> >  		return;

> How can parent be NULL?

It was more effort than it was worth to check to see if it could
actually be NULL through default initialization or something and fix it
than just not delete the check so I just left it there.  I'll probably
go back and clean it up more thorougly at some point.

> I am trying to make it so that debugfs doesn't return anything for when
> a file is created.  Now if that will ever be possible or not, I don't
> know, but I am pretty close in one of the branches in my driver-core
> tree...

You mentioned this in a mail last week, I then replied pointing out that
this is not helpful as it reduces the robustness and quality of our
debugging tools and you then did not respond.  This is a view I still
hold and in any case debugfs as it stands (and was in the kernel
versions since this was broken) is still capable of reporting errors so
we should fix that.

--GyBFFrpYHGV4SYp0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl0M6hwACgkQJNaLcl1U
h9CVfgf/Zvf50vTJSnV4Ifjlc60r5s/W7eTpQGayjvn9PD0gkjA4+G5hVAEjeV5u
qRvkDMZwgld9zIa08UvfBb7J7Cr+HV5RgQGnYBjcwXJwQ2bDecBUUhXjlNgcMRos
NwA99IiRefpwluCcD4Tc7jom/y/XyuIh07rvZyvGcrObNVytaRWToAjumnIT/tM0
DINLjqjXAHQNeNs3cpNea2HvjTxk524bEMm075hc87KWaqYZqfjL+PNyJthE9Psc
tVee93MX3iLcNfxeJe0XXhKZ4fNJh1KgREynpzNfKm3j+EPGS75BR66uimNtoS6J
4LLlg1ZRASBNPaIeHXVCk1u9MCpVGQ==
=27li
-----END PGP SIGNATURE-----

--GyBFFrpYHGV4SYp0--
