Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEBC421112
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 16:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbhJDOOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 10:14:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233188AbhJDOOL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 10:14:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42D0F61354;
        Mon,  4 Oct 2021 14:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633356742;
        bh=8C70wqLG2kw6y622LgfXYt7HTq8THcyBWE+2lsIEJnQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i16hIkQvFR9+0QnWNgtrxQXynBVcw7MTqsN/lomrM4Xv0IHDDXIbfbY+vXWmQLORl
         Rpi5wOu4YkBGEf0r7GlQ9viZo9+FTuFx3X6dM5GruG/oUsN/4Nq/5vC9oth/eSi9lV
         18Leo1JskxjEWyLZUJc96etV/3U2ZNB9A5X+zC1N3oaEAeACStCqyvpXe9Dxgy1Kk7
         npT06ZcHDdYyw2aWa6YUEw1YOsjz+OwEV5DmOvJ6M6WHS1Xtopz9mOO1Cps6w45Gg8
         uYTCUO9e8tIFn2qm7UePSC9ZIeaj47fAxFvhfsLT4tLMVCSqx6N7fZv3jgk4gjFTY6
         N8OsW2BRG9lTA==
Date:   Mon, 4 Oct 2021 15:12:20 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Lino Sanfilippo <LinoSanfilippo@gmx.de>, f.fainelli@gmail.com,
        rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, nsaenz@kernel.org,
        linux-spi@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        p.rosenberger@kunbus.com, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] spi: bcm2835: do not unregister controller in shutdown
 handler
Message-ID: <YVsLxHMCdXf4vS+i@sirena.org.uk>
References: <20210928195657.5573-1-LinoSanfilippo@gmx.de>
 <20211001175422.GA53652@sirena.org.uk>
 <2c4d7115-7a02-f79e-c91b-3c2dd54051b2@gmx.de>
 <YVr4USeiIoQJ0Pqh@sirena.org.uk>
 <20211004131756.GW3544071@ziepe.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="d4pFysLjW10458eo"
Content-Disposition: inline
In-Reply-To: <20211004131756.GW3544071@ziepe.ca>
X-Cookie: If it heals good, say it.
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--d4pFysLjW10458eo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 04, 2021 at 10:17:56AM -0300, Jason Gunthorpe wrote:

> Shutdown is supposed to quiet the HW so it is not doing DMAs any
> more. This is basically an 'emergency' kind of path, the HW should be
> violently stopped if available - ie clearing the bus master bits on
> PCI, for instance.

> When something like kexec happens we need the machine to be in a state
> where random DMA's are not corrupting memory.

That's all well and good but there's no point in implementing something
half baked that's opening up a whole bunch of opportunities to crash the
system if more work comes in after it's half broken the device setup. =20

> Due to the emergency sort of nature it is not appropriate to do
> locking complicated sorts of things like struct device unregistrations
> here.

That's just not what's actually implemented in a bunch of places, nor
something one would infer from the documentation ("Called at shut-down
to quiesce the device", no mention of emergency cases which I'd guess
would just be kdump) - there's a bunch of locks in shutdown paths, and
drivers on sleeping buses with shutdown callbacks.  Never mind the few
of them that use a shutdown callback to power the system down, though
that's a different thing and definitely abusing the API.  I would guess
that a good proportion of people implementing it are more worried about
clean system shutdown than they are about kdump.

--d4pFysLjW10458eo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmFbC8MACgkQJNaLcl1U
h9A9ZQf9H8HngYbz4lcBHU1c64oQ/goR+5zcEkFnEgDZ36zSAaLm0y97biTrlmqv
qB9KRporje388T9XAfOsyt02dXnMdt0sqrg5C/dUfO554axWtv27CgzPR2MReklb
KUYGA65DtHm57pyAJYpQ2LyaWHGHmGaJfa8cfxsA7cZd92LfL+89teR7DlU8nrnw
mgnuECKes199R6AZfrj2Iva3m7bbtYrh52uMIyWTWIi26rv3LJvu2RNINOrdf4c8
QTYHiztY7h+oxW9iz/704UcnU30lWzoEy6WkazOUC8WAYmNfQyOlMF8dL6AVBqqV
uGYmfraX2n5BpPf2ZE+wkpRGjlpBVQ==
=PKtu
-----END PGP SIGNATURE-----

--d4pFysLjW10458eo--
