Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E553AE82A
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 13:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhFULaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 07:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229487AbhFULaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 07:30:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A7726100A;
        Mon, 21 Jun 2021 11:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624274889;
        bh=rj3vBToAOKNVorRQkvAummT8lFrSz1uw9LgUZVhOihw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JQ2eiRJZUYPEo1jVLZNZSuTILbCDyNJI5BC1Xx800KpRxbCTKIM5slfnZPfjGUMBy
         PwnIaW30TXETz0wAxAl45XRAYVxj6w6OniDUjJAc0bItAmSAKhpFvNGsvh0PLUNhub
         mfwQ3PpQYU61s7aMQw37nINY4RrBMNrItuPb0PyvVlY0x6mqU4NA/p6cRdP/3txPbh
         6SBCQuiBQ+GcwBtozqE42l23s1NaaaQdlysAI75xoiSFWXFaC7ebuOOWoOhqVKnJNW
         fKlXCZD5o6tS6vfgzNUEp6t6CQfint6q3kW3JJUYDMHukC/VbFoGRYv7Rzm33UUuMQ
         BtyDDIymf1k3A==
Date:   Mon, 21 Jun 2021 12:27:47 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     srivasam@codeaurora.org, rafael@kernel.org,
        dp@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] regmap: move readable check before accessing regcache.
Message-ID: <20210621112747.GC4094@sirena.org.uk>
References: <20210618113558.10046-1-srinivas.kandagatla@linaro.org>
 <20210618115104.GB4920@sirena.org.uk>
 <666da41f-173e-152d-84e5-e9b32baa60da@linaro.org>
 <20210618154836.GC4920@sirena.org.uk>
 <6eca27bf-5696-3ffc-24a5-5a58407f6e93@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="RIYY1s2vRbPFwWeW"
Content-Disposition: inline
In-Reply-To: <6eca27bf-5696-3ffc-24a5-5a58407f6e93@linaro.org>
X-Cookie: I hate dying.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--RIYY1s2vRbPFwWeW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 21, 2021 at 11:30:00AM +0100, Srinivas Kandagatla wrote:
> On 18/06/2021 16:48, Mark Brown wrote:
> > On Fri, Jun 18, 2021 at 01:29:50PM +0100, Srinivas Kandagatla wrote:

> > > _regmap_update_bits() checks _regmap_read() return value before baili=
ng out.
> > > In non cache path we have this regmap_readable() check however in cac=
hed
> > > patch we do not have this check, so _regmap_read() will return succes=
s in
> > > this case so regmap_update_bits() never reports any error.
> >=20
> > > driver in question does check the return value.

> > OK, so everything is working fine then - what's the problem?  The value

> How can this be working fine?

> In this particular setup the register is marked as write only and is not
> readable. Should it really store value in cache at the first instance?

Yes, we know exactly what the value in the register is since we wrote it
so there's no problem with us remembering and using that.

> Also on the other note, if we mark the same regmap as uncached this useca=
se
> will fail straightaway with -EIO, so why is the behavior different in
> regcache path?

If the register is marked as uncachable then obviously the cache
behaviour is going to be different to that for a register which we can
cache for whatever reason the register was marked volatile.

> Shouldn't the regcache path check if the register is readable before tryi=
ng
> to cache the value?

Why?  If we know what the value is we can cache it and then use it,
meaning things like restoring the value in a cache sync and update_bits()
work, this is useful especially on devices which have no read support at
all.  What would the benefit it not caching it be?

> From "APQ8016E Technical Reference Manual" https://developer.qualcomm.com=
/qfile/28813/lm80-p0436-7_f_410e_proc_apq8016e_device_spec.pdf

> Section: 4.5.9.6.19
> this register LPASS_LPAIF_IRQ_CLEARa is clearly marked with Type: W

> with this description:
> "Writing a 1 to a bit in this register clears the latched interrupt event

> So am not 100% sure if we read this we will get anything real from the
> register. I always get zeros if I do that.

> Should this behavior treated as volatile?

Yes.  This is indistingusihable from a register that is volatile because
it doesn't latch written values, given that you're saying readback
actually works there's an argument here that the documentation isn't
accurate here.  My guess is that this device doesn't have any write only
registers as far as anything outside the device is concerned since the
I/O hardware won't fault or anything on reads, it just has addresses
where the read side isn't wired up to anything.

> If we mark this register as volatile and make it readable then it would w=
ork
> but that just sounds like a hack to avoid cache.

> Am sure other hardware platforms have similar write-only registers, how do
> they handle regmap_update_bits case if they have regcache enabled?

They either mark the registers as volatile or just don't do any
operations that involve reading the value so it's a non-issue.

--RIYY1s2vRbPFwWeW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmDQd7IACgkQJNaLcl1U
h9A/fgf+Pg2mLrrh7T7omEx9eanLnkHhdJfPwfxAOeNVURlpYVMYVnVrZ9obc+i8
obgTzFZ9XNx7JS56LhdMJY6GlMMYIGN8QP6GHCtQehL+4558bPBzkbOdK5asNebR
PhIulYGtMmy2h///HlxNC0Vv1BJKiC0dFLxdFh08w657KPNHPPB+MLqs0Q5FwP+i
zvLFZWUVXwZG18WhgKoGWkOT9vDTXs6YjsDSbRR/85zgU5kZVCWCf2P7mmvWZmrQ
RFybYtCUTtwJwr4A7P/qp5P/qwvHD1B+AkI8VH07dv9xR8Ebgj/Q79X3pTQzq9is
63/1T7Ov3l5y7w1VjJM3opM9YnF4Zw==
=Mm3p
-----END PGP SIGNATURE-----

--RIYY1s2vRbPFwWeW--
