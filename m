Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E2C2933A0
	for <lists+stable@lfdr.de>; Tue, 20 Oct 2020 05:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729857AbgJTD0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 23:26:47 -0400
Received: from mga18.intel.com ([134.134.136.126]:29094 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729594AbgJTD0r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Oct 2020 23:26:47 -0400
IronPort-SDR: dm3A2EVgnEG/18kBaOHb6y+G2Y2M5G8erUh7MxzuIsvZBX1+OXoPyDGjEnKODbPh28gm7Fe0CT
 o2lStvblKkzw==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="154932212"
X-IronPort-AV: E=Sophos;i="5.77,396,1596524400"; 
   d="asc'?scan'208";a="154932212"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2020 20:26:45 -0700
IronPort-SDR: WzG7+NPimw7oGUfCD0AgqPsE91rR1PN+uVL+x0dUrfh45OK1iaOgSeVk9NnYva3y3UBBJmOPa8
 FwP33YCPjMiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,396,1596524400"; 
   d="asc'?scan'208";a="353193858"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.160.147])
  by fmsmga002.fm.intel.com with ESMTP; 19 Oct 2020 20:26:43 -0700
Date:   Tue, 20 Oct 2020 11:05:56 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org, Stefan Fritsch <sf@sfritsch.de>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Force VT'd workarounds when running as a guest
 OS
Message-ID: <20201020030556.GZ27141@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20201019101230.29860-1-chris@chris-wilson.co.uk>
 <20201019101523.4145-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="thwsKKN5whlRGe6j"
Content-Disposition: inline
In-Reply-To: <20201019101523.4145-1-chris@chris-wilson.co.uk>
User-Agent: Mutt/1.10.0 (2018-05-17)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--thwsKKN5whlRGe6j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020.10.19 11:15:23 +0100, Chris Wilson wrote:
> If i915.ko is being used as a passthrough device, it does not know if
> the host is using intel_iommu. Mixing the iommu and gfx causing a few
> issues (such as scanout overfetch) which we need to workaround inside
> the driver, so if we detect we are running under a hypervisor, also
> assume the device access is being virtualised.
>=20
> Reported-by: Stefan Fritsch <sf@sfritsch.de>
> Suggested-by: Stefan Fritsch <sf@sfritsch.de>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: Stefan Fritsch <sf@sfritsch.de>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/i915/i915_drv.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_=
drv.h
> index 1a5729932c81..bcd8650603d8 100644
> --- a/drivers/gpu/drm/i915/i915_drv.h
> +++ b/drivers/gpu/drm/i915/i915_drv.h
> @@ -33,6 +33,8 @@
>  #include <uapi/drm/i915_drm.h>
>  #include <uapi/drm/drm_fourcc.h>
> =20
> +#include <asm/hypervisor.h>
> +
>  #include <linux/io-mapping.h>
>  #include <linux/i2c.h>
>  #include <linux/i2c-algo-bit.h>
> @@ -1760,7 +1762,9 @@ static inline bool intel_vtd_active(void)
>  	if (intel_iommu_gfx_mapped)
>  		return true;
>  #endif
> -	return false;
> +
> +	/* Running as a guest, we assume the host is enforcing VT'd */
> +	return !hypervisor_is_type(X86_HYPER_NATIVE);
>  }
> =20
>  static inline bool intel_scanout_needs_vtd_wa(struct drm_i915_private *d=
ev_priv)
> --=20

Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>

--=20

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--thwsKKN5whlRGe6j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCX45UFAAKCRCxBBozTXgY
J3dyAJ0bGhyAbPBXVP41vLhpRNvs/WX9NQCeK9QA1u1jUvczmPmapaRjHNs17hE=
=/q/D
-----END PGP SIGNATURE-----

--thwsKKN5whlRGe6j--
