Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 149DA4EBD0
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 17:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfFUPUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 11:20:45 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:33992 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfFUPUp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 11:20:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=k7B4qpZRKekRsbrJRNAOCMknlWwPS/PrFmf0ar+9f2c=; b=FA4zWpbZiGYYqPMCe4vRccZWw
        xc3qxMMiz+bl3AUk4jG0roXYSFlR8dEMaLsW46bgruBYTa3+x3QfLIiBm4h2O3e6GCy5Lmuqfz626
        7/qXve56a4Y2OxGJJBfQqfd4oa/Q343hf3Mv6YS7XHoW9iFWRyo/Dw9c4oMHbT3+pmMLc=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=finisterre.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1heLLF-0002dm-8b; Fri, 21 Jun 2019 15:20:41 +0000
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
        id AB9D5440046; Fri, 21 Jun 2019 16:20:40 +0100 (BST)
Date:   Fri, 21 Jun 2019 16:20:40 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] ASoC: dapm: Adapt for debugfs API change
Message-ID: <20190621152040.GI5316@sirena.org.uk>
References: <20190621113357.8264-1-broonie@kernel.org>
 <20190621113357.8264-2-broonie@kernel.org>
 <20190621132222.GB10459@kroah.com>
 <20190621143053.GH5316@sirena.org.uk>
 <20190621145309.GA6313@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ZfA+D/N/UnTE6S9V"
Content-Disposition: inline
In-Reply-To: <20190621145309.GA6313@kroah.com>
X-Cookie: Editing is a rewording activity.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZfA+D/N/UnTE6S9V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 21, 2019 at 04:53:09PM +0200, Greg KH wrote:
> On Fri, Jun 21, 2019 at 03:30:53PM +0100, Mark Brown wrote:
> > On Fri, Jun 21, 2019 at 03:22:22PM +0200, Greg KH wrote:

> > This is a view I still hold and in any case debugfs as it stands (and
> > was in the kernel versions since this was broken) is still capable of
> > reporting errors so we should fix that.

> Sort story is, I am trying to change it so that it can not report errors :)

Yes, I know.  This is what I think is a bad idea.

> And even then, no kernel code should be doing anything different if
> debugfs calls fail or not, that is why I am I making these changes.  No
> "real" code should ever be affected, and right now, it is, if something
> goes wrong with debugfs.

> So removing those checks is the goal here.  Your driver code should not
> care if debugfs is working at all or not.

None of which addresses the issue which is that we should be telling
users who are trying to use debugfs to debug things that something went
wrong rather than silently failing and potentially confusing them with
corrupted data display.  This isn't something you can address through
API restrictions without hurting users unless you are prepared to add
user visible error reporting to the debugfs core.

The conditional code here beyond printing errors only affects the
creation of further debugfs files, it's just there to avoid spewing
secondary errors at people when something goes wrong so the underlying
problem is clearer and is entirely compatible with the idea of not
affecting real code.

--ZfA+D/N/UnTE6S9V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl0M9ccACgkQJNaLcl1U
h9Bq8Af+PVFkh3ZMQMAxpPrWk3rRg/BQFsbLERElZQ53DaijZATrwHksee798bg9
ydkEqv0JLIVhQIns1BagFBxuBnaPPpKVZvbAiIvHiDPj5qf8spP/mfM9r7PaI8n5
zquhdry2iTbY41p+oMW7GoSg744C750E/5UHHPiMr6+g75mvWQqO1K1GkOsQ3fky
0/ecXc9nfdMJ/KLXGEKdcpNtKYEjNM4QtpmIDcteStRXH6gV/qW3Hw6s5jSpQ1jf
4I2UdPBcPKvukjvxHos8fnKTBslUh35Yt4NmkZRDRjbozXo+Hc4D3U9mOvqkHcCV
eQVOX17U1jPYRiXVPNlh7Z+yDO1skQ==
=gvme
-----END PGP SIGNATURE-----

--ZfA+D/N/UnTE6S9V--
