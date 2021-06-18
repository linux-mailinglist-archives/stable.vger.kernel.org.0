Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291103ACF6A
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 17:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbhFRPvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 11:51:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230334AbhFRPvH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Jun 2021 11:51:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1192861351;
        Fri, 18 Jun 2021 15:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624031337;
        bh=PGGvVrkMfYH/qnVXzL1ynHkXyfl4h/zcwQx6X9fgpDQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d9p48mZSZZwIyejtBkS+zdYTLSoOoWeVDRQj4MxSMqpfc2bx/kRN+4fbtXNu9d9ZA
         vF7uLab4tYZL1/u3YnHcbxuFG85fzkeoyFxY8B6xC2WPYUlYspQNtc6o0+xdlUBKRG
         TpfB27FW49PDAPdddqo5sGc0DUgqX4wc6ZuOKUmT38qCoQNQ1JGB092hLFF9M3CV2z
         XjpYTWWlUO6XMC0wr4e718EsDUUzxyWAV3qAnuuVyzRyDVMPQ9iq/WI1gBC0Z4T9Qk
         a5HK4jsJYXBpmygX8VTC9xYBtY38Ov6IbcvwHx3aBh0NEoqcx8LmUKhnAqztgieCsk
         G8Pj9cP8FmbFA==
Date:   Fri, 18 Jun 2021 16:48:36 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     srivasam@codeaurora.org, rafael@kernel.org,
        dp@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] regmap: move readable check before accessing regcache.
Message-ID: <20210618154836.GC4920@sirena.org.uk>
References: <20210618113558.10046-1-srinivas.kandagatla@linaro.org>
 <20210618115104.GB4920@sirena.org.uk>
 <666da41f-173e-152d-84e5-e9b32baa60da@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="L6iaP+gRLNZHKoI4"
Content-Disposition: inline
In-Reply-To: <666da41f-173e-152d-84e5-e9b32baa60da@linaro.org>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--L6iaP+gRLNZHKoI4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 18, 2021 at 01:29:50PM +0100, Srinivas Kandagatla wrote:
> On 18/06/2021 12:51, Mark Brown wrote:

> > Why will use of regmap_update_bits() mean that a driver will never
> > notice a write failure?  Shouldn't remgap_update_bits() be fixed to
> > report any errors it isn't reporting, or the driver fixed to check

> usecase is performing regmap_update_bits() on a *write-only* registers.

> _regmap_update_bits() checks _regmap_read() return value before bailing o=
ut.
> In non cache path we have this regmap_readable() check however in cached
> patch we do not have this check, so _regmap_read() will return success in
> this case so regmap_update_bits() never reports any error.

> driver in question does check the return value.

OK, so everything is working fine then - what's the problem?  The value
in the register is cached, the read returns that cached value and then
the relevant bits are updated and the new value written out to both the
cache and the hardware.  No part of that sounds like a problem to me.

> > error codes?  I really don't understand the issue you're trying to
> > report - what is "the right thing" and what makes you believe that a
> > driver can't do an _update_bits() on a write only but cached register?
> > Can you specify in concrete terms what the problem is.

> So one of recent patch ("ASoC: qcom: Fix for DMA interrupt clear reg
> overwriting) https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-n=
ext.git/commit/?h=3Dnext-20210618&id=3Dda0363f7bfd3c32f8d5918e40bfddb9905c8=
6ee1
>=20
> broke audio on DragonBoard 410c.

> This patch simply converts writes to regmap_update_bits for that particul=
ar
> dma channel. The register that its updating is IRQ_CLEAR register which is
> software "WRITE-ONLY" and Hardware read-only register.

So the driver is buggy then, the register is clearly volatile and can't
be cached, and it sounds like it's unsafe to use _update_bits() on it.
The register is clearly not write only since it can be read and it's
volatile since the readback value does not reflect what was written (and
presumably can change),.  Even without that it's buggy to use
_update_bits() here since the device needs the write to happen
regardless of the value that is read back, with the register marked as
volatile that will still potentially fail if the readback value happens
to be the same as whatever bits the driver is trying to set.

Your description of the register is being "software write only" and
"hardware read only" should be a warning sign here, think about what
that might mean for a minute.

> The bits in particular case is updating is a period interrupt clear bit.

> Because we are using regmap cache in this driver,

> first regmap_update_bits(map, 0x1, 0x1) on first period interrupt will
> update the cache and write to IRQ_CLEAR hardware register which then clea=
rs
> the interrupt latch.
> On second period interrupt we do regmap_update_bits(map, 0x1, 0x1) with t=
he
> same bits, Because we are using cache for this regmap caches sees no chan=
ge
> in the cache value vs the new value so it will never write/update  IRQ_CL=
EAR
> hardware register, so hardware is stuck here waiting for IRQ_CLEAR write
> from driver and audio keeps repeating the last period.

This is because the register is volatile and we can't cache the written
value, it is a driver bug.  If the value in the register does not change
=66rom the value written unexpectedly then the register can be cached and
there is no problem but that's not the case here.

--L6iaP+gRLNZHKoI4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmDMwFMACgkQJNaLcl1U
h9AgvAf+O2iXF73nAl/Z/pHHSRh0SYND8UF9rb9lkKpGLz6EkfggX6JF3CDffZH2
b6KsnBeujrFYIeu2sUOGGiu7ZpTtFHGeXT1Y0kQ8KOQxyYXVZB0KaVw2StBCdXJB
bVFtbHv+SLPQ1Di1g4/g+YmwHXS0Dgp9bKCjxmCpuLhjD03c3Eb8a24Cu6DDhwEp
DQoCJSDnAVOtVwsJn4AOhfX6glbDk6AviI++OhxYh24C8tY56PhnlKx/pKq8fB3+
JGW4NSyqTosNuSKKkPZLCOB+Ytr7/SrXWpXwSXrrVjcnjw+hcs5r1LWBlRGE9FEW
K4wRSCfbEFcnOTaUqsS6uwxmFerhNQ==
=g9qE
-----END PGP SIGNATURE-----

--L6iaP+gRLNZHKoI4--
