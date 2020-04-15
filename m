Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF481AB15D
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 21:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441709AbgDOTO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 15:14:26 -0400
Received: from mx1.riseup.net ([198.252.153.129]:44820 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441705AbgDOTOY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 15:14:24 -0400
Received: from capuchin.riseup.net (unknown [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 492X8t3smdzFctM;
        Wed, 15 Apr 2020 12:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1586978062; bh=toYBUT7xw21tIeZNZNFWN4jeQ8Yi674ejp60OTdKqH8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=sGOfJD9Z6efJ1aIFpQ7lZMQJeeiw7msdxudI9HPJKCZ/F9FpKq440Sm+RUf7hQYmW
         U/BF2PRTxe12Y+wibKs6txRxDoYXCo96Hc8YkwqEYAIXbQYy85r7R40NbLnf94gZbh
         w6EqCl7RTJDSSmG9PGCPDcacvdv43LYr82dVYK4U=
X-Riseup-User-ID: 2968E23E4F7AA60FC00545F2FF2A419E198424D251C06A6DC5115DF5D3F358B7
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 492X8s6pSBz8tpW;
        Wed, 15 Apr 2020 12:14:21 -0700 (PDT)
From:   Francisco Jerez <currojerez@riseup.net>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Andi Shyti <andi.shyti@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915/gt: Update PMINTRMSK holding fw
In-Reply-To: <20200415075018.7636-1-chris@chris-wilson.co.uk>
References: <20200415075018.7636-1-chris@chris-wilson.co.uk>
Date:   Wed, 15 Apr 2020 12:14:27 -0700
Message-ID: <87y2qwy31o.fsf@riseup.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="==-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--==-=-=
Content-Type: multipart/mixed; boundary="=-=-="

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Chris Wilson <chris@chris-wilson.co.uk> writes:

> If we use a non-forcewaked write to PMINTRMSK, it does not take effect
> until much later, if at all, causing a loss of RPS interrupts and no GPU
> reclocking, leaving the GPU running at the wrong frequency for long
> periods of time.
>
> Reported-by: Francisco Jerez <currojerez@riseup.net>
> Suggested-by: Francisco Jerez <currojerez@riseup.net>
> Fixes: 35cc7f32c298 ("drm/i915/gt: Use non-forcewake writes for RPS")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>

Reviewed-by: Francisco Jerez <currojerez@riseup.net>

> Cc: Francisco Jerez <currojerez@riseup.net>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Cc: Andi Shyti <andi.shyti@intel.com>
> Cc: <stable@vger.kernel.org> # v5.6+
> ---
>  drivers/gpu/drm/i915/gt/intel_rps.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gt/intel_rps.c b/drivers/gpu/drm/i915/g=
t/intel_rps.c
> index 86110458e2a7..6a3505467406 100644
> --- a/drivers/gpu/drm/i915/gt/intel_rps.c
> +++ b/drivers/gpu/drm/i915/gt/intel_rps.c
> @@ -81,13 +81,14 @@ static void rps_enable_interrupts(struct intel_rps *r=
ps)
>  		events =3D (GEN6_PM_RP_UP_THRESHOLD |
>  			  GEN6_PM_RP_DOWN_THRESHOLD |
>  			  GEN6_PM_RP_DOWN_TIMEOUT);
> -
>  	WRITE_ONCE(rps->pm_events, events);
> +
>  	spin_lock_irq(&gt->irq_lock);
>  	gen6_gt_pm_enable_irq(gt, rps->pm_events);
>  	spin_unlock_irq(&gt->irq_lock);
>=20=20
> -	set(gt->uncore, GEN6_PMINTRMSK, rps_pm_mask(rps, rps->cur_freq));
> +	intel_uncore_write(gt->uncore,
> +                           GEN6_PMINTRMSK, rps_pm_mask(rps, rps->last_fr=
eq));
>  }
>=20=20
>  static void gen6_rps_reset_interrupts(struct intel_rps *rps)
> @@ -120,7 +121,9 @@ static void rps_disable_interrupts(struct intel_rps *=
rps)
>  	struct intel_gt *gt =3D rps_to_gt(rps);
>=20=20
>  	WRITE_ONCE(rps->pm_events, 0);
> -	set(gt->uncore, GEN6_PMINTRMSK, rps_pm_sanitize_mask(rps, ~0u));
> +
> +	intel_uncore_write(gt->uncore,
> +                           GEN6_PMINTRMSK, rps_pm_sanitize_mask(rps, ~0u=
));
>=20=20
>  	spin_lock_irq(&gt->irq_lock);
>  	gen6_gt_pm_disable_irq(gt, GEN6_PM_RPS_EVENTS);
> --=20
> 2.20.1

--=-=-=--

--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEAREIAB0WIQST8OekYz69PM20/4aDmTidfVK/WwUCXpddEwAKCRCDmTidfVK/
W9N1AP9yLOpUxJFBqi/4ZUW61ihZ9rvADYdcS6ec8IQrQ+7uBgD/cwydjRZ4STQm
pgZdqnTrkuM5ih3BNNgyGmBaz3uPDWo=
=06a9
-----END PGP SIGNATURE-----
--==-=-=--
