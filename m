Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52AD54214C6
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 19:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238103AbhJDRHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 13:07:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:44136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233646AbhJDRHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 13:07:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 493E761381;
        Mon,  4 Oct 2021 17:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633367128;
        bh=G5hoHCsSs0ocXoe0zEsFa7YLsrviOjikiHQe2cZPcIE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aL9kWvE1Mens/W4k9TQo8SiASeBohIf/YABW8S9d2KgBDnq2gn7OsqcPipRjhsCTS
         2VkaeQQ3TaUsRuhV/2uAEYKWHUFYowik4xbwsa1/MQ9L5ddqVp7dl246dlBnkkR1jt
         W1FLyxpyIZsgrbCMr6824mGbbOhW2dII3LNfzAa1Y4DpztRwVOK5QF1iFZKZOy8f6g
         58MI61+D5CTGmMGg0pNyui91yfmHRJAIbhvuLn1gdJChc72MEI2u2W3f0dqsX/dxqa
         zny2xK7iCM1GM59RD7PsTs/GvptLm8lNvz3ogKlFhTnB2TagMzmyGzmgQ5g1KhLERB
         AlaRsf1xeVdAA==
Date:   Mon, 4 Oct 2021 18:05:26 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        nsaenz@kernel.org, linux-spi@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        p.rosenberger@kunbus.com, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] spi: bcm2835: do not unregister controller in shutdown
 handler
Message-ID: <YVs0Vk9TJqHt8R4K@sirena.org.uk>
References: <20210928195657.5573-1-LinoSanfilippo@gmx.de>
 <20211001175422.GA53652@sirena.org.uk>
 <2c4d7115-7a02-f79e-c91b-3c2dd54051b2@gmx.de>
 <YVr4USeiIoQJ0Pqh@sirena.org.uk>
 <20211004131756.GW3544071@ziepe.ca>
 <YVsLxHMCdXf4vS+i@sirena.org.uk>
 <20211004154436.GY3544071@ziepe.ca>
 <YVssWYaxuQDi8jI5@sirena.org.uk>
 <e68b04ab-831b-0ed5-074a-0879194569f9@gmail.com>
 <20211004165127.GZ3544071@ziepe.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="omXKEcphJO0A+Ruq"
Content-Disposition: inline
In-Reply-To: <20211004165127.GZ3544071@ziepe.ca>
X-Cookie: If it heals good, say it.
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--omXKEcphJO0A+Ruq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 04, 2021 at 01:51:27PM -0300, Jason Gunthorpe wrote:
> On Mon, Oct 04, 2021 at 09:36:37AM -0700, Florian Fainelli wrote:

> > No please don't, I should have arguably justified the reasons why
> > better, but the main reason is that one of the platforms on which this
> > driver is used has received extensive power management analysis and
> > changes, and shutting down every bit of hardware, including something as
> > small as a SPI controller, and its clock (and its PLL) helped meet
> > stringent power targets.

> Huh? for device shutdown? What would this matter if the next step is
> reboot or power off?

On some embedded systems, especially ultra low cost ones, the system
power off state might not actually involve removing all the physical
power supplies for the all the chips in the system so any residual
leakages or active functions will continue to consume power.

Ideally the system power on/off will be triggered by a PMIC which is
able to physically remove power to most other parts of the system which
avoids this issue (much like the PSU in a server) but that's not always
the case.

--omXKEcphJO0A+Ruq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmFbNFUACgkQJNaLcl1U
h9Dx9Af8DCQRph1eyeLpiMS1kEOVvwEqf8tRrtBApuuXS5tWm7zMTg5AE2lDlds0
RTtPA3rlUwtFQ81V1DRG7dRsogvl+OVWoHNa+UCqj2U4sovq6zEVKhMmerSCZhBN
hfZZ80XagCRjQWzpMciVWGE5tzgVPF1Z9hkM/jYc7x1WrHa5q0CWjfu/uWSuYQWw
KNyIdjh0Xgf0sMxWZLJt5mrcsYfb8wMWn+0XQy7ZXaUIC7NAKZxwmxb1LtUN5KQQ
nsQJ/lUeKzEcOW0tLmXy2EU7AqlLe2L+iDbezKDjKz8UvOAvmZRuWUKmzChRUZtl
DRB0HyviDdShhrRF/2ViT9Moqu5uaw==
=WGIQ
-----END PGP SIGNATURE-----

--omXKEcphJO0A+Ruq--
